import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:one_fa/routes/error_handler.dart';
import 'package:one_fa/routes/main_page.dart';
import 'package:one_fa/util/custom_page_decoration.dart';
import 'package:one_fa/util/encryption.dart';
import 'package:one_fa/util/global.dart';
//Owner : Debmalya Sarkar

class OwnerLogIn extends StatelessWidget {
  const OwnerLogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: boxdecoration(),
        child: const SingleChildScrollView(
          child: MainBodySkel(),
        ),
      ),
    );
  }
}

class MainBodySkel extends StatefulWidget {
  const MainBodySkel({super.key});

  @override
  State<MainBodySkel> createState() => _MainBodySkelState();
}

class _MainBodySkelState extends State<MainBodySkel> {
  TextEditingController userId = TextEditingController(),
      password = TextEditingController();

  bool _hide = true;
  bool _disable_email = true, _disable_pass = true;
  int chances = 5;

  void toggle() {
    setState(() {
      _hide = !_hide;
    });
  }

  @override
  void initState() {
    super.initState();
    userId.addListener(() {
      setState(() {
        if (userId.text.isNotEmpty &&
            RegExp(r'([a-zA-Z]+[0-9]*@[a-zA-Z]+\.[a-z]+)')
                .hasMatch(userId.text))
          _disable_email = false;
        else
          _disable_email = true;
      });
    });

    password.addListener(() {
      setState(() {
        if (password.text.isNotEmpty)
          _disable_pass = false;
        else
          _disable_pass = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 54.97,
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(
              Icons.question_mark_sharp,
              color: Colors.white,
            ),
            tooltip: "About Us",
            splashRadius: 20,
            onPressed: () => Navigator.pushNamed(context, '/aboutus'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 250,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    controller: userId,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'example@example.com',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      label: GlowText(
                        'Enter your email ID',
                        glowColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: _hide,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: toggle,
                        icon: GlowIcon(
                          (!_hide) ? Icons.visibility : Icons.visibility_off,
                          glowColor: Colors.white,
                        ),
                        color: Colors.white,
                        splashRadius: 20,
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      label: const GlowText(
                        'Enter your Password',
                        glowColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: GlowButton(
                      onPressed: (_disable_email || _disable_pass)
                          ? null
                          : () async {
                              supabase_connector.sendNotfctn(
                                  email: userId.text);
                              final result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FutureBuilder(
                                    future: supabase_connector.logIn(
                                        id: userId.text, pass: password.text),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        if (snapshot.data == 0) {
                                          return const OwnerLogIn();
                                        }
                                        return ErrorHandler(
                                            err: snapshot.data!,
                                            chances: chances);
                                      } else {
                                        return const Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    });
                              }));
                              setState(() {
                                chances = result;
                              });
                              if (chances <= 0) {
                                supabase_connector.ban(email: userId.text);
                                setState(() {
                                  chances = 5;
                                  _disable_email = true;
                                  _disable_pass = true;
                                  password.clear();
                                  userId.clear();
                                });
                              }
                            },
                      color: Colors.white,
                      disableColor: Colors.grey,
                      child: const Text('Start'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Image.asset(
                'assets/Landing_page/Landing_card_body.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
