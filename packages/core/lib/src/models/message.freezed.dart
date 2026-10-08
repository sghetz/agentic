// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {

 String get id; String get sourceId; String get externalId; String? get author; DateTime get sentAt; String get body; Map<String, Object?> get raw; String? get routedProjectId; double? get routingConfidence; DateTime? get processedAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.externalId, _this.externalId) || other.externalId == _this.externalId)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.raw, _this.raw)&&(identical(other.routedProjectId, _this.routedProjectId) || other.routedProjectId == _this.routedProjectId)&&(identical(other.routingConfidence, _this.routingConfidence) || other.routingConfidence == _this.routingConfidence)&&(identical(other.processedAt, _this.processedAt) || other.processedAt == _this.processedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.sourceId,_this.externalId,_this.author,_this.sentAt,_this.body,const DeepCollectionEquality().hash(_this.raw),_this.routedProjectId,_this.routingConfidence,_this.processedAt);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, sourceId: ${_this.sourceId}, externalId: ${_this.externalId}, author: ${_this.author}, sentAt: ${_this.sentAt}, body: ${_this.body}, raw: ${_this.raw}, routedProjectId: ${_this.routedProjectId}, routingConfidence: ${_this.routingConfidence}, processedAt: ${_this.processedAt})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id, String sourceId, String externalId, String? author, DateTime sentAt, String body, Map<String, Object?> raw, String? routedProjectId, double? routingConfidence, DateTime? processedAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? externalId = null,Object? author = freezed,Object? sentAt = null,Object? body = null,Object? raw = null,Object? routedProjectId = freezed,Object? routingConfidence = freezed,Object? processedAt = freezed,}) {
  return _then(Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,routedProjectId: freezed == routedProjectId ? _self.routedProjectId : routedProjectId // ignore: cast_nullable_to_non_nullable
as String?,routingConfidence: freezed == routingConfidence ? _self.routingConfidence : routingConfidence // ignore: cast_nullable_to_non_nullable
as double?,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceId,  String externalId,  String? author,  DateTime sentAt,  String body,  Map<String, Object?> raw,  String? routedProjectId,  double? routingConfidence,  DateTime? processedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.sourceId,_that.externalId,_that.author,_that.sentAt,_that.body,_that.raw,_that.routedProjectId,_that.routingConfidence,_that.processedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceId,  String externalId,  String? author,  DateTime sentAt,  String body,  Map<String, Object?> raw,  String? routedProjectId,  double? routingConfidence,  DateTime? processedAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.sourceId,_that.externalId,_that.author,_that.sentAt,_that.body,_that.raw,_that.routedProjectId,_that.routingConfidence,_that.processedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceId,  String externalId,  String? author,  DateTime sentAt,  String body,  Map<String, Object?> raw,  String? routedProjectId,  double? routingConfidence,  DateTime? processedAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.sourceId,_that.externalId,_that.author,_that.sentAt,_that.body,_that.raw,_that.routedProjectId,_that.routingConfidence,_that.processedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({required this.id, required this.sourceId, required this.externalId, this.author, required this.sentAt, required this.body, required  Map<String, Object?> raw, this.routedProjectId, this.routingConfidence, this.processedAt}): _raw = raw;
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String id;
@override final  String sourceId;
@override final  String externalId;
@override final  String? author;
@override final  DateTime sentAt;
@override final  String body;
 final  Map<String, Object?> _raw;
@override Map<String, Object?> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}

@override final  String? routedProjectId;
@override final  double? routingConfidence;
@override final  DateTime? processedAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.author, author) || other.author == author)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.raw, _raw)&&(identical(other.routedProjectId, routedProjectId) || other.routedProjectId == routedProjectId)&&(identical(other.routingConfidence, routingConfidence) || other.routingConfidence == routingConfidence)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sourceId,externalId,author,sentAt,body,const DeepCollectionEquality().hash(_raw),routedProjectId,routingConfidence,processedAt);
}

@override
String toString() {
    return 'Message(id: $id, sourceId: $sourceId, externalId: $externalId, author: $author, sentAt: $sentAt, body: $body, raw: $raw, routedProjectId: $routedProjectId, routingConfidence: $routingConfidence, processedAt: $processedAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceId, String externalId, String? author, DateTime sentAt, String body, Map<String, Object?> raw, String? routedProjectId, double? routingConfidence, DateTime? processedAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? externalId = null,Object? author = freezed,Object? sentAt = null,Object? body = null,Object? raw = null,Object? routedProjectId = freezed,Object? routingConfidence = freezed,Object? processedAt = freezed,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,routedProjectId: freezed == routedProjectId ? _self.routedProjectId : routedProjectId // ignore: cast_nullable_to_non_nullable
as String?,routingConfidence: freezed == routingConfidence ? _self.routingConfidence : routingConfidence // ignore: cast_nullable_to_non_nullable
as double?,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
