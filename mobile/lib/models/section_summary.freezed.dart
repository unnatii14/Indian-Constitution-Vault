// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SectionSummary _$SectionSummaryFromJson(Map<String, dynamic> json) {
  return _SectionSummary.fromJson(json);
}

/// @nodoc
mixin _$SectionSummary {
  String get sectionNumber => throw _privateConstructorUsedError;
  String get heading => throw _privateConstructorUsedError;
  String? get preview => throw _privateConstructorUsedError;

  /// Serializes this SectionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionSummaryCopyWith<SectionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionSummaryCopyWith<$Res> {
  factory $SectionSummaryCopyWith(
    SectionSummary value,
    $Res Function(SectionSummary) then,
  ) = _$SectionSummaryCopyWithImpl<$Res, SectionSummary>;
  @useResult
  $Res call({String sectionNumber, String heading, String? preview});
}

/// @nodoc
class _$SectionSummaryCopyWithImpl<$Res, $Val extends SectionSummary>
    implements $SectionSummaryCopyWith<$Res> {
  _$SectionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionNumber = null,
    Object? heading = null,
    Object? preview = freezed,
  }) {
    return _then(
      _value.copyWith(
            sectionNumber: null == sectionNumber
                ? _value.sectionNumber
                : sectionNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            heading: null == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as String,
            preview: freezed == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SectionSummaryImplCopyWith<$Res>
    implements $SectionSummaryCopyWith<$Res> {
  factory _$$SectionSummaryImplCopyWith(
    _$SectionSummaryImpl value,
    $Res Function(_$SectionSummaryImpl) then,
  ) = __$$SectionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sectionNumber, String heading, String? preview});
}

/// @nodoc
class __$$SectionSummaryImplCopyWithImpl<$Res>
    extends _$SectionSummaryCopyWithImpl<$Res, _$SectionSummaryImpl>
    implements _$$SectionSummaryImplCopyWith<$Res> {
  __$$SectionSummaryImplCopyWithImpl(
    _$SectionSummaryImpl _value,
    $Res Function(_$SectionSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SectionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionNumber = null,
    Object? heading = null,
    Object? preview = freezed,
  }) {
    return _then(
      _$SectionSummaryImpl(
        sectionNumber: null == sectionNumber
            ? _value.sectionNumber
            : sectionNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        heading: null == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as String,
        preview: freezed == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionSummaryImpl implements _SectionSummary {
  const _$SectionSummaryImpl({
    required this.sectionNumber,
    required this.heading,
    this.preview,
  });

  factory _$SectionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionSummaryImplFromJson(json);

  @override
  final String sectionNumber;
  @override
  final String heading;
  @override
  final String? preview;

  @override
  String toString() {
    return 'SectionSummary(sectionNumber: $sectionNumber, heading: $heading, preview: $preview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionSummaryImpl &&
            (identical(other.sectionNumber, sectionNumber) ||
                other.sectionNumber == sectionNumber) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.preview, preview) || other.preview == preview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sectionNumber, heading, preview);

  /// Create a copy of SectionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionSummaryImplCopyWith<_$SectionSummaryImpl> get copyWith =>
      __$$SectionSummaryImplCopyWithImpl<_$SectionSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionSummaryImplToJson(this);
  }
}

abstract class _SectionSummary implements SectionSummary {
  const factory _SectionSummary({
    required final String sectionNumber,
    required final String heading,
    final String? preview,
  }) = _$SectionSummaryImpl;

  factory _SectionSummary.fromJson(Map<String, dynamic> json) =
      _$SectionSummaryImpl.fromJson;

  @override
  String get sectionNumber;
  @override
  String get heading;
  @override
  String? get preview;

  /// Create a copy of SectionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionSummaryImplCopyWith<_$SectionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
