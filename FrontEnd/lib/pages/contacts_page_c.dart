import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/models/users/user_shared_devices_model.dart';
import 'package:sentinel_guard/resources/user_shared_device_resource.dart';

class ContactsPageC extends StatefulWidget {
  final String userEmail;
  const ContactsPageC({super.key, required this.userEmail});

  @override
  State<ContactsPageC> createState() => _ContactsPageCState();
}

class _ContactsPageCState extends State<ContactsPageC> {
  List<UserSharedDevices> _response = [];
  final nameController = TextEditingController();

  Future<List<UserSharedDevices>> getUserSharedDevices(String userEmail) async {
    return await UserSharedDeviceResource().getUserSharedDevices(userEmail);
  }

  Future<void> updateSharedDeviceNickname(
      int deviceId, String newDeviceNickname) async {
    final payload = {"shared_device_nickname": newDeviceNickname};
    await UserSharedDeviceResource()
        .updateUserSharedDevice(widget.userEmail, deviceId, payload);
    getUserSharedDevices(widget.userEmail).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserSharedDevices(widget.userEmail).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.vertical,
              itemCount: _response.length,
              itemBuilder: (BuildContext context, int index) {
                final sharedDevice = _response[index];
                final shareDevicePhotoId = sharedDevice.devicePhotoId;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Novo nome do dispositivo'),
                            content: SizedBox(
                              height: 75,
                              child: Column(
                                children: [
                                  MyTextField(
                                      controller: nameController,
                                      hintText: 'Nome do dispositivo',
                                      obscureText: false),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            actions: <Widget>[
                              Center(
                                child: ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    MyElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await updateSharedDeviceNickname(
                                            sharedDevice.deviceId,
                                            nameController.text);
                                        nameController.clear();
                                      },
                                      icon: Icons.check,
                                      texto: 'Confirmar',
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: buildSharedDevices(sharedDevice.sharedDeviceNickname, 'lib/images/$shareDevicePhotoId.jpg'),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

Widget buildSharedDevices(String name, String imagePath) {
  
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      //border: Border.all(color: Color.fromRGBO(152, 218, 217, 1), width: 1)
    ),
    margin: const EdgeInsets.only(top: 15),
    child: Row(
      children: [
        // Padding ao redor da imagem
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getImage(imagePath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: 60,  // Defina a largura conforme necessário
                  height: 60, // Defina a altura conforme necessário
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40), // Metade da largura/altura para torná-lo circular
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(Uint8List.fromList(snapshot.data as List<int>)),
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        // Padding ao redor do texto
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Future<List<int>> getImage(String imagePath) async {
  ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}