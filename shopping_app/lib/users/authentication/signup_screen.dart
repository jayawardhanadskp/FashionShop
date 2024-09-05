import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/api/api_connection.dart';
import 'package:shopping_app/users/authentication/login_screen.dart';
import 'package:shopping_app/users/model/user.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/fonts.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async {
    try {
      var response = await http.post(
          Uri.parse(ApiConnection.validateEmail),
          body: {
            'user_email': _emailController.text.trim(),
          }
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['emailFound'] == true) {
          Fluttertoast.showToast(msg: 'Email is already in use');
        } else {
          registerAndSaveUserRecord();
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Network error: $e');
    }
  }


  registerAndSaveUserRecord() async {
    User userModel = User(
      user_id: 1,
      user_name: _nameController.text.trim(),
      user_email: _emailController.text.trim(),
      user_password: _passwordController.text.trim(),
    );

    try {
      var response = await http.post(
        Uri.parse(ApiConnection.signUp),
        body: userModel.toJson(),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          Fluttertoast.showToast(msg: 'Sign up Successfully');
        } else {
          Fluttertoast.showToast(msg: 'Error: ${responseBody['error'] ?? 'Try again'}');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Network error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 390,
                    child: Image.asset('assets/drawn-fashion.png'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[10],
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                _buildNameField(),
                                const SizedBox(height: 20,),
                                _buildEmailField(),
                                const SizedBox(height: 20),
                                _buildPasswordField(),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()){
                                        print('signup running button');
                                        validateUserEmail();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.pink,
                                        foregroundColor: AppColors.white,
                                        fixedSize: const Size(200, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    child: Text(
                                      'SIGN UP',
                                      style: AppFonts.normal,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Have an Account?',
                                  style: AppFonts.bodyText1white,
                                ),
                                const SizedBox(
                                  width: 0,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(const LoginScreen());
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: AppFonts.bodyText1pink,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) => value == '' ? 'Please Enter Name' : null,
      decoration: _inputDecoration(
        hintText: 'Name',
        icon: Icons.person,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) => value == '' ? 'Please Enter Email' : null,
      decoration: _inputDecoration(
        hintText: 'Email',
        icon: Icons.email,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
          controller: _passwordController,
          obscureText: isObsecure.value,
          validator: (value) => value == '' ? 'Please Enter Password' : null,
          decoration: _inputDecoration(
            hintText: 'Password',
            icon: Icons.lock,
            suffixIcon: GestureDetector(
              onTap: () => isObsecure.value = !isObsecure.value,
              child: Icon(
                isObsecure.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.pink[100],
              ),
            ),
          ),
        ));
  }

  InputDecoration _inputDecoration(
      {required String hintText, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: AppColors.pink,
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.pink),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.pink),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.pink),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.pink),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      fillColor: Colors.white,
      filled: true,
    );
  }
}
