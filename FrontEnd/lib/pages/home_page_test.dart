import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/devices/device_geolocation_model.dart';
import 'package:sentinel_guard/models/users/user_shared_devices_model.dart';
import 'package:sentinel_guard/resources/device_location_resource.dart';
import 'package:sentinel_guard/resources/home_contact_preference_resource.dart';
import 'package:sentinel_guard/resources/user_shared_device_resource.dart';

class HomePageTest extends StatefulWidget {
  final String userEmail;
  const HomePageTest({super.key, required this.userEmail});

  @override
  State<HomePageTest> createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  final Completer<GoogleMapController> _controller = Completer();
  List<UserSharedDevices> _sharedDevices = [];
  int? _primaryId;
  int? _secondaryId;
  String? _primaryNickname;
  String? _secondaryNickname;
  // LatLng currentLocation = const LatLng(-23.6367722, -46.5689852);
  LatLng? currentLocation;
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  // double? _screenWidth;
  // final double primaryProportion = 0.7;
  // final double secondaryPropotion = 0.3;
  // final double _buttonHeight = 50.0;
  // bool _isPrimaryButtonPressed = true;
  // bool _isSecondaryButtonPressed = false;
  // double? _primaryButtonWidth;
  // double? _secondaryButtonWidth;

  double buttonHeight = 70.0;
  final double _primaryWidth = 250.0;
  final double _secondaryWidth = 100.0;
  double primaryButtonWidth = 250.0;
  double secondaryButtonWidth = 100.0;

  Future<void> initFunction(String userEmail) async {
    List<UserSharedDevices> sharedDevices =
        await UserSharedDeviceResource().getUserSharedDevices(userEmail);
    setState(() {
      _sharedDevices = sharedDevices;
    });
    await getPrimaryAndSecondaryDevices(sharedDevices);
    await getLocation(_primaryId!).then((value) {
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
        updateMapCamera(currentLocation!);
      });
    });
    // await getLocation(_primaryId!);
    setCustomMarker();
  }

  void updateMapCamera(LatLng newLocation) async {
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newLatLng(newLocation));
}

  Future<List<UserSharedDevices>> getUserSharedDevices(String userEmail) async {
    return await UserSharedDeviceResource().getUserSharedDevices(userEmail);
  }

  Future<void> getPrimaryAndSecondaryDevices(
      List<UserSharedDevices> sharedDevices) async {
    for (var sharedDevice in sharedDevices) {
      if (sharedDevice.isPrimary == "true") {
        int primaryId = sharedDevice.deviceId;
        String primaryNickname = sharedDevice.sharedDeviceNickname;

        _primaryId = primaryId;
        _primaryNickname = primaryNickname;
        
      } else if (sharedDevice.isSecondary == "true") {
        int secondaryId = sharedDevice.deviceId;
        String secondaryNickname = sharedDevice.sharedDeviceNickname;
        
        _secondaryId = secondaryId;
        _secondaryNickname = secondaryNickname;
        
      }
    }
  }

  Future<DeviceLocation> getLocation(int deviceId) async {
    // DeviceLocation deviceLocation =
    //     await DeviceLocationResource().getDeviceLocation(deviceId);
    // setState(() {
    //   currentLocation =
    //       LatLng(deviceLocation.latitude, deviceLocation.longitude);
    // });
    return await DeviceLocationResource().getDeviceLocation(deviceId);
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void setCustomMarker() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset('../lib/images/ana.jpg', 50);
    setState(() {
      customMarkerIcon = BitmapDescriptor.fromBytes(markerIcon!);
    });
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration.empty, "../lib/images/ana.jpg")
    //     .then((icon) => customMarkerIcon = icon);
  }

  Future<void> setContactToPrimary(String userEmail, int deviceId) async {
    await HomeContactPreferenceResource().setHomeContactPreferenceToPrimary(userEmail, deviceId);
    initFunction(userEmail);
  }

  Future<void> setContactToSecondary(String userEmail, int deviceId) async {
    await HomeContactPreferenceResource()
        .setHomeContactPreferenceToSecondary(userEmail, deviceId);
    initFunction(userEmail);
  }

  void primaryButtonSizeTransformer() async {
    setState(() {
      if (primaryButtonWidth == _primaryWidth) {
        primaryDialogCard(_sharedDevices);
      } else {
        primaryButtonWidth = _primaryWidth;
        secondaryButtonWidth = _secondaryWidth;
        getLocation(_primaryId!).then((value) => setState(() {
              currentLocation = LatLng(value.latitude, value.longitude);
              updateMapCamera(currentLocation!);
            }));
      }
    });
  }

  void secondaryButtonSizeTransformer() {
    setState(() {
      if (secondaryButtonWidth == _primaryWidth) {
        secondaryDialogCard(_sharedDevices);
      } else {
        secondaryButtonWidth = _primaryWidth;
        primaryButtonWidth = _secondaryWidth;
        getLocation(_secondaryId!).then((value) => setState(() {
              currentLocation = LatLng(value.latitude, value.longitude);
              updateMapCamera(currentLocation!);
            }));
      }
    });
  }

  void primaryCallback(value) {
    setState(() {
      _primaryId = value;
    });
  }

  void secondaryCallback(value) {
    setState(() {
      _secondaryId = value;
    });
  }

  void primaryDialogCard(List<UserSharedDevices> sharedDevices) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecione o dispositivo primário'),
          content: DropdownButton(
            isExpanded: true,
            value: _primaryId,         
            items: sharedDevices
                .map((e) => DropdownMenuItem(
                      value: e.deviceId,
                      child: Text(e.sharedDeviceNickname),
                    ))
                .toList(),
            onChanged: primaryCallback,
          ),
          actions: [
            Center(
              child: MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setContactToPrimary(widget.userEmail, _primaryId!);
                },
                icon: Icons.check,
                texto: 'Atualizar',
              ),
            ),
          ],
        );
      },
    );
  }

  void secondaryDialogCard(List<UserSharedDevices> sharedDevices) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecione o dispositivo secundário'),
          content: DropdownButton(
            isExpanded: true,
            items: sharedDevices
                .map((e) => DropdownMenuItem(
                      value: e.deviceId,
                      child: Text(e.sharedDeviceNickname),
                    ))
                .toList(),
            value: _secondaryId,
            onChanged: secondaryCallback,
          ),
          actions: [
            Center(
              child: MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setContactToSecondary(widget.userEmail, _secondaryId!);
                },
                icon: Icons.check,
                texto: 'Atualizar',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initFunction(widget.userEmail);
    
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenWidthUtil = screenWidth - 16 - 16 - 24;
    // setState(() {
    //   _screenWidth = screenWidthUtil;
    //   _primaryButtonWidth = screenWidthUtil * primaryProportion;
    //   _secondaryButtonWidth = screenWidthUtil * secondaryPropotion;
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(152, 218, 217, 1),
        title: const Text('SentinelGuard'),
        leading: IconButton(
          onPressed: () {
            // Não faz nada
          },
          icon: const Icon(Icons.home),
        ),
      ),
      
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: currentLocation == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(152, 218, 217, 1),
                          ),
                        )
                      : /*Column(
                          children: [
                            Text('$_primaryId, $_secondaryId'),
                            Text(currentLocation.toString()),
                          ],
                        ),*/
                      // Container(child: Center(child: Image.asset("../lib/images/ana.jpg"))),
                      GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: currentLocation!,
                            zoom: 17.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              icon: customMarkerIcon,
                              position: currentLocation!,
                            ),
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: primaryButtonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: primaryButtonSizeTransformer, 
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color.fromRGBO(152, 218, 217, 1)),
                        child: Text(_primaryNickname.toString()),
                      ),
                    ),
                    SizedBox(
                      width: secondaryButtonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: secondaryButtonSizeTransformer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color.fromRGBO(152, 218, 217, 1)),
                        child: Text(_secondaryNickname.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
                  
            ),
            child: bnavbar(userEmail: widget.userEmail, selectedIndex: 0)),
    );
  }
}
