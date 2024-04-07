import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:one_fa/util/encryption.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class querySystem {
  bool _verified = false;
  late int _client_id;
  Future<int> logIn({required String id, required String pass}) async {
    id = caesarEncrypt(text: id);
    pass = caesarEncrypt(text: pass);
    try {
      final saltData = await Supabase.instance.client
          .from('client_data')
          .select('salt')
          .eq('email_id', id)
          .single();
      final saltedpass =
          caesarEncrypt(text: (caesarEncrypt(text: saltData['salt']) + pass));
      final arr = await Supabase.instance.client
          .from('client_data')
          .select()
          .eq('email_id', id)
          .eq('password', saltedpass)
          .lte('banned_till', DateTime.now().toString());
      if (arr.isNotEmpty) {
        _verified = true;
        _client_id = arr[0]['client_id'];
      }
      return (_verified) ? 200 : 404;
    } catch (e) {
      return 0;
    }
  }

  Future<void> ban({required String email}) async {
    email = caesarEncrypt(text: email);
    try {
      await Supabase.instance.client.from('client_data').update({
        'banned_till': DateTime.now().add(const Duration(days: 1)).toString()
      }).eq('email_id', email);
    } catch (e) {
      return;
    }
  }

  Future<void> banCustomer({required String uuid}) async {
    try {
      await Supabase.instance.client.from('customer_data').update({
        'banned_till': DateTime.now().add(const Duration(days: 1)).toString()
      }).eq('uuid', caesarEncrypt(text: uuid));
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<int> accExist({required String uuid, required String pass}) async {
    uuid = caesarEncrypt(text: uuid);
    pass = caesarEncrypt(text: pass);
    final res = await Supabase.instance.client
        .from('customer_data')
        .select('password, salt')
        .eq('uuid', uuid);
    if (res.isEmpty) {
      return 404;
    } else {
      final saltedPass =
          caesarEncrypt(text: caesarEncrypt(text: res[0]['salt']) + pass);
      if (saltedPass == res[0]['password']) {
        return 200;
      } else {
        return 400;
      }
    }
  }

  Future<Map<String, dynamic>> fetchData(
      {required String uuid, required String pass}) async {
    Map<String, dynamic> data = {'response': false};
    uuid = caesarEncrypt(text: uuid);
    pass = caesarEncrypt(text: pass);
    try {
      final salt = await Supabase.instance.client
          .from('customer_data')
          .select('salt')
          .eq('uuid', uuid)
          .single();
      final saltedPass =
          caesarEncrypt(text: caesarEncrypt(text: salt['salt']) + pass);
      print({"saltedpass": saltedPass});
      data.addAll(await Supabase.instance.client
          .from('customer_data')
          .select()
          .eq('uuid', uuid)
          .eq('password', saltedPass)
          .lte('banned_till', DateTime.now().toString())
          .single());
      data['response'] = true;
      if (data.length == 1) {
        return data;
      }
      _accessUpdation(customerId: data['customer_id'], enPass: pass);
      final aadhar = await Supabase.instance.client.storage
              .from('picture')
              .download(caesarDecrypt(text: data['aadhar']).toString()),
          pan = await Supabase.instance.client.storage
              .from('picture')
              .download(caesarDecrypt(text: data['pan']).toString());
      dynamic a = Image.memory(
        aadhar,
        fit: BoxFit.contain,
      );
      data['aadhar'] = a;
      a = Image.memory(
        pan,
        fit: BoxFit.contain,
      );
      data['pan'] = a;
      data['email_id'] = caesarDecrypt(text: data['email_id']);
      return data;
    } catch (e) {
      print(e);
      data['response'] = 'error';
      return data;
    } finally {
      print(data);
    }
  }

  Future<String> senduuidOTP({required String uuid}) async {
    try {
      Random rnd = Random.secure();
      final String otp = String.fromCharCodes(Iterable.generate(
          6, (_) => '0123456789'.codeUnitAt(rnd.nextInt(10))));
      String body =
          '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;"><h2>Verify Your OFA Account</h2><p>Hello %s,</p><p>To complete the verification process for your OFA account, please use the following OTP (One-Time Password):</p><p style="font-size: 24px; font-weight: bold; color: #007bff;">$otp</p><p>This OTP is valid for a limited time. Please enter it in the specified field to verify your account.</p><p>If you did not request this verification, please ignore this email.</p><p>Thank you for using OFA services!</p><p>Best regards,<br>Your OFA Team</p></div>';
      final email = await Supabase.instance.client
          .from('customer_data')
          .select('email_id, username')
          .eq('uuid', caesarEncrypt(text: uuid))
          .single();
      await _sendEmail(
          email: caesarDecrypt(text: email['email_id']),
          subject: "Verification for OFA",
          body: body.replaceFirst(RegExp(r'%s'), email['username']));
      print(otp);
      return otp;
    } catch (e) {
      print(e.toString());
      return "404";
    }
  }

  Future<void> _accessUpdation(
      {required int customerId, required String enPass}) async {
    try {
      await Supabase.instance.client
          .from('access_history')
          .insert({'customer_id': customerId, 'client_id': _client_id});
      final salt = getSalt(10);
      await Supabase.instance.client.from('customer_data').update({
        'password': caesarEncrypt(text: caesarEncrypt(text: salt) + enPass),
        'salt': salt,
        'last_accesed': DateTime.now().toString()
      }).eq('customer_id', customerId);
    } catch (e) {
      return;
    }
  }

  Future<void> _sendEmail(
      {required String email,
      required String subject,
      required String body}) async {
    print('Sending email to $email');
    String username = 'solutionfordocs91@gmail.com';
    String password = 'ijcxqthldcevstbi';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'OFA@Support')
      ..recipients.add(email)
      ..subject = subject
      ..html = body;

    try {
      final sendReport = await send(message, smtpServer);
      print(sendReport);
    } on MailerException catch (e) {
      print(e);
    }
  }

  Future<void> sendNotfctn({String uuid = "", String email = ""}) async {
    const subject = "OFA Card Scanned";
    if (uuid.isNotEmpty) {
      uuid = caesarEncrypt(text: uuid);
      try {
        final emailid = await Supabase.instance.client
            .from('customer_data')
            .select('email_id, username')
            .eq('uuid', uuid)
            .single();
        if (emailid.isNotEmpty) {
          String body =
              '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;"><h2>Notification: Your OFA Card Has Been Scanned</h2><p>Hello %s,</p><p>We are writing to inform you that your OFA card has been scanned somewhere.</p><p>If you have any questions or concerns, please don\'t hesitate to contact us.</p><p>Thank you!</p><p>Best regards,<br>Your OFA Team</p></div>';
          _sendEmail(
              email: caesarDecrypt(text: emailid['email_id']),
              subject: subject,
              body: body.replaceFirst(RegExp(r'%s'), emailid['username']));
          print('Sending mail to ${caesarDecrypt(text: emailid["email_id"])}');
        }
      } catch (e) {
        return;
      }
    } else if (email.isNotEmpty) {
      email = caesarEncrypt(text: email);
      try {
        final emailid = await Supabase.instance.client
            .from('client_data')
            .select('email_id, username')
            .eq('email_id', email)
            .single();
        if (emailid.isNotEmpty) {
          String body =
              '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;"><h2>Notification: Your OFA Account Has Been Accessed</h2><p>Hello %s,</p><p>We are writing to inform you that your OFA account has been accessed.</p><p>If you have any questions or concerns, please don\'t hesitate to contact us.</p><p>Thank you!</p><p>Best regards,<br>Your OFA Team</p></div>';
          _sendEmail(
              email: caesarDecrypt(text: emailid['email_id']),
              subject: subject,
              body: body.replaceFirst(RegExp(r'%s'), emailid['username']));
          print('Sending mail to ${caesarDecrypt(text: emailid["email_id"])}');
        }
      } catch (e) {
        print(e.toString());
        return;
      }
    }
  }
}
