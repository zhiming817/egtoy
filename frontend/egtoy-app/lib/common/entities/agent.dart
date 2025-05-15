/// 新闻分页 response
class AgentPageListResponseEntity {
  int? code;
  List<AgentItem>? data;

  AgentPageListResponseEntity({this.code, this.data});

  factory AgentPageListResponseEntity.fromJson(Map<String, dynamic> json) =>
      AgentPageListResponseEntity(
        code: json["code"],
        data:
            json["data"] == null
                ? []
                : List<AgentItem>.from(
                  json["data"].map((x) => AgentItem.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "code": code ?? 0,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AgentListRequestEntity {
  String email;
  String password;

  AgentListRequestEntity({required this.email, required this.password});

  factory AgentListRequestEntity.fromJson(Map<String, dynamic> json) =>
      AgentListRequestEntity(email: json["email"], password: json["password"]);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

class AgentItem {
  String? id;
  String? agentName;
  int? deviceCount;
  DateTime? lastConnectedAt;
  String? llmModelName;
  String? systemPrompt;
  String? ttsModelName;
  String? ttsVoiceName;

  AgentItem({
    this.id,
    this.agentName,
    this.deviceCount,
    this.lastConnectedAt,
    this.llmModelName,
    this.systemPrompt,
    this.ttsModelName,
    this.ttsVoiceName,
  });

  factory AgentItem.fromJson(Map<String, dynamic> json) => AgentItem(
    id: json["id"],
    agentName: json["agentName"],
    deviceCount: json["deviceCount"],
    lastConnectedAt:
        json["lastConnectedAt"] != null
            ? DateTime.parse(json["lastConnectedAt"])
            : null,
    llmModelName: json["llmModelName"],
    systemPrompt: json["systemPrompt"],
    ttsModelName: json["ttsModelName"],
    ttsVoiceName: json["ttsVoiceName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "agentName": agentName,
    "deviceCount": deviceCount,
    "lastConnectedAt": lastConnectedAt?.toIso8601String(),
    "llmModelName": llmModelName,
    "systemPrompt": systemPrompt,
    "ttsModelName": ttsModelName,
    "ttsVoiceName": ttsVoiceName,
  };
}
