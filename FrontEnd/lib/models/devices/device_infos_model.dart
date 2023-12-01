class DeviceInfos {
  int deviceId;
  String userEmail;
  String deviceNickname;
  int devicePhotoId;

  DeviceInfos({
    required this.deviceId,
    required this.userEmail,
    required this.deviceNickname,
    required this.devicePhotoId,
  });

  factory DeviceInfos.fromJson(Map<String, dynamic> json) {
    return DeviceInfos(
      deviceId: int.parse(json['PK'].replaceAll('DEVICES#', '')),
      userEmail: json['owner_user_email'],
      deviceNickname: json['device_nickname'],
      devicePhotoId: int.parse(json['device_photo_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'user_email': userEmail,
      'device_nickname': deviceNickname,
      'device_photo_id': devicePhotoId,
    };
  }
}
