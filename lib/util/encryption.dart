import 'dart:math';
import 'package:one_fa/util/global.dart';

String getSalt(int length) {
  const String char =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rd = Random.secure();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => char.codeUnitAt(rd.nextInt(char.length))));
}

String make_salt(String text, int shift) {
  const String uppercaseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercaseAlphabet =
      'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz';
  const String numberDigit =
      '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
  String ciphertext = '';
  for (int i = 0; i < text.length; i++) {
    String currentChar = text[i];
    if (numberDigit.contains(currentChar)) {
      int newIndex = (numberDigit.indexOf(currentChar) + shift) % 90;
      ciphertext += numberDigit[newIndex];
    } else if (uppercaseAlphabet.contains(currentChar)) {
      int newIndex = (uppercaseAlphabet.indexOf(currentChar) + shift) % 104;
      ciphertext += uppercaseAlphabet[newIndex];
    } else if (lowercaseAlphabet.contains(currentChar)) {
      int newIndex = (lowercaseAlphabet.indexOf(currentChar) + shift) % 104;
      ciphertext += lowercaseAlphabet[newIndex];
    } else if (currentChar == '@') {
      ciphertext += '*';
    } else if (currentChar == '.') {
      ciphertext += '/';
    } else {
      ciphertext += currentChar;
    }
  }
  return ciphertext;
}

String caesarEncrypt_Even(String plaintext, int shift) {
  const String uppercaseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercaseAlphabet =
      'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz';
  const String numberDigit =
      '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
  String ciphertext = '';

  for (int i = 0; i < plaintext.length; i++) {
    String currentChar = plaintext[i];
    if (i % 2 == 0) {
      if (numberDigit.contains(currentChar)) {
        int newIndex = (numberDigit.indexOf(currentChar) + shift) % 90;
        ciphertext += numberDigit[newIndex];
      } else if (uppercaseAlphabet.contains(currentChar)) {
        int newIndex = (uppercaseAlphabet.indexOf(currentChar) + shift) % 104;
        ciphertext += uppercaseAlphabet[newIndex];
      } else if (lowercaseAlphabet.contains(currentChar)) {
        int newIndex = (lowercaseAlphabet.indexOf(currentChar) + shift) % 104;
        ciphertext += lowercaseAlphabet[newIndex];
      } else if (currentChar == '@') {
        ciphertext += '+';
      } else if (currentChar == '.') {
        ciphertext += '-';
      } else {
        ciphertext += currentChar;
      }
    } else {
      ciphertext += currentChar;
    }
  }
  return ciphertext;
}

String caesarEncrypt_Odd(String plaintext, int shift) {
  const String uppercaseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercaseAlphabet =
      'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz';
  const String numberDigit =
      '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
  String ciphertext = '';

  for (int i = 0; i < plaintext.length; i++) {
    String currentChar = plaintext[i];
    if (i % 2 != 0) {
      if (numberDigit.contains(currentChar)) {
        int newIndex = (numberDigit.indexOf(currentChar) + shift) % 90;
        ciphertext += numberDigit[newIndex];
      } else if (uppercaseAlphabet.contains(currentChar)) {
        int newIndex = (uppercaseAlphabet.indexOf(currentChar) + shift) % 104;
        ciphertext += uppercaseAlphabet[newIndex];
      } else if (lowercaseAlphabet.contains(currentChar)) {
        int newIndex = (lowercaseAlphabet.indexOf(currentChar) + shift) % 104;
        ciphertext += lowercaseAlphabet[newIndex];
      } else if (currentChar == '@') {
        ciphertext += '+';
      } else if (currentChar == '.') {
        ciphertext += '-';
      } else {
        ciphertext += currentChar;
      }
    } else {
      ciphertext += currentChar;
    }
  }
  return ciphertext;
}

String caesarDecrypt_Even(String ciphertext, int shift) {
  const String uppercaseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercaseAlphabet =
      'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz';
  const String numberDigit =
      '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
  String plaintext = '';

  for (int i = 0; i < ciphertext.length; i++) {
    String currentChar = ciphertext[i];
    if (i % 2 == 0) {
      if (numberDigit.contains(currentChar)) {
        int newIndex = (numberDigit.indexOf(currentChar) - shift) % 90;
        if (newIndex < 0) {
          newIndex += 90;
        }
        plaintext += numberDigit[newIndex];
      } else if (uppercaseAlphabet.contains(currentChar)) {
        int newIndex = (uppercaseAlphabet.indexOf(currentChar) - shift) % 104;
        if (newIndex < 0) {
          newIndex += 104;
        }
        plaintext += uppercaseAlphabet[newIndex];
      } else if (lowercaseAlphabet.contains(currentChar)) {
        int newIndex = (lowercaseAlphabet.indexOf(currentChar) - shift) % 104;
        if (newIndex < 0) {
          newIndex += 104;
        }
        plaintext += lowercaseAlphabet[newIndex];
      } else if (currentChar == '+') {
        plaintext += '@';
      } else if (currentChar == '-') {
        plaintext += '.';
      } else {
        plaintext += currentChar;
      }
    } else {
      plaintext += currentChar;
    }
  }
  return plaintext;
}

String caesarDecrypt_Odd(String ciphertext, int shift) {
  const String uppercaseAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowercaseAlphabet =
      'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz';
  const String numberDigit =
      '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
  String plaintext = '';

  for (int i = 0; i < ciphertext.length; i++) {
    String currentChar = ciphertext[i];
    if (i % 2 != 0) {
      if (numberDigit.contains(currentChar)) {
        int newIndex = (numberDigit.indexOf(currentChar) - shift) % 90;
        if (newIndex < 0) {
          newIndex += 90;
        }
        plaintext += numberDigit[newIndex];
      } else if (uppercaseAlphabet.contains(currentChar)) {
        int newIndex = (uppercaseAlphabet.indexOf(currentChar) - shift) % 104;
        if (newIndex < 0) {
          newIndex += 104;
        }
        plaintext += uppercaseAlphabet[newIndex];
      } else if (lowercaseAlphabet.contains(currentChar)) {
        int newIndex = (lowercaseAlphabet.indexOf(currentChar) - shift) % 104;
        if (newIndex < 0) {
          newIndex += 104;
        }
        plaintext += lowercaseAlphabet[newIndex];
      } else if (currentChar == '+') {
        plaintext += '@';
      } else if (currentChar == '-') {
        plaintext += '.';
      } else {
        plaintext += currentChar;
      }
    } else {
      plaintext += currentChar;
    }
  }
  return plaintext;
}

String caesarEncrypt({required String text}) {
  String shiftedtext;
  int sum_of_rng = 0;
  String RevSalt = '';
  String RevData = '';
  for (int i = text.length - 1; i >= 11; i--) {
    RevSalt += text[i];
  }

  List<int> dts = [3, 7, 5, 1];
  for (int i = 0; i < dts.length; i++) {
    sum_of_rng += dts[i];
  }
  String SaltedData = make_salt(RevSalt, (sum_of_rng % 26));
  String SaltedLast = make_salt(RevSalt, 26 - (sum_of_rng % 26));
  shiftedtext = caesarEncrypt_Odd(text, dts[0]);
  for (int i = 1; i < dts.length; i++) {
    if (i % 2 != 0) {
      shiftedtext = caesarEncrypt_Even(shiftedtext, dts[i]);
    } else {
      shiftedtext = caesarEncrypt_Odd(shiftedtext, dts[i]);
    }
  }
  for (int i = shiftedtext.length - 1; i >= 0; i--) {
    RevData += shiftedtext[i];
  }
  return RevData;
}

String caesarDecrypt({required String text}) {
  String decryptedMessage = '', shiftedtext = text.reverse();
  List<int> dts = [3, 7, 5, 1];
  decryptedMessage = caesarDecrypt_Even(shiftedtext, dts[dts.length - 1]);
  for (int i = dts.length - 2; i >= 0; i--) {
    if (i % 2 != 0) {
      decryptedMessage = caesarDecrypt_Even(decryptedMessage, dts[i]);
    } else {
      decryptedMessage = caesarDecrypt_Odd(decryptedMessage, dts[i]);
    }
  }
  return decryptedMessage;
}
