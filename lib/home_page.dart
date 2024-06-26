import 'package:doctor_app/doctor_login.dart';
import 'package:doctor_app/user_login.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: SingleChildScrollView(
        child: Column(
        
          children: [
        
            SizedBox(
              width:double.infinity,
              child: Image.asset(
                'images/splashimage.jpg',
                color: Colors.purple.withOpacity(1.0),
                colorBlendMode: BlendMode.softLight,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text('Medico',style: TextStyle(fontFamily: 'Poppins',fontSize: 40,fontWeight: FontWeight.w600,color:Color(0xFF7165D6)),),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                textAlign: TextAlign.center,
                'Appoint your doctor with one tap',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,color:Colors.grey[600]),),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                textAlign: TextAlign.center,
                'Choose Your Role',style: TextStyle(fontFamily: 'Poppins',fontSize:17, fontWeight: FontWeight.w600,color:Colors.grey[600]),),
            ),
        SizedBox(
          height: 30,
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly
          ,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorLogin()));
        
              },
              child: Container(
                width: 130,
                height: 150,
              
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/docrole.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Doctor',
                      style: TextStyle(fontSize: 17,fontFamily: 'Poppins',color: Colors.grey[600]),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(
                    color: Color(0xFF7165D6),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
              
              ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()));
              },
              child: Container(
                width: 130,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/userrole.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User',
                      style: TextStyle(fontSize: 17,fontFamily: 'Poppins',color: Colors.grey[600]),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(
                    color: Color(0xFF7165D6),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
              
              ),
                ),
            ),
          ],
        )
        ],
        ),
      ),
    );
  }
}
