// TODO Implement this library.
class Device {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime? lastConnectedAt;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.createdAt,
    this.lastConnectedAt,
  });

  // 从JSON转换为Device对象
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      lastConnectedAt:
          json['lastConnectedAt'] != null
              ? DateTime.parse(json['lastConnectedAt'])
              : null,
    );
  }

  // 将Device对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lastConnectedAt': lastConnectedAt?.toIso8601String(),
    };
  }
}
