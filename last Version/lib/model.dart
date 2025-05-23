// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

List<Model> modelFromJson(String str) =>
    List<Model>.from(json.decode(str).map((x) => Model.fromJson(x)));

String modelToJson(List<Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Model {
  int? id;
  DateTime? createdAt;
  String mealName;
  int rating;
  String feedback;
  String? customerName;
  String? customerNumber;

  Model({
    this.id,
    this.createdAt,
    required this.mealName,
    required this.rating,
    required this.feedback,
    this.customerName,
    this.customerNumber,
  });

  Model copyWith({
    int? id,
    DateTime? createdAt,
    String? mealName,
    int? rating,
    String? feedback,
    String? customerName,
    String? customerNumber,
  }) => Model(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    mealName: mealName ?? this.mealName,
    rating: rating ?? this.rating,
    feedback: feedback ?? this.feedback,
    customerName: customerName ?? this.customerName,
    customerNumber: customerNumber ?? this.customerNumber,
  );

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    mealName: json["meal_name"],
    rating: json["rating"],
    feedback: json["feedback"],
    customerName: json["customer_name"],
    customerNumber: json["customer_number"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": (createdAt ?? DateTime.now()).toIso8601String(),
    "meal_name": mealName,
    "rating": rating,
    "feedback": feedback,
    "customer_name": customerName,
    "customer_number": customerNumber,
  };
}
