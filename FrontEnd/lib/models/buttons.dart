import 'package:flutter/material.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(25),
  backgroundColor: Color.fromRGBO(152, 218, 217, 1),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      ),
);

//----------------------------------------------

class MyElevatedButton extends StatelessWidget {
  final IconData? icon;
  final String texto;
  final Function()? onPressed;
  


  const MyElevatedButton({super.key, required this.onPressed, required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, 
      icon: Icon(icon),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: const Color.fromRGBO(152, 218, 217, 1)
      )
    );
  }
}

//----------------------------------------------

class MyButton extends StatelessWidget {
  
  final Function()? onTap;


  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromRGBO(152, 218, 217, 1),
          borderRadius: BorderRadius.circular(15),
          ),
        child: const Center(
          child: Text(
            "Sign In", 
            style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}

//----------------------------------------------

class TextButtonContainer extends StatelessWidget {
  const TextButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.fromLTRB(16, 24, 16, 24),

      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: <Widget>[
            TextButton(onPressed: (){}, child: const Text('Teste'))
            //TextButton(style: TextButton.styleFrom(textStyle:  const TextStyle(fontSize: 20)), onPressed: (){}, child:  Text('Compartilhados')),
          ],
        ),
    );
  }
}

//----------------------------------------------

class MyFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final String texto;
  final Function()? onPressed;
  


  const MyFloatingActionButton({super.key, required this.onPressed, required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed, 
      icon: Icon(icon),
      label: Text(texto),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

      foregroundColor: Colors.black,
      backgroundColor: const Color.fromRGBO(152, 218, 217, 1),
    );
  }
}

/*style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: const Color.fromRGBO(152, 218, 217, 1)
      )*/