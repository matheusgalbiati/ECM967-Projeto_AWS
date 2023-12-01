import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/models/users/user_infos_model.dart';
import 'package:sentinel_guard/resources/user_info_resource.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _response = 'Aguardando resposta...';
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  List<int>? _imageData; // Store the image data here

  Future<void> getUser(String userEmail) async {
    UserInfos response = await UserInfoResource().getUser(userEmail);
    setState(() {
      _response = response.userEmail;
    });
  }

  Future<void> updateUser(String userEmail, payload) async {
    String response = await UserInfoResource().updateUser(userEmail, payload);
    setState(() {
      _response = response;
    });
  }

  Future<void> updatePassword(String userEmail, String novaSenha) async {
    var payload = {
      "senha": novaSenha,
    };
    String response = await UserInfoResource().updateUser(userEmail, payload);
    setState(() {});
  }

  String getUserPhoto(String userEmail) {
    late String _imagePath;
    switch (userEmail) {
      case 'victor@gmail.com':
        _imagePath = 'lib/images/4.jpg';
        break;
      case 'julia@gmail.com':
        _imagePath = 'lib/images/2.jpg';
        break;
      default:
        _imagePath = 'lib/images/3.jpg';
    }
    return _imagePath;
  }

  void _showDialogEditUser() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dados do dispositivo'),
            content: Container(
                height: 200,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    MyTextField(
                      controller: oldPasswordController,
                      hintText: 'Senha atual',
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: newPasswordController,
                      hintText: 'Nova senha',
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: ConfirmPasswordController,
                      hintText: 'Confirme a nova senha',
                      obscureText: true,
                    ),
                  ],
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            actions: <Widget>[
              Center(
                  child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  MyElevatedButton(
                    onPressed: () {
                      if (newPasswordController.text ==
                          ConfirmPasswordController.text) {
                        //updateuser
                        Navigator.of(context).pop();
                        updatePassword(
                            widget.userEmail, newPasswordController.text);
                      }
                    },
                    icon: Icons.check,
                    texto: 'Atualizar',
                  ),
                ],
              ))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    // getUser(widget.userEmail);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(152, 218, 217, 1),
        title: const Text('Perfil'),
        leading: IconButton(
          onPressed: () {
            // Não faz nada
          },
          icon: const Icon(Icons.person),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color.fromRGBO(5, 22, 26, 1))),
              ),
              child: Container(
                width: double.infinity,
                height: 200.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _imageData != null
                          ? CircleAvatar(
                              backgroundImage:
                                  MemoryImage(Uint8List.fromList(_imageData!)),
                              radius: 50,
                            )
                          : FutureBuilder<List<int>>(
                              future: getImage(getUserPhoto(widget.userEmail)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    // Handle error
                                    return Text('Error loading image');
                                  } else {
                                    // Update the image data and trigger a rebuild
                                    _imageData = snapshot.data;
                                    return CircleAvatar(
                                      backgroundImage: MemoryImage(
                                          Uint8List.fromList(_imageData!)),
                                      radius: 50,
                                    );
                                  }
                                } else {
                                  // While the image is being loaded, show a loading indicator
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                      const SizedBox(height: 25),
                      Text(
                        _response,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: <Widget>[
                MyFloatingActionButton(
                    onPressed: () {
                      _showDialogEditUser();
                    },
                    icon: Icons.edit,
                    texto: 'Editar credenciais')
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
        ),
        child: bnavbar(userEmail: widget.userEmail, selectedIndex: 4),
      ),
    );
  }
}

Future<List<int>> getImage(String imagePath) async {
  ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}
