//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sentinel_guard/models/loading.dart';
import 'package:sentinel_guard/models/square_tile.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/pages/home_page.dart';
//import 'package:sentinel_guard/pages/home_page_test.dart';
import 'package:sentinel_guard/resources/user_info_resource.dart';
//import 'package:sentinel_guard/pages/home_page.dart';
import 'package:sentinel_guard/pages/register.dart';

import '../models/buttons.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _response = 'Aguardando resposta...';
  // Edição do texto do controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  

  Future<void> loginUser(String userEmail, String senha) async {

    //loading circle
    LoadingDialog().showMyDialog(context);

    String response = await UserInfoResource().loginUser(userEmail, senha);
    setState(() {
      _response = response;
    });

    // pop the loading circle
    Navigator.of(context).pop();
  }

  void _ShowDialog() {
    showDialog(context: context, builder: (context){
      return const AlertDialog(
        backgroundColor: Color.fromRGBO(152, 218, 217, 1),
        title: Text('Usuário ou senha inválidos!'),
        shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              //logo
              Column(
                children: <Widget>[
                  Container(
                    height: 130,
                    child: Image.asset('lib/images/app_logo.jpg')
                    ),
                ],
              ),
        
              const SizedBox(height: 45),

              //Bem vindo
              const Text(
                'SentinelGuard', 
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  ),
                ),

              const SizedBox(height: 25),

              //Texto de login
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,

              ),

              const SizedBox(height: 10),

              //Texto de senha
              MyTextField(
                controller: passwordController,
                hintText: 'Senha',
                obscureText: true,

              ),

              const SizedBox(height: 10),

              //Esqueceu a senha?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){}, child: const Text('Esqueceu a senha?'))
                  ],
                ),
              ),
            
              const SizedBox(height: 15),

              //Sign in button
              ElevatedButton(onPressed: () async {
                await loginUser(usernameController.text, passwordController.text);
                if (_response == 'User validated successfully'){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(userEmail: usernameController.text)));
                }else{
                  Navigator.of(context).pop();
                  _ShowDialog();
                }
              }, 
              style: buttonPrimary,
              child: 
                const Text('Login',
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  )
                )
              ),

              const SizedBox(height: 30),

              //continuar com...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
              
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Ou continue com...'),
                    ),
              
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //google sign button
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/google_logo.png')
                ],
              ),

              const SizedBox(height: 30),

              //cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem cadastro?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),

                  TextButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));}, 
                    child: const Text('Registre-se'))
                ],
              ),
      ]),
    ),));
  }
}