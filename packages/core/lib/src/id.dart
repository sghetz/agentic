import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A time-ordered UUID v7, used as the primary key for every stored record.
String newId() => _uuid.v7();
