// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pet_coordinate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PetCoordinateTearOff {
  const _$PetCoordinateTearOff();

  _PetCoordinate call(
      {required GeoPoint coordinate, required Timestamp dateTime}) {
    return _PetCoordinate(
      coordinate: coordinate,
      dateTime: dateTime,
    );
  }
}

/// @nodoc
const $PetCoordinate = _$PetCoordinateTearOff();

/// @nodoc
mixin _$PetCoordinate {
  GeoPoint get coordinate => throw _privateConstructorUsedError;
  Timestamp get dateTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PetCoordinateCopyWith<PetCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetCoordinateCopyWith<$Res> {
  factory $PetCoordinateCopyWith(
          PetCoordinate value, $Res Function(PetCoordinate) then) =
      _$PetCoordinateCopyWithImpl<$Res>;
  $Res call({GeoPoint coordinate, Timestamp dateTime});
}

/// @nodoc
class _$PetCoordinateCopyWithImpl<$Res>
    implements $PetCoordinateCopyWith<$Res> {
  _$PetCoordinateCopyWithImpl(this._value, this._then);

  final PetCoordinate _value;
  // ignore: unused_field
  final $Res Function(PetCoordinate) _then;

  @override
  $Res call({
    Object? coordinate = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_value.copyWith(
      coordinate: coordinate == freezed
          ? _value.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as Timestamp,
    ));
  }
}

/// @nodoc
abstract class _$PetCoordinateCopyWith<$Res>
    implements $PetCoordinateCopyWith<$Res> {
  factory _$PetCoordinateCopyWith(
          _PetCoordinate value, $Res Function(_PetCoordinate) then) =
      __$PetCoordinateCopyWithImpl<$Res>;
  @override
  $Res call({GeoPoint coordinate, Timestamp dateTime});
}

/// @nodoc
class __$PetCoordinateCopyWithImpl<$Res>
    extends _$PetCoordinateCopyWithImpl<$Res>
    implements _$PetCoordinateCopyWith<$Res> {
  __$PetCoordinateCopyWithImpl(
      _PetCoordinate _value, $Res Function(_PetCoordinate) _then)
      : super(_value, (v) => _then(v as _PetCoordinate));

  @override
  _PetCoordinate get _value => super._value as _PetCoordinate;

  @override
  $Res call({
    Object? coordinate = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_PetCoordinate(
      coordinate: coordinate == freezed
          ? _value.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as Timestamp,
    ));
  }
}

/// @nodoc

class _$_PetCoordinate implements _PetCoordinate {
  const _$_PetCoordinate({required this.coordinate, required this.dateTime});

  @override
  final GeoPoint coordinate;
  @override
  final Timestamp dateTime;

  @override
  String toString() {
    return 'PetCoordinate(coordinate: $coordinate, dateTime: $dateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PetCoordinate &&
            (identical(other.coordinate, coordinate) ||
                const DeepCollectionEquality()
                    .equals(other.coordinate, coordinate)) &&
            (identical(other.dateTime, dateTime) ||
                const DeepCollectionEquality()
                    .equals(other.dateTime, dateTime)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(coordinate) ^
      const DeepCollectionEquality().hash(dateTime);

  @JsonKey(ignore: true)
  @override
  _$PetCoordinateCopyWith<_PetCoordinate> get copyWith =>
      __$PetCoordinateCopyWithImpl<_PetCoordinate>(this, _$identity);

  @override
  Map<String, dynamic> toMap(PetCoordinate object) {
    return {'coordinates': object.coordinate, 'date-time': object.dateTime};
  }
}

abstract class _PetCoordinate implements PetCoordinate {
  const factory _PetCoordinate(
      {required GeoPoint coordinate,
      required Timestamp dateTime}) = _$_PetCoordinate;

  @override
  GeoPoint get coordinate => throw _privateConstructorUsedError;
  @override
  Timestamp get dateTime => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PetCoordinateCopyWith<_PetCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}
