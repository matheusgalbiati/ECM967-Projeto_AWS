import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/pages/login_page.dart';
import 'package:sentinel_guard/resources/user_info_resource.dart';

import '../models/buttons.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _response = 'Aguardando resposta...';
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
  bool _senhaForte = false;

  Future<void> createUser(String userEmail, String senha) async {
    String response = await UserInfoResource().createUser(userEmail, senha);
    setState(() {
      _response = response;
    });
  }

  void _ShowDialog(Text texto) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Color.fromRGBO(152, 218, 217, 1),
        title: Center(child: texto),
        shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),),
      );
    });
  }

  void _verificarSenhaForte(String senha) {
    // Defina os critérios da senha aqui
    bool temLetraMaiuscula = senha.contains(RegExp(r'[A-Z]'));
    bool temLetraMinuscula = senha.contains(RegExp(r'[a-z]'));
    bool temNumero = senha.contains(RegExp(r'[0-9]'));
    bool temCaractereEspecial = senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool temComprimentoMinimo = senha.length >= 8;

    // Faça a verificação completa
    bool senhaForte = temLetraMaiuscula &&
        temLetraMinuscula &&
        temNumero &&
        temCaractereEspecial &&
        temComprimentoMinimo;

    // Atualize o estado para refletir se a senha é forte ou fraca
    setState(() {
      _senhaForte = senhaForte;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 50),

            Row(
              children: [
                IconButton(
                  onPressed: () {Navigator.pop(context);}, 
                  icon: Icon(Icons.arrow_back),
                ),
                const Text(
                    'Cadastro', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      ),
                    ),
              ],
            ),

            const SizedBox(height: 40),

            MyTextField(
              controller: usernameController,
              hintText: 'Nome', 
              obscureText: false
              ),

            const SizedBox(height: 10),

            MyTextField(
              controller: passwordController,
              hintText: 'Senha', 
              obscureText: true
              ),
              
            const SizedBox(height: 10),

            MyTextField(
              controller: cpasswordController,
              hintText: 'Confirme a senha', 
              obscureText: true
              ),
              
            const SizedBox(height: 10),

            MyTextField(
              controller: emailController,
              hintText: 'Email', 
              obscureText: false
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async{
                _verificarSenhaForte(passwordController.text);
                if (passwordController.text == cpasswordController.text && _senhaForte == true) {
                  await createUser(emailController.text, passwordController.text);
                  _ShowDialog(const Text('Usuário criado com sucesso!'));
                  Timer(const Duration(seconds: 2), () { 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  });
                } else{
                  _ShowDialog(const Text('Senha inválida!'));
                }
              }, 
              style: buttonPrimary,
              child: 
                const Text('Cadastre-se',
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  )
                )
            ),            
          ]),
          
    );
  }
}