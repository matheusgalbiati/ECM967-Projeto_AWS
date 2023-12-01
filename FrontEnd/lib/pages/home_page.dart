import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinel_guard/mock/maua_path_coordinations.dart';
import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/models/buttons.dart';
import 'package:sentinel_guard/models/devices/device_geolocation_model.dart';
import 'package:sentinel_guard/models/users/user_shared_devices_model.dart';
import 'package:sentinel_guard/resources/device_location_resource.dart';
import 'package:sentinel_guard/resources/home_contact_preference_resource.dart';
import 'package:sentinel_guard/resources/user_shared_device_resource.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<UserSharedDevices> _sharedDevices = [];
  int? _primaryId;
  int? _primaryPhotoId;
  int? _secondaryId;
  int? _secondaryPhotoId;
  String? _primaryNickname;
  String? _secondaryNickname;
  LatLng? currentLocation;
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;
  final List coordenadas = mauaCoordenadas;
  Timer? _timer;
  int _currentIndex = 0; // Índice atual da lista de coordenadas

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
    //setCustomMarker();
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
        int primaryPhotoId = sharedDevice.devicePhotoId;

        _primaryId = primaryId;
        _primaryNickname = primaryNickname;
        _primaryPhotoId = primaryPhotoId;
      } else if (sharedDevice.isSecondary == "true") {
        int secondaryId = sharedDevice.deviceId;
        String secondaryNickname = sharedDevice.sharedDeviceNickname;
        int secondaryPhotoId = sharedDevice.devicePhotoId;

        _secondaryId = secondaryId;
        _secondaryNickname = secondaryNickname;
        _secondaryPhotoId = secondaryPhotoId;
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

  Future<void> setContactToPrimary(String userEmail, int deviceId) async {
    await HomeContactPreferenceResource()
        .setHomeContactPreferenceToPrimary(userEmail, deviceId);
    initFunction(userEmail);
  }

  Future<void> setContactToSecondary(String userEmail, int deviceId) async {
    await HomeContactPreferenceResource()
        .setHomeContactPreferenceToSecondary(userEmail, deviceId);
    List<UserSharedDevices> sharedDevices =
        await UserSharedDeviceResource().getUserSharedDevices(userEmail);
    setState(() {
      _sharedDevices = sharedDevices;
    });
    await getPrimaryAndSecondaryDevices(sharedDevices);
    await getLocation(_secondaryId!).then((value) {
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
        updateMapCamera(currentLocation!);
      });
    });
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
        return StatefulBuilder(
          // Use StatefulBuilder para reconstruir o AlertDialog
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Selecione o dispositivo primário'),
              content: DropdownButton(
                isExpanded: true,
                value: _primaryId,
                onChanged: (e) {
                  setState(() {
                    _primaryId = e; // Modifica o estado e reconstrói o widget
                  });
                },
                items: sharedDevices
                    .map((e) => DropdownMenuItem(
                          value: e.deviceId,
                          child: Text(e.sharedDeviceNickname),
                        ))
                    .toList(),
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
      },
    );
  }



  void secondaryDialogCard(List<UserSharedDevices> sharedDevices) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                onChanged: (e) {
                  setState(() {
                    _secondaryId = e;
                  });
                },
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
      },
    );
  }


  void updateMapCamera(LatLng newLocation) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(newLocation));
  }

  /*void updateMapWithCoordinates() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < coordenadas.length) {
        final LatLng newLocation = LatLng(
          coordenadas[_currentIndex]['latitude']!,
          coordenadas[_currentIndex]['longitude']!,
        );

        setState(() {
          currentLocation = newLocation;
          // Move the camera to the new location
          updateMapCamera(newLocation);
        });

        _currentIndex++;

        // If reached the end of the list, restart
        if (_currentIndex >= coordenadas.length) {
          _currentIndex = 0;
        }
      }
    });
  }*/

  @override
  void initState() {
    super.initState();
    initFunction(widget.userEmail);
    /*updateMapWithCoordinates();*/
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            // Map
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
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: const Color.fromRGBO(152, 218, 217, 1),
                                  width: 3)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: GoogleMap(
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
              ),
            ),

            // Buttons
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(152, 218, 217, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (primaryButtonWidth != _primaryWidth)
                                _primaryNickname == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )
                                    : // Mostra apenas a foto se o botão não está selecionado
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                            'lib/images/$_primaryPhotoId.jpg',
                                            fit: BoxFit.fill)),
                              if (primaryButtonWidth ==
                                  _primaryWidth) // Mostra a foto e o texto se o botão está selecionado
                                _primaryNickname == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color.fromRGBO(46, 66, 77, 1),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.asset(
                                                  'lib/images/$_primaryPhotoId.jpg',
                                                  fit: BoxFit.fill)),
                                          const SizedBox(
                                              width:
                                                  15), // Adiciona um espaço entre a imagem e o texto
                                          Text(_primaryNickname.toString()),
                                        ],
                                      ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: secondaryButtonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: secondaryButtonSizeTransformer,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(152, 218, 217, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (secondaryButtonWidth !=
                                  _primaryWidth) // Mostra apenas a foto se o botão não está selecionado
                                _primaryNickname == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color.fromRGBO(46, 66, 77, 1),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: _secondaryPhotoId == null
                                            ? Image.asset('lib/images/null.png',
                                                fit: BoxFit.fill)
                                            : Image.asset(
                                                'lib/images/$_secondaryPhotoId.jpg',
                                                fit: BoxFit.fill)),
                              if (secondaryButtonWidth ==
                                  _primaryWidth) // Mostra a foto e o texto se o botão está selecionado
                                _primaryNickname == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color.fromRGBO(46, 66, 77, 1),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: _secondaryPhotoId == null
                                                  ? Image.asset(
                                                      'lib/images/null.png',
                                                      fit: BoxFit.fill)
                                                  : Image.asset(
                                                      'lib/images/$_secondaryPhotoId.jpg',
                                                      fit: BoxFit.fill)),
                                          const SizedBox(
                                              width:
                                                  15), // Adiciona um espaço entre a imagem e o texto
                                          Text(_secondaryNickname.toString()),
                                        ],
                                      ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
          ),
          child: bnavbar(userEmail: widget.userEmail, selectedIndex: 0)),
    );
  }
}
