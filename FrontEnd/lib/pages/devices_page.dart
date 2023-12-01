import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/devices/device_infos_model.dart';
import 'package:sentinel_guard/models/textfields.dart';
import 'package:sentinel_guard/resources/device_info_resource.dart';

class DevicesPage extends StatefulWidget {
  final String userEmail;
  const DevicesPage({super.key, required this.userEmail});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final nameContactController = TextEditingController();
  final IdContactController = TextEditingController();
  final photoContactController = TextEditingController();
  List<DeviceInfos> _response = [];

  Future<List<DeviceInfos>> getDevices(String userEmail) async {
    return await DeviceInfoResource().getDevices(userEmail);
  }

  Future<void> registerDevice(int deviceId, String userEmail,
      String deviceNickname, int devicePhotoId) async {
    await DeviceInfoResource()
        .registerDevice(deviceId, userEmail, deviceNickname, devicePhotoId);
    getDevices(widget.userEmail).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  Future<void> removeDevice(int deviceId) async {
    await DeviceInfoResource().removeDevice(deviceId);
    getDevices(widget.userEmail).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  Future<void> updateDevice(int deviceId, newDeviceNickname) async {
    var payload = {"device_nickname": newDeviceNickname};
    await DeviceInfoResource().updateDevice(deviceId, payload);
    getDevices(widget.userEmail).then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  void _showDialogAddDevice() {
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
                      controller: IdContactController,
                      hintText: 'Id do Dispositivo',
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: nameContactController,
                      hintText: 'Nome do Dispositivo',
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: photoContactController,
                      hintText: 'Id da Foto',
                      obscureText: false,
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
                      Navigator.of(context).pop();
                      registerDevice(
                          int.parse(IdContactController.text),
                          widget.userEmail,
                          nameContactController.text,
                          int.parse(photoContactController.text));
                    },
                    icon: Icons.check,
                    texto: 'Adicionar',
                  ),
                ],
              ))
            ],
          );
        });
  }

  void _showDialogEditDevice(int Id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Novo nome do Dispositivo'),
            content: Container(
              height: 75,
              child: Column(
                children: [
                  MyTextField(
                      controller: nameContactController,
                      hintText: 'Nome do Dispositivo',
                      obscureText: false)
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
                        updateDevice(Id, nameContactController.text);
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
    getDevices(widget.userEmail).then((value) {
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
        title: Text('Dispositivos Cadastrados'),
        leading: IconButton(
          onPressed: () {
            // Não faz nada
          },
          icon: const Icon(Icons.watch),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              scrollDirection: Axis.vertical,
              itemCount: _response.length,
              itemBuilder: (BuildContext context, int index) {
                final device = _response[index];
                final devicePhotoId = device.devicePhotoId;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(device.deviceNickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content: Container(
                              color: Color.fromRGBO(255, 255, 255, 0),
                              child: Row(
                                children: [
                                  MyFloatingActionButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        removeDevice(device.deviceId);
                                      },
                                      texto: 'Remover',
                                      icon: Icons.close),
                                  const SizedBox(width: 16),
                                  MyFloatingActionButton(
                                      onPressed: () {
                                        _showDialogEditDevice(device.deviceId);
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
                  child: buildDeviceCard(device.deviceNickname, 'lib/images/$devicePhotoId.jpg'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: MyFloatingActionButton(
          onPressed: () {
            _showDialogAddDevice();
          },
          icon: Icons.add,
          texto: 'Dispositivo'),
          
      bottomNavigationBar:
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
                  
            ),
            child: bnavbar(userEmail: widget.userEmail, selectedIndex: 3)),
    );
  }
}

Widget buildDeviceCard(String deviceNickname, String imagePath) {
  return Container(
    margin: EdgeInsets.only(top: 15, bottom: 15),
    child: Column(
      children: [
        // Padding ao redor da imagem
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getImage(imagePath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
            deviceNickname,
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
