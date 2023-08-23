import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(children: [
          const Text('Please verify your email'),
          TextButton(onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                // ignore: use_build_context_synchronously
                showDialog(
                 context: context,
                 builder: (context) {
                   return AlertDialog(
                    title: const Text('Email Verification has been sent!'),
                    content: const Text('Please login again'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                         (route) => false);
                      }, child: const Text('OK'))
                    ],
                   );
                 },);                
          }
          , child: const Text('Send Email Verification')),
          Center(
            child: TextButton(onPressed: () {
               
            }, child: const Text('Login')),
          )
        ]),
    );
  }
}