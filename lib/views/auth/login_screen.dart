import 'package:flutter/material.dart';
import 'package:foodapp/controllers/auth_controllers.dart';
import 'package:foodapp/views/auth/sign_up_screen.dart';
import 'package:get/get.dart';

import '../../components/reusable_primary_button.dart';
import '../../components/reusable_textfield.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ReusableTextField(
                  labelText: 'Phone/Email',
                  controller: authController.loginEmailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone/email';
                    }
                    return null;
                  }, obscureText: false,
                ),
                SizedBox(
                  height: 20,
                ),
                ReusableTextField(
                  labelText: 'Password',
                  controller: authController.loginPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),

                // Lets make a custom button and convert into a component
                ReusablePrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      authController.loginUser();
                    }
                  },
                  buttonText: 'Login',
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.to(SignUpScreen());
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
