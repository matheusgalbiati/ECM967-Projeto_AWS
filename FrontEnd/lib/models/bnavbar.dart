import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sentinel_guard/pages/contacts_page_m.dart';
import 'package:sentinel_guard/pages/devices_page.dart';
import 'package:sentinel_guard/pages/routes_page.dart';
import 'package:sentinel_guard/pages/profile_page.dart';
import 'package:sentinel_guard/pages/home_page.dart';



// ignore: must_be_immutable
class bnavbar extends StatefulWidget {
  String userEmail;
  int selectedIndex;
  bnavbar({super.key, required this.userEmail, required this.selectedIndex});

  @override
  State<bnavbar> createState() => _bnavbarState(userEmail, selectedIndex);
}

class _bnavbarState extends State<bnavbar> {
  String userEmail;
  int selectedIndex;
  //String _response = 'Aguardando resposta...';

  

  _bnavbarState(this.userEmail, this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: /*const Color.fromRGBO(152, 218, 217, 1)*/Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
            backgroundColor: /*const Color.fromRGBO(152, 218, 217, 1)*/Colors.white,
            activeColor: Colors.black,
            tabBackgroundColor: const Color.fromRGBO(152, 218, 217, 0.4),
            padding: const EdgeInsets.all(16),
            gap: 5,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Início',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomePage(userEmail: widget.userEmail))));},
                ),
              GButton(
                icon: Icons.contacts,
                text: 'Contatos',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => ContactsPageM(userEmail: widget.userEmail))));}
                ),
              GButton(
                icon: Icons.route,
                text: 'Rotas',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => RoutesPage(userEmail: widget.userEmail))));}
                ),
              GButton(
                icon: Icons.watch,
                text: 'Dispositivos',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => DevicesPage(userEmail: widget.userEmail))));}
                ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => ProfilePage(userEmail: widget.userEmail))));}
                )
            ],
            selectedIndex: 
              selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              }
          ),
      ),
    );
  }
}