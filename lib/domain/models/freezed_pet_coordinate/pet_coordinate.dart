import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_coordinate.freezed.dart';

@freezed
abstract class PetCoordinate with _$PetCoordinate {
  const factory PetCoordinate({
    required GeoPoint coordinate,
    required Timestamp dateTime,
  }) = _PetCoordinate;

  factory PetCoordinate.fromFirestore(Map<String, dynamic> json) {
    return PetCoordinate(
        coordinate: json['coordinates'], dateTime: json['date-time']);
  }

  Map<String, dynamic> toMap(PetCoordinate object) {
    return {'coordinates': object.coordinate, 'date-time': object.dateTime};
  }
}
