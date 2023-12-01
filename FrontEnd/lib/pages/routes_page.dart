import 'package:flutter/material.dart';
import 'package:sentinel_guard/models/bnavbar.dart';


// ignore: must_be_immutable
class RoutesPage extends StatefulWidget {
  String userEmail;
  RoutesPage({super.key, required this.userEmail});

  @override
  State<RoutesPage> createState() => _RoutesPageState(userEmail);
}

class _RoutesPageState extends State<RoutesPage> {
  String userEmail;

  _RoutesPageState(this.userEmail);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(152, 218, 217, 1),
        title: Text('Rotas Cadastradas'),
        leading: 
          IconButton(
            onPressed: (){
              // Não faz nada
            },
            icon: const Icon(Icons.route),
          ),
      ),

      body: Container(child: const Placeholder(color: Color.fromRGBO(152, 218, 217, 1))),

      bottomNavigationBar:
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
                  
            ),
            child: bnavbar(userEmail: widget.userEmail, selectedIndex: 2)),
    );
  }
}