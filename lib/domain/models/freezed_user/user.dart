import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String? email,
    required String? userName,
    required LatLng location,
  }) = _User;
}
