import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

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
          const Text('Email verification has been sent. Open it to verify your email.'),
          const Text("If you haven't received any verifications, press the button below."),
          TextButton(
            onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventSendVerification());
                if(context.mounted){
                  showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Email Verification has been sent!'),
                      content: const Text('Please login again'),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: const Text('OK'))
                      ],
                    );
                  },);  
                  }
              
          }
          , child: const Text('Send Email Verification')),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogOut());
          }, child: const Text('Back to login page'))
        ]),
    );
  }
}