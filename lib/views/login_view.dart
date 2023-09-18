import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    listener: (context, state) async {
      if (state is AuthStateLoggedOut) {
        if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(context, "Couldn't find a user with the given credentials!");
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(context, 'Wrong password!');
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(context, "Authentication error!");
        }
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF1B1B1B),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 55, 53, 53), 
        padding: const EdgeInsets.all(16.0),
        child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      'You have to login to create notes and store them.',
      style: TextStyle(color: Colors.white),
    ),
    const SizedBox(height: 26.0),
    TextField(
      controller: _email,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: Color.fromARGB(255, 103, 99, 99)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 86, 83, 83)),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        )
      ),
    ),
    const SizedBox(height: 20.0),
    TextField(
      controller: _password,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Color.fromARGB(255, 103, 99, 99)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 86, 83, 83)),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
          )
      ),
    ),
    const SizedBox(height: 26.0),
    ElevatedButton(
      onPressed: () async {
        final email = _email.text;
        final password = _password.text;
        context.read<AuthBloc>().add(AuthEventLogIn(email, password));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 28, 73, 95),
      ),
      child: const Text(
        'Login',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    ),
    TextButton(
      onPressed: () {
        context.read<AuthBloc>().add(const AuthEventForgotPassword());
      },
      style: TextButton.styleFrom(),
      child: const Text('Forgot your password?'),
    ),
    TextButton(
      onPressed: () {
        context.read<AuthBloc>().add(const AuthEventShouldRegister());
      },
      style: TextButton.styleFrom(),
      child: const Text('Not registered yet? Register here!'),
    ),
  ],
),
      ),
    ),
  );
}
}