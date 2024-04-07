import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_fa/util/global.dart';
//Owner : Debmalya Sarkar

PreferredSize customAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(180),
    child: Container(
        width: double.infinity,
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/1FA.png',
              fit: BoxFit.cover,
            ),
            Text('ONE FOR ALL',
                style: GoogleFonts.londrinaShadow(
                    textStyle: const TextStyle(
                        fontSize: 100, fontWeight: FontWeight.bold))),
            Image.asset(
              'assets/Landing_page/Landing_card.png',
              fit: BoxFit.contain,
            )
          ],
        )),
  );
}

BoxDecoration boxdecoration() {
  return const BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/Landing_page/Landing_background.png'),
        fit: BoxFit.contain),
  );
}

SnackBar errorSnack() {
  return SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      backgroundColor: const Color.fromARGB(63, 162, 162, 162),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel,
            color: Colors.red[400],
          ),
          const Padding(padding: EdgeInsets.all(8)),
          const Text(
            "Looks like port 8080 is already in use by some other process. Try to free it.",
            style: TextStyle(color: Colors.white),
          )
        ],
      ));
}

SnackBar banSnack() {
  return SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      backgroundColor: const Color.fromARGB(63, 162, 162, 162),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            color: Colors.red[400],
          ),
          const Padding(padding: EdgeInsets.all(8)),
          const Text(
            "Your account has been banned for 24 hours",
            style: TextStyle(color: Colors.white),
          )
        ],
      ));
}
SnackBar notExistSnk() {
  return SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      backgroundColor: const Color.fromARGB(63, 162, 162, 162),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            color: Colors.red[400],
          ),
          const Padding(padding: EdgeInsets.all(8)),
          const Text(
            "Account does not exist",
            style: TextStyle(color: Colors.white),
          )
        ],
      ));
}
