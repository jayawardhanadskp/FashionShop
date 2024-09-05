import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/api/api_connection.dart';
import 'package:shopping_app/users/authentication/signup_screen.dart';
import 'package:shopping_app/users/model/user.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isObsecure = true.obs;

  // Function to log in the user
  loginUser() async {
    if (!formKey.currentState!.validate()) {
      return; // Early exit if form is not valid
    }

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      var response = await http.post(
        Uri.parse(ApiConnection.logIn),
        body: {
          'user_email': _emailController.text.trim(),
          'user_password': _passwordController.text.trim(),
        },
      );

      Navigator.of(context).pop(); // Dismiss the loading indicator

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          // Ensure userData is not null and is of correct type
          if (responseBody.containsKey('userData') && responseBody['userData'] != null) {
            var userData = responseBody['userData'];
            User user = User.fromJson(userData);

            Fluttertoast.showToast(msg: 'Login Successful');

            // Navigate to the home screen
            Get.offAll(() => HomeScreen());
          } else {
            Fluttertoast.showToast(msg: 'User data is missing');
          }
        } else {
          // Handle login error
          Fluttertoast.showToast(msg: 'Login Failed: ${responseBody['error'] ?? 'Try again'}');
        }
      } else {
        // Handle server error
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading indicator
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
                                _buildEmailField(),
                                const SizedBox(height: 20),
                                _buildPasswordField(),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: loginUser, // Call the login function
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.pink,
                                    foregroundColor: AppColors.white,
                                    fixedSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'SIGN IN',
                                    style: AppFonts.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an Account?',
                                  style: AppFonts.bodyText1white,
                                ),
                                const SizedBox(width: 0),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const SignupScreen());
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: AppFonts.bodyText1pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
