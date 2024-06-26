import 'dart:convert';
import 'package:doctor_app/user_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_route.dart';
import 'loadingdialog.dart';

class DoctorDetails extends StatefulWidget {
  final String name;
  final String about;
  final String id;
  final String exp;
  final String spec;

  const DoctorDetails({
    required this.name,
    required this.about,
    required this.id,
    required this.exp,
    required this.spec,
    super.key,
  });

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();

  void addappointment(String name, phone, disease, age) async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking credentials",
        );
      },
    );
    var prefs = await SharedPreferences.getInstance();
    String? usersid = prefs.getString('userid');

    final appBody = {
      "pname": name,
      "dname": widget.name,
      "age": age,
      "disease": disease,
      "phone": phone,
      "doc_id": widget.id,
      "pat_id": usersid,
      "spec": widget.spec,
    };

    try {
      final apiroute = Uri.parse('$api/api/user/bookAppointment');
      final headers = {'Content-Type': 'application/json'};
      print(appBody);
      final response = await http.post(
        apiroute,
        headers: headers,
        body: json.encode(appBody),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['msg'] == 'Success') {
        Navigator.pop(context); // Close any existing dialogs or loading indicators

        Future.delayed(Duration(seconds: 0), () {
          setState(() {
            print(jsonResponse['appointment']);
          });

          // Show the success dialog
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Success',
            desc: 'Booking Confirmed',
            btnOkOnPress: () {},
          ).show();

          // Navigate to the home screen after another delay
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDashboard()),
            );
          });
        });
      } else {
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

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Book an Appointment',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[800],
                    fontSize: 19,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Doctor: ${widget.name}',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                'Speciality: ${widget.spec}',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: diseaseController,
                decoration: InputDecoration(
                  labelText: 'Disease',
                  labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7165D6),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final name = nameController.text.trim();
                  final age = ageController.text.trim();
                  final phone = phoneController.text.trim();
                  final disease = diseaseController.text.trim();
                  addappointment(name, phone, disease, age);
                  Navigator.pop(context);
                  intializefields();
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(width: 5), // Add space between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  intializefields();
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void intializefields() {
    nameController.clear();
    phoneController.clear();
    diseaseController.clear();
    ageController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Color(0xFF7165D6),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple[100]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                        child: Image.asset(
                          'images/doc.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.purple.withOpacity(0.6), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Experience',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  widget.exp,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.local_hospital, color: Colors.red, size: 18),
                            SizedBox(width: 4),
                            Text(
                              widget.spec,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.about,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 100), // To give space for the button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7165D6),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showBookingDialog,
              child: Text(
                'Book Appointment',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
