import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateForgotPassword){
          if(state.hasSentEmail){
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if(context.mounted){
            if(state.exception != null){
              if(_controller.text == ''){
                await showErrorDialog(context, 'Please provide an email');
                return;
              }else{
                await showErrorDialog(context, 'User does not exist/invalid email');
            }  
              }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
          backgroundColor: const Color(0xFF1B1B1B),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromARGB(255, 55, 53, 53),
          child: Column(
            children: [
              const Text('If you forgot your password, write your email and we will send you a recovery link.', style: TextStyle(color: Colors.white),),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 103, 99, 99)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 86, 83, 83)),
                    borderRadius: BorderRadius.all(Radius.circular(23))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
                }, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(2255, 28, 73, 95)),
                child: const Text('Reset password', style: TextStyle(color: Colors.white),)
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255,255,255,255)),
                child: const Text('Go back'))
            ],
          ),
        ),
      ),
      );

  }
}