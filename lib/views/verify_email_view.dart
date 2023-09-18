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
        backgroundColor: const Color(0xFF1B1B1B),
        centerTitle: true, // 
      ),
      body: Container(
        color: const Color.fromARGB(255, 55, 53, 53),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Email verification has been sent. Open it to verify your email.',style: TextStyle(color: Colors.white),),
            const Text("If you haven't received any verifications, press the button below.",style: TextStyle(color: Colors.white),),
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
                
            },style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 28, 73, 95))
            
            , child: const Text('Send Email Verification', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            style: TextButton.styleFrom(backgroundColor: Colors.white),
            
             child: const Text('Back to login page'))
          ]),
      ),
    );
  }
}