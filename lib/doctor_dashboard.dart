import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_route.dart';
import 'home_page.dart';
import 'loadingdialog.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  List<dynamic>? appointments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getalldocdata();
    });
  }

  Future<void> getalldocdata() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Fetching data",
        );
      },
    );

    try {
      var prefs = await SharedPreferences.getInstance();
      String? usersid = prefs.getString('docid');
      var getdataapi = Uri.parse('$api/api/doctor/getAppointments_byDoctorId/$usersid');
      var response = await http.get(
        getdataapi,
        headers: {
          "Content-Type": "application/json",
        },
      );
      Navigator.pop(context); // Close loading dialog
      if (response.statusCode == 200) {
        setState(() {
          appointments = jsonDecode(response.body)['msg'] as List<dynamic>;
          print(appointments);
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog in case of error
      print('Error fetching appointments: $e');
    }
  }

  void logoutNow(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('docid');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
    );
  }

  void showAppointmentDetailsBottomSheet(Map<String, dynamic> appointment, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 350.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.purple[100]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${appointment['dname']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${appointment['spec']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 10),
                Text(
                  'Patient Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Name: ${appointment['pname']}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'Age: ${appointment['age']}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'Phone: ${appointment['phone']}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'Disease: ${appointment['disease']}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7165D6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Text('Are you sure to mark for done ?',
                                    textAlign: TextAlign.start,),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Confirm'),
                                onPressed: () {
                                  changestatus(appointment['_id'], index);
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      // Close bottom sheet
                    },
                    child: Text(
                      'Mark for Done',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void changestatus(String id, int index) async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking credentials",
        );
      },
    );

    try {
      final apiroute = Uri.parse('$api/api/doctor/updateAppointmentStatus/$id');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.put(
        apiroute,
        headers: headers,
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['msg'] == 'Success') {
        setState(() {
          appointments!.removeAt(index);
        });
        Navigator.pop(context); // Close the loading dialog
        Navigator.pop(context); // Close the bottom sheet

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'Status Updated',
          btnOkOnPress: () {},
        ).show();
      }
      else
      {
        Navigator.pop(context); // Close the loading dialog

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
    } catch (e)
    {
      Navigator.pop(context); // Close the loading dialog
      // Show error dialog
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

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF7165D6),
        title: Text('Hello Doctor', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: () {
              logoutNow(context);
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 17),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: appointments == null
              ? Center(child: CircularProgressIndicator())
              : appointments!.isEmpty
              ? Center(child: Text("No appointments found.", style: TextStyle(fontFamily: 'Poppins', fontSize: 18)))
              : ListView.builder(
            itemCount: appointments?.length ?? 0,
            itemBuilder: (context, index) {
              final appointment = appointments![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child:
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Patient: ${appointment['pname']}',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Age: ${appointment['age']}',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Disease: ${appointment['disease']}',
                        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone: ${appointment['phone']}',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: (){
                                showAppointmentDetailsBottomSheet(appointment, index);
                              },
                              child: Text('More Details'))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
