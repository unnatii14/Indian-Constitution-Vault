// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SectionDetail _$SectionDetailFromJson(Map<String, dynamic> json) {
  return _SectionDetail.fromJson(json);
}

/// @nodoc
mixin _$SectionDetail {
  String get actId => throw _privateConstructorUsedError;
  String get sectionNumber => throw _privateConstructorUsedError;
  String get heading => throw _privateConstructorUsedError;
  String get textEn => throw _privateConstructorUsedError;
  String? get textHi => throw _privateConstructorUsedError;

  /// Serializes this SectionDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionDetailCopyWith<SectionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionDetailCopyWith<$Res> {
  factory $SectionDetailCopyWith(
    SectionDetail value,
    $Res Function(SectionDetail) then,
  ) = _$SectionDetailCopyWithImpl<$Res, SectionDetail>;
  @useResult
  $Res call({
    String actId,
    String sectionNumber,
    String heading,
    String textEn,
    String? textHi,
  });
}

/// @nodoc
class _$SectionDetailCopyWithImpl<$Res, $Val extends SectionDetail>
    implements $SectionDetailCopyWith<$Res> {
  _$SectionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actId = null,
    Object? sectionNumber = null,
    Object? heading = null,
    Object? textEn = null,
    Object? textHi = freezed,
  }) {
    return _then(
      _value.copyWith(
            actId: null == actId
                ? _value.actId
                : actId // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionNumber: null == sectionNumber
                ? _value.sectionNumber
                : sectionNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            heading: null == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as String,
            textEn: null == textEn
                ? _value.textEn
                : textEn // ignore: cast_nullable_to_non_nullable
                      as String,
            textHi: freezed == textHi
                ? _value.textHi
                : textHi // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SectionDetailImplCopyWith<$Res>
    implements $SectionDetailCopyWith<$Res> {
  factory _$$SectionDetailImplCopyWith(
    _$SectionDetailImpl value,
    $Res Function(_$SectionDetailImpl) then,
  ) = __$$SectionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String actId,
    String sectionNumber,
    String heading,
    String textEn,
    String? textHi,
  });
}

/// @nodoc
class __$$SectionDetailImplCopyWithImpl<$Res>
    extends _$SectionDetailCopyWithImpl<$Res, _$SectionDetailImpl>
    implements _$$SectionDetailImplCopyWith<$Res> {
  __$$SectionDetailImplCopyWithImpl(
    _$SectionDetailImpl _value,
    $Res Function(_$SectionDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actId = null,
    Object? sectionNumber = null,
    Object? heading = null,
    Object? textEn = null,
    Object? textHi = freezed,
  }) {
    return _then(
      _$SectionDetailImpl(
        actId: null == actId
            ? _value.actId
            : actId // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionNumber: null == sectionNumber
            ? _value.sectionNumber
            : sectionNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        heading: null == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as String,
        textEn: null == textEn
            ? _value.textEn
            : textEn // ignore: cast_nullable_to_non_nullable
                  as String,
        textHi: freezed == textHi
            ? _value.textHi
            : textHi // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionDetailImpl implements _SectionDetail {
  const _$SectionDetailImpl({
    required this.actId,
    required this.sectionNumber,
    required this.heading,
    required this.textEn,
    this.textHi,
  });

  factory _$SectionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionDetailImplFromJson(json);

  @override
  final String actId;
  @override
  final String sectionNumber;
  @override
  final String heading;
  @override
  final String textEn;
  @override
  final String? textHi;

  @override
  String toString() {
    return 'SectionDetail(actId: $actId, sectionNumber: $sectionNumber, heading: $heading, textEn: $textEn, textHi: $textHi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionDetailImpl &&
            (identical(other.actId, actId) || other.actId == actId) &&
            (identical(other.sectionNumber, sectionNumber) ||
                other.sectionNumber == sectionNumber) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.textHi, textHi) || other.textHi == textHi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, actId, sectionNumber, heading, textEn, textHi);

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionDetailImplCopyWith<_$SectionDetailImpl> get copyWith =>
      __$$SectionDetailImplCopyWithImpl<_$SectionDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionDetailImplToJson(this);
  }
}

abstract class _SectionDetail implements SectionDetail {
  const factory _SectionDetail({
    required final String actId,
    required final String sectionNumber,
    required final String heading,
    required final String textEn,
    final String? textHi,
  }) = _$SectionDetailImpl;

  factory _SectionDetail.fromJson(Map<String, dynamic> json) =
      _$SectionDetailImpl.fromJson;

  @override
  String get actId;
  @override
  String get sectionNumber;
  @override
  String get heading;
  @override
  String get textEn;
  @override
  String? get textHi;

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionDetailImplCopyWith<_$SectionDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
