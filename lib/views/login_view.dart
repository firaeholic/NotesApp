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
      listener: (context, state) async{
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('You have to login to create notes and store them.'),
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventLogIn(email, password));
                  },
                  child: const Text('Login')),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventForgotPassword());
                  },
                  child: const Text('Forgot your password?'))
                ,
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventShouldRegister());
                  },
                  child: const Text('Not registered yet? Register here!'))
                ,
                //  TextButton(
                // onPressed: () async{
                //   await getUsers();
                // }, 
                // child: const Text('click'))
            ],
          ),
        ),
      ),
    );
  }
}
