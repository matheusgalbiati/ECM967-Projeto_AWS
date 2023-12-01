class DeviceContacts {
  int deviceId;
  String contactEmail;
  String deviceContactNickname;
  int contactPhotoId;

  DeviceContacts({
    required this.deviceId,
    required this.contactEmail,
    required this.deviceContactNickname,
    required this.contactPhotoId,
  });

  factory DeviceContacts.fromJson(Map<String, dynamic> json) {
    return DeviceContacts(
      deviceId: int.parse(json['PK'].replaceAll('DEVICES#', '')),
      contactEmail: json['SK'].replaceAll('#CONTACTS#', ''),
      deviceContactNickname: json['device_contact_nickname'],
      contactPhotoId: int.parse(json['contact_photo_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'contact_email': contactEmail,
      'device_contact_nickname': deviceContactNickname,
      'contact_photo_id': contactPhotoId,
    };
  }
}
