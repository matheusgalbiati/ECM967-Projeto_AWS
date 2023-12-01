import 'package:flutter/material.dart';
//import 'package:sentinel_guard/pages/contacts_page_m.dart';
import 'package:sentinel_guard/pages/home_page.dart';
import 'package:sentinel_guard/pages/login_page.dart';
//import 'package:sentinel_guard/pages/map_page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget { 
  const MyApp({Key? key}) : super(key: key);
  
  @override  
    Widget build(BuildContext context) {    
      return  MaterialApp(
        home: LoginPage(),
              //const HomePage(userEmail: 'victor@gmail.com'),
              //const ContactsPageM(userEmail: "victor@gmail.com"),
         );
    }
}

