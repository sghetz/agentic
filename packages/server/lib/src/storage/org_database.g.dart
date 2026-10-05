// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _reposJsonMeta = const VerificationMeta(
    'reposJson',
  );
  @override
  late final GeneratedColumn<String> reposJson = GeneratedColumn<String>(
    'repos_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flutterVersionMeta = const VerificationMeta(
    'flutterVersion',
  );
  @override
  late final GeneratedColumn<String> flutterVersion = GeneratedColumn<String>(
    'flutter_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _designSystemRefMeta = const VerificationMeta(
    'designSystemRef',
  );
  @override
  late final GeneratedColumn<String> designSystemRef = GeneratedColumn<String>(
    'design_system_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProjectStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProjectStatus>($ProjectsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    slug,
    reposJson,
    flutterVersion,
    designSystemRef,
    status,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('repos_json')) {
      context.handle(
        _reposJsonMeta,
        reposJson.isAcceptableOrUnknown(data['repos_json']!, _reposJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_reposJsonMeta);
    }
    if (data.containsKey('flutter_version')) {
      context.handle(
        _flutterVersionMeta,
        flutterVersion.isAcceptableOrUnknown(
          data['flutter_version']!,
          _flutterVersionMeta,
        ),
      );
    }
    if (data.containsKey('design_system_ref')) {
      context.handle(
        _designSystemRefMeta,
        designSystemRef.isAcceptableOrUnknown(
          data['design_system_ref']!,
          _designSystemRefMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      reposJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repos_json'],
      )!,
      flutterVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flutter_version'],
      ),
      designSystemRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}design_system_ref'],
      ),
      status: $ProjectsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProjectStatus, String, String> $converterstatus =
      const EnumNameConverter<ProjectStatus>(ProjectStatus.values);
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String id;
  final String name;
  final String slug;
  final String reposJson;
  final String? flutterVersion;
  final String? designSystemRef;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const ProjectRow({
    required this.id,
    required this.name,
    required this.slug,
    required this.reposJson,
    this.flutterVersion,
    this.designSystemRef,
    required this.status,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['repos_json'] = Variable<String>(reposJson);
    if (!nullToAbsent || flutterVersion != null) {
      map['flutter_version'] = Variable<String>(flutterVersion);
    }
    if (!nullToAbsent || designSystemRef != null) {
      map['design_system_ref'] = Variable<String>(designSystemRef);
    }
    {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      reposJson: Value(reposJson),
      flutterVersion: flutterVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(flutterVersion),
      designSystemRef: designSystemRef == null && nullToAbsent
          ? const Value.absent()
          : Value(designSystemRef),
      status: Value(status),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      reposJson: serializer.fromJson<String>(json['reposJson']),
      flutterVersion: serializer.fromJson<String?>(json['flutterVersion']),
      designSystemRef: serializer.fromJson<String?>(json['designSystemRef']),
      status: $ProjectsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'reposJson': serializer.toJson<String>(reposJson),
      'flutterVersion': serializer.toJson<String?>(flutterVersion),
      'designSystemRef': serializer.toJson<String?>(designSystemRef),
      'status': serializer.toJson<String>(
        $ProjectsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  ProjectRow copyWith({
    String? id,
    String? name,
    String? slug,
    String? reposJson,
    Value<String?> flutterVersion = const Value.absent(),
    Value<String?> designSystemRef = const Value.absent(),
    ProjectStatus? status,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => ProjectRow(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    reposJson: reposJson ?? this.reposJson,
    flutterVersion: flutterVersion.present
        ? flutterVersion.value
        : this.flutterVersion,
    designSystemRef: designSystemRef.present
        ? designSystemRef.value
        : this.designSystemRef,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      reposJson: data.reposJson.present ? data.reposJson.value : this.reposJson,
      flutterVersion: data.flutterVersion.present
          ? data.flutterVersion.value
          : this.flutterVersion,
      designSystemRef: data.designSystemRef.present
          ? data.designSystemRef.value
          : this.designSystemRef,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('reposJson: $reposJson, ')
          ..write('flutterVersion: $flutterVersion, ')
          ..write('designSystemRef: $designSystemRef, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    slug,
    reposJson,
    flutterVersion,
    designSystemRef,
    status,
    createdAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.reposJson == this.reposJson &&
          other.flutterVersion == this.flutterVersion &&
          other.designSystemRef == this.designSystemRef &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> reposJson;
  final Value<String?> flutterVersion;
  final Value<String?> designSystemRef;
  final Value<ProjectStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.reposJson = const Value.absent(),
    this.flutterVersion = const Value.absent(),
    this.designSystemRef = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required String slug,
    required String reposJson,
    this.flutterVersion = const Value.absent(),
    this.designSystemRef = const Value.absent(),
    required ProjectStatus status,
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       slug = Value(slug),
       reposJson = Value(reposJson),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ProjectRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? reposJson,
    Expression<String>? flutterVersion,
    Expression<String>? designSystemRef,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (reposJson != null) 'repos_json': reposJson,
      if (flutterVersion != null) 'flutter_version': flutterVersion,
      if (designSystemRef != null) 'design_system_ref': designSystemRef,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? slug,
    Value<String>? reposJson,
    Value<String?>? flutterVersion,
    Value<String?>? designSystemRef,
    Value<ProjectStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      reposJson: reposJson ?? this.reposJson,
      flutterVersion: flutterVersion ?? this.flutterVersion,
      designSystemRef: designSystemRef ?? this.designSystemRef,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (reposJson.present) {
      map['repos_json'] = Variable<String>(reposJson.value);
    }
    if (flutterVersion.present) {
      map['flutter_version'] = Variable<String>(flutterVersion.value);
    }
    if (designSystemRef.present) {
      map['design_system_ref'] = Variable<String>(designSystemRef.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('reposJson: $reposJson, ')
          ..write('flutterVersion: $flutterVersion, ')
          ..write('designSystemRef: $designSystemRef, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectLinksTable extends ProjectLinks
    with TableInfo<$ProjectLinksTable, ProjectLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromProjectIdMeta = const VerificationMeta(
    'fromProjectId',
  );
  @override
  late final GeneratedColumn<String> fromProjectId = GeneratedColumn<String>(
    'from_project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toProjectIdMeta = const VerificationMeta(
    'toProjectId',
  );
  @override
  late final GeneratedColumn<String> toProjectId = GeneratedColumn<String>(
    'to_project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkRelation, String> relation =
      GeneratedColumn<String>(
        'relation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkRelation>($ProjectLinksTable.$converterrelation);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromProjectId,
    toProjectId,
    relation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectLinkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_project_id')) {
      context.handle(
        _fromProjectIdMeta,
        fromProjectId.isAcceptableOrUnknown(
          data['from_project_id']!,
          _fromProjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromProjectIdMeta);
    }
    if (data.containsKey('to_project_id')) {
      context.handle(
        _toProjectIdMeta,
        toProjectId.isAcceptableOrUnknown(
          data['to_project_id']!,
          _toProjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toProjectIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectLinkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_project_id'],
      )!,
      toProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_project_id'],
      )!,
      relation: $ProjectLinksTable.$converterrelation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}relation'],
        )!,
      ),
    );
  }

  @override
  $ProjectLinksTable createAlias(String alias) {
    return $ProjectLinksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LinkRelation, String, String> $converterrelation =
      const EnumNameConverter<LinkRelation>(LinkRelation.values);
}

class ProjectLinkRow extends DataClass implements Insertable<ProjectLinkRow> {
  final String id;
  final String fromProjectId;
  final String toProjectId;
  final LinkRelation relation;
  const ProjectLinkRow({
    required this.id,
    required this.fromProjectId,
    required this.toProjectId,
    required this.relation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_project_id'] = Variable<String>(fromProjectId);
    map['to_project_id'] = Variable<String>(toProjectId);
    {
      map['relation'] = Variable<String>(
        $ProjectLinksTable.$converterrelation.toSql(relation),
      );
    }
    return map;
  }

  ProjectLinksCompanion toCompanion(bool nullToAbsent) {
    return ProjectLinksCompanion(
      id: Value(id),
      fromProjectId: Value(fromProjectId),
      toProjectId: Value(toProjectId),
      relation: Value(relation),
    );
  }

  factory ProjectLinkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectLinkRow(
      id: serializer.fromJson<String>(json['id']),
      fromProjectId: serializer.fromJson<String>(json['fromProjectId']),
      toProjectId: serializer.fromJson<String>(json['toProjectId']),
      relation: $ProjectLinksTable.$converterrelation.fromJson(
        serializer.fromJson<String>(json['relation']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromProjectId': serializer.toJson<String>(fromProjectId),
      'toProjectId': serializer.toJson<String>(toProjectId),
      'relation': serializer.toJson<String>(
        $ProjectLinksTable.$converterrelation.toJson(relation),
      ),
    };
  }

  ProjectLinkRow copyWith({
    String? id,
    String? fromProjectId,
    String? toProjectId,
    LinkRelation? relation,
  }) => ProjectLinkRow(
    id: id ?? this.id,
    fromProjectId: fromProjectId ?? this.fromProjectId,
    toProjectId: toProjectId ?? this.toProjectId,
    relation: relation ?? this.relation,
  );
  ProjectLinkRow copyWithCompanion(ProjectLinksCompanion data) {
    return ProjectLinkRow(
      id: data.id.present ? data.id.value : this.id,
      fromProjectId: data.fromProjectId.present
          ? data.fromProjectId.value
          : this.fromProjectId,
      toProjectId: data.toProjectId.present
          ? data.toProjectId.value
          : this.toProjectId,
      relation: data.relation.present ? data.relation.value : this.relation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectLinkRow(')
          ..write('id: $id, ')
          ..write('fromProjectId: $fromProjectId, ')
          ..write('toProjectId: $toProjectId, ')
          ..write('relation: $relation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromProjectId, toProjectId, relation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectLinkRow &&
          other.id == this.id &&
          other.fromProjectId == this.fromProjectId &&
          other.toProjectId == this.toProjectId &&
          other.relation == this.relation);
}

class ProjectLinksCompanion extends UpdateCompanion<ProjectLinkRow> {
  final Value<String> id;
  final Value<String> fromProjectId;
  final Value<String> toProjectId;
  final Value<LinkRelation> relation;
  final Value<int> rowid;
  const ProjectLinksCompanion({
    this.id = const Value.absent(),
    this.fromProjectId = const Value.absent(),
    this.toProjectId = const Value.absent(),
    this.relation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectLinksCompanion.insert({
    required String id,
    required String fromProjectId,
    required String toProjectId,
    required LinkRelation relation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromProjectId = Value(fromProjectId),
       toProjectId = Value(toProjectId),
       relation = Value(relation);
  static Insertable<ProjectLinkRow> custom({
    Expression<String>? id,
    Expression<String>? fromProjectId,
    Expression<String>? toProjectId,
    Expression<String>? relation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromProjectId != null) 'from_project_id': fromProjectId,
      if (toProjectId != null) 'to_project_id': toProjectId,
      if (relation != null) 'relation': relation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? fromProjectId,
    Value<String>? toProjectId,
    Value<LinkRelation>? relation,
    Value<int>? rowid,
  }) {
    return ProjectLinksCompanion(
      id: id ?? this.id,
      fromProjectId: fromProjectId ?? this.fromProjectId,
      toProjectId: toProjectId ?? this.toProjectId,
      relation: relation ?? this.relation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromProjectId.present) {
      map['from_project_id'] = Variable<String>(fromProjectId.value);
    }
    if (toProjectId.present) {
      map['to_project_id'] = Variable<String>(toProjectId.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(
        $ProjectLinksTable.$converterrelation.toSql(relation.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectLinksCompanion(')
          ..write('id: $id, ')
          ..write('fromProjectId: $fromProjectId, ')
          ..write('toProjectId: $toProjectId, ')
          ..write('relation: $relation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String>
  currentStatus = GeneratedColumn<String>(
    'current_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TaskStatus>($TasksTable.$convertercurrentStatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    title,
    currentStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      currentStatus: $TasksTable.$convertercurrentStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}current_status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String>
  $convertercurrentStatus = const EnumNameConverter<TaskStatus>(
    TaskStatus.values,
  );
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String projectId;
  final String title;
  final TaskStatus currentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRow({
    required this.id,
    required this.projectId,
    required this.title,
    required this.currentStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    {
      map['current_status'] = Variable<String>(
        $TasksTable.$convertercurrentStatus.toSql(currentStatus),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      currentStatus: Value(currentStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      currentStatus: $TasksTable.$convertercurrentStatus.fromJson(
        serializer.fromJson<String>(json['currentStatus']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'currentStatus': serializer.toJson<String>(
        $TasksTable.$convertercurrentStatus.toJson(currentStatus),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? projectId,
    String? title,
    TaskStatus? currentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    currentStatus: currentStatus ?? this.currentStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      currentStatus: data.currentStatus.present
          ? data.currentStatus.value
          : this.currentStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, title, currentStatus, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.currentStatus == this.currentStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> title;
  final Value<TaskStatus> currentStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.currentStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String projectId,
    required String title,
    required TaskStatus currentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       title = Value(title),
       currentStatus = Value(currentStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? currentStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (currentStatus != null) 'current_status': currentStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? title,
    Value<TaskStatus>? currentStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      currentStatus: currentStatus ?? this.currentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (currentStatus.present) {
      map['current_status'] = Variable<String>(
        $TasksTable.$convertercurrentStatus.toSql(currentStatus.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEventsTable extends TaskEvents
    with TableInfo<$TaskEventsTable, TaskEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<DateTime> ts = GeneratedColumn<DateTime>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskEventType, String> eventType =
      GeneratedColumn<String>(
        'event_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskEventType>($TaskEventsTable.$convertereventType);
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    ts,
    actor,
    eventType,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      eventType: $TaskEventsTable.$convertereventType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}event_type'],
        )!,
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $TaskEventsTable createAlias(String alias) {
    return $TaskEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskEventType, String, String> $convertereventType =
      const EnumNameConverter<TaskEventType>(TaskEventType.values);
}

class TaskEventRow extends DataClass implements Insertable<TaskEventRow> {
  final String id;
  final String taskId;
  final DateTime ts;

  /// "user" or "agent:`<role>`" -- see `core.Actor.toStorageString()`.
  final String actor;
  final TaskEventType eventType;
  final String payloadJson;
  const TaskEventRow({
    required this.id,
    required this.taskId,
    required this.ts,
    required this.actor,
    required this.eventType,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['ts'] = Variable<DateTime>(ts);
    map['actor'] = Variable<String>(actor);
    {
      map['event_type'] = Variable<String>(
        $TaskEventsTable.$convertereventType.toSql(eventType),
      );
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  TaskEventsCompanion toCompanion(bool nullToAbsent) {
    return TaskEventsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      ts: Value(ts),
      actor: Value(actor),
      eventType: Value(eventType),
      payloadJson: Value(payloadJson),
    );
  }

  factory TaskEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEventRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      actor: serializer.fromJson<String>(json['actor']),
      eventType: $TaskEventsTable.$convertereventType.fromJson(
        serializer.fromJson<String>(json['eventType']),
      ),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'ts': serializer.toJson<DateTime>(ts),
      'actor': serializer.toJson<String>(actor),
      'eventType': serializer.toJson<String>(
        $TaskEventsTable.$convertereventType.toJson(eventType),
      ),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  TaskEventRow copyWith({
    String? id,
    String? taskId,
    DateTime? ts,
    String? actor,
    TaskEventType? eventType,
    String? payloadJson,
  }) => TaskEventRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    ts: ts ?? this.ts,
    actor: actor ?? this.actor,
    eventType: eventType ?? this.eventType,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  TaskEventRow copyWithCompanion(TaskEventsCompanion data) {
    return TaskEventRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      ts: data.ts.present ? data.ts.value : this.ts,
      actor: data.actor.present ? data.actor.value : this.actor,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('ts: $ts, ')
          ..write('actor: $actor, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, ts, actor, eventType, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEventRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.ts == this.ts &&
          other.actor == this.actor &&
          other.eventType == this.eventType &&
          other.payloadJson == this.payloadJson);
}

class TaskEventsCompanion extends UpdateCompanion<TaskEventRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<DateTime> ts;
  final Value<String> actor;
  final Value<TaskEventType> eventType;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const TaskEventsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.ts = const Value.absent(),
    this.actor = const Value.absent(),
    this.eventType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEventsCompanion.insert({
    required String id,
    required String taskId,
    required DateTime ts,
    required String actor,
    required TaskEventType eventType,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       ts = Value(ts),
       actor = Value(actor),
       eventType = Value(eventType),
       payloadJson = Value(payloadJson);
  static Insertable<TaskEventRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<DateTime>? ts,
    Expression<String>? actor,
    Expression<String>? eventType,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (ts != null) 'ts': ts,
      if (actor != null) 'actor': actor,
      if (eventType != null) 'event_type': eventType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<DateTime>? ts,
    Value<String>? actor,
    Value<TaskEventType>? eventType,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return TaskEventsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      ts: ts ?? this.ts,
      actor: actor ?? this.actor,
      eventType: eventType ?? this.eventType,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (ts.present) {
      map['ts'] = Variable<DateTime>(ts.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(
        $TaskEventsTable.$convertereventType.toSql(eventType.value),
      );
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('ts: $ts, ')
          ..write('actor: $actor, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtifactsTable extends Artifacts
    with TableInfo<$ArtifactsTable, ArtifactRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtifactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ArtifactKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ArtifactKind>($ArtifactsTable.$converterkind);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    kind,
    uri,
    version,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artifacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArtifactRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArtifactRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtifactRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      kind: $ArtifactsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      uri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uri'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ArtifactsTable createAlias(String alias) {
    return $ArtifactsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ArtifactKind, String, String> $converterkind =
      const EnumNameConverter<ArtifactKind>(ArtifactKind.values);
}

class ArtifactRow extends DataClass implements Insertable<ArtifactRow> {
  final String id;
  final String taskId;
  final ArtifactKind kind;
  final String uri;
  final int version;
  final DateTime createdAt;
  const ArtifactRow({
    required this.id,
    required this.taskId,
    required this.kind,
    required this.uri,
    required this.version,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    {
      map['kind'] = Variable<String>(
        $ArtifactsTable.$converterkind.toSql(kind),
      );
    }
    map['uri'] = Variable<String>(uri);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ArtifactsCompanion toCompanion(bool nullToAbsent) {
    return ArtifactsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      kind: Value(kind),
      uri: Value(uri),
      version: Value(version),
      createdAt: Value(createdAt),
    );
  }

  factory ArtifactRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtifactRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      kind: $ArtifactsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      uri: serializer.fromJson<String>(json['uri']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'kind': serializer.toJson<String>(
        $ArtifactsTable.$converterkind.toJson(kind),
      ),
      'uri': serializer.toJson<String>(uri),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ArtifactRow copyWith({
    String? id,
    String? taskId,
    ArtifactKind? kind,
    String? uri,
    int? version,
    DateTime? createdAt,
  }) => ArtifactRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    kind: kind ?? this.kind,
    uri: uri ?? this.uri,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
  );
  ArtifactRow copyWithCompanion(ArtifactsCompanion data) {
    return ArtifactRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      kind: data.kind.present ? data.kind.value : this.kind,
      uri: data.uri.present ? data.uri.value : this.uri,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArtifactRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('kind: $kind, ')
          ..write('uri: $uri, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, kind, uri, version, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtifactRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.kind == this.kind &&
          other.uri == this.uri &&
          other.version == this.version &&
          other.createdAt == this.createdAt);
}

class ArtifactsCompanion extends UpdateCompanion<ArtifactRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<ArtifactKind> kind;
  final Value<String> uri;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ArtifactsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.kind = const Value.absent(),
    this.uri = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtifactsCompanion.insert({
    required String id,
    required String taskId,
    required ArtifactKind kind,
    required String uri,
    required int version,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       kind = Value(kind),
       uri = Value(uri),
       version = Value(version),
       createdAt = Value(createdAt);
  static Insertable<ArtifactRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? kind,
    Expression<String>? uri,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (kind != null) 'kind': kind,
      if (uri != null) 'uri': uri,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtifactsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<ArtifactKind>? kind,
    Value<String>? uri,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ArtifactsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      kind: kind ?? this.kind,
      uri: uri ?? this.uri,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ArtifactsTable.$converterkind.toSql(kind.value),
      );
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtifactsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('kind: $kind, ')
          ..write('uri: $uri, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OrgDatabase extends GeneratedDatabase {
  _$OrgDatabase(QueryExecutor e) : super(e);
  $OrgDatabaseManager get managers => $OrgDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $ProjectLinksTable projectLinks = $ProjectLinksTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskEventsTable taskEvents = $TaskEventsTable(this);
  late final $ArtifactsTable artifacts = $ArtifactsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    projectLinks,
    tasks,
    taskEvents,
    artifacts,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      required String slug,
      required String reposJson,
      Value<String?> flutterVersion,
      Value<String?> designSystemRef,
      required ProjectStatus status,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> slug,
      Value<String> reposJson,
      Value<String?> flutterVersion,
      Value<String?> designSystemRef,
      Value<ProjectStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$ProjectsTableFilterComposer
    extends Composer<_$OrgDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reposJson => $composableBuilder(
    column: $table.reposJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flutterVersion => $composableBuilder(
    column: $table.flutterVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get designSystemRef => $composableBuilder(
    column: $table.designSystemRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProjectStatus, ProjectStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$OrgDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reposJson => $composableBuilder(
    column: $table.reposJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flutterVersion => $composableBuilder(
    column: $table.flutterVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get designSystemRef => $composableBuilder(
    column: $table.designSystemRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$OrgDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get reposJson =>
      $composableBuilder(column: $table.reposJson, builder: (column) => column);

  GeneratedColumn<String> get flutterVersion => $composableBuilder(
    column: $table.flutterVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get designSystemRef => $composableBuilder(
    column: $table.designSystemRef,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ProjectStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$OrgDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (
            ProjectRow,
            BaseReferences<_$OrgDatabase, $ProjectsTable, ProjectRow>,
          ),
          ProjectRow,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$OrgDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> reposJson = const Value.absent(),
                Value<String?> flutterVersion = const Value.absent(),
                Value<String?> designSystemRef = const Value.absent(),
                Value<ProjectStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                slug: slug,
                reposJson: reposJson,
                flutterVersion: flutterVersion,
                designSystemRef: designSystemRef,
                status: status,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String slug,
                required String reposJson,
                Value<String?> flutterVersion = const Value.absent(),
                Value<String?> designSystemRef = const Value.absent(),
                required ProjectStatus status,
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                slug: slug,
                reposJson: reposJson,
                flutterVersion: flutterVersion,
                designSystemRef: designSystemRef,
                status: status,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$OrgDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, BaseReferences<_$OrgDatabase, $ProjectsTable, ProjectRow>),
      ProjectRow,
      PrefetchHooks Function()
    >;
typedef $$ProjectLinksTableCreateCompanionBuilder =
    ProjectLinksCompanion Function({
      required String id,
      required String fromProjectId,
      required String toProjectId,
      required LinkRelation relation,
      Value<int> rowid,
    });
typedef $$ProjectLinksTableUpdateCompanionBuilder =
    ProjectLinksCompanion Function({
      Value<String> id,
      Value<String> fromProjectId,
      Value<String> toProjectId,
      Value<LinkRelation> relation,
      Value<int> rowid,
    });

class $$ProjectLinksTableFilterComposer
    extends Composer<_$OrgDatabase, $ProjectLinksTable> {
  $$ProjectLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromProjectId => $composableBuilder(
    column: $table.fromProjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toProjectId => $composableBuilder(
    column: $table.toProjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkRelation, LinkRelation, String>
  get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$ProjectLinksTableOrderingComposer
    extends Composer<_$OrgDatabase, $ProjectLinksTable> {
  $$ProjectLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromProjectId => $composableBuilder(
    column: $table.fromProjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toProjectId => $composableBuilder(
    column: $table.toProjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectLinksTableAnnotationComposer
    extends Composer<_$OrgDatabase, $ProjectLinksTable> {
  $$ProjectLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromProjectId => $composableBuilder(
    column: $table.fromProjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toProjectId => $composableBuilder(
    column: $table.toProjectId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LinkRelation, String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);
}

class $$ProjectLinksTableTableManager
    extends
        RootTableManager<
          _$OrgDatabase,
          $ProjectLinksTable,
          ProjectLinkRow,
          $$ProjectLinksTableFilterComposer,
          $$ProjectLinksTableOrderingComposer,
          $$ProjectLinksTableAnnotationComposer,
          $$ProjectLinksTableCreateCompanionBuilder,
          $$ProjectLinksTableUpdateCompanionBuilder,
          (
            ProjectLinkRow,
            BaseReferences<_$OrgDatabase, $ProjectLinksTable, ProjectLinkRow>,
          ),
          ProjectLinkRow,
          PrefetchHooks Function()
        > {
  $$ProjectLinksTableTableManager(_$OrgDatabase db, $ProjectLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromProjectId = const Value.absent(),
                Value<String> toProjectId = const Value.absent(),
                Value<LinkRelation> relation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectLinksCompanion(
                id: id,
                fromProjectId: fromProjectId,
                toProjectId: toProjectId,
                relation: relation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromProjectId,
                required String toProjectId,
                required LinkRelation relation,
                Value<int> rowid = const Value.absent(),
              }) => ProjectLinksCompanion.insert(
                id: id,
                fromProjectId: fromProjectId,
                toProjectId: toProjectId,
                relation: relation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$OrgDatabase,
      $ProjectLinksTable,
      ProjectLinkRow,
      $$ProjectLinksTableFilterComposer,
      $$ProjectLinksTableOrderingComposer,
      $$ProjectLinksTableAnnotationComposer,
      $$ProjectLinksTableCreateCompanionBuilder,
      $$ProjectLinksTableUpdateCompanionBuilder,
      (
        ProjectLinkRow,
        BaseReferences<_$OrgDatabase, $ProjectLinksTable, ProjectLinkRow>,
      ),
      ProjectLinkRow,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String projectId,
      required String title,
      required TaskStatus currentStatus,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> title,
      Value<TaskStatus> currentStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$OrgDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String>
  get currentStatus => $composableBuilder(
    column: $table.currentStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$OrgDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentStatus => $composableBuilder(
    column: $table.currentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$OrgDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get currentStatus =>
      $composableBuilder(
        column: $table.currentStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$OrgDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$OrgDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$OrgDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskStatus> currentStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                projectId: projectId,
                title: title,
                currentStatus: currentStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String title,
                required TaskStatus currentStatus,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                projectId: projectId,
                title: title,
                currentStatus: currentStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$OrgDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$OrgDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$TaskEventsTableCreateCompanionBuilder =
    TaskEventsCompanion Function({
      required String id,
      required String taskId,
      required DateTime ts,
      required String actor,
      required TaskEventType eventType,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$TaskEventsTableUpdateCompanionBuilder =
    TaskEventsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<DateTime> ts,
      Value<String> actor,
      Value<TaskEventType> eventType,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$TaskEventsTableFilterComposer
    extends Composer<_$OrgDatabase, $TaskEventsTable> {
  $$TaskEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskEventType, TaskEventType, String>
  get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskEventsTableOrderingComposer
    extends Composer<_$OrgDatabase, $TaskEventsTable> {
  $$TaskEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskEventsTableAnnotationComposer
    extends Composer<_$OrgDatabase, $TaskEventsTable> {
  $$TaskEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<DateTime> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskEventType, String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$TaskEventsTableTableManager
    extends
        RootTableManager<
          _$OrgDatabase,
          $TaskEventsTable,
          TaskEventRow,
          $$TaskEventsTableFilterComposer,
          $$TaskEventsTableOrderingComposer,
          $$TaskEventsTableAnnotationComposer,
          $$TaskEventsTableCreateCompanionBuilder,
          $$TaskEventsTableUpdateCompanionBuilder,
          (
            TaskEventRow,
            BaseReferences<_$OrgDatabase, $TaskEventsTable, TaskEventRow>,
          ),
          TaskEventRow,
          PrefetchHooks Function()
        > {
  $$TaskEventsTableTableManager(_$OrgDatabase db, $TaskEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<TaskEventType> eventType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEventsCompanion(
                id: id,
                taskId: taskId,
                ts: ts,
                actor: actor,
                eventType: eventType,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required DateTime ts,
                required String actor,
                required TaskEventType eventType,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => TaskEventsCompanion.insert(
                id: id,
                taskId: taskId,
                ts: ts,
                actor: actor,
                eventType: eventType,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$OrgDatabase,
      $TaskEventsTable,
      TaskEventRow,
      $$TaskEventsTableFilterComposer,
      $$TaskEventsTableOrderingComposer,
      $$TaskEventsTableAnnotationComposer,
      $$TaskEventsTableCreateCompanionBuilder,
      $$TaskEventsTableUpdateCompanionBuilder,
      (
        TaskEventRow,
        BaseReferences<_$OrgDatabase, $TaskEventsTable, TaskEventRow>,
      ),
      TaskEventRow,
      PrefetchHooks Function()
    >;
typedef $$ArtifactsTableCreateCompanionBuilder =
    ArtifactsCompanion Function({
      required String id,
      required String taskId,
      required ArtifactKind kind,
      required String uri,
      required int version,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ArtifactsTableUpdateCompanionBuilder =
    ArtifactsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<ArtifactKind> kind,
      Value<String> uri,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ArtifactsTableFilterComposer
    extends Composer<_$OrgDatabase, $ArtifactsTable> {
  $$ArtifactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ArtifactKind, ArtifactKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArtifactsTableOrderingComposer
    extends Composer<_$OrgDatabase, $ArtifactsTable> {
  $$ArtifactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtifactsTableAnnotationComposer
    extends Composer<_$OrgDatabase, $ArtifactsTable> {
  $$ArtifactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ArtifactKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ArtifactsTableTableManager
    extends
        RootTableManager<
          _$OrgDatabase,
          $ArtifactsTable,
          ArtifactRow,
          $$ArtifactsTableFilterComposer,
          $$ArtifactsTableOrderingComposer,
          $$ArtifactsTableAnnotationComposer,
          $$ArtifactsTableCreateCompanionBuilder,
          $$ArtifactsTableUpdateCompanionBuilder,
          (
            ArtifactRow,
            BaseReferences<_$OrgDatabase, $ArtifactsTable, ArtifactRow>,
          ),
          ArtifactRow,
          PrefetchHooks Function()
        > {
  $$ArtifactsTableTableManager(_$OrgDatabase db, $ArtifactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtifactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtifactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtifactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<ArtifactKind> kind = const Value.absent(),
                Value<String> uri = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtifactsCompanion(
                id: id,
                taskId: taskId,
                kind: kind,
                uri: uri,
                version: version,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required ArtifactKind kind,
                required String uri,
                required int version,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ArtifactsCompanion.insert(
                id: id,
                taskId: taskId,
                kind: kind,
                uri: uri,
                version: version,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArtifactsTableProcessedTableManager =
    ProcessedTableManager<
      _$OrgDatabase,
      $ArtifactsTable,
      ArtifactRow,
      $$ArtifactsTableFilterComposer,
      $$ArtifactsTableOrderingComposer,
      $$ArtifactsTableAnnotationComposer,
      $$ArtifactsTableCreateCompanionBuilder,
      $$ArtifactsTableUpdateCompanionBuilder,
      (
        ArtifactRow,
        BaseReferences<_$OrgDatabase, $ArtifactsTable, ArtifactRow>,
      ),
      ArtifactRow,
      PrefetchHooks Function()
    >;

class $OrgDatabaseManager {
  final _$OrgDatabase _db;
  $OrgDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$ProjectLinksTableTableManager get projectLinks =>
      $$ProjectLinksTableTableManager(_db, _db.projectLinks);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskEventsTableTableManager get taskEvents =>
      $$TaskEventsTableTableManager(_db, _db.taskEvents);
  $$ArtifactsTableTableManager get artifacts =>
      $$ArtifactsTableTableManager(_db, _db.artifacts);
}
