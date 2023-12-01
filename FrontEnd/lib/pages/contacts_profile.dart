import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/devices/device_contacts_model.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/resources/device_contact_resource.dart';

class ContactsProfilePage extends StatefulWidget {
  final String userEmail;
  final String nickName;
  final int Id;
  const ContactsProfilePage(
      {super.key,
      required this.userEmail,
      required this.nickName,
      required this.Id});

  @override
  State<ContactsProfilePage> createState() => _ContactsProfilePageState();
}

class _ContactsProfilePageState extends State<ContactsProfilePage> {
  final nameContactController = TextEditingController();
  final emailContactController = TextEditingController();
  final photoContactController = TextEditingController();
  List<DeviceContacts> _response = [];

  Future<List<DeviceContacts>> getDevicesContacts(int deviceId) async {
    return await DeviceContactResource().getDevicesContacts(deviceId);
  }

  Future<void> registerDeviceContact(int deviceId, String contactEmail,
      String deviceContactNickname, int contactPhotoId) async {
    await DeviceContactResource().registerDeviceContact(
        deviceId, contactEmail, deviceContactNickname, contactPhotoId);
    getDevicesContacts(widget.Id).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  Future<void> removeDeviceContact(int deviceId, String contactEmail) async {
    await DeviceContactResource().removeDeviceContact(deviceId, contactEmail);
    getDevicesContacts(widget.Id).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  Future<void> updateDeviceContact(
      int deviceId, String contactEmail, newContactNickname) async {
    var payload = {"device_contact_nickname": newContactNickname};
    await DeviceContactResource()
        .updateDeviceContact(deviceId, contactEmail, payload);
    getDevicesContacts(widget.Id).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  void _showDialogAdd() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dados do contato'),
          content: Container(
            height: 200, // Altura desejada para o conteúdo
            child: Column(
              children: [
                SizedBox(height: 10),
                MyTextField(
                  controller: emailContactController,
                  hintText: 'Email de Contato',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: nameContactController,
                  hintText: 'Nome de Contato',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: photoContactController,
                  hintText: 'Id da Foto',
                  obscureText: false,
                ),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    registerDeviceContact(
                      widget.Id,
                      emailContactController.text,
                      nameContactController.text,
                      int.parse(photoContactController.text),
                    );
                  },
                  icon: Icons.check,
                  texto: 'Adicionar',
                ),
              ],
            ))
          ],
        );
      },
    );
  }

  void _showDialogEdit(String Email) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Novo nome do Contato:'),
            content: Container(
              height: 75,
              child: Column(
                children: [
                  MyTextField(
                    controller: nameContactController,
                    hintText: 'Nome de Contato',
                    obscureText: false,
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            actions: <Widget>[
              Center(
                  child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  MyElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        updateDeviceContact(
                            widget.Id, Email, nameContactController.text);
                        Navigator.of(context).pop();
                      },
                      icon: Icons.check,
                      texto: 'Confirmar')
                ],
              ))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getDevicesContacts(widget.Id).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(152, 218, 217, 1),
        title: Text(widget.nickName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.vertical,
              itemCount: _response.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = _response[index];
                final contactPhotoId = contact.contactPhotoId;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(contact.deviceContactNickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content: Container(
                              color: Color.fromRGBO(255, 255, 255, 0),
                              child: Row(
                                children: [
                                  MyFloatingActionButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        removeDeviceContact(
                                            widget.Id, contact.contactEmail);
                                      },
                                      texto: 'Remover',
                                      icon: Icons.close),
                                  const SizedBox(width: 16),
                                  MyFloatingActionButton(
                                      onPressed: () {
                                        _showDialogEdit(contact.contactEmail);
                                      },
                                      texto: 'Editar',
                                      icon: Icons.edit)
                                ],
                              ),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          );
                        });
                  },
                  child: buildContactsLines(contact.deviceContactNickname, 'lib/images/$contactPhotoId.jpg'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: MyFloatingActionButton(
          onPressed: () {
            _showDialogAdd();
          },
          icon: Icons.add,
          texto: 'Contato'),
      bottomNavigationBar:
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
                  
            ),
            child: bnavbar(userEmail: widget.userEmail, selectedIndex: 1)),
    );
  }
}

Widget buildContactsLines(String contactName, String imagePath) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      //border: Border.all(color: Color.fromRGBO(152, 218, 217, 1), width: 1)
    ),
    margin: EdgeInsets.only(top: 15),
    child: Row(
      children: [
        // Padding ao redor da imagem
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(imagePath, fit: BoxFit.fill,),
            ),
          ),
        ),
        // Padding ao redor do texto
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            contactName,
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