class DataModel {
  final String? id;
  final String name;
  final Map<String, dynamic>? data;

  DataModel({
    this.id,
    required this.name,
    this.data,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'name': name,
    };
    
    if (data != null && data!.isNotEmpty) {
      result['data'] = data;
    }
    
    return result;
  }

  DataModel copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? data,
  }) {
    return DataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }

  String get dataString {
    if (data == null || data!.isEmpty) return 'No data';
    return data!.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }
}