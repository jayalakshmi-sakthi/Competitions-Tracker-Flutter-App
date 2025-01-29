import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'competition.g.dart';

@JsonSerializable()
class Competition {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "details")
  String? details;

  @JsonKey(name: "category")
  String? category;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "date")
  DateTime? date;  // Change from double? to DateTime?

  @JsonKey(name: "level")
  String? level;

  @JsonKey(name: "fee")
  bool? fee;

  Competition({
    this.id,
    this.name,
    this.details,
    this.category,
    this.image,
    this.fee,
    this.date,
    this.level,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return _$CompetitionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    final data = _$CompetitionToJson(this);
    // If date is not null, convert it to Timestamp
    if (date != null) {
      data['date'] = Timestamp.fromDate(date!); // Convert DateTime to Timestamp
    }
    return data;
  }
}
