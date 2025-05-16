// TODO Implement this library.
class DeviceListResponseEntity {
  int? code;
  List<Device>? data;

  DeviceListResponseEntity({this.code, this.data});

  factory DeviceListResponseEntity.fromJson(Map<String, dynamic> json) =>
      DeviceListResponseEntity(
        code: json["code"],
        data:
            json["data"] == null
                ? []
                : List<Device>.from(
                  json["data"].map((x) => Device.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "code": code ?? 0,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Device {
  final String id;
  final String board;
  final String appVersion;
  final String userId;
  final int autoUpdate;
  final DateTime createDate;
  final DateTime? lastConnectedAt;

  Device({
    required this.id,
    required this.board,
    required this.autoUpdate,
    required this.appVersion,
    required this.userId,
    required this.createDate,
    this.lastConnectedAt,
  });

  // 从JSON转换为Device对象
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      board: json['board'],
      autoUpdate: json['autoUpdate'] ?? false,
      appVersion: json['appVersion'],
      userId: json['userId'],
      createDate:
          json['createDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['createDate'] as int)
              : DateTime.now(), // 或者提供一个合适的默认DateTime
      lastConnectedAt:
          json['lastConnectedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                json['lastConnectedAt'] as int,
              )
              : null,
    );
  }

  // 将Device对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': board,
      'autoUpdate': autoUpdate,
      'appVersion': appVersion,
      'userId': userId,
      'createDate': createDate.toIso8601String(),
      'lastConnectedAt': lastConnectedAt?.toIso8601String(),
    };
  }
}
