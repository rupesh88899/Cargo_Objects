class CargoObject {
  final String? id;
  final String name;
  final Map<String, dynamic>? data;

  CargoObject({this.id, required this.name, this.data});

  factory CargoObject.fromJson(Map<String, dynamic> json) => CargoObject(
        id: json['id']?.toString(),
        name: json['name']?.toString() ?? '',
        data: json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>) : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        if (data != null) 'data': data,
      };
}
