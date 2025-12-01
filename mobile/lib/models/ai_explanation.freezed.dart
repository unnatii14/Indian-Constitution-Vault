// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_explanation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AiExplanation _$AiExplanationFromJson(Map<String, dynamic> json) {
  return _AiExplanation.fromJson(json);
}

/// @nodoc
mixin _$AiExplanation {
  @JsonKey(name: 'simple_explanation')
  String get simpleExplanation => throw _privateConstructorUsedError;
  String? get examples => throw _privateConstructorUsedError;

  /// Serializes this AiExplanation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiExplanation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiExplanationCopyWith<AiExplanation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiExplanationCopyWith<$Res> {
  factory $AiExplanationCopyWith(
    AiExplanation value,
    $Res Function(AiExplanation) then,
  ) = _$AiExplanationCopyWithImpl<$Res, AiExplanation>;
  @useResult
  $Res call({
    @JsonKey(name: 'simple_explanation') String simpleExplanation,
    String? examples,
  });
}

/// @nodoc
class _$AiExplanationCopyWithImpl<$Res, $Val extends AiExplanation>
    implements $AiExplanationCopyWith<$Res> {
  _$AiExplanationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiExplanation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? simpleExplanation = null, Object? examples = freezed}) {
    return _then(
      _value.copyWith(
            simpleExplanation: null == simpleExplanation
                ? _value.simpleExplanation
                : simpleExplanation // ignore: cast_nullable_to_non_nullable
                      as String,
            examples: freezed == examples
                ? _value.examples
                : examples // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiExplanationImplCopyWith<$Res>
    implements $AiExplanationCopyWith<$Res> {
  factory _$$AiExplanationImplCopyWith(
    _$AiExplanationImpl value,
    $Res Function(_$AiExplanationImpl) then,
  ) = __$$AiExplanationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'simple_explanation') String simpleExplanation,
    String? examples,
  });
}

/// @nodoc
class __$$AiExplanationImplCopyWithImpl<$Res>
    extends _$AiExplanationCopyWithImpl<$Res, _$AiExplanationImpl>
    implements _$$AiExplanationImplCopyWith<$Res> {
  __$$AiExplanationImplCopyWithImpl(
    _$AiExplanationImpl _value,
    $Res Function(_$AiExplanationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiExplanation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? simpleExplanation = null, Object? examples = freezed}) {
    return _then(
      _$AiExplanationImpl(
        simpleExplanation: null == simpleExplanation
            ? _value.simpleExplanation
            : simpleExplanation // ignore: cast_nullable_to_non_nullable
                  as String,
        examples: freezed == examples
            ? _value.examples
            : examples // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiExplanationImpl implements _AiExplanation {
  const _$AiExplanationImpl({
    @JsonKey(name: 'simple_explanation') required this.simpleExplanation,
    this.examples,
  });

  factory _$AiExplanationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiExplanationImplFromJson(json);

  @override
  @JsonKey(name: 'simple_explanation')
  final String simpleExplanation;
  @override
  final String? examples;

  @override
  String toString() {
    return 'AiExplanation(simpleExplanation: $simpleExplanation, examples: $examples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiExplanationImpl &&
            (identical(other.simpleExplanation, simpleExplanation) ||
                other.simpleExplanation == simpleExplanation) &&
            (identical(other.examples, examples) ||
                other.examples == examples));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, simpleExplanation, examples);

  /// Create a copy of AiExplanation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiExplanationImplCopyWith<_$AiExplanationImpl> get copyWith =>
      __$$AiExplanationImplCopyWithImpl<_$AiExplanationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiExplanationImplToJson(this);
  }
}

abstract class _AiExplanation implements AiExplanation {
  const factory _AiExplanation({
    @JsonKey(name: 'simple_explanation')
    required final String simpleExplanation,
    final String? examples,
  }) = _$AiExplanationImpl;

  factory _AiExplanation.fromJson(Map<String, dynamic> json) =
      _$AiExplanationImpl.fromJson;

  @override
  @JsonKey(name: 'simple_explanation')
  String get simpleExplanation;
  @override
  String? get examples;

  /// Create a copy of AiExplanation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiExplanationImplCopyWith<_$AiExplanationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
