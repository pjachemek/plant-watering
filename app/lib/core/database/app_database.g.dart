// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, HouseholdRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _publicCardsEnabledMeta =
      const VerificationMeta('publicCardsEnabled');
  @override
  late final GeneratedColumn<bool> publicCardsEnabled = GeneratedColumn<bool>(
    'public_cards_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("public_cards_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hemisphereMeta = const VerificationMeta(
    'hemisphere',
  );
  @override
  late final GeneratedColumn<String> hemisphere = GeneratedColumn<String>(
    'hemisphere',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    publicCardsEnabled,
    hemisphere,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(
    Insertable<HouseholdRow> instance, {
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
    if (data.containsKey('public_cards_enabled')) {
      context.handle(
        _publicCardsEnabledMeta,
        publicCardsEnabled.isAcceptableOrUnknown(
          data['public_cards_enabled']!,
          _publicCardsEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publicCardsEnabledMeta);
    }
    if (data.containsKey('hemisphere')) {
      context.handle(
        _hemisphereMeta,
        hemisphere.isAcceptableOrUnknown(data['hemisphere']!, _hemisphereMeta),
      );
    } else if (isInserting) {
      context.missing(_hemisphereMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      publicCardsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}public_cards_enabled'],
      )!,
      hemisphere: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hemisphere'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class HouseholdRow extends DataClass implements Insertable<HouseholdRow> {
  final String id;
  final String name;
  final bool publicCardsEnabled;
  final String hemisphere;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const HouseholdRow({
    required this.id,
    required this.name,
    required this.publicCardsEnabled,
    required this.hemisphere,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['public_cards_enabled'] = Variable<bool>(publicCardsEnabled);
    map['hemisphere'] = Variable<String>(hemisphere);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      name: Value(name),
      publicCardsEnabled: Value(publicCardsEnabled),
      hemisphere: Value(hemisphere),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory HouseholdRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      publicCardsEnabled: serializer.fromJson<bool>(json['publicCardsEnabled']),
      hemisphere: serializer.fromJson<String>(json['hemisphere']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'publicCardsEnabled': serializer.toJson<bool>(publicCardsEnabled),
      'hemisphere': serializer.toJson<String>(hemisphere),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  HouseholdRow copyWith({
    String? id,
    String? name,
    bool? publicCardsEnabled,
    String? hemisphere,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => HouseholdRow(
    id: id ?? this.id,
    name: name ?? this.name,
    publicCardsEnabled: publicCardsEnabled ?? this.publicCardsEnabled,
    hemisphere: hemisphere ?? this.hemisphere,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  HouseholdRow copyWithCompanion(HouseholdsCompanion data) {
    return HouseholdRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      publicCardsEnabled: data.publicCardsEnabled.present
          ? data.publicCardsEnabled.value
          : this.publicCardsEnabled,
      hemisphere: data.hemisphere.present
          ? data.hemisphere.value
          : this.hemisphere,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('publicCardsEnabled: $publicCardsEnabled, ')
          ..write('hemisphere: $hemisphere, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    publicCardsEnabled,
    hemisphere,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.publicCardsEnabled == this.publicCardsEnabled &&
          other.hemisphere == this.hemisphere &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class HouseholdsCompanion extends UpdateCompanion<HouseholdRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> publicCardsEnabled;
  final Value<String> hemisphere;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.publicCardsEnabled = const Value.absent(),
    this.hemisphere = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String id,
    required String name,
    required bool publicCardsEnabled,
    required String hemisphere,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       publicCardsEnabled = Value(publicCardsEnabled),
       hemisphere = Value(hemisphere),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HouseholdRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? publicCardsEnabled,
    Expression<String>? hemisphere,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (publicCardsEnabled != null)
        'public_cards_enabled': publicCardsEnabled,
      if (hemisphere != null) 'hemisphere': hemisphere,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? publicCardsEnabled,
    Value<String>? hemisphere,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      publicCardsEnabled: publicCardsEnabled ?? this.publicCardsEnabled,
      hemisphere: hemisphere ?? this.hemisphere,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (publicCardsEnabled.present) {
      map['public_cards_enabled'] = Variable<bool>(publicCardsEnabled.value);
    }
    if (hemisphere.present) {
      map['hemisphere'] = Variable<String>(hemisphere.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('publicCardsEnabled: $publicCardsEnabled, ')
          ..write('hemisphere: $hemisphere, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, MemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    userId,
    displayName,
    joinedAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class MemberRow extends DataClass implements Insertable<MemberRow> {
  final String id;
  final String householdId;
  final String userId;
  final String displayName;
  final DateTime joinedAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const MemberRow({
    required this.id,
    required this.householdId,
    required this.userId,
    required this.displayName,
    required this.joinedAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['user_id'] = Variable<String>(userId);
    map['display_name'] = Variable<String>(displayName);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      userId: Value(userId),
      displayName: Value(displayName),
      joinedAt: Value(joinedAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory MemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String>(displayName),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  MemberRow copyWith({
    String? id,
    String? householdId,
    String? userId,
    String? displayName,
    DateTime? joinedAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => MemberRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    joinedAt: joinedAt ?? this.joinedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  MemberRow copyWithCompanion(MembersCompanion data) {
    return MemberRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    userId,
    displayName,
    joinedAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.joinedAt == this.joinedAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MembersCompanion extends UpdateCompanion<MemberRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> userId;
  final Value<String> displayName;
  final Value<DateTime> joinedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String householdId,
    required String userId,
    required String displayName,
    required DateTime joinedAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       userId = Value(userId),
       displayName = Value(displayName),
       joinedAt = Value(joinedAt),
       updatedAt = Value(updatedAt);
  static Insertable<MemberRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<DateTime>? joinedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? userId,
    Value<String>? displayName,
    Value<DateTime>? joinedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, PlantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presetIdMeta = const VerificationMeta(
    'presetId',
  );
  @override
  late final GeneratedColumn<String> presetId = GeneratedColumn<String>(
    'preset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presetVersionMeta = const VerificationMeta(
    'presetVersion',
  );
  @override
  late final GeneratedColumn<int> presetVersion = GeneratedColumn<int>(
    'preset_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalSummerDaysMeta =
      const VerificationMeta('intervalSummerDays');
  @override
  late final GeneratedColumn<int> intervalSummerDays = GeneratedColumn<int>(
    'interval_summer_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalWinterDaysMeta =
      const VerificationMeta('intervalWinterDays');
  @override
  late final GeneratedColumn<int> intervalWinterDays = GeneratedColumn<int>(
    'interval_winter_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    nickname,
    presetId,
    presetVersion,
    room,
    photoPath,
    intervalSummerDays,
    intervalWinterDays,
    amount,
    method,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('preset_id')) {
      context.handle(
        _presetIdMeta,
        presetId.isAcceptableOrUnknown(data['preset_id']!, _presetIdMeta),
      );
    }
    if (data.containsKey('preset_version')) {
      context.handle(
        _presetVersionMeta,
        presetVersion.isAcceptableOrUnknown(
          data['preset_version']!,
          _presetVersionMeta,
        ),
      );
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('interval_summer_days')) {
      context.handle(
        _intervalSummerDaysMeta,
        intervalSummerDays.isAcceptableOrUnknown(
          data['interval_summer_days']!,
          _intervalSummerDaysMeta,
        ),
      );
    }
    if (data.containsKey('interval_winter_days')) {
      context.handle(
        _intervalWinterDaysMeta,
        intervalWinterDays.isAcceptableOrUnknown(
          data['interval_winter_days']!,
          _intervalWinterDaysMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      presetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset_id'],
      ),
      presetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preset_version'],
      ),
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      intervalSummerDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_summer_days'],
      ),
      intervalWinterDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_winter_days'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      ),
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }
}

class PlantRow extends DataClass implements Insertable<PlantRow> {
  final String id;
  final String householdId;
  final String nickname;
  final String? presetId;
  final int? presetVersion;
  final String? room;
  final String? photoPath;
  final int? intervalSummerDays;
  final int? intervalWinterDays;
  final String? amount;
  final String? method;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const PlantRow({
    required this.id,
    required this.householdId,
    required this.nickname,
    this.presetId,
    this.presetVersion,
    this.room,
    this.photoPath,
    this.intervalSummerDays,
    this.intervalWinterDays,
    this.amount,
    this.method,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || presetId != null) {
      map['preset_id'] = Variable<String>(presetId);
    }
    if (!nullToAbsent || presetVersion != null) {
      map['preset_version'] = Variable<int>(presetVersion);
    }
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || intervalSummerDays != null) {
      map['interval_summer_days'] = Variable<int>(intervalSummerDays);
    }
    if (!nullToAbsent || intervalWinterDays != null) {
      map['interval_winter_days'] = Variable<int>(intervalWinterDays);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<String>(amount);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      nickname: Value(nickname),
      presetId: presetId == null && nullToAbsent
          ? const Value.absent()
          : Value(presetId),
      presetVersion: presetVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(presetVersion),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      intervalSummerDays: intervalSummerDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalSummerDays),
      intervalWinterDays: intervalWinterDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalWinterDays),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PlantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      presetId: serializer.fromJson<String?>(json['presetId']),
      presetVersion: serializer.fromJson<int?>(json['presetVersion']),
      room: serializer.fromJson<String?>(json['room']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      intervalSummerDays: serializer.fromJson<int?>(json['intervalSummerDays']),
      intervalWinterDays: serializer.fromJson<int?>(json['intervalWinterDays']),
      amount: serializer.fromJson<String?>(json['amount']),
      method: serializer.fromJson<String?>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'nickname': serializer.toJson<String>(nickname),
      'presetId': serializer.toJson<String?>(presetId),
      'presetVersion': serializer.toJson<int?>(presetVersion),
      'room': serializer.toJson<String?>(room),
      'photoPath': serializer.toJson<String?>(photoPath),
      'intervalSummerDays': serializer.toJson<int?>(intervalSummerDays),
      'intervalWinterDays': serializer.toJson<int?>(intervalWinterDays),
      'amount': serializer.toJson<String?>(amount),
      'method': serializer.toJson<String?>(method),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PlantRow copyWith({
    String? id,
    String? householdId,
    String? nickname,
    Value<String?> presetId = const Value.absent(),
    Value<int?> presetVersion = const Value.absent(),
    Value<String?> room = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<int?> intervalSummerDays = const Value.absent(),
    Value<int?> intervalWinterDays = const Value.absent(),
    Value<String?> amount = const Value.absent(),
    Value<String?> method = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PlantRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    nickname: nickname ?? this.nickname,
    presetId: presetId.present ? presetId.value : this.presetId,
    presetVersion: presetVersion.present
        ? presetVersion.value
        : this.presetVersion,
    room: room.present ? room.value : this.room,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    intervalSummerDays: intervalSummerDays.present
        ? intervalSummerDays.value
        : this.intervalSummerDays,
    intervalWinterDays: intervalWinterDays.present
        ? intervalWinterDays.value
        : this.intervalWinterDays,
    amount: amount.present ? amount.value : this.amount,
    method: method.present ? method.value : this.method,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PlantRow copyWithCompanion(PlantsCompanion data) {
    return PlantRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      presetId: data.presetId.present ? data.presetId.value : this.presetId,
      presetVersion: data.presetVersion.present
          ? data.presetVersion.value
          : this.presetVersion,
      room: data.room.present ? data.room.value : this.room,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      intervalSummerDays: data.intervalSummerDays.present
          ? data.intervalSummerDays.value
          : this.intervalSummerDays,
      intervalWinterDays: data.intervalWinterDays.present
          ? data.intervalWinterDays.value
          : this.intervalWinterDays,
      amount: data.amount.present ? data.amount.value : this.amount,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('nickname: $nickname, ')
          ..write('presetId: $presetId, ')
          ..write('presetVersion: $presetVersion, ')
          ..write('room: $room, ')
          ..write('photoPath: $photoPath, ')
          ..write('intervalSummerDays: $intervalSummerDays, ')
          ..write('intervalWinterDays: $intervalWinterDays, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    nickname,
    presetId,
    presetVersion,
    room,
    photoPath,
    intervalSummerDays,
    intervalWinterDays,
    amount,
    method,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.nickname == this.nickname &&
          other.presetId == this.presetId &&
          other.presetVersion == this.presetVersion &&
          other.room == this.room &&
          other.photoPath == this.photoPath &&
          other.intervalSummerDays == this.intervalSummerDays &&
          other.intervalWinterDays == this.intervalWinterDays &&
          other.amount == this.amount &&
          other.method == this.method &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PlantsCompanion extends UpdateCompanion<PlantRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> nickname;
  final Value<String?> presetId;
  final Value<int?> presetVersion;
  final Value<String?> room;
  final Value<String?> photoPath;
  final Value<int?> intervalSummerDays;
  final Value<int?> intervalWinterDays;
  final Value<String?> amount;
  final Value<String?> method;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.presetId = const Value.absent(),
    this.presetVersion = const Value.absent(),
    this.room = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.intervalSummerDays = const Value.absent(),
    this.intervalWinterDays = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlantsCompanion.insert({
    required String id,
    required String householdId,
    required String nickname,
    this.presetId = const Value.absent(),
    this.presetVersion = const Value.absent(),
    this.room = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.intervalSummerDays = const Value.absent(),
    this.intervalWinterDays = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       nickname = Value(nickname),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlantRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? nickname,
    Expression<String>? presetId,
    Expression<int>? presetVersion,
    Expression<String>? room,
    Expression<String>? photoPath,
    Expression<int>? intervalSummerDays,
    Expression<int>? intervalWinterDays,
    Expression<String>? amount,
    Expression<String>? method,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (nickname != null) 'nickname': nickname,
      if (presetId != null) 'preset_id': presetId,
      if (presetVersion != null) 'preset_version': presetVersion,
      if (room != null) 'room': room,
      if (photoPath != null) 'photo_path': photoPath,
      if (intervalSummerDays != null)
        'interval_summer_days': intervalSummerDays,
      if (intervalWinterDays != null)
        'interval_winter_days': intervalWinterDays,
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlantsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? nickname,
    Value<String?>? presetId,
    Value<int?>? presetVersion,
    Value<String?>? room,
    Value<String?>? photoPath,
    Value<int?>? intervalSummerDays,
    Value<int?>? intervalWinterDays,
    Value<String?>? amount,
    Value<String?>? method,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PlantsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      nickname: nickname ?? this.nickname,
      presetId: presetId ?? this.presetId,
      presetVersion: presetVersion ?? this.presetVersion,
      room: room ?? this.room,
      photoPath: photoPath ?? this.photoPath,
      intervalSummerDays: intervalSummerDays ?? this.intervalSummerDays,
      intervalWinterDays: intervalWinterDays ?? this.intervalWinterDays,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (presetId.present) {
      map['preset_id'] = Variable<String>(presetId.value);
    }
    if (presetVersion.present) {
      map['preset_version'] = Variable<int>(presetVersion.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (intervalSummerDays.present) {
      map['interval_summer_days'] = Variable<int>(intervalSummerDays.value);
    }
    if (intervalWinterDays.present) {
      map['interval_winter_days'] = Variable<int>(intervalWinterDays.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('nickname: $nickname, ')
          ..write('presetId: $presetId, ')
          ..write('presetVersion: $presetVersion, ')
          ..write('room: $room, ')
          ..write('photoPath: $photoPath, ')
          ..write('intervalSummerDays: $intervalSummerDays, ')
          ..write('intervalWinterDays: $intervalWinterDays, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<String> plantId = GeneratedColumn<String>(
    'plant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _writtenAtMeta = const VerificationMeta(
    'writtenAt',
  );
  @override
  late final GeneratedColumn<DateTime> writtenAt = GeneratedColumn<DateTime>(
    'written_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _writtenByMeta = const VerificationMeta(
    'writtenBy',
  );
  @override
  late final GeneratedColumn<String> writtenBy = GeneratedColumn<String>(
    'written_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    token,
    plantId,
    writtenAt,
    writtenBy,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    }
    if (data.containsKey('written_at')) {
      context.handle(
        _writtenAtMeta,
        writtenAt.isAcceptableOrUnknown(data['written_at']!, _writtenAtMeta),
      );
    }
    if (data.containsKey('written_by')) {
      context.handle(
        _writtenByMeta,
        writtenBy.isAcceptableOrUnknown(data['written_by']!, _writtenByMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_id'],
      ),
      writtenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}written_at'],
      ),
      writtenBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}written_by'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String householdId;
  final String token;
  final String? plantId;
  final DateTime? writtenAt;
  final String? writtenBy;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const TagRow({
    required this.id,
    required this.householdId,
    required this.token,
    this.plantId,
    this.writtenAt,
    this.writtenBy,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['token'] = Variable<String>(token);
    if (!nullToAbsent || plantId != null) {
      map['plant_id'] = Variable<String>(plantId);
    }
    if (!nullToAbsent || writtenAt != null) {
      map['written_at'] = Variable<DateTime>(writtenAt);
    }
    if (!nullToAbsent || writtenBy != null) {
      map['written_by'] = Variable<String>(writtenBy);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      token: Value(token),
      plantId: plantId == null && nullToAbsent
          ? const Value.absent()
          : Value(plantId),
      writtenAt: writtenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(writtenAt),
      writtenBy: writtenBy == null && nullToAbsent
          ? const Value.absent()
          : Value(writtenBy),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      token: serializer.fromJson<String>(json['token']),
      plantId: serializer.fromJson<String?>(json['plantId']),
      writtenAt: serializer.fromJson<DateTime?>(json['writtenAt']),
      writtenBy: serializer.fromJson<String?>(json['writtenBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'token': serializer.toJson<String>(token),
      'plantId': serializer.toJson<String?>(plantId),
      'writtenAt': serializer.toJson<DateTime?>(writtenAt),
      'writtenBy': serializer.toJson<String?>(writtenBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TagRow copyWith({
    String? id,
    String? householdId,
    String? token,
    Value<String?> plantId = const Value.absent(),
    Value<DateTime?> writtenAt = const Value.absent(),
    Value<String?> writtenBy = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TagRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    token: token ?? this.token,
    plantId: plantId.present ? plantId.value : this.plantId,
    writtenAt: writtenAt.present ? writtenAt.value : this.writtenAt,
    writtenBy: writtenBy.present ? writtenBy.value : this.writtenBy,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      token: data.token.present ? data.token.value : this.token,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      writtenAt: data.writtenAt.present ? data.writtenAt.value : this.writtenAt,
      writtenBy: data.writtenBy.present ? data.writtenBy.value : this.writtenBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('token: $token, ')
          ..write('plantId: $plantId, ')
          ..write('writtenAt: $writtenAt, ')
          ..write('writtenBy: $writtenBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    token,
    plantId,
    writtenAt,
    writtenBy,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.token == this.token &&
          other.plantId == this.plantId &&
          other.writtenAt == this.writtenAt &&
          other.writtenBy == this.writtenBy &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> token;
  final Value<String?> plantId;
  final Value<DateTime?> writtenAt;
  final Value<String?> writtenBy;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.token = const Value.absent(),
    this.plantId = const Value.absent(),
    this.writtenAt = const Value.absent(),
    this.writtenBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String householdId,
    required String token,
    this.plantId = const Value.absent(),
    this.writtenAt = const Value.absent(),
    this.writtenBy = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       token = Value(token),
       updatedAt = Value(updatedAt);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? token,
    Expression<String>? plantId,
    Expression<DateTime>? writtenAt,
    Expression<String>? writtenBy,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (token != null) 'token': token,
      if (plantId != null) 'plant_id': plantId,
      if (writtenAt != null) 'written_at': writtenAt,
      if (writtenBy != null) 'written_by': writtenBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? token,
    Value<String?>? plantId,
    Value<DateTime?>? writtenAt,
    Value<String?>? writtenBy,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      token: token ?? this.token,
      plantId: plantId ?? this.plantId,
      writtenAt: writtenAt ?? this.writtenAt,
      writtenBy: writtenBy ?? this.writtenBy,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<String>(plantId.value);
    }
    if (writtenAt.present) {
      map['written_at'] = Variable<DateTime>(writtenAt.value);
    }
    if (writtenBy.present) {
      map['written_by'] = Variable<String>(writtenBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('token: $token, ')
          ..write('plantId: $plantId, ')
          ..write('writtenAt: $writtenAt, ')
          ..write('writtenBy: $writtenBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WateringEventsTable extends WateringEvents
    with TableInfo<$WateringEventsTable, WateringEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WateringEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<String> plantId = GeneratedColumn<String>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateredAtMeta = const VerificationMeta(
    'wateredAt',
  );
  @override
  late final GeneratedColumn<DateTime> wateredAt = GeneratedColumn<DateTime>(
    'watered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    plantId,
    userId,
    wateredAt,
    source,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watering_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<WateringEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('watered_at')) {
      context.handle(
        _wateredAtMeta,
        wateredAt.isAcceptableOrUnknown(data['watered_at']!, _wateredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_wateredAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WateringEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WateringEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      wateredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}watered_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $WateringEventsTable createAlias(String alias) {
    return $WateringEventsTable(attachedDatabase, alias);
  }
}

class WateringEventRow extends DataClass
    implements Insertable<WateringEventRow> {
  final String id;
  final String householdId;
  final String plantId;
  final String? userId;
  final DateTime wateredAt;
  final String source;
  final DateTime createdAt;

  /// Set when the watering was undone.
  final DateTime? deletedAt;
  const WateringEventRow({
    required this.id,
    required this.householdId,
    required this.plantId,
    this.userId,
    required this.wateredAt,
    required this.source,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['plant_id'] = Variable<String>(plantId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['watered_at'] = Variable<DateTime>(wateredAt);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  WateringEventsCompanion toCompanion(bool nullToAbsent) {
    return WateringEventsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      plantId: Value(plantId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      wateredAt: Value(wateredAt),
      source: Value(source),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory WateringEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WateringEventRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      plantId: serializer.fromJson<String>(json['plantId']),
      userId: serializer.fromJson<String?>(json['userId']),
      wateredAt: serializer.fromJson<DateTime>(json['wateredAt']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'plantId': serializer.toJson<String>(plantId),
      'userId': serializer.toJson<String?>(userId),
      'wateredAt': serializer.toJson<DateTime>(wateredAt),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  WateringEventRow copyWith({
    String? id,
    String? householdId,
    String? plantId,
    Value<String?> userId = const Value.absent(),
    DateTime? wateredAt,
    String? source,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => WateringEventRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    plantId: plantId ?? this.plantId,
    userId: userId.present ? userId.value : this.userId,
    wateredAt: wateredAt ?? this.wateredAt,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  WateringEventRow copyWithCompanion(WateringEventsCompanion data) {
    return WateringEventRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      wateredAt: data.wateredAt.present ? data.wateredAt.value : this.wateredAt,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WateringEventRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('plantId: $plantId, ')
          ..write('userId: $userId, ')
          ..write('wateredAt: $wateredAt, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    plantId,
    userId,
    wateredAt,
    source,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WateringEventRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.plantId == this.plantId &&
          other.userId == this.userId &&
          other.wateredAt == this.wateredAt &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class WateringEventsCompanion extends UpdateCompanion<WateringEventRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> plantId;
  final Value<String?> userId;
  final Value<DateTime> wateredAt;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const WateringEventsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.plantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.wateredAt = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WateringEventsCompanion.insert({
    required String id,
    required String householdId,
    required String plantId,
    this.userId = const Value.absent(),
    required DateTime wateredAt,
    required String source,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       plantId = Value(plantId),
       wateredAt = Value(wateredAt),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<WateringEventRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? plantId,
    Expression<String>? userId,
    Expression<DateTime>? wateredAt,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (plantId != null) 'plant_id': plantId,
      if (userId != null) 'user_id': userId,
      if (wateredAt != null) 'watered_at': wateredAt,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WateringEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? plantId,
    Value<String?>? userId,
    Value<DateTime>? wateredAt,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return WateringEventsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      plantId: plantId ?? this.plantId,
      userId: userId ?? this.userId,
      wateredAt: wateredAt ?? this.wateredAt,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<String>(plantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (wateredAt.present) {
      map['watered_at'] = Variable<DateTime>(wateredAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WateringEventsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('plantId: $plantId, ')
          ..write('userId: $userId, ')
          ..write('wateredAt: $wateredAt, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _changeIdMeta = const VerificationMeta(
    'changeId',
  );
  @override
  late final GeneratedColumn<String> changeId = GeneratedColumn<String>(
    'change_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldsMeta = const VerificationMeta('fields');
  @override
  late final GeneratedColumn<String> fields = GeneratedColumn<String>(
    'fields',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patchMeta = const VerificationMeta('patch');
  @override
  late final GeneratedColumn<String> patch = GeneratedColumn<String>(
    'patch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _batchKeyMeta = const VerificationMeta(
    'batchKey',
  );
  @override
  late final GeneratedColumn<String> batchKey = GeneratedColumn<String>(
    'batch_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    changeId,
    householdId,
    entity,
    op,
    rowId,
    fields,
    patch,
    createdAt,
    batchKey,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('change_id')) {
      context.handle(
        _changeIdMeta,
        changeId.isAcceptableOrUnknown(data['change_id']!, _changeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_changeIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('fields')) {
      context.handle(
        _fieldsMeta,
        fields.isAcceptableOrUnknown(data['fields']!, _fieldsMeta),
      );
    }
    if (data.containsKey('patch')) {
      context.handle(
        _patchMeta,
        patch.isAcceptableOrUnknown(data['patch']!, _patchMeta),
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
    if (data.containsKey('batch_key')) {
      context.handle(
        _batchKeyMeta,
        batchKey.isAcceptableOrUnknown(data['batch_key']!, _batchKeyMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      changeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      fields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields'],
      ),
      patch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patch'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      batchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_key'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final int seq;

  /// The change's own UUID v7; the API's ledger keys retries on it.
  final String changeId;
  final String householdId;

  /// `household`, `plant`, `tag` or `watering_event`.
  final String entity;

  /// `upsert` or `delete`.
  final String op;
  final String rowId;

  /// JSON array of the field names this upsert sets, or null.
  final String? fields;

  /// JSON object with the patch, or null for a delete.
  final String? patch;
  final DateTime createdAt;

  /// The Idempotency-Key of the push that last carried this change, kept so
  /// a retry of the same batch reuses it (ADR-0019).
  final String? batchKey;
  final int attempts;
  const OutboxRow({
    required this.seq,
    required this.changeId,
    required this.householdId,
    required this.entity,
    required this.op,
    required this.rowId,
    this.fields,
    this.patch,
    required this.createdAt,
    this.batchKey,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['change_id'] = Variable<String>(changeId);
    map['household_id'] = Variable<String>(householdId);
    map['entity'] = Variable<String>(entity);
    map['op'] = Variable<String>(op);
    map['row_id'] = Variable<String>(rowId);
    if (!nullToAbsent || fields != null) {
      map['fields'] = Variable<String>(fields);
    }
    if (!nullToAbsent || patch != null) {
      map['patch'] = Variable<String>(patch);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || batchKey != null) {
      map['batch_key'] = Variable<String>(batchKey);
    }
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      seq: Value(seq),
      changeId: Value(changeId),
      householdId: Value(householdId),
      entity: Value(entity),
      op: Value(op),
      rowId: Value(rowId),
      fields: fields == null && nullToAbsent
          ? const Value.absent()
          : Value(fields),
      patch: patch == null && nullToAbsent
          ? const Value.absent()
          : Value(patch),
      createdAt: Value(createdAt),
      batchKey: batchKey == null && nullToAbsent
          ? const Value.absent()
          : Value(batchKey),
      attempts: Value(attempts),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      seq: serializer.fromJson<int>(json['seq']),
      changeId: serializer.fromJson<String>(json['changeId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      entity: serializer.fromJson<String>(json['entity']),
      op: serializer.fromJson<String>(json['op']),
      rowId: serializer.fromJson<String>(json['rowId']),
      fields: serializer.fromJson<String?>(json['fields']),
      patch: serializer.fromJson<String?>(json['patch']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      batchKey: serializer.fromJson<String?>(json['batchKey']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'changeId': serializer.toJson<String>(changeId),
      'householdId': serializer.toJson<String>(householdId),
      'entity': serializer.toJson<String>(entity),
      'op': serializer.toJson<String>(op),
      'rowId': serializer.toJson<String>(rowId),
      'fields': serializer.toJson<String?>(fields),
      'patch': serializer.toJson<String?>(patch),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'batchKey': serializer.toJson<String?>(batchKey),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  OutboxRow copyWith({
    int? seq,
    String? changeId,
    String? householdId,
    String? entity,
    String? op,
    String? rowId,
    Value<String?> fields = const Value.absent(),
    Value<String?> patch = const Value.absent(),
    DateTime? createdAt,
    Value<String?> batchKey = const Value.absent(),
    int? attempts,
  }) => OutboxRow(
    seq: seq ?? this.seq,
    changeId: changeId ?? this.changeId,
    householdId: householdId ?? this.householdId,
    entity: entity ?? this.entity,
    op: op ?? this.op,
    rowId: rowId ?? this.rowId,
    fields: fields.present ? fields.value : this.fields,
    patch: patch.present ? patch.value : this.patch,
    createdAt: createdAt ?? this.createdAt,
    batchKey: batchKey.present ? batchKey.value : this.batchKey,
    attempts: attempts ?? this.attempts,
  );
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
      seq: data.seq.present ? data.seq.value : this.seq,
      changeId: data.changeId.present ? data.changeId.value : this.changeId,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      entity: data.entity.present ? data.entity.value : this.entity,
      op: data.op.present ? data.op.value : this.op,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      fields: data.fields.present ? data.fields.value : this.fields,
      patch: data.patch.present ? data.patch.value : this.patch,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      batchKey: data.batchKey.present ? data.batchKey.value : this.batchKey,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('seq: $seq, ')
          ..write('changeId: $changeId, ')
          ..write('householdId: $householdId, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('rowId: $rowId, ')
          ..write('fields: $fields, ')
          ..write('patch: $patch, ')
          ..write('createdAt: $createdAt, ')
          ..write('batchKey: $batchKey, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    changeId,
    householdId,
    entity,
    op,
    rowId,
    fields,
    patch,
    createdAt,
    batchKey,
    attempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.seq == this.seq &&
          other.changeId == this.changeId &&
          other.householdId == this.householdId &&
          other.entity == this.entity &&
          other.op == this.op &&
          other.rowId == this.rowId &&
          other.fields == this.fields &&
          other.patch == this.patch &&
          other.createdAt == this.createdAt &&
          other.batchKey == this.batchKey &&
          other.attempts == this.attempts);
}

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> seq;
  final Value<String> changeId;
  final Value<String> householdId;
  final Value<String> entity;
  final Value<String> op;
  final Value<String> rowId;
  final Value<String?> fields;
  final Value<String?> patch;
  final Value<DateTime> createdAt;
  final Value<String?> batchKey;
  final Value<int> attempts;
  const OutboxCompanion({
    this.seq = const Value.absent(),
    this.changeId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.entity = const Value.absent(),
    this.op = const Value.absent(),
    this.rowId = const Value.absent(),
    this.fields = const Value.absent(),
    this.patch = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.batchKey = const Value.absent(),
    this.attempts = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String changeId,
    required String householdId,
    required String entity,
    required String op,
    required String rowId,
    this.fields = const Value.absent(),
    this.patch = const Value.absent(),
    required DateTime createdAt,
    this.batchKey = const Value.absent(),
    this.attempts = const Value.absent(),
  }) : changeId = Value(changeId),
       householdId = Value(householdId),
       entity = Value(entity),
       op = Value(op),
       rowId = Value(rowId),
       createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
    Expression<int>? seq,
    Expression<String>? changeId,
    Expression<String>? householdId,
    Expression<String>? entity,
    Expression<String>? op,
    Expression<String>? rowId,
    Expression<String>? fields,
    Expression<String>? patch,
    Expression<DateTime>? createdAt,
    Expression<String>? batchKey,
    Expression<int>? attempts,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (changeId != null) 'change_id': changeId,
      if (householdId != null) 'household_id': householdId,
      if (entity != null) 'entity': entity,
      if (op != null) 'op': op,
      if (rowId != null) 'row_id': rowId,
      if (fields != null) 'fields': fields,
      if (patch != null) 'patch': patch,
      if (createdAt != null) 'created_at': createdAt,
      if (batchKey != null) 'batch_key': batchKey,
      if (attempts != null) 'attempts': attempts,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? changeId,
    Value<String>? householdId,
    Value<String>? entity,
    Value<String>? op,
    Value<String>? rowId,
    Value<String?>? fields,
    Value<String?>? patch,
    Value<DateTime>? createdAt,
    Value<String?>? batchKey,
    Value<int>? attempts,
  }) {
    return OutboxCompanion(
      seq: seq ?? this.seq,
      changeId: changeId ?? this.changeId,
      householdId: householdId ?? this.householdId,
      entity: entity ?? this.entity,
      op: op ?? this.op,
      rowId: rowId ?? this.rowId,
      fields: fields ?? this.fields,
      patch: patch ?? this.patch,
      createdAt: createdAt ?? this.createdAt,
      batchKey: batchKey ?? this.batchKey,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (changeId.present) {
      map['change_id'] = Variable<String>(changeId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (fields.present) {
      map['fields'] = Variable<String>(fields.value);
    }
    if (patch.present) {
      map['patch'] = Variable<String>(patch.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (batchKey.present) {
      map['batch_key'] = Variable<String>(batchKey.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('changeId: $changeId, ')
          ..write('householdId: $householdId, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('rowId: $rowId, ')
          ..write('fields: $fields, ')
          ..write('patch: $patch, ')
          ..write('createdAt: $createdAt, ')
          ..write('batchKey: $batchKey, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }
}

class $SyncStatesTable extends SyncStates
    with TableInfo<$SyncStatesTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pulledAtMeta = const VerificationMeta(
    'pulledAt',
  );
  @override
  late final GeneratedColumn<DateTime> pulledAt = GeneratedColumn<DateTime>(
    'pulled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullPullNeededMeta = const VerificationMeta(
    'fullPullNeeded',
  );
  @override
  late final GeneratedColumn<bool> fullPullNeeded = GeneratedColumn<bool>(
    'full_pull_needed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_pull_needed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    householdId,
    cursor,
    pulledAt,
    fullPullNeeded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('pulled_at')) {
      context.handle(
        _pulledAtMeta,
        pulledAt.isAcceptableOrUnknown(data['pulled_at']!, _pulledAtMeta),
      );
    }
    if (data.containsKey('full_pull_needed')) {
      context.handle(
        _fullPullNeededMeta,
        fullPullNeeded.isAcceptableOrUnknown(
          data['full_pull_needed']!,
          _fullPullNeededMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {householdId};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
      pulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pulled_at'],
      ),
      fullPullNeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_pull_needed'],
      )!,
    );
  }

  @override
  $SyncStatesTable createAlias(String alias) {
    return $SyncStatesTable(attachedDatabase, alias);
  }
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final String householdId;

  /// The opaque cursor from the last pull, or null before the first.
  final String? cursor;
  final DateTime? pulledAt;

  /// Set when the API rejected a change: the next pull fetches everything,
  /// so rows the server never accepted disappear from this phone.
  final bool fullPullNeeded;
  const SyncStateRow({
    required this.householdId,
    this.cursor,
    this.pulledAt,
    required this.fullPullNeeded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    if (!nullToAbsent || pulledAt != null) {
      map['pulled_at'] = Variable<DateTime>(pulledAt);
    }
    map['full_pull_needed'] = Variable<bool>(fullPullNeeded);
    return map;
  }

  SyncStatesCompanion toCompanion(bool nullToAbsent) {
    return SyncStatesCompanion(
      householdId: Value(householdId),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
      pulledAt: pulledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pulledAt),
      fullPullNeeded: Value(fullPullNeeded),
    );
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      householdId: serializer.fromJson<String>(json['householdId']),
      cursor: serializer.fromJson<String?>(json['cursor']),
      pulledAt: serializer.fromJson<DateTime?>(json['pulledAt']),
      fullPullNeeded: serializer.fromJson<bool>(json['fullPullNeeded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'householdId': serializer.toJson<String>(householdId),
      'cursor': serializer.toJson<String?>(cursor),
      'pulledAt': serializer.toJson<DateTime?>(pulledAt),
      'fullPullNeeded': serializer.toJson<bool>(fullPullNeeded),
    };
  }

  SyncStateRow copyWith({
    String? householdId,
    Value<String?> cursor = const Value.absent(),
    Value<DateTime?> pulledAt = const Value.absent(),
    bool? fullPullNeeded,
  }) => SyncStateRow(
    householdId: householdId ?? this.householdId,
    cursor: cursor.present ? cursor.value : this.cursor,
    pulledAt: pulledAt.present ? pulledAt.value : this.pulledAt,
    fullPullNeeded: fullPullNeeded ?? this.fullPullNeeded,
  );
  SyncStateRow copyWithCompanion(SyncStatesCompanion data) {
    return SyncStateRow(
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      pulledAt: data.pulledAt.present ? data.pulledAt.value : this.pulledAt,
      fullPullNeeded: data.fullPullNeeded.present
          ? data.fullPullNeeded.value
          : this.fullPullNeeded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('householdId: $householdId, ')
          ..write('cursor: $cursor, ')
          ..write('pulledAt: $pulledAt, ')
          ..write('fullPullNeeded: $fullPullNeeded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(householdId, cursor, pulledAt, fullPullNeeded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.householdId == this.householdId &&
          other.cursor == this.cursor &&
          other.pulledAt == this.pulledAt &&
          other.fullPullNeeded == this.fullPullNeeded);
}

class SyncStatesCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<String> householdId;
  final Value<String?> cursor;
  final Value<DateTime?> pulledAt;
  final Value<bool> fullPullNeeded;
  final Value<int> rowid;
  const SyncStatesCompanion({
    this.householdId = const Value.absent(),
    this.cursor = const Value.absent(),
    this.pulledAt = const Value.absent(),
    this.fullPullNeeded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStatesCompanion.insert({
    required String householdId,
    this.cursor = const Value.absent(),
    this.pulledAt = const Value.absent(),
    this.fullPullNeeded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : householdId = Value(householdId);
  static Insertable<SyncStateRow> custom({
    Expression<String>? householdId,
    Expression<String>? cursor,
    Expression<DateTime>? pulledAt,
    Expression<bool>? fullPullNeeded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (householdId != null) 'household_id': householdId,
      if (cursor != null) 'cursor': cursor,
      if (pulledAt != null) 'pulled_at': pulledAt,
      if (fullPullNeeded != null) 'full_pull_needed': fullPullNeeded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStatesCompanion copyWith({
    Value<String>? householdId,
    Value<String?>? cursor,
    Value<DateTime?>? pulledAt,
    Value<bool>? fullPullNeeded,
    Value<int>? rowid,
  }) {
    return SyncStatesCompanion(
      householdId: householdId ?? this.householdId,
      cursor: cursor ?? this.cursor,
      pulledAt: pulledAt ?? this.pulledAt,
      fullPullNeeded: fullPullNeeded ?? this.fullPullNeeded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (pulledAt.present) {
      map['pulled_at'] = Variable<DateTime>(pulledAt.value);
    }
    if (fullPullNeeded.present) {
      map['full_pull_needed'] = Variable<bool>(fullPullNeeded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesCompanion(')
          ..write('householdId: $householdId, ')
          ..write('cursor: $cursor, ')
          ..write('pulledAt: $pulledAt, ')
          ..write('fullPullNeeded: $fullPullNeeded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $WateringEventsTable wateringEvents = $WateringEventsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStatesTable syncStates = $SyncStatesTable(this);
  late final Index plantsHousehold = Index(
    'plants_household',
    'CREATE INDEX plants_household ON plants (household_id)',
  );
  late final Index tagsToken = Index(
    'tags_token',
    'CREATE UNIQUE INDEX tags_token ON tags (token)',
  );
  late final Index tagsPlant = Index(
    'tags_plant',
    'CREATE INDEX tags_plant ON tags (plant_id)',
  );
  late final Index wateringPlantTime = Index(
    'watering_plant_time',
    'CREATE INDEX watering_plant_time ON watering_events (plant_id, watered_at)',
  );
  late final Index outboxHousehold = Index(
    'outbox_household',
    'CREATE INDEX outbox_household ON outbox (household_id, seq)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    households,
    members,
    plants,
    tags,
    wateringEvents,
    outbox,
    syncStates,
    plantsHousehold,
    tagsToken,
    tagsPlant,
    wateringPlantTime,
    outboxHousehold,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  required String id,
  required String name,
  required bool publicCardsEnabled,
  required String hemisphere,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> publicCardsEnabled,
  Value<String> hemisphere,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
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

  ColumnFilters<bool> get publicCardsEnabled => $composableBuilder(
    column: $table.publicCardsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
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

  ColumnOrderings<bool> get publicCardsEnabled => $composableBuilder(
    column: $table.publicCardsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
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

  GeneratedColumn<bool> get publicCardsEnabled => $composableBuilder(
    column: $table.publicCardsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$HouseholdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HouseholdsTable,
          HouseholdRow,
          $$HouseholdsTableFilterComposer,
          $$HouseholdsTableOrderingComposer,
          $$HouseholdsTableAnnotationComposer,
          $$HouseholdsTableCreateCompanionBuilder,
          $$HouseholdsTableUpdateCompanionBuilder,
          (
            HouseholdRow,
            BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdRow>,
          ),
          HouseholdRow,
          PrefetchHooks Function()
        > {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> publicCardsEnabled = const Value.absent(),
                Value<String> hemisphere = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HouseholdsCompanion(
                id: id,
                name: name,
                publicCardsEnabled: publicCardsEnabled,
                hemisphere: hemisphere,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required bool publicCardsEnabled,
                required String hemisphere,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HouseholdsCompanion.insert(
                id: id,
                name: name,
                publicCardsEnabled: publicCardsEnabled,
                hemisphere: hemisphere,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HouseholdsTable, HouseholdRow>(table),
                  BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HouseholdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HouseholdsTable,
      HouseholdRow,
      $$HouseholdsTableFilterComposer,
      $$HouseholdsTableOrderingComposer,
      $$HouseholdsTableAnnotationComposer,
      $$HouseholdsTableCreateCompanionBuilder,
      $$HouseholdsTableUpdateCompanionBuilder,
      (
        HouseholdRow,
        BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdRow>,
      ),
      HouseholdRow,
      PrefetchHooks Function()
    >;
typedef $$MembersTableCreateCompanionBuilder = MembersCompanion Function({
  required String id,
  required String householdId,
  required String userId,
  required String displayName,
  required DateTime joinedAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MembersTableUpdateCompanionBuilder = MembersCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> userId,
  Value<String> displayName,
  Value<DateTime> joinedAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
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

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
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

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          MemberRow,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (MemberRow, BaseReferences<_$AppDatabase, $MembersTable, MemberRow>),
          MemberRow,
          PrefetchHooks Function()
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                householdId: householdId,
                userId: userId,
                displayName: displayName,
                joinedAt: joinedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String userId,
                required String displayName,
                required DateTime joinedAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                householdId: householdId,
                userId: userId,
                displayName: displayName,
                joinedAt: joinedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MembersTable, MemberRow>(table),
                  BaseReferences<_$AppDatabase, $MembersTable, MemberRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      MemberRow,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (MemberRow, BaseReferences<_$AppDatabase, $MembersTable, MemberRow>),
      MemberRow,
      PrefetchHooks Function()
    >;
typedef $$PlantsTableCreateCompanionBuilder = PlantsCompanion Function({
  required String id,
  required String householdId,
  required String nickname,
  Value<String?> presetId,
  Value<int?> presetVersion,
  Value<String?> room,
  Value<String?> photoPath,
  Value<int?> intervalSummerDays,
  Value<int?> intervalWinterDays,
  Value<String?> amount,
  Value<String?> method,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PlantsTableUpdateCompanionBuilder = PlantsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> nickname,
  Value<String?> presetId,
  Value<int?> presetVersion,
  Value<String?> room,
  Value<String?> photoPath,
  Value<int?> intervalSummerDays,
  Value<int?> intervalWinterDays,
  Value<String?> amount,
  Value<String?> method,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$PlantsTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableFilterComposer({
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

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presetId => $composableBuilder(
    column: $table.presetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalSummerDays => $composableBuilder(
    column: $table.intervalSummerDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalWinterDays => $composableBuilder(
    column: $table.intervalWinterDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableOrderingComposer({
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

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presetId => $composableBuilder(
    column: $table.presetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalSummerDays => $composableBuilder(
    column: $table.intervalSummerDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalWinterDays => $composableBuilder(
    column: $table.intervalWinterDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get presetId =>
      $composableBuilder(column: $table.presetId, builder: (column) => column);

  GeneratedColumn<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get intervalSummerDays => $composableBuilder(
    column: $table.intervalSummerDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalWinterDays => $composableBuilder(
    column: $table.intervalWinterDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PlantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantsTable,
          PlantRow,
          $$PlantsTableFilterComposer,
          $$PlantsTableOrderingComposer,
          $$PlantsTableAnnotationComposer,
          $$PlantsTableCreateCompanionBuilder,
          $$PlantsTableUpdateCompanionBuilder,
          (PlantRow, BaseReferences<_$AppDatabase, $PlantsTable, PlantRow>),
          PlantRow,
          PrefetchHooks Function()
        > {
  $$PlantsTableTableManager(_$AppDatabase db, $PlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> presetId = const Value.absent(),
                Value<int?> presetVersion = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> intervalSummerDays = const Value.absent(),
                Value<int?> intervalWinterDays = const Value.absent(),
                Value<String?> amount = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsCompanion(
                id: id,
                householdId: householdId,
                nickname: nickname,
                presetId: presetId,
                presetVersion: presetVersion,
                room: room,
                photoPath: photoPath,
                intervalSummerDays: intervalSummerDays,
                intervalWinterDays: intervalWinterDays,
                amount: amount,
                method: method,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String nickname,
                Value<String?> presetId = const Value.absent(),
                Value<int?> presetVersion = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> intervalSummerDays = const Value.absent(),
                Value<int?> intervalWinterDays = const Value.absent(),
                Value<String?> amount = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsCompanion.insert(
                id: id,
                householdId: householdId,
                nickname: nickname,
                presetId: presetId,
                presetVersion: presetVersion,
                room: room,
                photoPath: photoPath,
                intervalSummerDays: intervalSummerDays,
                intervalWinterDays: intervalWinterDays,
                amount: amount,
                method: method,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlantsTable, PlantRow>(table),
                  BaseReferences<_$AppDatabase, $PlantsTable, PlantRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantsTable,
      PlantRow,
      $$PlantsTableFilterComposer,
      $$PlantsTableOrderingComposer,
      $$PlantsTableAnnotationComposer,
      $$PlantsTableCreateCompanionBuilder,
      $$PlantsTableUpdateCompanionBuilder,
      (PlantRow, BaseReferences<_$AppDatabase, $PlantsTable, PlantRow>),
      PlantRow,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String householdId,
  required String token,
  Value<String?> plantId,
  Value<DateTime?> writtenAt,
  Value<String?> writtenBy,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> token,
  Value<String?> plantId,
  Value<DateTime?> writtenAt,
  Value<String?> writtenBy,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get writtenAt => $composableBuilder(
    column: $table.writtenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get writtenBy => $composableBuilder(
    column: $table.writtenBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get writtenAt => $composableBuilder(
    column: $table.writtenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get writtenBy => $composableBuilder(
    column: $table.writtenBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => column);

  GeneratedColumn<DateTime> get writtenAt =>
      $composableBuilder(column: $table.writtenAt, builder: (column) => column);

  GeneratedColumn<String> get writtenBy =>
      $composableBuilder(column: $table.writtenBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
          TagRow,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<String?> plantId = const Value.absent(),
                Value<DateTime?> writtenAt = const Value.absent(),
                Value<String?> writtenBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                householdId: householdId,
                token: token,
                plantId: plantId,
                writtenAt: writtenAt,
                writtenBy: writtenBy,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String token,
                Value<String?> plantId = const Value.absent(),
                Value<DateTime?> writtenAt = const Value.absent(),
                Value<String?> writtenBy = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                householdId: householdId,
                token: token,
                plantId: plantId,
                writtenAt: writtenAt,
                writtenBy: writtenBy,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, TagRow>(table),
                  BaseReferences<_$AppDatabase, $TagsTable, TagRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
      TagRow,
      PrefetchHooks Function()
    >;
typedef $$WateringEventsTableCreateCompanionBuilder =
    WateringEventsCompanion Function({
      required String id,
      required String householdId,
      required String plantId,
      Value<String?> userId,
      required DateTime wateredAt,
      required String source,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$WateringEventsTableUpdateCompanionBuilder =
    WateringEventsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> plantId,
      Value<String?> userId,
      Value<DateTime> wateredAt,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$WateringEventsTableFilterComposer
    extends Composer<_$AppDatabase, $WateringEventsTable> {
  $$WateringEventsTableFilterComposer({
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

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wateredAt => $composableBuilder(
    column: $table.wateredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WateringEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $WateringEventsTable> {
  $$WateringEventsTableOrderingComposer({
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

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wateredAt => $composableBuilder(
    column: $table.wateredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WateringEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WateringEventsTable> {
  $$WateringEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get wateredAt =>
      $composableBuilder(column: $table.wateredAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$WateringEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WateringEventsTable,
          WateringEventRow,
          $$WateringEventsTableFilterComposer,
          $$WateringEventsTableOrderingComposer,
          $$WateringEventsTableAnnotationComposer,
          $$WateringEventsTableCreateCompanionBuilder,
          $$WateringEventsTableUpdateCompanionBuilder,
          (
            WateringEventRow,
            BaseReferences<
              _$AppDatabase,
              $WateringEventsTable,
              WateringEventRow
            >,
          ),
          WateringEventRow,
          PrefetchHooks Function()
        > {
  $$WateringEventsTableTableManager(
    _$AppDatabase db,
    $WateringEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WateringEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WateringEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WateringEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> plantId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> wateredAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WateringEventsCompanion(
                id: id,
                householdId: householdId,
                plantId: plantId,
                userId: userId,
                wateredAt: wateredAt,
                source: source,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String plantId,
                Value<String?> userId = const Value.absent(),
                required DateTime wateredAt,
                required String source,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WateringEventsCompanion.insert(
                id: id,
                householdId: householdId,
                plantId: plantId,
                userId: userId,
                wateredAt: wateredAt,
                source: source,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WateringEventsTable, WateringEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WateringEventsTable,
                    WateringEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WateringEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WateringEventsTable,
      WateringEventRow,
      $$WateringEventsTableFilterComposer,
      $$WateringEventsTableOrderingComposer,
      $$WateringEventsTableAnnotationComposer,
      $$WateringEventsTableCreateCompanionBuilder,
      $$WateringEventsTableUpdateCompanionBuilder,
      (
        WateringEventRow,
        BaseReferences<_$AppDatabase, $WateringEventsTable, WateringEventRow>,
      ),
      WateringEventRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  required String changeId,
  required String householdId,
  required String entity,
  required String op,
  required String rowId,
  Value<String?> fields,
  Value<String?> patch,
  required DateTime createdAt,
  Value<String?> batchKey,
  Value<int> attempts,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  Value<String> changeId,
  Value<String> householdId,
  Value<String> entity,
  Value<String> op,
  Value<String> rowId,
  Value<String?> fields,
  Value<String?> patch,
  Value<DateTime> createdAt,
  Value<String?> batchKey,
  Value<int> attempts,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeId => $composableBuilder(
    column: $table.changeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fields => $composableBuilder(
    column: $table.fields,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchKey => $composableBuilder(
    column: $table.batchKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeId => $composableBuilder(
    column: $table.changeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fields => $composableBuilder(
    column: $table.fields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchKey => $composableBuilder(
    column: $table.batchKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get changeId =>
      $composableBuilder(column: $table.changeId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get fields =>
      $composableBuilder(column: $table.fields, builder: (column) => column);

  GeneratedColumn<String> get patch =>
      $composableBuilder(column: $table.patch, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get batchKey =>
      $composableBuilder(column: $table.batchKey, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> changeId = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String?> fields = const Value.absent(),
                Value<String?> patch = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> batchKey = const Value.absent(),
                Value<int> attempts = const Value.absent(),
              }) => OutboxCompanion(
                seq: seq,
                changeId: changeId,
                householdId: householdId,
                entity: entity,
                op: op,
                rowId: rowId,
                fields: fields,
                patch: patch,
                createdAt: createdAt,
                batchKey: batchKey,
                attempts: attempts,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String changeId,
                required String householdId,
                required String entity,
                required String op,
                required String rowId,
                Value<String?> fields = const Value.absent(),
                Value<String?> patch = const Value.absent(),
                required DateTime createdAt,
                Value<String?> batchKey = const Value.absent(),
                Value<int> attempts = const Value.absent(),
              }) => OutboxCompanion.insert(
                seq: seq,
                changeId: changeId,
                householdId: householdId,
                entity: entity,
                op: op,
                rowId: rowId,
                fields: fields,
                patch: patch,
                createdAt: createdAt,
                batchKey: batchKey,
                attempts: attempts,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStatesTableCreateCompanionBuilder = SyncStatesCompanion Function({
  required String householdId,
  Value<String?> cursor,
  Value<DateTime?> pulledAt,
  Value<bool> fullPullNeeded,
  Value<int> rowid,
});
typedef $$SyncStatesTableUpdateCompanionBuilder = SyncStatesCompanion Function({
  Value<String> householdId,
  Value<String?> cursor,
  Value<DateTime?> pulledAt,
  Value<bool> fullPullNeeded,
  Value<int> rowid,
});

class $$SyncStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pulledAt => $composableBuilder(
    column: $table.pulledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullPullNeeded => $composableBuilder(
    column: $table.fullPullNeeded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pulledAt => $composableBuilder(
    column: $table.pulledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullPullNeeded => $composableBuilder(
    column: $table.fullPullNeeded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<DateTime> get pulledAt =>
      $composableBuilder(column: $table.pulledAt, builder: (column) => column);

  GeneratedColumn<bool> get fullPullNeeded => $composableBuilder(
    column: $table.fullPullNeeded,
    builder: (column) => column,
  );
}

class $$SyncStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStatesTable,
          SyncStateRow,
          $$SyncStatesTableFilterComposer,
          $$SyncStatesTableOrderingComposer,
          $$SyncStatesTableAnnotationComposer,
          $$SyncStatesTableCreateCompanionBuilder,
          $$SyncStatesTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStatesTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStatesTableTableManager(_$AppDatabase db, $SyncStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> householdId = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> pulledAt = const Value.absent(),
                Value<bool> fullPullNeeded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion(
                householdId: householdId,
                cursor: cursor,
                pulledAt: pulledAt,
                fullPullNeeded: fullPullNeeded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String householdId,
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> pulledAt = const Value.absent(),
                Value<bool> fullPullNeeded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion.insert(
                householdId: householdId,
                cursor: cursor,
                pulledAt: pulledAt,
                fullPullNeeded: fullPullNeeded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStatesTable, SyncStateRow>(table),
                  BaseReferences<_$AppDatabase, $SyncStatesTable, SyncStateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStatesTable,
      SyncStateRow,
      $$SyncStatesTableFilterComposer,
      $$SyncStatesTableOrderingComposer,
      $$SyncStatesTableAnnotationComposer,
      $$SyncStatesTableCreateCompanionBuilder,
      $$SyncStatesTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStatesTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$WateringEventsTableTableManager get wateringEvents =>
      $$WateringEventsTableTableManager(_db, _db.wateringEvents);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncStatesTableTableManager get syncStates =>
      $$SyncStatesTableTableManager(_db, _db.syncStates);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The open database for the whole app. Tests override it with an in-memory
/// one.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The open database for the whole app. Tests override it with an in-memory
/// one.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The open database for the whole app. Tests override it with an in-memory
  /// one.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'a2c854720496454719598a8b7b2cf7f2560992b8';
