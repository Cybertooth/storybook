// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoriesTableTable extends StoriesTable
    with TableInfo<$StoriesTableTable, StoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coreQuestionMeta =
      const VerificationMeta('coreQuestion');
  @override
  late final GeneratedColumn<String> coreQuestion = GeneratedColumn<String>(
      'core_question', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, summary, theme, coreQuestion, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories_table';
  @override
  VerificationContext validateIntegrity(Insertable<StoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('core_question')) {
      context.handle(
          _coreQuestionMeta,
          coreQuestion.isAcceptableOrUnknown(
              data['core_question']!, _coreQuestionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      coreQuestion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}core_question'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StoriesTableTable createAlias(String alias) {
    return $StoriesTableTable(attachedDatabase, alias);
  }
}

class StoriesTableData extends DataClass
    implements Insertable<StoriesTableData> {
  final String id;
  final String title;
  final String summary;
  final String theme;
  final String coreQuestion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StoriesTableData(
      {required this.id,
      required this.title,
      required this.summary,
      required this.theme,
      required this.coreQuestion,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['theme'] = Variable<String>(theme);
    map['core_question'] = Variable<String>(coreQuestion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoriesTableCompanion toCompanion(bool nullToAbsent) {
    return StoriesTableCompanion(
      id: Value(id),
      title: Value(title),
      summary: Value(summary),
      theme: Value(theme),
      coreQuestion: Value(coreQuestion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      theme: serializer.fromJson<String>(json['theme']),
      coreQuestion: serializer.fromJson<String>(json['coreQuestion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'theme': serializer.toJson<String>(theme),
      'coreQuestion': serializer.toJson<String>(coreQuestion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StoriesTableData copyWith(
          {String? id,
          String? title,
          String? summary,
          String? theme,
          String? coreQuestion,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      StoriesTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        summary: summary ?? this.summary,
        theme: theme ?? this.theme,
        coreQuestion: coreQuestion ?? this.coreQuestion,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StoriesTableData copyWithCompanion(StoriesTableCompanion data) {
    return StoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      theme: data.theme.present ? data.theme.value : this.theme,
      coreQuestion: data.coreQuestion.present
          ? data.coreQuestion.value
          : this.coreQuestion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoriesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('theme: $theme, ')
          ..write('coreQuestion: $coreQuestion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, summary, theme, coreQuestion, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoriesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.theme == this.theme &&
          other.coreQuestion == this.coreQuestion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StoriesTableCompanion extends UpdateCompanion<StoriesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> summary;
  final Value<String> theme;
  final Value<String> coreQuestion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StoriesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.theme = const Value.absent(),
    this.coreQuestion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoriesTableCompanion.insert({
    required String id,
    required String title,
    this.summary = const Value.absent(),
    this.theme = const Value.absent(),
    this.coreQuestion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<StoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? theme,
    Expression<String>? coreQuestion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (theme != null) 'theme': theme,
      if (coreQuestion != null) 'core_question': coreQuestion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? summary,
      Value<String>? theme,
      Value<String>? coreQuestion,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return StoriesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      theme: theme ?? this.theme,
      coreQuestion: coreQuestion ?? this.coreQuestion,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (coreQuestion.present) {
      map['core_question'] = Variable<String>(coreQuestion.value);
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
    return (StringBuffer('StoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('theme: $theme, ')
          ..write('coreQuestion: $coreQuestion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTableTable extends CharactersTable
    with TableInfo<$CharactersTableTable, CharactersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('supporting'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _traitsJsonMeta =
      const VerificationMeta('traitsJson');
  @override
  late final GeneratedColumn<String> traitsJson = GeneratedColumn<String>(
      'traits_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _arcLieMeta = const VerificationMeta('arcLie');
  @override
  late final GeneratedColumn<String> arcLie = GeneratedColumn<String>(
      'arc_lie', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _arcTruthMeta =
      const VerificationMeta('arcTruth');
  @override
  late final GeneratedColumn<String> arcTruth = GeneratedColumn<String>(
      'arc_truth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _arcGhostMeta =
      const VerificationMeta('arcGhost');
  @override
  late final GeneratedColumn<String> arcGhost = GeneratedColumn<String>(
      'arc_ghost', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storyId,
        name,
        role,
        description,
        traitsJson,
        arcLie,
        arcTruth,
        arcGhost,
        avatarUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CharactersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('traits_json')) {
      context.handle(
          _traitsJsonMeta,
          traitsJson.isAcceptableOrUnknown(
              data['traits_json']!, _traitsJsonMeta));
    }
    if (data.containsKey('arc_lie')) {
      context.handle(_arcLieMeta,
          arcLie.isAcceptableOrUnknown(data['arc_lie']!, _arcLieMeta));
    }
    if (data.containsKey('arc_truth')) {
      context.handle(_arcTruthMeta,
          arcTruth.isAcceptableOrUnknown(data['arc_truth']!, _arcTruthMeta));
    }
    if (data.containsKey('arc_ghost')) {
      context.handle(_arcGhostMeta,
          arcGhost.isAcceptableOrUnknown(data['arc_ghost']!, _arcGhostMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharactersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharactersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      traitsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}traits_json'])!,
      arcLie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arc_lie']),
      arcTruth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arc_truth']),
      arcGhost: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arc_ghost']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
    );
  }

  @override
  $CharactersTableTable createAlias(String alias) {
    return $CharactersTableTable(attachedDatabase, alias);
  }
}

class CharactersTableData extends DataClass
    implements Insertable<CharactersTableData> {
  final String id;
  final String storyId;
  final String name;
  final String role;
  final String description;
  final String traitsJson;
  final String? arcLie;
  final String? arcTruth;
  final String? arcGhost;
  final String? avatarUrl;
  const CharactersTableData(
      {required this.id,
      required this.storyId,
      required this.name,
      required this.role,
      required this.description,
      required this.traitsJson,
      this.arcLie,
      this.arcTruth,
      this.arcGhost,
      this.avatarUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['description'] = Variable<String>(description);
    map['traits_json'] = Variable<String>(traitsJson);
    if (!nullToAbsent || arcLie != null) {
      map['arc_lie'] = Variable<String>(arcLie);
    }
    if (!nullToAbsent || arcTruth != null) {
      map['arc_truth'] = Variable<String>(arcTruth);
    }
    if (!nullToAbsent || arcGhost != null) {
      map['arc_ghost'] = Variable<String>(arcGhost);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    return map;
  }

  CharactersTableCompanion toCompanion(bool nullToAbsent) {
    return CharactersTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      name: Value(name),
      role: Value(role),
      description: Value(description),
      traitsJson: Value(traitsJson),
      arcLie:
          arcLie == null && nullToAbsent ? const Value.absent() : Value(arcLie),
      arcTruth: arcTruth == null && nullToAbsent
          ? const Value.absent()
          : Value(arcTruth),
      arcGhost: arcGhost == null && nullToAbsent
          ? const Value.absent()
          : Value(arcGhost),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
    );
  }

  factory CharactersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharactersTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      description: serializer.fromJson<String>(json['description']),
      traitsJson: serializer.fromJson<String>(json['traitsJson']),
      arcLie: serializer.fromJson<String?>(json['arcLie']),
      arcTruth: serializer.fromJson<String?>(json['arcTruth']),
      arcGhost: serializer.fromJson<String?>(json['arcGhost']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'description': serializer.toJson<String>(description),
      'traitsJson': serializer.toJson<String>(traitsJson),
      'arcLie': serializer.toJson<String?>(arcLie),
      'arcTruth': serializer.toJson<String?>(arcTruth),
      'arcGhost': serializer.toJson<String?>(arcGhost),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
    };
  }

  CharactersTableData copyWith(
          {String? id,
          String? storyId,
          String? name,
          String? role,
          String? description,
          String? traitsJson,
          Value<String?> arcLie = const Value.absent(),
          Value<String?> arcTruth = const Value.absent(),
          Value<String?> arcGhost = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent()}) =>
      CharactersTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        name: name ?? this.name,
        role: role ?? this.role,
        description: description ?? this.description,
        traitsJson: traitsJson ?? this.traitsJson,
        arcLie: arcLie.present ? arcLie.value : this.arcLie,
        arcTruth: arcTruth.present ? arcTruth.value : this.arcTruth,
        arcGhost: arcGhost.present ? arcGhost.value : this.arcGhost,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
      );
  CharactersTableData copyWithCompanion(CharactersTableCompanion data) {
    return CharactersTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      description:
          data.description.present ? data.description.value : this.description,
      traitsJson:
          data.traitsJson.present ? data.traitsJson.value : this.traitsJson,
      arcLie: data.arcLie.present ? data.arcLie.value : this.arcLie,
      arcTruth: data.arcTruth.present ? data.arcTruth.value : this.arcTruth,
      arcGhost: data.arcGhost.present ? data.arcGhost.value : this.arcGhost,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('description: $description, ')
          ..write('traitsJson: $traitsJson, ')
          ..write('arcLie: $arcLie, ')
          ..write('arcTruth: $arcTruth, ')
          ..write('arcGhost: $arcGhost, ')
          ..write('avatarUrl: $avatarUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, name, role, description,
      traitsJson, arcLie, arcTruth, arcGhost, avatarUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharactersTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.name == this.name &&
          other.role == this.role &&
          other.description == this.description &&
          other.traitsJson == this.traitsJson &&
          other.arcLie == this.arcLie &&
          other.arcTruth == this.arcTruth &&
          other.arcGhost == this.arcGhost &&
          other.avatarUrl == this.avatarUrl);
}

class CharactersTableCompanion extends UpdateCompanion<CharactersTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> name;
  final Value<String> role;
  final Value<String> description;
  final Value<String> traitsJson;
  final Value<String?> arcLie;
  final Value<String?> arcTruth;
  final Value<String?> arcGhost;
  final Value<String?> avatarUrl;
  final Value<int> rowid;
  const CharactersTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.description = const Value.absent(),
    this.traitsJson = const Value.absent(),
    this.arcLie = const Value.absent(),
    this.arcTruth = const Value.absent(),
    this.arcGhost = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersTableCompanion.insert({
    required String id,
    required String storyId,
    required String name,
    this.role = const Value.absent(),
    this.description = const Value.absent(),
    this.traitsJson = const Value.absent(),
    this.arcLie = const Value.absent(),
    this.arcTruth = const Value.absent(),
    this.arcGhost = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        name = Value(name);
  static Insertable<CharactersTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? description,
    Expression<String>? traitsJson,
    Expression<String>? arcLie,
    Expression<String>? arcTruth,
    Expression<String>? arcGhost,
    Expression<String>? avatarUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (description != null) 'description': description,
      if (traitsJson != null) 'traits_json': traitsJson,
      if (arcLie != null) 'arc_lie': arcLie,
      if (arcTruth != null) 'arc_truth': arcTruth,
      if (arcGhost != null) 'arc_ghost': arcGhost,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? name,
      Value<String>? role,
      Value<String>? description,
      Value<String>? traitsJson,
      Value<String?>? arcLie,
      Value<String?>? arcTruth,
      Value<String?>? arcGhost,
      Value<String?>? avatarUrl,
      Value<int>? rowid}) {
    return CharactersTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      traitsJson: traitsJson ?? this.traitsJson,
      arcLie: arcLie ?? this.arcLie,
      arcTruth: arcTruth ?? this.arcTruth,
      arcGhost: arcGhost ?? this.arcGhost,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (traitsJson.present) {
      map['traits_json'] = Variable<String>(traitsJson.value);
    }
    if (arcLie.present) {
      map['arc_lie'] = Variable<String>(arcLie.value);
    }
    if (arcTruth.present) {
      map['arc_truth'] = Variable<String>(arcTruth.value);
    }
    if (arcGhost.present) {
      map['arc_ghost'] = Variable<String>(arcGhost.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('description: $description, ')
          ..write('traitsJson: $traitsJson, ')
          ..write('arcLie: $arcLie, ')
          ..write('arcTruth: $arcTruth, ')
          ..write('arcGhost: $arcGhost, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTableTable extends LocationsTable
    with TableInfo<$LocationsTableTable, LocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sensorySightMeta =
      const VerificationMeta('sensorySight');
  @override
  late final GeneratedColumn<String> sensorySight = GeneratedColumn<String>(
      'sensory_sight', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sensorySoundMeta =
      const VerificationMeta('sensorySound');
  @override
  late final GeneratedColumn<String> sensorySound = GeneratedColumn<String>(
      'sensory_sound', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sensorySmellMeta =
      const VerificationMeta('sensorySmell');
  @override
  late final GeneratedColumn<String> sensorySmell = GeneratedColumn<String>(
      'sensory_smell', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sensoryTouchMeta =
      const VerificationMeta('sensoryTouch');
  @override
  late final GeneratedColumn<String> sensoryTouch = GeneratedColumn<String>(
      'sensory_touch', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sensoryTasteMeta =
      const VerificationMeta('sensoryTaste');
  @override
  late final GeneratedColumn<String> sensoryTaste = GeneratedColumn<String>(
      'sensory_taste', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storyId,
        name,
        description,
        sensorySight,
        sensorySound,
        sensorySmell,
        sensoryTouch,
        sensoryTaste
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations_table';
  @override
  VerificationContext validateIntegrity(Insertable<LocationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sensory_sight')) {
      context.handle(
          _sensorySightMeta,
          sensorySight.isAcceptableOrUnknown(
              data['sensory_sight']!, _sensorySightMeta));
    }
    if (data.containsKey('sensory_sound')) {
      context.handle(
          _sensorySoundMeta,
          sensorySound.isAcceptableOrUnknown(
              data['sensory_sound']!, _sensorySoundMeta));
    }
    if (data.containsKey('sensory_smell')) {
      context.handle(
          _sensorySmellMeta,
          sensorySmell.isAcceptableOrUnknown(
              data['sensory_smell']!, _sensorySmellMeta));
    }
    if (data.containsKey('sensory_touch')) {
      context.handle(
          _sensoryTouchMeta,
          sensoryTouch.isAcceptableOrUnknown(
              data['sensory_touch']!, _sensoryTouchMeta));
    }
    if (data.containsKey('sensory_taste')) {
      context.handle(
          _sensoryTasteMeta,
          sensoryTaste.isAcceptableOrUnknown(
              data['sensory_taste']!, _sensoryTasteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      sensorySight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sensory_sight']),
      sensorySound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sensory_sound']),
      sensorySmell: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sensory_smell']),
      sensoryTouch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sensory_touch']),
      sensoryTaste: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sensory_taste']),
    );
  }

  @override
  $LocationsTableTable createAlias(String alias) {
    return $LocationsTableTable(attachedDatabase, alias);
  }
}

class LocationsTableData extends DataClass
    implements Insertable<LocationsTableData> {
  final String id;
  final String storyId;
  final String name;
  final String description;
  final String? sensorySight;
  final String? sensorySound;
  final String? sensorySmell;
  final String? sensoryTouch;
  final String? sensoryTaste;
  const LocationsTableData(
      {required this.id,
      required this.storyId,
      required this.name,
      required this.description,
      this.sensorySight,
      this.sensorySound,
      this.sensorySmell,
      this.sensoryTouch,
      this.sensoryTaste});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || sensorySight != null) {
      map['sensory_sight'] = Variable<String>(sensorySight);
    }
    if (!nullToAbsent || sensorySound != null) {
      map['sensory_sound'] = Variable<String>(sensorySound);
    }
    if (!nullToAbsent || sensorySmell != null) {
      map['sensory_smell'] = Variable<String>(sensorySmell);
    }
    if (!nullToAbsent || sensoryTouch != null) {
      map['sensory_touch'] = Variable<String>(sensoryTouch);
    }
    if (!nullToAbsent || sensoryTaste != null) {
      map['sensory_taste'] = Variable<String>(sensoryTaste);
    }
    return map;
  }

  LocationsTableCompanion toCompanion(bool nullToAbsent) {
    return LocationsTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      name: Value(name),
      description: Value(description),
      sensorySight: sensorySight == null && nullToAbsent
          ? const Value.absent()
          : Value(sensorySight),
      sensorySound: sensorySound == null && nullToAbsent
          ? const Value.absent()
          : Value(sensorySound),
      sensorySmell: sensorySmell == null && nullToAbsent
          ? const Value.absent()
          : Value(sensorySmell),
      sensoryTouch: sensoryTouch == null && nullToAbsent
          ? const Value.absent()
          : Value(sensoryTouch),
      sensoryTaste: sensoryTaste == null && nullToAbsent
          ? const Value.absent()
          : Value(sensoryTaste),
    );
  }

  factory LocationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationsTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sensorySight: serializer.fromJson<String?>(json['sensorySight']),
      sensorySound: serializer.fromJson<String?>(json['sensorySound']),
      sensorySmell: serializer.fromJson<String?>(json['sensorySmell']),
      sensoryTouch: serializer.fromJson<String?>(json['sensoryTouch']),
      sensoryTaste: serializer.fromJson<String?>(json['sensoryTaste']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sensorySight': serializer.toJson<String?>(sensorySight),
      'sensorySound': serializer.toJson<String?>(sensorySound),
      'sensorySmell': serializer.toJson<String?>(sensorySmell),
      'sensoryTouch': serializer.toJson<String?>(sensoryTouch),
      'sensoryTaste': serializer.toJson<String?>(sensoryTaste),
    };
  }

  LocationsTableData copyWith(
          {String? id,
          String? storyId,
          String? name,
          String? description,
          Value<String?> sensorySight = const Value.absent(),
          Value<String?> sensorySound = const Value.absent(),
          Value<String?> sensorySmell = const Value.absent(),
          Value<String?> sensoryTouch = const Value.absent(),
          Value<String?> sensoryTaste = const Value.absent()}) =>
      LocationsTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        name: name ?? this.name,
        description: description ?? this.description,
        sensorySight:
            sensorySight.present ? sensorySight.value : this.sensorySight,
        sensorySound:
            sensorySound.present ? sensorySound.value : this.sensorySound,
        sensorySmell:
            sensorySmell.present ? sensorySmell.value : this.sensorySmell,
        sensoryTouch:
            sensoryTouch.present ? sensoryTouch.value : this.sensoryTouch,
        sensoryTaste:
            sensoryTaste.present ? sensoryTaste.value : this.sensoryTaste,
      );
  LocationsTableData copyWithCompanion(LocationsTableCompanion data) {
    return LocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      sensorySight: data.sensorySight.present
          ? data.sensorySight.value
          : this.sensorySight,
      sensorySound: data.sensorySound.present
          ? data.sensorySound.value
          : this.sensorySound,
      sensorySmell: data.sensorySmell.present
          ? data.sensorySmell.value
          : this.sensorySmell,
      sensoryTouch: data.sensoryTouch.present
          ? data.sensoryTouch.value
          : this.sensoryTouch,
      sensoryTaste: data.sensoryTaste.present
          ? data.sensoryTaste.value
          : this.sensoryTaste,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationsTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sensorySight: $sensorySight, ')
          ..write('sensorySound: $sensorySound, ')
          ..write('sensorySmell: $sensorySmell, ')
          ..write('sensoryTouch: $sensoryTouch, ')
          ..write('sensoryTaste: $sensoryTaste')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, name, description, sensorySight,
      sensorySound, sensorySmell, sensoryTouch, sensoryTaste);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationsTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.name == this.name &&
          other.description == this.description &&
          other.sensorySight == this.sensorySight &&
          other.sensorySound == this.sensorySound &&
          other.sensorySmell == this.sensorySmell &&
          other.sensoryTouch == this.sensoryTouch &&
          other.sensoryTaste == this.sensoryTaste);
}

class LocationsTableCompanion extends UpdateCompanion<LocationsTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> sensorySight;
  final Value<String?> sensorySound;
  final Value<String?> sensorySmell;
  final Value<String?> sensoryTouch;
  final Value<String?> sensoryTaste;
  final Value<int> rowid;
  const LocationsTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sensorySight = const Value.absent(),
    this.sensorySound = const Value.absent(),
    this.sensorySmell = const Value.absent(),
    this.sensoryTouch = const Value.absent(),
    this.sensoryTaste = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsTableCompanion.insert({
    required String id,
    required String storyId,
    required String name,
    this.description = const Value.absent(),
    this.sensorySight = const Value.absent(),
    this.sensorySound = const Value.absent(),
    this.sensorySmell = const Value.absent(),
    this.sensoryTouch = const Value.absent(),
    this.sensoryTaste = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        name = Value(name);
  static Insertable<LocationsTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? sensorySight,
    Expression<String>? sensorySound,
    Expression<String>? sensorySmell,
    Expression<String>? sensoryTouch,
    Expression<String>? sensoryTaste,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sensorySight != null) 'sensory_sight': sensorySight,
      if (sensorySound != null) 'sensory_sound': sensorySound,
      if (sensorySmell != null) 'sensory_smell': sensorySmell,
      if (sensoryTouch != null) 'sensory_touch': sensoryTouch,
      if (sensoryTaste != null) 'sensory_taste': sensoryTaste,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? sensorySight,
      Value<String?>? sensorySound,
      Value<String?>? sensorySmell,
      Value<String?>? sensoryTouch,
      Value<String?>? sensoryTaste,
      Value<int>? rowid}) {
    return LocationsTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      name: name ?? this.name,
      description: description ?? this.description,
      sensorySight: sensorySight ?? this.sensorySight,
      sensorySound: sensorySound ?? this.sensorySound,
      sensorySmell: sensorySmell ?? this.sensorySmell,
      sensoryTouch: sensoryTouch ?? this.sensoryTouch,
      sensoryTaste: sensoryTaste ?? this.sensoryTaste,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sensorySight.present) {
      map['sensory_sight'] = Variable<String>(sensorySight.value);
    }
    if (sensorySound.present) {
      map['sensory_sound'] = Variable<String>(sensorySound.value);
    }
    if (sensorySmell.present) {
      map['sensory_smell'] = Variable<String>(sensorySmell.value);
    }
    if (sensoryTouch.present) {
      map['sensory_touch'] = Variable<String>(sensoryTouch.value);
    }
    if (sensoryTaste.present) {
      map['sensory_taste'] = Variable<String>(sensoryTaste.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sensorySight: $sensorySight, ')
          ..write('sensorySound: $sensorySound, ')
          ..write('sensorySmell: $sensorySmell, ')
          ..write('sensoryTouch: $sensoryTouch, ')
          ..write('sensoryTaste: $sensoryTaste, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlotEventsTableTable extends PlotEventsTable
    with TableInfo<$PlotEventsTableTable, PlotEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlotEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _characterIdsJsonMeta =
      const VerificationMeta('characterIdsJson');
  @override
  late final GeneratedColumn<String> characterIdsJson = GeneratedColumn<String>(
      'character_ids_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('idea'));
  static const VerificationMeta _plotThreadMeta =
      const VerificationMeta('plotThread');
  @override
  late final GeneratedColumn<String> plotThread = GeneratedColumn<String>(
      'plot_thread', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Main Plot'));
  static const VerificationMeta _emotionalValueMeta =
      const VerificationMeta('emotionalValue');
  @override
  late final GeneratedColumn<int> emotionalValue = GeneratedColumn<int>(
      'emotional_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storyId,
        title,
        description,
        order,
        chapterId,
        characterIdsJson,
        locationId,
        status,
        plotThread,
        emotionalValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plot_events_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlotEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    }
    if (data.containsKey('character_ids_json')) {
      context.handle(
          _characterIdsJsonMeta,
          characterIdsJson.isAcceptableOrUnknown(
              data['character_ids_json']!, _characterIdsJsonMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('plot_thread')) {
      context.handle(
          _plotThreadMeta,
          plotThread.isAcceptableOrUnknown(
              data['plot_thread']!, _plotThreadMeta));
    }
    if (data.containsKey('emotional_value')) {
      context.handle(
          _emotionalValueMeta,
          emotionalValue.isAcceptableOrUnknown(
              data['emotional_value']!, _emotionalValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlotEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlotEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id']),
      characterIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}character_ids_json'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      plotThread: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plot_thread'])!,
      emotionalValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}emotional_value'])!,
    );
  }

  @override
  $PlotEventsTableTable createAlias(String alias) {
    return $PlotEventsTableTable(attachedDatabase, alias);
  }
}

class PlotEventsTableData extends DataClass
    implements Insertable<PlotEventsTableData> {
  final String id;
  final String storyId;
  final String title;
  final String description;
  final int order;
  final String? chapterId;
  final String characterIdsJson;
  final String? locationId;
  final String status;
  final String plotThread;
  final int emotionalValue;
  const PlotEventsTableData(
      {required this.id,
      required this.storyId,
      required this.title,
      required this.description,
      required this.order,
      this.chapterId,
      required this.characterIdsJson,
      this.locationId,
      required this.status,
      required this.plotThread,
      required this.emotionalValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['character_ids_json'] = Variable<String>(characterIdsJson);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    map['status'] = Variable<String>(status);
    map['plot_thread'] = Variable<String>(plotThread);
    map['emotional_value'] = Variable<int>(emotionalValue);
    return map;
  }

  PlotEventsTableCompanion toCompanion(bool nullToAbsent) {
    return PlotEventsTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      title: Value(title),
      description: Value(description),
      order: Value(order),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      characterIdsJson: Value(characterIdsJson),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      status: Value(status),
      plotThread: Value(plotThread),
      emotionalValue: Value(emotionalValue),
    );
  }

  factory PlotEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlotEventsTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      characterIdsJson: serializer.fromJson<String>(json['characterIdsJson']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      status: serializer.fromJson<String>(json['status']),
      plotThread: serializer.fromJson<String>(json['plotThread']),
      emotionalValue: serializer.fromJson<int>(json['emotionalValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'order': serializer.toJson<int>(order),
      'chapterId': serializer.toJson<String?>(chapterId),
      'characterIdsJson': serializer.toJson<String>(characterIdsJson),
      'locationId': serializer.toJson<String?>(locationId),
      'status': serializer.toJson<String>(status),
      'plotThread': serializer.toJson<String>(plotThread),
      'emotionalValue': serializer.toJson<int>(emotionalValue),
    };
  }

  PlotEventsTableData copyWith(
          {String? id,
          String? storyId,
          String? title,
          String? description,
          int? order,
          Value<String?> chapterId = const Value.absent(),
          String? characterIdsJson,
          Value<String?> locationId = const Value.absent(),
          String? status,
          String? plotThread,
          int? emotionalValue}) =>
      PlotEventsTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        title: title ?? this.title,
        description: description ?? this.description,
        order: order ?? this.order,
        chapterId: chapterId.present ? chapterId.value : this.chapterId,
        characterIdsJson: characterIdsJson ?? this.characterIdsJson,
        locationId: locationId.present ? locationId.value : this.locationId,
        status: status ?? this.status,
        plotThread: plotThread ?? this.plotThread,
        emotionalValue: emotionalValue ?? this.emotionalValue,
      );
  PlotEventsTableData copyWithCompanion(PlotEventsTableCompanion data) {
    return PlotEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      order: data.order.present ? data.order.value : this.order,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      characterIdsJson: data.characterIdsJson.present
          ? data.characterIdsJson.value
          : this.characterIdsJson,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      status: data.status.present ? data.status.value : this.status,
      plotThread:
          data.plotThread.present ? data.plotThread.value : this.plotThread,
      emotionalValue: data.emotionalValue.present
          ? data.emotionalValue.value
          : this.emotionalValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlotEventsTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('chapterId: $chapterId, ')
          ..write('characterIdsJson: $characterIdsJson, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('plotThread: $plotThread, ')
          ..write('emotionalValue: $emotionalValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      storyId,
      title,
      description,
      order,
      chapterId,
      characterIdsJson,
      locationId,
      status,
      plotThread,
      emotionalValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlotEventsTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.chapterId == this.chapterId &&
          other.characterIdsJson == this.characterIdsJson &&
          other.locationId == this.locationId &&
          other.status == this.status &&
          other.plotThread == this.plotThread &&
          other.emotionalValue == this.emotionalValue);
}

class PlotEventsTableCompanion extends UpdateCompanion<PlotEventsTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> title;
  final Value<String> description;
  final Value<int> order;
  final Value<String?> chapterId;
  final Value<String> characterIdsJson;
  final Value<String?> locationId;
  final Value<String> status;
  final Value<String> plotThread;
  final Value<int> emotionalValue;
  final Value<int> rowid;
  const PlotEventsTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.characterIdsJson = const Value.absent(),
    this.locationId = const Value.absent(),
    this.status = const Value.absent(),
    this.plotThread = const Value.absent(),
    this.emotionalValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlotEventsTableCompanion.insert({
    required String id,
    required String storyId,
    required String title,
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.characterIdsJson = const Value.absent(),
    this.locationId = const Value.absent(),
    this.status = const Value.absent(),
    this.plotThread = const Value.absent(),
    this.emotionalValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        title = Value(title);
  static Insertable<PlotEventsTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<String>? chapterId,
    Expression<String>? characterIdsJson,
    Expression<String>? locationId,
    Expression<String>? status,
    Expression<String>? plotThread,
    Expression<int>? emotionalValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (chapterId != null) 'chapter_id': chapterId,
      if (characterIdsJson != null) 'character_ids_json': characterIdsJson,
      if (locationId != null) 'location_id': locationId,
      if (status != null) 'status': status,
      if (plotThread != null) 'plot_thread': plotThread,
      if (emotionalValue != null) 'emotional_value': emotionalValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlotEventsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? title,
      Value<String>? description,
      Value<int>? order,
      Value<String?>? chapterId,
      Value<String>? characterIdsJson,
      Value<String?>? locationId,
      Value<String>? status,
      Value<String>? plotThread,
      Value<int>? emotionalValue,
      Value<int>? rowid}) {
    return PlotEventsTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      chapterId: chapterId ?? this.chapterId,
      characterIdsJson: characterIdsJson ?? this.characterIdsJson,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      plotThread: plotThread ?? this.plotThread,
      emotionalValue: emotionalValue ?? this.emotionalValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (characterIdsJson.present) {
      map['character_ids_json'] = Variable<String>(characterIdsJson.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (plotThread.present) {
      map['plot_thread'] = Variable<String>(plotThread.value);
    }
    if (emotionalValue.present) {
      map['emotional_value'] = Variable<int>(emotionalValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlotEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('chapterId: $chapterId, ')
          ..write('characterIdsJson: $characterIdsJson, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('plotThread: $plotThread, ')
          ..write('emotionalValue: $emotionalValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTableTable extends ChaptersTable
    with TableInfo<$ChaptersTableTable, ChaptersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('planned'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, storyId, title, content, order, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChaptersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChaptersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ChaptersTableTable createAlias(String alias) {
    return $ChaptersTableTable(attachedDatabase, alias);
  }
}

class ChaptersTableData extends DataClass
    implements Insertable<ChaptersTableData> {
  final String id;
  final String storyId;
  final String title;
  final String content;
  final int order;
  final String status;
  const ChaptersTableData(
      {required this.id,
      required this.storyId,
      required this.title,
      required this.content,
      required this.order,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['order'] = Variable<int>(order);
    map['status'] = Variable<String>(status);
    return map;
  }

  ChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ChaptersTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      title: Value(title),
      content: Value(content),
      order: Value(order),
      status: Value(status),
    );
  }

  factory ChaptersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChaptersTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      order: serializer.fromJson<int>(json['order']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'order': serializer.toJson<int>(order),
      'status': serializer.toJson<String>(status),
    };
  }

  ChaptersTableData copyWith(
          {String? id,
          String? storyId,
          String? title,
          String? content,
          int? order,
          String? status}) =>
      ChaptersTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        title: title ?? this.title,
        content: content ?? this.content,
        order: order ?? this.order,
        status: status ?? this.status,
      );
  ChaptersTableData copyWithCompanion(ChaptersTableCompanion data) {
    return ChaptersTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      order: data.order.present ? data.order.value : this.order,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('order: $order, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, title, content, order, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChaptersTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.title == this.title &&
          other.content == this.content &&
          other.order == this.order &&
          other.status == this.status);
}

class ChaptersTableCompanion extends UpdateCompanion<ChaptersTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> title;
  final Value<String> content;
  final Value<int> order;
  final Value<String> status;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.order = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String storyId,
    required String title,
    this.content = const Value.absent(),
    this.order = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        title = Value(title);
  static Insertable<ChaptersTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? order,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (order != null) 'order': order,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? title,
      Value<String>? content,
      Value<int>? order,
      Value<String>? status,
      Value<int>? rowid}) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('order: $order, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, storyId, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(Insertable<NotesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final String id;
  final String storyId;
  final String content;
  final DateTime createdAt;
  const NotesTableData(
      {required this.id,
      required this.storyId,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory NotesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotesTableData copyWith(
          {String? id,
          String? storyId,
          String? content,
          DateTime? createdAt}) =>
      NotesTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    required String storyId,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<NotesTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return NotesTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      content: content ?? this.content,
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
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTableTable extends QuestionsTable
    with TableInfo<$QuestionsTableTable, QuestionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isResolvedMeta =
      const VerificationMeta('isResolved');
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
      'is_resolved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_resolved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, storyId, question, details, isResolved, answer, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions_table';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
          _isResolvedMeta,
          isResolved.isAcceptableOrUnknown(
              data['is_resolved']!, _isResolvedMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      isResolved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_resolved'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $QuestionsTableTable createAlias(String alias) {
    return $QuestionsTableTable(attachedDatabase, alias);
  }
}

class QuestionsTableData extends DataClass
    implements Insertable<QuestionsTableData> {
  final String id;
  final String storyId;
  final String question;
  final String details;
  final bool isResolved;
  final String? answer;
  final DateTime createdAt;
  const QuestionsTableData(
      {required this.id,
      required this.storyId,
      required this.question,
      required this.details,
      required this.isResolved,
      this.answer,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['question'] = Variable<String>(question);
    map['details'] = Variable<String>(details);
    map['is_resolved'] = Variable<bool>(isResolved);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuestionsTableCompanion toCompanion(bool nullToAbsent) {
    return QuestionsTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      question: Value(question),
      details: Value(details),
      isResolved: Value(isResolved),
      answer:
          answer == null && nullToAbsent ? const Value.absent() : Value(answer),
      createdAt: Value(createdAt),
    );
  }

  factory QuestionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionsTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      question: serializer.fromJson<String>(json['question']),
      details: serializer.fromJson<String>(json['details']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
      answer: serializer.fromJson<String?>(json['answer']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'question': serializer.toJson<String>(question),
      'details': serializer.toJson<String>(details),
      'isResolved': serializer.toJson<bool>(isResolved),
      'answer': serializer.toJson<String?>(answer),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuestionsTableData copyWith(
          {String? id,
          String? storyId,
          String? question,
          String? details,
          bool? isResolved,
          Value<String?> answer = const Value.absent(),
          DateTime? createdAt}) =>
      QuestionsTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        question: question ?? this.question,
        details: details ?? this.details,
        isResolved: isResolved ?? this.isResolved,
        answer: answer.present ? answer.value : this.answer,
        createdAt: createdAt ?? this.createdAt,
      );
  QuestionsTableData copyWithCompanion(QuestionsTableCompanion data) {
    return QuestionsTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      question: data.question.present ? data.question.value : this.question,
      details: data.details.present ? data.details.value : this.details,
      isResolved:
          data.isResolved.present ? data.isResolved.value : this.isResolved,
      answer: data.answer.present ? data.answer.value : this.answer,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('question: $question, ')
          ..write('details: $details, ')
          ..write('isResolved: $isResolved, ')
          ..write('answer: $answer, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, storyId, question, details, isResolved, answer, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionsTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.question == this.question &&
          other.details == this.details &&
          other.isResolved == this.isResolved &&
          other.answer == this.answer &&
          other.createdAt == this.createdAt);
}

class QuestionsTableCompanion extends UpdateCompanion<QuestionsTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> question;
  final Value<String> details;
  final Value<bool> isResolved;
  final Value<String?> answer;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const QuestionsTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.question = const Value.absent(),
    this.details = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.answer = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsTableCompanion.insert({
    required String id,
    required String storyId,
    required String question,
    this.details = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.answer = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        question = Value(question),
        createdAt = Value(createdAt);
  static Insertable<QuestionsTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? question,
    Expression<String>? details,
    Expression<bool>? isResolved,
    Expression<String>? answer,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (question != null) 'question': question,
      if (details != null) 'details': details,
      if (isResolved != null) 'is_resolved': isResolved,
      if (answer != null) 'answer': answer,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? question,
      Value<String>? details,
      Value<bool>? isResolved,
      Value<String?>? answer,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return QuestionsTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      question: question ?? this.question,
      details: details ?? this.details,
      isResolved: isResolved ?? this.isResolved,
      answer: answer ?? this.answer,
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
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
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
    return (StringBuffer('QuestionsTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('question: $question, ')
          ..write('details: $details, ')
          ..write('isResolved: $isResolved, ')
          ..write('answer: $answer, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationshipsTableTable extends RelationshipsTable
    with TableInfo<$RelationshipsTableTable, RelationshipsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stories_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetIdMeta =
      const VerificationMeta('targetId');
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
      'target_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, storyId, sourceId, targetId, type, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationships_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RelationshipsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(_targetIdMeta,
          targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta));
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationshipsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationshipsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      targetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $RelationshipsTableTable createAlias(String alias) {
    return $RelationshipsTableTable(attachedDatabase, alias);
  }
}

class RelationshipsTableData extends DataClass
    implements Insertable<RelationshipsTableData> {
  final String id;
  final String storyId;
  final String sourceId;
  final String targetId;
  final String type;
  final String description;
  const RelationshipsTableData(
      {required this.id,
      required this.storyId,
      required this.sourceId,
      required this.targetId,
      required this.type,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['source_id'] = Variable<String>(sourceId);
    map['target_id'] = Variable<String>(targetId);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    return map;
  }

  RelationshipsTableCompanion toCompanion(bool nullToAbsent) {
    return RelationshipsTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      sourceId: Value(sourceId),
      targetId: Value(targetId),
      type: Value(type),
      description: Value(description),
    );
  }

  factory RelationshipsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationshipsTableData(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'sourceId': serializer.toJson<String>(sourceId),
      'targetId': serializer.toJson<String>(targetId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
    };
  }

  RelationshipsTableData copyWith(
          {String? id,
          String? storyId,
          String? sourceId,
          String? targetId,
          String? type,
          String? description}) =>
      RelationshipsTableData(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        sourceId: sourceId ?? this.sourceId,
        targetId: targetId ?? this.targetId,
        type: type ?? this.type,
        description: description ?? this.description,
      );
  RelationshipsTableData copyWithCompanion(RelationshipsTableCompanion data) {
    return RelationshipsTableData(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsTableData(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storyId, sourceId, targetId, type, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationshipsTableData &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.sourceId == this.sourceId &&
          other.targetId == this.targetId &&
          other.type == this.type &&
          other.description == this.description);
}

class RelationshipsTableCompanion
    extends UpdateCompanion<RelationshipsTableData> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> sourceId;
  final Value<String> targetId;
  final Value<String> type;
  final Value<String> description;
  final Value<int> rowid;
  const RelationshipsTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationshipsTableCompanion.insert({
    required String id,
    required String storyId,
    required String sourceId,
    required String targetId,
    required String type,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        sourceId = Value(sourceId),
        targetId = Value(targetId),
        type = Value(type);
  static Insertable<RelationshipsTableData> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? sourceId,
    Expression<String>? targetId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (sourceId != null) 'source_id': sourceId,
      if (targetId != null) 'target_id': targetId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationshipsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? sourceId,
      Value<String>? targetId,
      Value<String>? type,
      Value<String>? description,
      Value<int>? rowid}) {
    return RelationshipsTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StoriesTableTable storiesTable = $StoriesTableTable(this);
  late final $CharactersTableTable charactersTable =
      $CharactersTableTable(this);
  late final $LocationsTableTable locationsTable = $LocationsTableTable(this);
  late final $PlotEventsTableTable plotEventsTable =
      $PlotEventsTableTable(this);
  late final $ChaptersTableTable chaptersTable = $ChaptersTableTable(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $QuestionsTableTable questionsTable = $QuestionsTableTable(this);
  late final $RelationshipsTableTable relationshipsTable =
      $RelationshipsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        storiesTable,
        charactersTable,
        locationsTable,
        plotEventsTable,
        chaptersTable,
        notesTable,
        questionsTable,
        relationshipsTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('characters_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('locations_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plot_events_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chapters_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('notes_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('questions_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stories_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('relationships_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$StoriesTableTableCreateCompanionBuilder = StoriesTableCompanion
    Function({
  required String id,
  required String title,
  Value<String> summary,
  Value<String> theme,
  Value<String> coreQuestion,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StoriesTableTableUpdateCompanionBuilder = StoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> summary,
  Value<String> theme,
  Value<String> coreQuestion,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$StoriesTableTableReferences extends BaseReferences<_$AppDatabase,
    $StoriesTableTable, StoriesTableData> {
  $$StoriesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharactersTableTable, List<CharactersTableData>>
      _charactersTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.charactersTable,
              aliasName: $_aliasNameGenerator(
                  db.storiesTable.id, db.charactersTable.storyId));

  $$CharactersTableTableProcessedTableManager get charactersTableRefs {
    final manager =
        $$CharactersTableTableTableManager($_db, $_db.charactersTable)
            .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_charactersTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LocationsTableTable, List<LocationsTableData>>
      _locationsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.locationsTable,
              aliasName: $_aliasNameGenerator(
                  db.storiesTable.id, db.locationsTable.storyId));

  $$LocationsTableTableProcessedTableManager get locationsTableRefs {
    final manager = $$LocationsTableTableTableManager($_db, $_db.locationsTable)
        .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_locationsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlotEventsTableTable, List<PlotEventsTableData>>
      _plotEventsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.plotEventsTable,
              aliasName: $_aliasNameGenerator(
                  db.storiesTable.id, db.plotEventsTable.storyId));

  $$PlotEventsTableTableProcessedTableManager get plotEventsTableRefs {
    final manager =
        $$PlotEventsTableTableTableManager($_db, $_db.plotEventsTable)
            .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_plotEventsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ChaptersTableTable, List<ChaptersTableData>>
      _chaptersTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chaptersTable,
              aliasName: $_aliasNameGenerator(
                  db.storiesTable.id, db.chaptersTable.storyId));

  $$ChaptersTableTableProcessedTableManager get chaptersTableRefs {
    final manager = $$ChaptersTableTableTableManager($_db, $_db.chaptersTable)
        .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotesTableTable, List<NotesTableData>>
      _notesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.notesTable,
          aliasName:
              $_aliasNameGenerator(db.storiesTable.id, db.notesTable.storyId));

  $$NotesTableTableProcessedTableManager get notesTableRefs {
    final manager = $$NotesTableTableTableManager($_db, $_db.notesTable)
        .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$QuestionsTableTable, List<QuestionsTableData>>
      _questionsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.questionsTable,
              aliasName: $_aliasNameGenerator(
                  db.storiesTable.id, db.questionsTable.storyId));

  $$QuestionsTableTableProcessedTableManager get questionsTableRefs {
    final manager = $$QuestionsTableTableTableManager($_db, $_db.questionsTable)
        .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RelationshipsTableTable,
      List<RelationshipsTableData>> _relationshipsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.relationshipsTable,
          aliasName: $_aliasNameGenerator(
              db.storiesTable.id, db.relationshipsTable.storyId));

  $$RelationshipsTableTableProcessedTableManager get relationshipsTableRefs {
    final manager =
        $$RelationshipsTableTableTableManager($_db, $_db.relationshipsTable)
            .filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_relationshipsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $StoriesTableTable> {
  $$StoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coreQuestion => $composableBuilder(
      column: $table.coreQuestion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> charactersTableRefs(
      Expression<bool> Function($$CharactersTableTableFilterComposer f) f) {
    final $$CharactersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.charactersTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableTableFilterComposer(
              $db: $db,
              $table: $db.charactersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> locationsTableRefs(
      Expression<bool> Function($$LocationsTableTableFilterComposer f) f) {
    final $$LocationsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableFilterComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> plotEventsTableRefs(
      Expression<bool> Function($$PlotEventsTableTableFilterComposer f) f) {
    final $$PlotEventsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotEventsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotEventsTableTableFilterComposer(
              $db: $db,
              $table: $db.plotEventsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> chaptersTableRefs(
      Expression<bool> Function($$ChaptersTableTableFilterComposer f) f) {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chaptersTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableTableFilterComposer(
              $db: $db,
              $table: $db.chaptersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notesTableRefs(
      Expression<bool> Function($$NotesTableTableFilterComposer f) f) {
    final $$NotesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notesTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableTableFilterComposer(
              $db: $db,
              $table: $db.notesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> questionsTableRefs(
      Expression<bool> Function($$QuestionsTableTableFilterComposer f) f) {
    final $$QuestionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.questionsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionsTableTableFilterComposer(
              $db: $db,
              $table: $db.questionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> relationshipsTableRefs(
      Expression<bool> Function($$RelationshipsTableTableFilterComposer f) f) {
    final $$RelationshipsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationshipsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableTableFilterComposer(
              $db: $db,
              $table: $db.relationshipsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StoriesTableTable> {
  $$StoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coreQuestion => $composableBuilder(
      column: $table.coreQuestion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoriesTableTable> {
  $$StoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get coreQuestion => $composableBuilder(
      column: $table.coreQuestion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> charactersTableRefs<T extends Object>(
      Expression<T> Function($$CharactersTableTableAnnotationComposer a) f) {
    final $$CharactersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.charactersTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.charactersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> locationsTableRefs<T extends Object>(
      Expression<T> Function($$LocationsTableTableAnnotationComposer a) f) {
    final $$LocationsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> plotEventsTableRefs<T extends Object>(
      Expression<T> Function($$PlotEventsTableTableAnnotationComposer a) f) {
    final $$PlotEventsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotEventsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotEventsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.plotEventsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> chaptersTableRefs<T extends Object>(
      Expression<T> Function($$ChaptersTableTableAnnotationComposer a) f) {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chaptersTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.chaptersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notesTableRefs<T extends Object>(
      Expression<T> Function($$NotesTableTableAnnotationComposer a) f) {
    final $$NotesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notesTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.notesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> questionsTableRefs<T extends Object>(
      Expression<T> Function($$QuestionsTableTableAnnotationComposer a) f) {
    final $$QuestionsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.questionsTable,
        getReferencedColumn: (t) => t.storyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.questionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> relationshipsTableRefs<T extends Object>(
      Expression<T> Function($$RelationshipsTableTableAnnotationComposer a) f) {
    final $$RelationshipsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.relationshipsTable,
            getReferencedColumn: (t) => t.storyId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RelationshipsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.relationshipsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$StoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StoriesTableTable,
    StoriesTableData,
    $$StoriesTableTableFilterComposer,
    $$StoriesTableTableOrderingComposer,
    $$StoriesTableTableAnnotationComposer,
    $$StoriesTableTableCreateCompanionBuilder,
    $$StoriesTableTableUpdateCompanionBuilder,
    (StoriesTableData, $$StoriesTableTableReferences),
    StoriesTableData,
    PrefetchHooks Function(
        {bool charactersTableRefs,
        bool locationsTableRefs,
        bool plotEventsTableRefs,
        bool chaptersTableRefs,
        bool notesTableRefs,
        bool questionsTableRefs,
        bool relationshipsTableRefs})> {
  $$StoriesTableTableTableManager(_$AppDatabase db, $StoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<String> coreQuestion = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesTableCompanion(
            id: id,
            title: title,
            summary: summary,
            theme: theme,
            coreQuestion: coreQuestion,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> summary = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<String> coreQuestion = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesTableCompanion.insert(
            id: id,
            title: title,
            summary: summary,
            theme: theme,
            coreQuestion: coreQuestion,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StoriesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {charactersTableRefs = false,
              locationsTableRefs = false,
              plotEventsTableRefs = false,
              chaptersTableRefs = false,
              notesTableRefs = false,
              questionsTableRefs = false,
              relationshipsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (charactersTableRefs) db.charactersTable,
                if (locationsTableRefs) db.locationsTable,
                if (plotEventsTableRefs) db.plotEventsTable,
                if (chaptersTableRefs) db.chaptersTable,
                if (notesTableRefs) db.notesTable,
                if (questionsTableRefs) db.questionsTable,
                if (relationshipsTableRefs) db.relationshipsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (charactersTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, CharactersTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._charactersTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .charactersTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (locationsTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, LocationsTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._locationsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .locationsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (plotEventsTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, PlotEventsTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._plotEventsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .plotEventsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (chaptersTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, ChaptersTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._chaptersTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .chaptersTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (notesTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, NotesTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._notesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .notesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (questionsTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, QuestionsTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._questionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .questionsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items),
                  if (relationshipsTableRefs)
                    await $_getPrefetchedData<StoriesTableData,
                            $StoriesTableTable, RelationshipsTableData>(
                        currentTable: table,
                        referencedTable: $$StoriesTableTableReferences
                            ._relationshipsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StoriesTableTableReferences(db, table, p0)
                                .relationshipsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.storyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StoriesTableTable,
    StoriesTableData,
    $$StoriesTableTableFilterComposer,
    $$StoriesTableTableOrderingComposer,
    $$StoriesTableTableAnnotationComposer,
    $$StoriesTableTableCreateCompanionBuilder,
    $$StoriesTableTableUpdateCompanionBuilder,
    (StoriesTableData, $$StoriesTableTableReferences),
    StoriesTableData,
    PrefetchHooks Function(
        {bool charactersTableRefs,
        bool locationsTableRefs,
        bool plotEventsTableRefs,
        bool chaptersTableRefs,
        bool notesTableRefs,
        bool questionsTableRefs,
        bool relationshipsTableRefs})>;
typedef $$CharactersTableTableCreateCompanionBuilder = CharactersTableCompanion
    Function({
  required String id,
  required String storyId,
  required String name,
  Value<String> role,
  Value<String> description,
  Value<String> traitsJson,
  Value<String?> arcLie,
  Value<String?> arcTruth,
  Value<String?> arcGhost,
  Value<String?> avatarUrl,
  Value<int> rowid,
});
typedef $$CharactersTableTableUpdateCompanionBuilder = CharactersTableCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> name,
  Value<String> role,
  Value<String> description,
  Value<String> traitsJson,
  Value<String?> arcLie,
  Value<String?> arcTruth,
  Value<String?> arcGhost,
  Value<String?> avatarUrl,
  Value<int> rowid,
});

final class $$CharactersTableTableReferences extends BaseReferences<
    _$AppDatabase, $CharactersTableTable, CharactersTableData> {
  $$CharactersTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.charactersTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CharactersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get traitsJson => $composableBuilder(
      column: $table.traitsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arcLie => $composableBuilder(
      column: $table.arcLie, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arcTruth => $composableBuilder(
      column: $table.arcTruth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arcGhost => $composableBuilder(
      column: $table.arcGhost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CharactersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get traitsJson => $composableBuilder(
      column: $table.traitsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arcLie => $composableBuilder(
      column: $table.arcLie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arcTruth => $composableBuilder(
      column: $table.arcTruth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arcGhost => $composableBuilder(
      column: $table.arcGhost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CharactersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableAnnotationComposer({
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

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get traitsJson => $composableBuilder(
      column: $table.traitsJson, builder: (column) => column);

  GeneratedColumn<String> get arcLie =>
      $composableBuilder(column: $table.arcLie, builder: (column) => column);

  GeneratedColumn<String> get arcTruth =>
      $composableBuilder(column: $table.arcTruth, builder: (column) => column);

  GeneratedColumn<String> get arcGhost =>
      $composableBuilder(column: $table.arcGhost, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CharactersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharactersTableTable,
    CharactersTableData,
    $$CharactersTableTableFilterComposer,
    $$CharactersTableTableOrderingComposer,
    $$CharactersTableTableAnnotationComposer,
    $$CharactersTableTableCreateCompanionBuilder,
    $$CharactersTableTableUpdateCompanionBuilder,
    (CharactersTableData, $$CharactersTableTableReferences),
    CharactersTableData,
    PrefetchHooks Function({bool storyId})> {
  $$CharactersTableTableTableManager(
      _$AppDatabase db, $CharactersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> traitsJson = const Value.absent(),
            Value<String?> arcLie = const Value.absent(),
            Value<String?> arcTruth = const Value.absent(),
            Value<String?> arcGhost = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CharactersTableCompanion(
            id: id,
            storyId: storyId,
            name: name,
            role: role,
            description: description,
            traitsJson: traitsJson,
            arcLie: arcLie,
            arcTruth: arcTruth,
            arcGhost: arcGhost,
            avatarUrl: avatarUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String name,
            Value<String> role = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> traitsJson = const Value.absent(),
            Value<String?> arcLie = const Value.absent(),
            Value<String?> arcTruth = const Value.absent(),
            Value<String?> arcGhost = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CharactersTableCompanion.insert(
            id: id,
            storyId: storyId,
            name: name,
            role: role,
            description: description,
            traitsJson: traitsJson,
            arcLie: arcLie,
            arcTruth: arcTruth,
            arcGhost: arcGhost,
            avatarUrl: avatarUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CharactersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$CharactersTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$CharactersTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CharactersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharactersTableTable,
    CharactersTableData,
    $$CharactersTableTableFilterComposer,
    $$CharactersTableTableOrderingComposer,
    $$CharactersTableTableAnnotationComposer,
    $$CharactersTableTableCreateCompanionBuilder,
    $$CharactersTableTableUpdateCompanionBuilder,
    (CharactersTableData, $$CharactersTableTableReferences),
    CharactersTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$LocationsTableTableCreateCompanionBuilder = LocationsTableCompanion
    Function({
  required String id,
  required String storyId,
  required String name,
  Value<String> description,
  Value<String?> sensorySight,
  Value<String?> sensorySound,
  Value<String?> sensorySmell,
  Value<String?> sensoryTouch,
  Value<String?> sensoryTaste,
  Value<int> rowid,
});
typedef $$LocationsTableTableUpdateCompanionBuilder = LocationsTableCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> name,
  Value<String> description,
  Value<String?> sensorySight,
  Value<String?> sensorySound,
  Value<String?> sensorySmell,
  Value<String?> sensoryTouch,
  Value<String?> sensoryTaste,
  Value<int> rowid,
});

final class $$LocationsTableTableReferences extends BaseReferences<
    _$AppDatabase, $LocationsTableTable, LocationsTableData> {
  $$LocationsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.locationsTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sensorySight => $composableBuilder(
      column: $table.sensorySight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sensorySound => $composableBuilder(
      column: $table.sensorySound, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sensorySmell => $composableBuilder(
      column: $table.sensorySmell, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sensoryTouch => $composableBuilder(
      column: $table.sensoryTouch, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sensoryTaste => $composableBuilder(
      column: $table.sensoryTaste, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sensorySight => $composableBuilder(
      column: $table.sensorySight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sensorySound => $composableBuilder(
      column: $table.sensorySound,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sensorySmell => $composableBuilder(
      column: $table.sensorySmell,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sensoryTouch => $composableBuilder(
      column: $table.sensoryTouch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sensoryTaste => $composableBuilder(
      column: $table.sensoryTaste,
      builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get sensorySight => $composableBuilder(
      column: $table.sensorySight, builder: (column) => column);

  GeneratedColumn<String> get sensorySound => $composableBuilder(
      column: $table.sensorySound, builder: (column) => column);

  GeneratedColumn<String> get sensorySmell => $composableBuilder(
      column: $table.sensorySmell, builder: (column) => column);

  GeneratedColumn<String> get sensoryTouch => $composableBuilder(
      column: $table.sensoryTouch, builder: (column) => column);

  GeneratedColumn<String> get sensoryTaste => $composableBuilder(
      column: $table.sensoryTaste, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LocationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocationsTableTable,
    LocationsTableData,
    $$LocationsTableTableFilterComposer,
    $$LocationsTableTableOrderingComposer,
    $$LocationsTableTableAnnotationComposer,
    $$LocationsTableTableCreateCompanionBuilder,
    $$LocationsTableTableUpdateCompanionBuilder,
    (LocationsTableData, $$LocationsTableTableReferences),
    LocationsTableData,
    PrefetchHooks Function({bool storyId})> {
  $$LocationsTableTableTableManager(
      _$AppDatabase db, $LocationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> sensorySight = const Value.absent(),
            Value<String?> sensorySound = const Value.absent(),
            Value<String?> sensorySmell = const Value.absent(),
            Value<String?> sensoryTouch = const Value.absent(),
            Value<String?> sensoryTaste = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsTableCompanion(
            id: id,
            storyId: storyId,
            name: name,
            description: description,
            sensorySight: sensorySight,
            sensorySound: sensorySound,
            sensorySmell: sensorySmell,
            sensoryTouch: sensoryTouch,
            sensoryTaste: sensoryTaste,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String name,
            Value<String> description = const Value.absent(),
            Value<String?> sensorySight = const Value.absent(),
            Value<String?> sensorySound = const Value.absent(),
            Value<String?> sensorySmell = const Value.absent(),
            Value<String?> sensoryTouch = const Value.absent(),
            Value<String?> sensoryTaste = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsTableCompanion.insert(
            id: id,
            storyId: storyId,
            name: name,
            description: description,
            sensorySight: sensorySight,
            sensorySound: sensorySound,
            sensorySmell: sensorySmell,
            sensoryTouch: sensoryTouch,
            sensoryTaste: sensoryTaste,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LocationsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$LocationsTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$LocationsTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LocationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocationsTableTable,
    LocationsTableData,
    $$LocationsTableTableFilterComposer,
    $$LocationsTableTableOrderingComposer,
    $$LocationsTableTableAnnotationComposer,
    $$LocationsTableTableCreateCompanionBuilder,
    $$LocationsTableTableUpdateCompanionBuilder,
    (LocationsTableData, $$LocationsTableTableReferences),
    LocationsTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$PlotEventsTableTableCreateCompanionBuilder = PlotEventsTableCompanion
    Function({
  required String id,
  required String storyId,
  required String title,
  Value<String> description,
  Value<int> order,
  Value<String?> chapterId,
  Value<String> characterIdsJson,
  Value<String?> locationId,
  Value<String> status,
  Value<String> plotThread,
  Value<int> emotionalValue,
  Value<int> rowid,
});
typedef $$PlotEventsTableTableUpdateCompanionBuilder = PlotEventsTableCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> title,
  Value<String> description,
  Value<int> order,
  Value<String?> chapterId,
  Value<String> characterIdsJson,
  Value<String?> locationId,
  Value<String> status,
  Value<String> plotThread,
  Value<int> emotionalValue,
  Value<int> rowid,
});

final class $$PlotEventsTableTableReferences extends BaseReferences<
    _$AppDatabase, $PlotEventsTableTable, PlotEventsTableData> {
  $$PlotEventsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.plotEventsTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlotEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlotEventsTableTable> {
  $$PlotEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterIdsJson => $composableBuilder(
      column: $table.characterIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plotThread => $composableBuilder(
      column: $table.plotThread, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get emotionalValue => $composableBuilder(
      column: $table.emotionalValue,
      builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlotEventsTableTable> {
  $$PlotEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterIdsJson => $composableBuilder(
      column: $table.characterIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plotThread => $composableBuilder(
      column: $table.plotThread, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get emotionalValue => $composableBuilder(
      column: $table.emotionalValue,
      builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlotEventsTableTable> {
  $$PlotEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get characterIdsJson => $composableBuilder(
      column: $table.characterIdsJson, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get plotThread => $composableBuilder(
      column: $table.plotThread, builder: (column) => column);

  GeneratedColumn<int> get emotionalValue => $composableBuilder(
      column: $table.emotionalValue, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlotEventsTableTable,
    PlotEventsTableData,
    $$PlotEventsTableTableFilterComposer,
    $$PlotEventsTableTableOrderingComposer,
    $$PlotEventsTableTableAnnotationComposer,
    $$PlotEventsTableTableCreateCompanionBuilder,
    $$PlotEventsTableTableUpdateCompanionBuilder,
    (PlotEventsTableData, $$PlotEventsTableTableReferences),
    PlotEventsTableData,
    PrefetchHooks Function({bool storyId})> {
  $$PlotEventsTableTableTableManager(
      _$AppDatabase db, $PlotEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlotEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlotEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlotEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<String> characterIdsJson = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> plotThread = const Value.absent(),
            Value<int> emotionalValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotEventsTableCompanion(
            id: id,
            storyId: storyId,
            title: title,
            description: description,
            order: order,
            chapterId: chapterId,
            characterIdsJson: characterIdsJson,
            locationId: locationId,
            status: status,
            plotThread: plotThread,
            emotionalValue: emotionalValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String title,
            Value<String> description = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<String> characterIdsJson = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> plotThread = const Value.absent(),
            Value<int> emotionalValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotEventsTableCompanion.insert(
            id: id,
            storyId: storyId,
            title: title,
            description: description,
            order: order,
            chapterId: chapterId,
            characterIdsJson: characterIdsJson,
            locationId: locationId,
            status: status,
            plotThread: plotThread,
            emotionalValue: emotionalValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlotEventsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$PlotEventsTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$PlotEventsTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlotEventsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlotEventsTableTable,
    PlotEventsTableData,
    $$PlotEventsTableTableFilterComposer,
    $$PlotEventsTableTableOrderingComposer,
    $$PlotEventsTableTableAnnotationComposer,
    $$PlotEventsTableTableCreateCompanionBuilder,
    $$PlotEventsTableTableUpdateCompanionBuilder,
    (PlotEventsTableData, $$PlotEventsTableTableReferences),
    PlotEventsTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$ChaptersTableTableCreateCompanionBuilder = ChaptersTableCompanion
    Function({
  required String id,
  required String storyId,
  required String title,
  Value<String> content,
  Value<int> order,
  Value<String> status,
  Value<int> rowid,
});
typedef $$ChaptersTableTableUpdateCompanionBuilder = ChaptersTableCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> title,
  Value<String> content,
  Value<int> order,
  Value<String> status,
  Value<int> rowid,
});

final class $$ChaptersTableTableReferences extends BaseReferences<_$AppDatabase,
    $ChaptersTableTable, ChaptersTableData> {
  $$ChaptersTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.chaptersTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChaptersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (ChaptersTableData, $$ChaptersTableTableReferences),
    ChaptersTableData,
    PrefetchHooks Function({bool storyId})> {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion(
            id: id,
            storyId: storyId,
            title: title,
            content: content,
            order: order,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String title,
            Value<String> content = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion.insert(
            id: id,
            storyId: storyId,
            title: title,
            content: content,
            order: order,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChaptersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$ChaptersTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$ChaptersTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChaptersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (ChaptersTableData, $$ChaptersTableTableReferences),
    ChaptersTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  required String storyId,
  required String content,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$NotesTableTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData> {
  $$NotesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.notesTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NotesTableData, $$NotesTableTableReferences),
    NotesTableData,
    PrefetchHooks Function({bool storyId})> {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion(
            id: id,
            storyId: storyId,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String content,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion.insert(
            id: id,
            storyId: storyId,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NotesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$NotesTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$NotesTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NotesTableData, $$NotesTableTableReferences),
    NotesTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$QuestionsTableTableCreateCompanionBuilder = QuestionsTableCompanion
    Function({
  required String id,
  required String storyId,
  required String question,
  Value<String> details,
  Value<bool> isResolved,
  Value<String?> answer,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$QuestionsTableTableUpdateCompanionBuilder = QuestionsTableCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> question,
  Value<String> details,
  Value<bool> isResolved,
  Value<String?> answer,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$QuestionsTableTableReferences extends BaseReferences<
    _$AppDatabase, $QuestionsTableTable, QuestionsTableData> {
  $$QuestionsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias(
          $_aliasNameGenerator(db.questionsTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$QuestionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTableTable> {
  $$QuestionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTableTable> {
  $$QuestionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTableTable> {
  $$QuestionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTableTable,
    QuestionsTableData,
    $$QuestionsTableTableFilterComposer,
    $$QuestionsTableTableOrderingComposer,
    $$QuestionsTableTableAnnotationComposer,
    $$QuestionsTableTableCreateCompanionBuilder,
    $$QuestionsTableTableUpdateCompanionBuilder,
    (QuestionsTableData, $$QuestionsTableTableReferences),
    QuestionsTableData,
    PrefetchHooks Function({bool storyId})> {
  $$QuestionsTableTableTableManager(
      _$AppDatabase db, $QuestionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<bool> isResolved = const Value.absent(),
            Value<String?> answer = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsTableCompanion(
            id: id,
            storyId: storyId,
            question: question,
            details: details,
            isResolved: isResolved,
            answer: answer,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String question,
            Value<String> details = const Value.absent(),
            Value<bool> isResolved = const Value.absent(),
            Value<String?> answer = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsTableCompanion.insert(
            id: id,
            storyId: storyId,
            question: question,
            details: details,
            isResolved: isResolved,
            answer: answer,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$QuestionsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$QuestionsTableTableReferences._storyIdTable(db),
                    referencedColumn:
                        $$QuestionsTableTableReferences._storyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$QuestionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionsTableTable,
    QuestionsTableData,
    $$QuestionsTableTableFilterComposer,
    $$QuestionsTableTableOrderingComposer,
    $$QuestionsTableTableAnnotationComposer,
    $$QuestionsTableTableCreateCompanionBuilder,
    $$QuestionsTableTableUpdateCompanionBuilder,
    (QuestionsTableData, $$QuestionsTableTableReferences),
    QuestionsTableData,
    PrefetchHooks Function({bool storyId})>;
typedef $$RelationshipsTableTableCreateCompanionBuilder
    = RelationshipsTableCompanion Function({
  required String id,
  required String storyId,
  required String sourceId,
  required String targetId,
  required String type,
  Value<String> description,
  Value<int> rowid,
});
typedef $$RelationshipsTableTableUpdateCompanionBuilder
    = RelationshipsTableCompanion Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> sourceId,
  Value<String> targetId,
  Value<String> type,
  Value<String> description,
  Value<int> rowid,
});

final class $$RelationshipsTableTableReferences extends BaseReferences<
    _$AppDatabase, $RelationshipsTableTable, RelationshipsTableData> {
  $$RelationshipsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTableTable _storyIdTable(_$AppDatabase db) =>
      db.storiesTable.createAlias($_aliasNameGenerator(
          db.relationshipsTable.storyId, db.storiesTable.id));

  $$StoriesTableTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableTableManager($_db, $_db.storiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RelationshipsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetId => $composableBuilder(
      column: $table.targetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  $$StoriesTableTableFilterComposer get storyId {
    final $$StoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetId => $composableBuilder(
      column: $table.targetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  $$StoriesTableTableOrderingComposer get storyId {
    final $$StoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipsTableTable> {
  $$RelationshipsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  $$StoriesTableTableAnnotationComposer get storyId {
    final $$StoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storyId,
        referencedTable: $db.storiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationshipsTableTable,
    RelationshipsTableData,
    $$RelationshipsTableTableFilterComposer,
    $$RelationshipsTableTableOrderingComposer,
    $$RelationshipsTableTableAnnotationComposer,
    $$RelationshipsTableTableCreateCompanionBuilder,
    $$RelationshipsTableTableUpdateCompanionBuilder,
    (RelationshipsTableData, $$RelationshipsTableTableReferences),
    RelationshipsTableData,
    PrefetchHooks Function({bool storyId})> {
  $$RelationshipsTableTableTableManager(
      _$AppDatabase db, $RelationshipsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationshipsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> targetId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsTableCompanion(
            id: id,
            storyId: storyId,
            sourceId: sourceId,
            targetId: targetId,
            type: type,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String sourceId,
            required String targetId,
            required String type,
            Value<String> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsTableCompanion.insert(
            id: id,
            storyId: storyId,
            sourceId: sourceId,
            targetId: targetId,
            type: type,
            description: description,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RelationshipsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (storyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storyId,
                    referencedTable:
                        $$RelationshipsTableTableReferences._storyIdTable(db),
                    referencedColumn: $$RelationshipsTableTableReferences
                        ._storyIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RelationshipsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationshipsTableTable,
    RelationshipsTableData,
    $$RelationshipsTableTableFilterComposer,
    $$RelationshipsTableTableOrderingComposer,
    $$RelationshipsTableTableAnnotationComposer,
    $$RelationshipsTableTableCreateCompanionBuilder,
    $$RelationshipsTableTableUpdateCompanionBuilder,
    (RelationshipsTableData, $$RelationshipsTableTableReferences),
    RelationshipsTableData,
    PrefetchHooks Function({bool storyId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoriesTableTableTableManager get storiesTable =>
      $$StoriesTableTableTableManager(_db, _db.storiesTable);
  $$CharactersTableTableTableManager get charactersTable =>
      $$CharactersTableTableTableManager(_db, _db.charactersTable);
  $$LocationsTableTableTableManager get locationsTable =>
      $$LocationsTableTableTableManager(_db, _db.locationsTable);
  $$PlotEventsTableTableTableManager get plotEventsTable =>
      $$PlotEventsTableTableTableManager(_db, _db.plotEventsTable);
  $$ChaptersTableTableTableManager get chaptersTable =>
      $$ChaptersTableTableTableManager(_db, _db.chaptersTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$QuestionsTableTableTableManager get questionsTable =>
      $$QuestionsTableTableTableManager(_db, _db.questionsTable);
  $$RelationshipsTableTableTableManager get relationshipsTable =>
      $$RelationshipsTableTableTableManager(_db, _db.relationshipsTable);
}
