import 'package:demo_flutter/network/api_service.dart';
import 'package:demo_flutter/screens/home_screen.dart';
import 'package:demo_flutter/session/session_manager.dart';
import 'package:demo_flutter/widgets/custom_progress_dialog.dart';
import 'package:flutter/material.dart';

import '../utils/app_sizes.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _formKey =
  GlobalKey<FormState>();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  bool isPasswordVisible = false;

  final ApiService apiService =
  ApiService();

  Future<void> loginUser() async {

    try {

      CustomProgressDialog.show(
        context,
      );

      final response =
      await apiService.loginUser(

        username:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      CustomProgressDialog.hide(
        context,
      );

      final data = response.data;

      print(
        "Login Response => $data",
      );

      /// Save Session
      await SessionManager
          .saveLoginSession(

        userData: data,

        accessToken:
        data['accessToken'],
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            "Welcome ${data['firstName']}",
          ),
        ),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const HomeScreen(),
        ),
      );

    } catch (e) {

      CustomProgressDialog.hide(
        context,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Login Failed\n$e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FA),

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(
            AppSizes.padding,
          ),

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.center,

              children: [

                /// Top Text
                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.center,

                  children: [

                    Text(

                      AppStrings
                          .welcomeback,

                      style:
                      AppTextStyles
                          .heading,

                      textAlign:
                      TextAlign.center,
                    ),

                    SizedBox(
                      height:
                      AppSizes
                          .margintop,
                    ),

                    Text(

                      AppStrings.signmsg,

                      style:
                      AppTextStyles
                          .subHeading,

                      textAlign:
                      TextAlign.center,
                    ),
                  ],
                ),

                /// Center Content
                Expanded(

                  child: Center(

                    child:
                    SingleChildScrollView(

                      child: Column(

                        mainAxisSize:
                        MainAxisSize.min,

                        children: [

                          /// Logo
                          Container(

                            height: 100,
                            width: 100,

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              shape:
                              BoxShape.circle,

                              boxShadow: [

                                BoxShadow(

                                  color: Colors
                                      .black
                                      .withOpacity(
                                    0.1,
                                  ),

                                  blurRadius: 12,

                                  spreadRadius: 2,

                                  offset:
                                  const Offset(
                                    0,
                                    5,
                                  ),
                                ),
                              ],
                            ),

                            child: Padding(

                              padding:
                              const EdgeInsets
                                  .all(18),

                              child: Image.asset(

                                "assets/images/applogo.png",

                                fit: BoxFit
                                    .contain,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 35,
                          ),

                          /// Username
                          TextFormField(

                            controller:
                            emailController,

                            keyboardType:
                            TextInputType
                                .text,

                            decoration:
                            InputDecoration(

                              hintText:
                              "Enter Username",

                              prefixIcon:
                              const Icon(
                                Icons.person,
                              ),

                              filled: true,

                              fillColor:
                              Colors.white,

                              contentPadding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 18,
                              ),

                              border:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),

                              enabledBorder:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),

                              focusedBorder:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                const BorderSide(
                                  color:
                                  Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),

                            validator:
                                (value) {

                              if (value ==
                                  null ||
                                  value
                                      .isEmpty) {

                                return "Please enter username";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// Password
                          TextFormField(

                            controller:
                            passwordController,

                            obscureText:
                            !isPasswordVisible,

                            decoration:
                            InputDecoration(

                              hintText:
                              "Enter Password",

                              prefixIcon:
                              const Icon(
                                Icons.lock,
                              ),

                              suffixIcon:
                              IconButton(

                                icon: Icon(

                                  isPasswordVisible

                                      ? Icons
                                      .visibility

                                      : Icons
                                      .visibility_off,
                                ),

                                onPressed: () {

                                  setState(() {

                                    isPasswordVisible =
                                    !isPasswordVisible;
                                  });
                                },
                              ),

                              filled: true,

                              fillColor:
                              Colors.white,

                              contentPadding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 18,
                              ),

                              border:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),

                              enabledBorder:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),

                              focusedBorder:
                              OutlineInputBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  15,
                                ),

                                borderSide:
                                const BorderSide(
                                  color:
                                  Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),

                            validator:
                                (value) {

                              if (value ==
                                  null ||
                                  value
                                      .isEmpty) {

                                return "Please enter password";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 35,
                          ),

                          /// Login Button
                          SizedBox(

                            width:
                            double.infinity,

                            height: 55,

                            child:
                            ElevatedButton(

                              onPressed: () {

                                if (_formKey
                                    .currentState!
                                    .validate()) {

                                  loginUser();
                                }
                              },

                              style:
                              ElevatedButton
                                  .styleFrom(

                                backgroundColor:
                                Colors.blue,

                                shape:
                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    15,
                                  ),
                                ),
                              ),

                              child:
                              const Text(

                                "Login",

                                style:
                                TextStyle(

                                  fontSize:
                                  18,

                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  color: Colors
                                      .white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
