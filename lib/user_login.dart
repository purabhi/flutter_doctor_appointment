import 'dart:convert';
import 'package:doctor_app/user_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doctor_app/user_register.dart';
import 'package:flutter/material.dart';
import 'api_route.dart';
import 'loadingdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _obscureText = true;

  void formValidation() {
    if (namecontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty)
    {
loginNow();
    }
    else
    {
      print(namecontroller.text);
      print(passwordcontroller.text);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Warning',
        desc: 'Please Fill the field Properly!!',
        btnOkOnPress: () {},
        btnOkColor: Colors.yellow[700],
      ).show();
    }
  }

  void loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking credentials",
        );
      },
    );

    var loginBody = {
      "name": namecontroller.text.trim().toLowerCase(),
      "pass": passwordcontroller.text.trim().toLowerCase()
    };

    try {
      final apiroute = Uri.parse('$api/api/user/loginUser');
      final headers = {'Content-Type': 'application/json'};

      final response = await http.post(
        apiroute,
        headers: headers,
        body: json.encode(loginBody),
      );

      final jsonResponse = json.decode(response.body);



      if (response.statusCode == 200 && jsonResponse['msg'] == 'Success') {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', jsonResponse['userid']);

        Navigator.pop(context);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserDashboard()));
        intializefields(); // Clear the text fields
      }
      else
      {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Warning',
          desc: jsonResponse['msg'],
          btnOkOnPress: () {},
          btnOkColor: Colors.amber,
        ).show();
      }
    } catch (e) {
      print('Error: $e');
      Navigator.pop(context); // Close the loading dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Try Again!!',
        btnCancelOnPress: () {},
      ).show();
    }
  }

  void intializefields() {
    namecontroller.clear();
    passwordcontroller.clear();
  }





  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.deepPurple[50],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/doctors.png',
                    width: 300,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Log In User',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: namecontroller,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),

                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Name',
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'Poppins')),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: 'Poppins'),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      formValidation();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Color(0xFF7165D6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontFamily: 'Poppins',fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserRegister()),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFF7165D6),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
