// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instagram_app/dialogs/one_button_dialog.dart';
import 'package:instagram_app/pages/auth/login_page.dart';
import 'package:instagram_app/utils/api.dart' as api;

//stateless quindi quando si fa hot refresh si perdono i dati nei text field
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  static const String pageRoute = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  String error = '';

  Future<int> register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    var code = await api.UserApi.addNewUser(username, password, email);

  
    return code;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
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
                    child: Text(
                      'Instagram',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('Dopo la registrazione sarà necessario fare il login*'),
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: _usernameController,
                      decoration:
                          InputDecoration(labelText: 'Inserisci username'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(14.0),
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
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Inserisci email'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          int code = await register();
                          if (code== 200) {
                            bool? ok = await oneButtonDialog(context,
                                'Registrazione effettuata!\nOra effettua il login');

                            if (ok != null && ok) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyLoginPage()));
                            }
                          } else if(code == 409){
                            oneButtonDialog(context,
                                'Username con quel nome già esistente.\nRiprovare');
                          }
                          else{
                            oneButtonDialog(context,
                                'Errore nella registrazione.\nRiprovare');
                          }
                        }
                      },
                      child: const Text('Register')),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
