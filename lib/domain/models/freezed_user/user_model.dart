import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user_model.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String? email,
    required String? userName,
    required String? uid,
    required LatLng location,
  }) = _UserModel;

  Map<String, dynamic> toFirestoreMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
    };
  }
}
