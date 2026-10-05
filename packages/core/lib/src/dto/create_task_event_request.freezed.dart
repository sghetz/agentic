// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_task_event_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskEventRequest {

@ActorConverter() Actor get actor; TaskEventType get eventType; Map<String, Object?> get payload;
/// Create a copy of CreateTaskEventRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskEventRequestCopyWith<CreateTaskEventRequest> get copyWith => _$CreateTaskEventRequestCopyWithImpl<CreateTaskEventRequest>(this as CreateTaskEventRequest, _$identity);

  /// Serializes this CreateTaskEventRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskEventRequest&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actor,eventType,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'CreateTaskEventRequest(actor: $actor, eventType: $eventType, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $CreateTaskEventRequestCopyWith<$Res>  {
  factory $CreateTaskEventRequestCopyWith(CreateTaskEventRequest value, $Res Function(CreateTaskEventRequest) _then) = _$CreateTaskEventRequestCopyWithImpl;
@useResult
$Res call({
@ActorConverter() Actor actor, TaskEventType eventType, Map<String, Object?> payload
});




}
/// @nodoc
class _$CreateTaskEventRequestCopyWithImpl<$Res>
    implements $CreateTaskEventRequestCopyWith<$Res> {
  _$CreateTaskEventRequestCopyWithImpl(this._self, this._then);

  final CreateTaskEventRequest _self;
  final $Res Function(CreateTaskEventRequest) _then;

/// Create a copy of CreateTaskEventRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actor = null,Object? eventType = null,Object? payload = null,}) {
  return _then(_self.copyWith(
actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as Actor,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskEventType,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskEventRequest].
extension CreateTaskEventRequestPatterns on CreateTaskEventRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskEventRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskEventRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskEventRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskEventRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskEventRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskEventRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ActorConverter()  Actor actor,  TaskEventType eventType,  Map<String, Object?> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskEventRequest() when $default != null:
return $default(_that.actor,_that.eventType,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ActorConverter()  Actor actor,  TaskEventType eventType,  Map<String, Object?> payload)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskEventRequest():
return $default(_that.actor,_that.eventType,_that.payload);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ActorConverter()  Actor actor,  TaskEventType eventType,  Map<String, Object?> payload)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskEventRequest() when $default != null:
return $default(_that.actor,_that.eventType,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskEventRequest implements CreateTaskEventRequest {
  const _CreateTaskEventRequest({@ActorConverter() required this.actor, required this.eventType, final  Map<String, Object?> payload = const {}}): _payload = payload;
  factory _CreateTaskEventRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskEventRequestFromJson(json);

@override@ActorConverter() final  Actor actor;
@override final  TaskEventType eventType;
 final  Map<String, Object?> _payload;
@override@JsonKey() Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


/// Create a copy of CreateTaskEventRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskEventRequestCopyWith<_CreateTaskEventRequest> get copyWith => __$CreateTaskEventRequestCopyWithImpl<_CreateTaskEventRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskEventRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskEventRequest&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other._payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actor,eventType,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'CreateTaskEventRequest(actor: $actor, eventType: $eventType, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskEventRequestCopyWith<$Res> implements $CreateTaskEventRequestCopyWith<$Res> {
  factory _$CreateTaskEventRequestCopyWith(_CreateTaskEventRequest value, $Res Function(_CreateTaskEventRequest) _then) = __$CreateTaskEventRequestCopyWithImpl;
@override @useResult
$Res call({
@ActorConverter() Actor actor, TaskEventType eventType, Map<String, Object?> payload
});




}
/// @nodoc
class __$CreateTaskEventRequestCopyWithImpl<$Res>
    implements _$CreateTaskEventRequestCopyWith<$Res> {
  __$CreateTaskEventRequestCopyWithImpl(this._self, this._then);

  final _CreateTaskEventRequest _self;
  final $Res Function(_CreateTaskEventRequest) _then;

/// Create a copy of CreateTaskEventRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actor = null,Object? eventType = null,Object? payload = null,}) {
  return _then(_CreateTaskEventRequest(
actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as Actor,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskEventType,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
