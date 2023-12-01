class UserSharedDevices {
  String isPrimary;
  String isSecondary;
  int devicePhotoId;
  int deviceId;
  String userEmail;
  String sharedDeviceNickname;

  UserSharedDevices({
    required this.isPrimary,
    required this.isSecondary,
    required this.devicePhotoId,
    required this.deviceId,
    required this.userEmail,
    required this.sharedDeviceNickname,
  });

  factory UserSharedDevices.fromJson(Map<String, dynamic> json) {
    return UserSharedDevices(
      isPrimary: json['is_primary'],
      isSecondary: json['is_secondary'],
      devicePhotoId: int.parse(json['device_photo_id']),
      deviceId: int.parse(json['SK'].replaceAll('#DEVICES#', '')),
      userEmail: json['PK'].replaceAll('USERS#', ''),
      sharedDeviceNickname: json['shared_device_nickname'],
    );
  }
}
