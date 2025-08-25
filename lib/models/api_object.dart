class ApiObject {
final String id;
final String name;
final Map<String, dynamic>? data;
final DateTime? createdAt;
final DateTime? updatedAt;


ApiObject({
required this.id,
required this.name,
this.data,
this.createdAt,
this.updatedAt,
});


factory ApiObject.fromJson(Map<String, dynamic> json) => ApiObject(
id: json['id'].toString(),
name: json['name']?.toString() ?? '',
data: json['data'] == null ? null : Map<String, dynamic>.from(json['data'] as Map),
createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
);


Map<String, dynamic> toJson() => {
'id': id,
'name': name,
'data': data,
if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
};
}