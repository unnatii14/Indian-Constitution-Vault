// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'act_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActSummary _$ActSummaryFromJson(Map<String, dynamic> json) {
  return _ActSummary.fromJson(json);
}

/// @nodoc
mixin _$ActSummary {
  @JsonKey(name: 'act_id')
  String get actId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_count')
  int get sectionCount => throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;

  /// Serializes this ActSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActSummaryCopyWith<ActSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActSummaryCopyWith<$Res> {
  factory $ActSummaryCopyWith(
    ActSummary value,
    $Res Function(ActSummary) then,
  ) = _$ActSummaryCopyWithImpl<$Res, ActSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'act_id') String actId,
    String title,
    @JsonKey(name: 'section_count') int sectionCount,
    List<String> languages,
  });
}

/// @nodoc
class _$ActSummaryCopyWithImpl<$Res, $Val extends ActSummary>
    implements $ActSummaryCopyWith<$Res> {
  _$ActSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actId = null,
    Object? title = null,
    Object? sectionCount = null,
    Object? languages = null,
  }) {
    return _then(
      _value.copyWith(
            actId: null == actId
                ? _value.actId
                : actId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionCount: null == sectionCount
                ? _value.sectionCount
                : sectionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            languages: null == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActSummaryImplCopyWith<$Res>
    implements $ActSummaryCopyWith<$Res> {
  factory _$$ActSummaryImplCopyWith(
    _$ActSummaryImpl value,
    $Res Function(_$ActSummaryImpl) then,
  ) = __$$ActSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'act_id') String actId,
    String title,
    @JsonKey(name: 'section_count') int sectionCount,
    List<String> languages,
  });
}

/// @nodoc
class __$$ActSummaryImplCopyWithImpl<$Res>
    extends _$ActSummaryCopyWithImpl<$Res, _$ActSummaryImpl>
    implements _$$ActSummaryImplCopyWith<$Res> {
  __$$ActSummaryImplCopyWithImpl(
    _$ActSummaryImpl _value,
    $Res Function(_$ActSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actId = null,
    Object? title = null,
    Object? sectionCount = null,
    Object? languages = null,
  }) {
    return _then(
      _$ActSummaryImpl(
        actId: null == actId
            ? _value.actId
            : actId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionCount: null == sectionCount
            ? _value.sectionCount
            : sectionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        languages: null == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActSummaryImpl implements _ActSummary {
  const _$ActSummaryImpl({
    @JsonKey(name: 'act_id') required this.actId,
    required this.title,
    @JsonKey(name: 'section_count') required this.sectionCount,
    required final List<String> languages,
  }) : _languages = languages;

  factory _$ActSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'act_id')
  final String actId;
  @override
  final String title;
  @override
  @JsonKey(name: 'section_count')
  final int sectionCount;
  final List<String> _languages;
  @override
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  @override
  String toString() {
    return 'ActSummary(actId: $actId, title: $title, sectionCount: $sectionCount, languages: $languages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActSummaryImpl &&
            (identical(other.actId, actId) || other.actId == actId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sectionCount, sectionCount) ||
                other.sectionCount == sectionCount) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    actId,
    title,
    sectionCount,
    const DeepCollectionEquality().hash(_languages),
  );

  /// Create a copy of ActSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActSummaryImplCopyWith<_$ActSummaryImpl> get copyWith =>
      __$$ActSummaryImplCopyWithImpl<_$ActSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActSummaryImplToJson(this);
  }
}

abstract class _ActSummary implements ActSummary {
  const factory _ActSummary({
    @JsonKey(name: 'act_id') required final String actId,
    required final String title,
    @JsonKey(name: 'section_count') required final int sectionCount,
    required final List<String> languages,
  }) = _$ActSummaryImpl;

  factory _ActSummary.fromJson(Map<String, dynamic> json) =
      _$ActSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'act_id')
  String get actId;
  @override
  String get title;
  @override
  @JsonKey(name: 'section_count')
  int get sectionCount;
  @override
  List<String> get languages;

  /// Create a copy of ActSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActSummaryImplCopyWith<_$ActSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
