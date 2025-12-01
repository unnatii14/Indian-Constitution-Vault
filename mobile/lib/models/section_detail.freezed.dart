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
  @JsonKey(name: 'act_id')
  String get actId => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_number')
  String get sectionNumber => throw _privateConstructorUsedError;
  String get heading => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_hi')
  String? get contentHi => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'act_id') String actId,
    @JsonKey(name: 'section_number') String sectionNumber,
    String heading,
    String content,
    @JsonKey(name: 'content_hi') String? contentHi,
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
    Object? content = null,
    Object? contentHi = freezed,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            contentHi: freezed == contentHi
                ? _value.contentHi
                : contentHi // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'act_id') String actId,
    @JsonKey(name: 'section_number') String sectionNumber,
    String heading,
    String content,
    @JsonKey(name: 'content_hi') String? contentHi,
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
    Object? content = null,
    Object? contentHi = freezed,
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
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        contentHi: freezed == contentHi
            ? _value.contentHi
            : contentHi // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionDetailImpl implements _SectionDetail {
  const _$SectionDetailImpl({
    @JsonKey(name: 'act_id') required this.actId,
    @JsonKey(name: 'section_number') required this.sectionNumber,
    required this.heading,
    required this.content,
    @JsonKey(name: 'content_hi') this.contentHi,
  });

  factory _$SectionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionDetailImplFromJson(json);

  @override
  @JsonKey(name: 'act_id')
  final String actId;
  @override
  @JsonKey(name: 'section_number')
  final String sectionNumber;
  @override
  final String heading;
  @override
  final String content;
  @override
  @JsonKey(name: 'content_hi')
  final String? contentHi;

  @override
  String toString() {
    return 'SectionDetail(actId: $actId, sectionNumber: $sectionNumber, heading: $heading, content: $content, contentHi: $contentHi)';
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
            (identical(other.content, content) || other.content == content) &&
            (identical(other.contentHi, contentHi) ||
                other.contentHi == contentHi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    actId,
    sectionNumber,
    heading,
    content,
    contentHi,
  );

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
    @JsonKey(name: 'act_id') required final String actId,
    @JsonKey(name: 'section_number') required final String sectionNumber,
    required final String heading,
    required final String content,
    @JsonKey(name: 'content_hi') final String? contentHi,
  }) = _$SectionDetailImpl;

  factory _SectionDetail.fromJson(Map<String, dynamic> json) =
      _$SectionDetailImpl.fromJson;

  @override
  @JsonKey(name: 'act_id')
  String get actId;
  @override
  @JsonKey(name: 'section_number')
  String get sectionNumber;
  @override
  String get heading;
  @override
  String get content;
  @override
  @JsonKey(name: 'content_hi')
  String? get contentHi;

  /// Create a copy of SectionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionDetailImplCopyWith<_$SectionDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
