import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:one_fa/util/custom_page_decoration.dart';
import 'package:one_fa/util/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 34, 34, 1),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: const MainBodySkel(),
      ),
    );
  }
}

class MainBodySkel extends StatefulWidget {
  const MainBodySkel({super.key});

  @override
  State<MainBodySkel> createState() => _MainBodySkelState();
}

class _MainBodySkelState extends State<MainBodySkel>
    with SingleTickerProviderStateMixin {
  String _uuid = "", _otp = "";
  int _errCode = 0;
  Map<String, dynamic> _data = {'response': false};
  int _index = 0, _otpIndex = 1, _chances = 3, _colIndex1 = 1, _colIndex2 = 0;
  final TextEditingController _controller = TextEditingController(),
      _passwordController = TextEditingController();
  bool _hasgiven = false,
      _passgiven = false,
      _popupNeeded = false,
      _progressing = false;
  final List<Color> _colorList = [
    const Color.fromRGBO(102, 102, 102, 0.08),
    const Color.fromRGBO(112, 56, 155, 1)
  ];

  @override
  void initState() {
    super.initState();
    socketConnection();
    _controller.addListener(() {
      setState(() {
        if (_controller.text.length == 6) {
          _hasgiven = true;
        } else {
          _hasgiven = false;
        }
      });
    });
    _passwordController.addListener(() {
      setState(() {
        if (_passwordController.text.isNotEmpty) {
          _passgiven = true;
        } else {
          _passgiven = false;
        }
      });
    });
  }

  Future<void> socketConnection() async {
    try {
      Socket socket = await Socket.connect('127.0.0.1', 8080)
          .timeout(const Duration(seconds: 10));
      socket.listen((event) {
        setState(() {
          _uuid = utf8.decode(event);
          supabase_connector.sendNotfctn(uuid: _uuid);
          _chances = 3;
          _data = {};
          _otp = "";
          _hasgiven = false;
          _passgiven = false;
          _progressing = false;
          _popupNeeded = true;
          _otpIndex = 1;
          _index = 0;
          _colIndex1 = 1;
          _colIndex2 = 0;
          _controller.clear();
          _passwordController.clear();
        });
      });
    } catch (e) {
      setState(() {
        _errCode = 1;
        ScaffoldMessenger.of(context).showSnackBar(errorSnack());
      });
    } finally {
      setState(() {
        if (_data['response'] != 'error') {
          _data['response'] = true;
        }
      });
    }
  }

  Future<void> updateData() async {
    final otpfetch = await supabase_connector.senduuidOTP(uuid: _uuid);
    setState(() {
      _popupNeeded = false;
    });
    final res = await supabase_connector.fetchData(
        uuid: _uuid, pass: _passwordController.text);
    setState(() {
      _progressing = false;
      _otp = otpfetch;
      _data = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_popupNeeded) {
        return Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/Landing_page/Landing_background.png'))),
          alignment: Alignment.center,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 300,
                width: 300,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                          label: GlowText(
                            'Enter the password'.capitalize(),
                            glowColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                          suffix: (_progressing)
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ))
                              : null,
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    FloatingActionButton.extended(
                        backgroundColor:
                            (_passgiven) ? Colors.white : Colors.white12,
                        foregroundColor: Colors.black,
                        onPressed: (_passgiven)
                            ? () async {
                                setState(() {
                                  _progressing = true;
                                });
                                final int response =
                                    await supabase_connector.accExist(
                                        uuid: _uuid,
                                        pass: _passwordController.text);
                                if (response == 200 || response == 404) {
                                  updateData();
                                } else {
                                  setState(() {
                                    --_chances;
                                    _progressing = false;
                                  });
                                  if (_chances <= 0) {
                                    supabase_connector.banCustomer(uuid: _uuid);
                                    _uuid = "";
                                    _data = {"response": true};
                                    _otp = "";
                                    _hasgiven = false;
                                    _passgiven = false;
                                    _popupNeeded = false;
                                    _progressing = false;
                                    _otpIndex = 1;
                                    _index = 0;
                                    _colIndex1 = 1;
                                    _colIndex2 = 0;
                                    _controller.clear();
                                    _passwordController.clear();
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(banSnack());
                                  }
                                }
                              }
                            : null,
                        label: const Text('Open')),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(
                      'Chances left $_chances',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 17, 0)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (_data.isEmpty || _data['response'] == false) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      } else if (_data['response'] == true && _data.length <= 1) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              (_errCode == 0) ? Icons.tab : Icons.block,
              color: (_errCode == 0) ? Colors.white : Colors.red,
              size: 60,
            ),
            Text(
              (_errCode == 0)
                  ? 'Ready to Scan'.capitalize()
                  : 'Oops, could not connect to scanner!!!'.capitalize(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      } else if (_data['response'] == 'error') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.block,
              color: Colors.red,
              size: 60,
            ),
            Text(
              'Account does not exist!'.capitalize(),
              style: const TextStyle(
                color: Color.fromARGB(255, 247, 16, 0),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      } else {
        List<Widget> stackList = <Widget>[
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(34, 34, 34, 1),
            ),
            child: _data['aadhar'],
          ),
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(34, 34, 34, 1),
            ),
            child: _data['pan'],
          ),
        ];

        List<Widget> userDetails = <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                '\tUsername : ${_data['username']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tEmail : ${_data['email_id']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tPhone : ${_data['phone_no']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tAadhar No. : ${_data['aadhar_no']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                '\tUsername : ${_data['username']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tEmail : ${_data['email_id']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tPhone : ${_data['phone_no']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '\tPan No. : ${_data['pan_no']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ];

        List<Widget> mainView = <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(49, 49, 49, 1),
                    ),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(8)),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(23))),
                          child: Image.asset(
                            'assets/1FA.png',
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Listener(
                            onPointerDown: (event) {
                              setState(() {
                                _index = 0;
                                _colIndex1 = 1;
                                _colIndex2 = 0;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: _colorList[_colIndex1],
                              ),
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/Icons/aadhar.icon.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Listener(
                            onPointerDown: (event) {
                              setState(() {
                                _index = 1;
                                _colIndex1 = 0;
                                _colIndex2 = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: _colorList[_colIndex2],
                              ),
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/Icons/pan.icon.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                flex: 13,
                child: stackList[_index],
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(47, 46, 46, 1),
                  ),
                  child: userDetails[_index],
                ),
              ),
            ],
          ),
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/Landing_page/Landing_background.png'))),
            alignment: Alignment.center,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 300,
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            label: GlowText(
                              'Enter the OTP'.capitalize(),
                              glowColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Row(
                        children: [
                          FloatingActionButton.extended(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              onPressed: () async {
                                final otpfetch = await supabase_connector
                                    .senduuidOTP(uuid: _uuid);
                                setState(() {
                                  _otp = otpfetch;
                                });
                              },
                              icon: const Icon(
                                Icons.send,
                              ),
                              label: Text('send again'.capitalize())),
                          const Padding(padding: EdgeInsets.all(10)),
                          FloatingActionButton.extended(
                              backgroundColor:
                                  (_hasgiven) ? Colors.white : Colors.white12,
                              foregroundColor: Colors.black,
                              onPressed: (_hasgiven)
                                  ? () {
                                      setState(() {
                                        if (_otp == _controller.text) {
                                          _progressing = false;
                                          _otpIndex = 0;
                                        } else {
                                          _controller.clear();
                                        }
                                      });
                                    }
                                  : null,
                              label: const Text('Open')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ];

        return mainView[_otpIndex];
      }
    });
  }
}
