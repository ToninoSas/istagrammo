// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/utils/styles.dart';
import 'package:instagram_app_cool/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String pageRouteName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false, _hasSelectedImg = false;
  Uint8List? img;

  void registraUtente() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().register(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        profileImg: img);
    // if string returned is sucess, user has been created
    if (res == "") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      showSnackBar(context, 'Registrazione effettuata!');

      if (context.mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed('/main');
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Text(
                  //   'Instagram',
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  Stack(children: [
                    _hasSelectedImg
                        ? CircleAvatar(
                            radius: 55,
                            backgroundImage: MemoryImage(img!),
                            backgroundColor: Colors.white,
                          )
                        : const CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                "https://static.vecteezy.com/system/resources/previews/020/911/740/original/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png"),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 70,
                      child: IconButton(
                        onPressed: () async {
                          img = await getImageFromGallery();
                          if (img != null) {
                            setState(() {
                              _hasSelectedImg = true;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                    if (_hasSelectedImg)
                      Positioned(
                        bottom: -10,
                        left: -5,
                        child: IconButton(
                          tooltip: 'Rimuovi immagine',
                          onPressed: () {
                            setState(() {
                              _hasSelectedImg = false;
                              img = null;
                            });
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      )
                  ]),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Inserire email';
                                  }
                                  return null;
                                },
                                decoration: textFieldDecoration(label: 'Email')),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Inserire password';
                                  }
                                  return null;
                                },
                                decoration: textFieldDecoration(label: 'Password')),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                                controller: _usernameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Inserire username';
                                  }
                                  return null;
                                },
                                decoration: textFieldDecoration(label: 'Username')),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                                controller: _bioController,
                                decoration:
                                    textFieldDecoration(label: 'Bio')),
                            const SizedBox(
                              height: 24,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    registraUtente();
                                  }
                                },
                                child: const Text('Register'))
                          ],
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Hai già un account?',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.pushReplacementNamed(
                            context,
                            '/main',
                          )
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            ' Login.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
