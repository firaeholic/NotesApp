import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
            children: [
        
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email'
                ),
              ),
        
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  hintText: 'Password'
                ),
              ),
              
              TextButton(
                onPressed: () async {
        
                  final email = _email.text;
                  final password = _password.text;
                  try{
                    await AuthService.firebase().createUser(email: email, password: password);
                    AuthService.firebase().sendEmailVerification();
                    if(context.mounted){
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    }
                  } on WeakPasswordAuthException{
                    await showErrorDialog(context, 'Weak password!');

                  } on InvalidEmailAuthException{
                    await showErrorDialog(context, 'Invalid email address!');

                  } on EmailAlreadyInUseAuthException{
                    await showErrorDialog(context, 'Email is already in use!');

                  } on GenericAuthException{
                    await showErrorDialog(context, "Registration failed!");
                  }
                }, 
                child: const Text('Register')
                ),
    
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                       (route) => false);
                  },
                 child: const Text('Already registered? Login here!'))
            ],
          ),
    );
  }
}