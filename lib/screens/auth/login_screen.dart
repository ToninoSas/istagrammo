// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/dialogs/one_button_dialog.dart';
import 'package:instagram_app/methods/auth_methods.dart';
import 'package:instagram_app/utils/func.dart';

//stateless quindi quando si fa hot refresh si perdono i dati nei text field
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static const String pageRoute = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    String msg =
        await AuthMethods().loginUtente(email: email, password: password);

    if (msg != "") {
      showSnackBar(msg, context);
    } else {
      showSnackBar("Login effettuato", context);
    }
  }

  // TODO testare google login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            'Instagram',
                            style: TextStyle(fontSize: 24),
                          ),
                          // Text('Login', style: TextStyle(fontSize: 18))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Inserisci email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _passwordController,
                        decoration:
                            InputDecoration(labelText: 'Inserisci password'),
                      ),
                    ),
                    ElevatedButton(
                        // style: Styles.btnStyle,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text('Login')),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Registrati'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              AuthMethods().googleLoginUtente();
                            },
                            child: const Text('Entra con google')),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
