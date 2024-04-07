import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_fa/util/custom_page_decoration.dart';
import 'package:lottie/lottie.dart';

class ErrorHandler extends StatelessWidget {
  final int err;
  final int chances;

  const ErrorHandler({super.key, required this.err, required this.chances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: boxdecoration(),
        child: SingleChildScrollView(
          child: MainBodySkel(
            error: err,
            chances: chances,
          ),
        ),
      ),
    );
  }
}

class MainBodySkel extends StatefulWidget {
  final int error;
  final int chances;
  const MainBodySkel({super.key, required this.error, required this.chances});

  @override
  State<MainBodySkel> createState() => _MainBodySkelState();
}

class _MainBodySkelState extends State<MainBodySkel> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (widget.error == 200) {
        Navigator.pushNamed(context, '/homepage');
      } else if (widget.error == 404) {
        if (widget.chances <= 1) {
          ScaffoldMessenger.of(context).showSnackBar(banSnack());
        }
        Navigator.pop(context, widget.chances - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.error == 200)
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network(
                  'https://lottie.host/650b677f-e303-4016-8b8a-69b61fca6a4c/oOt7P5fxMF.json',
                  fit: BoxFit.contain,
                  height: 250,
                  width: 250,
                  repeat: false,
                ),
                Text(
                  'VERIFIED',
                  style: GoogleFonts.literata(
                      color: Colors.white,
                      fontSize: 100,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Lottie.network(
                  'https://lottie.host/e1428f15-990a-4d54-8a88-cc47d3dc49ef/Cd3uWZsWot.json',
                  fit: BoxFit.contain,
                  height: 250,
                  width: 250,
                  repeat: false),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THIS ACCOUNT IS NOT VERIFIED !',
                    style: GoogleFonts.jua(
                        color: Colors.white,
                        fontSize: 47,
                        decoration: TextDecoration.underline),
                  ),
                  Text(
                    'Anonymous account found,\nCAUTION!! try again.\n${widget.chances - 1} chances left',
                    style: GoogleFonts.judson(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100),
                  )
                ],
              )
            ]),
          );
  }
}
