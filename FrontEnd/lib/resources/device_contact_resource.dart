import 'package:sentinel_guard/constants/api_gateway.dart';
import 'package:sentinel_guard/models/devices/device_contacts_model.dart';

import 'package:dio/dio.dart';


class DeviceContactResource {
  final Dio _dio = Dio();

  Future<String> registerDeviceContact(int deviceId, String contactEmail,
      String deviceContactNickname, int contactPhotoId) async {
    var url = API_URL + '/device_contacts/create';

    var response = await _dio.post(url,
        data: DeviceContacts(
                deviceId: deviceId,
                contactEmail: contactEmail,
                deviceContactNickname: deviceContactNickname,
                contactPhotoId: contactPhotoId)
            .toJson());

    return response.data.toString();
  }

  Future<List<DeviceContacts>> getDevicesContacts(int deviceId) async {
    var url = API_URL + '/device_contacts/list/$deviceId';

    var response = await _dio.get(url);

    List devicesContacts = response.data;

    return devicesContacts
         .map((deviceContact) => DeviceContacts.fromJson(deviceContact))
         .toList();
    //return response.data;
  }

  Future<String> removeDeviceContact(int deviceId, String contactEmail) async {
    var url = API_URL + '/device_contacts/remove/$deviceId/$contactEmail';

    var response = await _dio.delete(url);

    return response.data.toString();
  }

  Future<String> updateDeviceContact(int deviceId, String contactEmail, payload) async {
    var url = API_URL + '/device_contacts/update/$deviceId/$contactEmail';

    final transformPayload = {};
    payload.forEach((key, value) {
      transformPayload[key] = value.toString();
    });

    var response = await _dio.put(url, data: transformPayload);

    return response.data.toString();
  }
}
