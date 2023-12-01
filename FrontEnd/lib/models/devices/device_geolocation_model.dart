class DeviceLocation {
  int deviceId;
  double latitude;
  double longitude;
  DateTime lastTrackTime;

  DeviceLocation({
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.lastTrackTime,
  });

  factory DeviceLocation.fromJson(Map<String, dynamic> json) {
    return DeviceLocation(
      deviceId: int.parse(json['PK'].replaceAll('DEVICES#', '')),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      lastTrackTime: DateTime.parse(json['last_track_time']),
    );
  }
}
