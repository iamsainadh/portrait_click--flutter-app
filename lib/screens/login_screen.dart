// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:portrait_click/screens/signup_screen.dart';
import 'package:portrait_click/utils/bottombar.dart';
import 'package:portrait_click/widgets/inputTextField.dart';
import 'package:portrait_click/colors.dart';
import 'package:portrait_click/services/auth_service.dart';
import 'package:portrait_click/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void makeLogin() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthService().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
     
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const BottomBar())));
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: MediaQuery.of(context).size.height / 1.5,
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
                    height: 30,
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
                    onTap: () {
                      makeLogin();
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue),
                            child: const Center(
                                child: Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                          },
                          child: const Text("SignUp Here"))
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
