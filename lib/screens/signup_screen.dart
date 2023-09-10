import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portrait_click/screens/login_screen.dart';
import 'package:portrait_click/services/auth_service.dart';
import 'package:portrait_click/utils/utils.dart';

import '../widgets/inputTextField.dart';
import '../colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!);

    if (res == 'success') {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  void dispose() {
    
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void pickImage() async {
    Uint8List img = await selectImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.1, 0),
                end: Alignment.topLeft,
                stops: [0.1, 5],
                colors: [
                  loginBGColor,
                  Colors.white,
                ],
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 1.4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                      offset: Offset(5.0, 6.0),
                    )
                  ]),
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo/logo_dark.png",
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg"),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: pickImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),

                  //Username TextField
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InputTextField(
                      textController: _usernameController,
                      isPassword: false,
                      hintText: "Enter Your Username",
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InputTextField(
                      textController: _emailController,
                      isPassword: false,
                      hintText: "Enter Your Email Address",
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),

                  //password Field
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InputTextField(
                      textController: _passwordController,
                      isPassword: true,
                      hintText: "Enter Your Password",
                      textInputType: TextInputType.name,
                    ),
                  ),

                  //Login Button
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: !_isLoading
                            ? const Center(
                                child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text("Login Here"))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
