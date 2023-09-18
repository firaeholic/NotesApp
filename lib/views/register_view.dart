import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordAuthException){
              await showErrorDialog(context, 'Weak password!');
          }else if(state.exception is InvalidEmailAuthException){
              await showErrorDialog(context, 'Invalid email address!');
          }else if(state.exception is EmailAlreadyInUseAuthException){
              await showErrorDialog(context, 'Email is already in use!');
          }else if(state.exception is GenericAuthException){
              await showErrorDialog(context, "Registration failed!");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: const Color(0xFF1B1B1B), 
          centerTitle: true, 
        ),
        body: Container(
          color: const Color.fromARGB(255, 55, 53, 53),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register using your email and password.',
                style: TextStyle(color: Colors.white),
                ),
              
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white), 
                decoration: const InputDecoration(hintText: 'Email', hintStyle: TextStyle(color: Colors.white)),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.white), 
                decoration: const InputDecoration(hintText: 'Password',hintStyle: TextStyle(color: Colors.white)),
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(AuthEventRegister(email, password,));
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 28, 73, 95), 
              ),
                  child: const Text('Register', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),)),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
              ),
                  child: const Text('Already registered? Login here!'))
            ],
          ),
        ),
      ),
    );
  }
}
