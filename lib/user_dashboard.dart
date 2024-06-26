import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doctor_app/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_route.dart';
import 'doctor_details.dart';
import 'loadingdialog.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<dynamic>? appointments;
  List<dynamic>? doctors;
  int appointmentCount = 0;
  String? selectedCat;
  List items=['Cardiology', 'Orthopedic', 'Pediatrician', 'Eye'];

  @override
  void initState() {
    super.initState();
    getalldata(); // Fetch appointment data when widget initializes
  }




  void logoutNow(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('usersid');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> getalldata() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? usersid = prefs.getString('userid');
      var getdataapi = Uri.parse('$api/api/user/getAppointments_byPatientId/$usersid');
      var response = await http.get(
        getdataapi,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body);
          appointments = data['msg'] as List<dynamic>;
          appointmentCount = appointments?.length ?? 0;
        });
      }
      else
      {
        print('Failed to load appointments');      }
    }
    catch (e)
    {
      print('Error fetching appointments: $e');
    }
  }

  void showDoctorList() {
    if (appointments != null && appointments!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.purple[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Appointment List',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
                  backgroundColor: Color(0xFF7165D6),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: appointments?.length ?? 0,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final appointment = appointments![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
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
                                              Navigator.pop(context); // Close bottom sheet
                                            },
                                            child: Text(
                                              'Close',
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
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${appointment['dname']} - ${appointment['spec']}',
                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Color(0xFF7165D6), size: 15),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7165D6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else
    {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.purple[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Appointment List',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
                  backgroundColor: Color(0xFF7165D6),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'No appointments found.',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7165D6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }


  void getdoctors(String category) async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking credentials",
        );
      },
    );
    try {
      var getdataapi = Uri.parse('$api/api/user/getDoc_byCategory/$category');
      var response = await http.get(
        getdataapi,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body);
          doctors = data['msg'] as List<dynamic>;
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Warning',
          desc: 'Failed to fetch doctors',
          btnOkOnPress: () {},
          btnOkColor: Colors.amber,
        ).show();
      }
    } catch (e) {
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Try Again',
        btnCancelOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.purple[50],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF7165D6),
        title: Text('Medico', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(left: 16,right: 12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello User',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFF7165D6),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: Stack(
                              children: [
                                Icon(Icons.notifications, color: Color(0xFF7615D6)),
                                if (appointmentCount > 0)
                                  Positioned(
                                    right: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 8,
                                      ),
                                      child: Text(
                                        '$appointmentCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            onPressed: () {
                              showDoctorList();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find Your doctor',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.grey[600],
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.only(right: 16),
                            child:
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint:Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Colors.black45,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: ['Cardiology','Orthopedic','Eye','Pediatrician']
                                 .asMap().entries.map((item)
                                  {
                                  int index = item.key;
                                  String value = item.value;

                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                textAlign: TextAlign.left,
                                                value,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',

                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if(index<3)
                                              Divider(
                                                color: Colors.grey[400],
                                                height: 1,
                                              ),

                                          ],
                                        )

                                    );
                                  }

                                  ).toList(),
                                  value: selectedCat,
                                  onChanged: (value) {
                                  setState(() {
                                  selectedCat = value;
                                  });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                  color: Colors.black26,
                                  ),
                                  color: Colors.purple[50],
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 25,
                                  iconEnabledColor: Colors.grey,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[50],
                                  ),
                                  offset: const Offset(1, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(10),
                                    thickness: WidgetStateProperty.all(6),
                                    thumbVisibility: WidgetStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7165D6)),
                          onPressed: selectedCat == null
                              ? null
                              : () {
                            getdoctors(selectedCat!);
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: doctors == null
                  ? Center(child: Text("No Data",style: TextStyle(fontFamily: 'Poppins',fontSize: 18),))
                  : doctors!.isEmpty
                  ? Center(child: Text("No doctors found.",style: TextStyle(fontFamily: 'Poppins',fontSize: 18),))
                  : ListView.builder(
                itemCount: doctors?.length ?? 0,
                itemBuilder: (context, index) {
                  final doctor = doctors![index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DoctorDetails(
                            name: doctor['doc_name'],
                            about: doctor['about'],
                            exp: doctor['exp'],
                            id: doctor['_id'],
                            spec: doctor['speciality'],
                          ),
                        ));
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/docsymbol.png',
                                width: 40,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doctor['doc_name'],
                                        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 15,color: Colors.grey[700])),
                                    SizedBox(height: 5),
                                    Text('Experience : ${doctor['exp']}',
                                        style: TextStyle(fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Color(0xFF7165D6)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


