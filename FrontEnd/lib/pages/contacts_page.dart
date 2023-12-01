import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sentinel_guard/models/devices/device_infos_model.dart';
import 'package:sentinel_guard/pages/contacts_profile.dart';
import 'package:sentinel_guard/resources/device_info_resource.dart';

class ContactsPage extends StatefulWidget {
  final String userEmail;
  const ContactsPage({super.key, required this.userEmail});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<DeviceInfos> _response = [];

  Future<List<DeviceInfos>> getDevices(String userEmail) async {
    return await DeviceInfoResource().getDevices(userEmail);
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContactsProfilePage(
                            userEmail: widget.userEmail,
                            nickName: device.deviceNickname,
                            Id: device.deviceId)));
                  },
                    child: buildDeviceCard(device.deviceNickname, 'lib/images/$devicePhotoId.jpg'),
                  );
                },
              ),
          ),
          
        ],
      ),

    );
  }
}

Widget buildDeviceCard(String deviceNickname, String imagePath) {
  return Container(
    margin: const EdgeInsets.only(top: 15, bottom: 15),
    child: Column(
      children: [    
        // Padding ao redor da imagem
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagePath, fit: BoxFit.fill,),
            ),
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