// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailVerifiedAtMeta = const VerificationMeta(
    'emailVerifiedAt',
  );
  @override
  late final GeneratedColumn<String> emailVerifiedAt = GeneratedColumn<String>(
    'email_verified_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentHouseholdIdMeta =
      const VerificationMeta('currentHouseholdId');
  @override
  late final GeneratedColumn<int> currentHouseholdId = GeneratedColumn<int>(
    'current_household_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    emailVerifiedAt,
    currentHouseholdId,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('email_verified_at')) {
      context.handle(
        _emailVerifiedAtMeta,
        emailVerifiedAt.isAcceptableOrUnknown(
          data['email_verified_at']!,
          _emailVerifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('current_household_id')) {
      context.handle(
        _currentHouseholdIdMeta,
        currentHouseholdId.isAcceptableOrUnknown(
          data['current_household_id']!,
          _currentHouseholdIdMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      emailVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_verified_at'],
      ),
      currentHouseholdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_household_id'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final int? currentHouseholdId;
  final DateTime syncedAt;
  const LocalUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.currentHouseholdId,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || emailVerifiedAt != null) {
      map['email_verified_at'] = Variable<String>(emailVerifiedAt);
    }
    if (!nullToAbsent || currentHouseholdId != null) {
      map['current_household_id'] = Variable<int>(currentHouseholdId);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      emailVerifiedAt: emailVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(emailVerifiedAt),
      currentHouseholdId: currentHouseholdId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentHouseholdId),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      emailVerifiedAt: serializer.fromJson<String?>(json['emailVerifiedAt']),
      currentHouseholdId: serializer.fromJson<int?>(json['currentHouseholdId']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'emailVerifiedAt': serializer.toJson<String?>(emailVerifiedAt),
      'currentHouseholdId': serializer.toJson<int?>(currentHouseholdId),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalUser copyWith({
    int? id,
    String? name,
    String? email,
    Value<String?> emailVerifiedAt = const Value.absent(),
    Value<int?> currentHouseholdId = const Value.absent(),
    DateTime? syncedAt,
  }) => LocalUser(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    emailVerifiedAt: emailVerifiedAt.present
        ? emailVerifiedAt.value
        : this.emailVerifiedAt,
    currentHouseholdId: currentHouseholdId.present
        ? currentHouseholdId.value
        : this.currentHouseholdId,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      emailVerifiedAt: data.emailVerifiedAt.present
          ? data.emailVerifiedAt.value
          : this.emailVerifiedAt,
      currentHouseholdId: data.currentHouseholdId.present
          ? data.currentHouseholdId.value
          : this.currentHouseholdId,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('currentHouseholdId: $currentHouseholdId, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    emailVerifiedAt,
    currentHouseholdId,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.emailVerifiedAt == this.emailVerifiedAt &&
          other.currentHouseholdId == this.currentHouseholdId &&
          other.syncedAt == this.syncedAt);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> emailVerifiedAt;
  final Value<int?> currentHouseholdId;
  final Value<DateTime> syncedAt;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.currentHouseholdId = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    this.emailVerifiedAt = const Value.absent(),
    this.currentHouseholdId = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : name = Value(name),
       email = Value(email);
  static Insertable<LocalUser> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? emailVerifiedAt,
    Expression<int>? currentHouseholdId,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
      if (currentHouseholdId != null)
        'current_household_id': currentHouseholdId,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalUsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? emailVerifiedAt,
    Value<int?>? currentHouseholdId,
    Value<DateTime>? syncedAt,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      currentHouseholdId: currentHouseholdId ?? this.currentHouseholdId,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (emailVerifiedAt.present) {
      map['email_verified_at'] = Variable<String>(emailVerifiedAt.value);
    }
    if (currentHouseholdId.present) {
      map['current_household_id'] = Variable<int>(currentHouseholdId.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('currentHouseholdId: $currentHouseholdId, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalHouseholdsTable extends LocalHouseholds
    with TableInfo<$LocalHouseholdsTable, LocalHousehold> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalHouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, role, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_households';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalHousehold> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalHousehold map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHousehold(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalHouseholdsTable createAlias(String alias) {
    return $LocalHouseholdsTable(attachedDatabase, alias);
  }
}

class LocalHousehold extends DataClass implements Insertable<LocalHousehold> {
  final int id;
  final String name;
  final String role;
  final DateTime syncedAt;
  const LocalHousehold({
    required this.id,
    required this.name,
    required this.role,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalHouseholdsCompanion toCompanion(bool nullToAbsent) {
    return LocalHouseholdsCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalHousehold.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHousehold(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalHousehold copyWith({
    int? id,
    String? name,
    String? role,
    DateTime? syncedAt,
  }) => LocalHousehold(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalHousehold copyWithCompanion(LocalHouseholdsCompanion data) {
    return LocalHousehold(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHousehold(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, role, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHousehold &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.syncedAt == this.syncedAt);
}

class LocalHouseholdsCompanion extends UpdateCompanion<LocalHousehold> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> role;
  final Value<DateTime> syncedAt;
  const LocalHouseholdsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalHouseholdsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String role,
    this.syncedAt = const Value.absent(),
  }) : name = Value(name),
       role = Value(role);
  static Insertable<LocalHousehold> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalHouseholdsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? role,
    Value<DateTime>? syncedAt,
  }) {
    return LocalHouseholdsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalHouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalAccountsTable extends LocalAccounts
    with TableInfo<$LocalAccountsTable, LocalAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PHP'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    name,
    type,
    balanceCents,
    currencyCode,
    isActive,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalAccountsTable createAlias(String alias) {
    return $LocalAccountsTable(attachedDatabase, alias);
  }
}

class LocalAccount extends DataClass implements Insertable<LocalAccount> {
  final int id;
  final int householdId;
  final String name;
  final String type;
  final int balanceCents;
  final String currencyCode;
  final bool isActive;
  final DateTime syncedAt;
  const LocalAccount({
    required this.id,
    required this.householdId,
    required this.name,
    required this.type,
    required this.balanceCents,
    required this.currencyCode,
    required this.isActive,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['currency_code'] = Variable<String>(currencyCode);
    map['is_active'] = Variable<bool>(isActive);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalAccountsCompanion toCompanion(bool nullToAbsent) {
    return LocalAccountsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      type: Value(type),
      balanceCents: Value(balanceCents),
      currencyCode: Value(currencyCode),
      isActive: Value(isActive),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAccount(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'isActive': serializer.toJson<bool>(isActive),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalAccount copyWith({
    int? id,
    int? householdId,
    String? name,
    String? type,
    int? balanceCents,
    String? currencyCode,
    bool? isActive,
    DateTime? syncedAt,
  }) => LocalAccount(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    type: type ?? this.type,
    balanceCents: balanceCents ?? this.balanceCents,
    currencyCode: currencyCode ?? this.currencyCode,
    isActive: isActive ?? this.isActive,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalAccount copyWithCompanion(LocalAccountsCompanion data) {
    return LocalAccount(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAccount(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    name,
    type,
    balanceCents,
    currencyCode,
    isActive,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAccount &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.type == this.type &&
          other.balanceCents == this.balanceCents &&
          other.currencyCode == this.currencyCode &&
          other.isActive == this.isActive &&
          other.syncedAt == this.syncedAt);
}

class LocalAccountsCompanion extends UpdateCompanion<LocalAccount> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<String> name;
  final Value<String> type;
  final Value<int> balanceCents;
  final Value<String> currencyCode;
  final Value<bool> isActive;
  final Value<DateTime> syncedAt;
  const LocalAccountsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalAccountsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required String name,
    required String type,
    this.balanceCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       name = Value(name),
       type = Value(type);
  static Insertable<LocalAccount> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? balanceCents,
    Expression<String>? currencyCode,
    Expression<bool>? isActive,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (isActive != null) 'is_active': isActive,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalAccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<String>? name,
    Value<String>? type,
    Value<int>? balanceCents,
    Value<String>? currencyCode,
    Value<bool>? isActive,
    Value<DateTime>? syncedAt,
  }) {
    return LocalAccountsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      type: type ?? this.type,
      balanceCents: balanceCents ?? this.balanceCents,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAccountsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalCategoriesTable extends LocalCategories
    with TableInfo<$LocalCategoriesTable, LocalCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    parentId,
    name,
    type,
    icon,
    colorHex,
    isSystem,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalCategoriesTable createAlias(String alias) {
    return $LocalCategoriesTable(attachedDatabase, alias);
  }
}

class LocalCategory extends DataClass implements Insertable<LocalCategory> {
  final int id;
  final int householdId;
  final int? parentId;
  final String name;
  final String type;
  final String? icon;
  final String? colorHex;
  final bool isSystem;
  final DateTime syncedAt;
  const LocalCategory({
    required this.id,
    required this.householdId,
    this.parentId,
    required this.name,
    required this.type,
    this.icon,
    this.colorHex,
    required this.isSystem,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LocalCategoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      isSystem: Value(isSystem),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCategory(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String?>(json['icon']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'parentId': serializer.toJson<int?>(parentId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String?>(icon),
      'colorHex': serializer.toJson<String?>(colorHex),
      'isSystem': serializer.toJson<bool>(isSystem),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalCategory copyWith({
    int? id,
    int? householdId,
    Value<int?> parentId = const Value.absent(),
    String? name,
    String? type,
    Value<String?> icon = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    bool? isSystem,
    DateTime? syncedAt,
  }) => LocalCategory(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    type: type ?? this.type,
    icon: icon.present ? icon.value : this.icon,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    isSystem: isSystem ?? this.isSystem,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalCategory copyWithCompanion(LocalCategoriesCompanion data) {
    return LocalCategory(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategory(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isSystem: $isSystem, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    parentId,
    name,
    type,
    icon,
    colorHex,
    isSystem,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCategory &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.isSystem == this.isSystem &&
          other.syncedAt == this.syncedAt);
}

class LocalCategoriesCompanion extends UpdateCompanion<LocalCategory> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<int?> parentId;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> icon;
  final Value<String?> colorHex;
  final Value<bool> isSystem;
  final Value<DateTime> syncedAt;
  const LocalCategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    this.parentId = const Value.absent(),
    required String name,
    required String type,
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       name = Value(name),
       type = Value(type);
  static Insertable<LocalCategory> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<int>? parentId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<bool>? isSystem,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (isSystem != null) 'is_system': isSystem,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<int?>? parentId,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? icon,
    Value<String?>? colorHex,
    Value<bool>? isSystem,
    Value<DateTime>? syncedAt,
  }) {
    return LocalCategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isSystem: isSystem ?? this.isSystem,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isSystem: $isSystem, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalTransactionsTable extends LocalTransactions
    with TableInfo<$LocalTransactionsTable, LocalTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
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
  static const VerificationMeta _importHashMeta = const VerificationMeta(
    'importHash',
  );
  @override
  late final GeneratedColumn<String> importHash = GeneratedColumn<String>(
    'import_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<bool> isPending = GeneratedColumn<bool>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    accountId,
    categoryId,
    amountCents,
    type,
    date,
    payee,
    notes,
    importHash,
    createdBy,
    isPending,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('import_hash')) {
      context.handle(
        _importHashMeta,
        importHash.isAcceptableOrUnknown(data['import_hash']!, _importHashMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      importHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_hash'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalTransactionsTable createAlias(String alias) {
    return $LocalTransactionsTable(attachedDatabase, alias);
  }
}

class LocalTransaction extends DataClass
    implements Insertable<LocalTransaction> {
  final int id;
  final int householdId;
  final int accountId;
  final int? categoryId;
  final int amountCents;
  final String type;
  final DateTime date;
  final String? payee;
  final String? notes;
  final String? importHash;
  final int createdBy;
  final bool isPending;
  final DateTime syncedAt;
  const LocalTransaction({
    required this.id,
    required this.householdId,
    required this.accountId,
    this.categoryId,
    required this.amountCents,
    required this.type,
    required this.date,
    this.payee,
    this.notes,
    this.importHash,
    required this.createdBy,
    required this.isPending,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || importHash != null) {
      map['import_hash'] = Variable<String>(importHash);
    }
    map['created_by'] = Variable<int>(createdBy);
    map['is_pending'] = Variable<bool>(isPending);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalTransactionsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransactionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountCents: Value(amountCents),
      type: Value(type),
      date: Value(date),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      importHash: importHash == null && nullToAbsent
          ? const Value.absent()
          : Value(importHash),
      createdBy: Value(createdBy),
      isPending: Value(isPending),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransaction(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      payee: serializer.fromJson<String?>(json['payee']),
      notes: serializer.fromJson<String?>(json['notes']),
      importHash: serializer.fromJson<String?>(json['importHash']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
      isPending: serializer.fromJson<bool>(json['isPending']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'amountCents': serializer.toJson<int>(amountCents),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'payee': serializer.toJson<String?>(payee),
      'notes': serializer.toJson<String?>(notes),
      'importHash': serializer.toJson<String?>(importHash),
      'createdBy': serializer.toJson<int>(createdBy),
      'isPending': serializer.toJson<bool>(isPending),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalTransaction copyWith({
    int? id,
    int? householdId,
    int? accountId,
    Value<int?> categoryId = const Value.absent(),
    int? amountCents,
    String? type,
    DateTime? date,
    Value<String?> payee = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> importHash = const Value.absent(),
    int? createdBy,
    bool? isPending,
    DateTime? syncedAt,
  }) => LocalTransaction(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountCents: amountCents ?? this.amountCents,
    type: type ?? this.type,
    date: date ?? this.date,
    payee: payee.present ? payee.value : this.payee,
    notes: notes.present ? notes.value : this.notes,
    importHash: importHash.present ? importHash.value : this.importHash,
    createdBy: createdBy ?? this.createdBy,
    isPending: isPending ?? this.isPending,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalTransaction copyWithCompanion(LocalTransactionsCompanion data) {
    return LocalTransaction(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      payee: data.payee.present ? data.payee.value : this.payee,
      notes: data.notes.present ? data.notes.value : this.notes,
      importHash: data.importHash.present
          ? data.importHash.value
          : this.importHash,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransaction(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('importHash: $importHash, ')
          ..write('createdBy: $createdBy, ')
          ..write('isPending: $isPending, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    accountId,
    categoryId,
    amountCents,
    type,
    date,
    payee,
    notes,
    importHash,
    createdBy,
    isPending,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransaction &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.amountCents == this.amountCents &&
          other.type == this.type &&
          other.date == this.date &&
          other.payee == this.payee &&
          other.notes == this.notes &&
          other.importHash == this.importHash &&
          other.createdBy == this.createdBy &&
          other.isPending == this.isPending &&
          other.syncedAt == this.syncedAt);
}

class LocalTransactionsCompanion extends UpdateCompanion<LocalTransaction> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<int> amountCents;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<String?> payee;
  final Value<String?> notes;
  final Value<String?> importHash;
  final Value<int> createdBy;
  final Value<bool> isPending;
  final Value<DateTime> syncedAt;
  const LocalTransactionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.importHash = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isPending = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required int accountId,
    this.categoryId = const Value.absent(),
    required int amountCents,
    required String type,
    required DateTime date,
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.importHash = const Value.absent(),
    required int createdBy,
    this.isPending = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       accountId = Value(accountId),
       amountCents = Value(amountCents),
       type = Value(type),
       date = Value(date),
       createdBy = Value(createdBy);
  static Insertable<LocalTransaction> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? amountCents,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<String>? payee,
    Expression<String>? notes,
    Expression<String>? importHash,
    Expression<int>? createdBy,
    Expression<bool>? isPending,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (payee != null) 'payee': payee,
      if (notes != null) 'notes': notes,
      if (importHash != null) 'import_hash': importHash,
      if (createdBy != null) 'created_by': createdBy,
      if (isPending != null) 'is_pending': isPending,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<int>? accountId,
    Value<int?>? categoryId,
    Value<int>? amountCents,
    Value<String>? type,
    Value<DateTime>? date,
    Value<String?>? payee,
    Value<String?>? notes,
    Value<String?>? importHash,
    Value<int>? createdBy,
    Value<bool>? isPending,
    Value<DateTime>? syncedAt,
  }) {
    return LocalTransactionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      type: type ?? this.type,
      date: date ?? this.date,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      importHash: importHash ?? this.importHash,
      createdBy: createdBy ?? this.createdBy,
      isPending: isPending ?? this.isPending,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (importHash.present) {
      map['import_hash'] = Variable<String>(importHash.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<bool>(isPending.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('importHash: $importHash, ')
          ..write('createdBy: $createdBy, ')
          ..write('isPending: $isPending, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalBudgetsTable extends LocalBudgets
    with TableInfo<$LocalBudgetsTable, LocalBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedCentsMeta = const VerificationMeta(
    'plannedCents',
  );
  @override
  late final GeneratedColumn<int> plannedCents = GeneratedColumn<int>(
    'planned_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    categoryId,
    year,
    month,
    plannedCents,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBudget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('planned_cents')) {
      context.handle(
        _plannedCentsMeta,
        plannedCents.isAcceptableOrUnknown(
          data['planned_cents']!,
          _plannedCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedCentsMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBudget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      plannedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_cents'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalBudgetsTable createAlias(String alias) {
    return $LocalBudgetsTable(attachedDatabase, alias);
  }
}

class LocalBudget extends DataClass implements Insertable<LocalBudget> {
  final int id;
  final int householdId;
  final int categoryId;
  final int year;
  final int month;
  final int plannedCents;
  final DateTime syncedAt;
  const LocalBudget({
    required this.id,
    required this.householdId,
    required this.categoryId,
    required this.year,
    required this.month,
    required this.plannedCents,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['category_id'] = Variable<int>(categoryId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['planned_cents'] = Variable<int>(plannedCents);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalBudgetsCompanion toCompanion(bool nullToAbsent) {
    return LocalBudgetsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      categoryId: Value(categoryId),
      year: Value(year),
      month: Value(month),
      plannedCents: Value(plannedCents),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalBudget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBudget(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      plannedCents: serializer.fromJson<int>(json['plannedCents']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'categoryId': serializer.toJson<int>(categoryId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'plannedCents': serializer.toJson<int>(plannedCents),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalBudget copyWith({
    int? id,
    int? householdId,
    int? categoryId,
    int? year,
    int? month,
    int? plannedCents,
    DateTime? syncedAt,
  }) => LocalBudget(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    categoryId: categoryId ?? this.categoryId,
    year: year ?? this.year,
    month: month ?? this.month,
    plannedCents: plannedCents ?? this.plannedCents,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalBudget copyWithCompanion(LocalBudgetsCompanion data) {
    return LocalBudget(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      plannedCents: data.plannedCents.present
          ? data.plannedCents.value
          : this.plannedCents,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBudget(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('plannedCents: $plannedCents, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    categoryId,
    year,
    month,
    plannedCents,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBudget &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.categoryId == this.categoryId &&
          other.year == this.year &&
          other.month == this.month &&
          other.plannedCents == this.plannedCents &&
          other.syncedAt == this.syncedAt);
}

class LocalBudgetsCompanion extends UpdateCompanion<LocalBudget> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<int> categoryId;
  final Value<int> year;
  final Value<int> month;
  final Value<int> plannedCents;
  final Value<DateTime> syncedAt;
  const LocalBudgetsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.plannedCents = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required int categoryId,
    required int year,
    required int month,
    required int plannedCents,
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       categoryId = Value(categoryId),
       year = Value(year),
       month = Value(month),
       plannedCents = Value(plannedCents);
  static Insertable<LocalBudget> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<int>? categoryId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? plannedCents,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (categoryId != null) 'category_id': categoryId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (plannedCents != null) 'planned_cents': plannedCents,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalBudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<int>? categoryId,
    Value<int>? year,
    Value<int>? month,
    Value<int>? plannedCents,
    Value<DateTime>? syncedAt,
  }) {
    return LocalBudgetsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      categoryId: categoryId ?? this.categoryId,
      year: year ?? this.year,
      month: month ?? this.month,
      plannedCents: plannedCents ?? this.plannedCents,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (plannedCents.present) {
      map['planned_cents'] = Variable<int>(plannedCents.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('plannedCents: $plannedCents, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalGoalsTable extends LocalGoals
    with TableInfo<$LocalGoalsTable, LocalGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _targetCentsMeta = const VerificationMeta(
    'targetCents',
  );
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
    'target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentCentsMeta = const VerificationMeta(
    'currentCents',
  );
  @override
  late final GeneratedColumn<int> currentCents = GeneratedColumn<int>(
    'current_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    name,
    targetCents,
    currentCents,
    dueDate,
    type,
    notes,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_cents')) {
      context.handle(
        _targetCentsMeta,
        targetCents.isAcceptableOrUnknown(
          data['target_cents']!,
          _targetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCentsMeta);
    }
    if (data.containsKey('current_cents')) {
      context.handle(
        _currentCentsMeta,
        currentCents.isAcceptableOrUnknown(
          data['current_cents']!,
          _currentCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentCentsMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cents'],
      )!,
      currentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_cents'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalGoalsTable createAlias(String alias) {
    return $LocalGoalsTable(attachedDatabase, alias);
  }
}

class LocalGoal extends DataClass implements Insertable<LocalGoal> {
  final int id;
  final int householdId;
  final String name;
  final int targetCents;
  final int currentCents;
  final DateTime? dueDate;
  final String type;
  final String? notes;
  final DateTime syncedAt;
  const LocalGoal({
    required this.id,
    required this.householdId,
    required this.name,
    required this.targetCents,
    required this.currentCents,
    this.dueDate,
    required this.type,
    this.notes,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['name'] = Variable<String>(name);
    map['target_cents'] = Variable<int>(targetCents);
    map['current_cents'] = Variable<int>(currentCents);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalGoalsCompanion toCompanion(bool nullToAbsent) {
    return LocalGoalsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      targetCents: Value(targetCents),
      currentCents: Value(currentCents),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      type: Value(type),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalGoal(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      targetCents: serializer.fromJson<int>(json['targetCents']),
      currentCents: serializer.fromJson<int>(json['currentCents']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      type: serializer.fromJson<String>(json['type']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'name': serializer.toJson<String>(name),
      'targetCents': serializer.toJson<int>(targetCents),
      'currentCents': serializer.toJson<int>(currentCents),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'type': serializer.toJson<String>(type),
      'notes': serializer.toJson<String?>(notes),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalGoal copyWith({
    int? id,
    int? householdId,
    String? name,
    int? targetCents,
    int? currentCents,
    Value<DateTime?> dueDate = const Value.absent(),
    String? type,
    Value<String?> notes = const Value.absent(),
    DateTime? syncedAt,
  }) => LocalGoal(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    targetCents: targetCents ?? this.targetCents,
    currentCents: currentCents ?? this.currentCents,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    type: type ?? this.type,
    notes: notes.present ? notes.value : this.notes,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalGoal copyWithCompanion(LocalGoalsCompanion data) {
    return LocalGoal(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      targetCents: data.targetCents.present
          ? data.targetCents.value
          : this.targetCents,
      currentCents: data.currentCents.present
          ? data.currentCents.value
          : this.currentCents,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalGoal(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('currentCents: $currentCents, ')
          ..write('dueDate: $dueDate, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    name,
    targetCents,
    currentCents,
    dueDate,
    type,
    notes,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalGoal &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.targetCents == this.targetCents &&
          other.currentCents == this.currentCents &&
          other.dueDate == this.dueDate &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.syncedAt == this.syncedAt);
}

class LocalGoalsCompanion extends UpdateCompanion<LocalGoal> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<String> name;
  final Value<int> targetCents;
  final Value<int> currentCents;
  final Value<DateTime?> dueDate;
  final Value<String> type;
  final Value<String?> notes;
  final Value<DateTime> syncedAt;
  const LocalGoalsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.currentCents = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalGoalsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required String name,
    required int targetCents,
    required int currentCents,
    this.dueDate = const Value.absent(),
    required String type,
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       name = Value(name),
       targetCents = Value(targetCents),
       currentCents = Value(currentCents),
       type = Value(type);
  static Insertable<LocalGoal> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<String>? name,
    Expression<int>? targetCents,
    Expression<int>? currentCents,
    Expression<DateTime>? dueDate,
    Expression<String>? type,
    Expression<String>? notes,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (targetCents != null) 'target_cents': targetCents,
      if (currentCents != null) 'current_cents': currentCents,
      if (dueDate != null) 'due_date': dueDate,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalGoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<String>? name,
    Value<int>? targetCents,
    Value<int>? currentCents,
    Value<DateTime?>? dueDate,
    Value<String>? type,
    Value<String?>? notes,
    Value<DateTime>? syncedAt,
  }) {
    return LocalGoalsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      targetCents: targetCents ?? this.targetCents,
      currentCents: currentCents ?? this.currentCents,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (currentCents.present) {
      map['current_cents'] = Variable<int>(currentCents.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalGoalsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('currentCents: $currentCents, ')
          ..write('dueDate: $dueDate, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalRecurringBillsTable extends LocalRecurringBills
    with TableInfo<$LocalRecurringBillsTable, LocalRecurringBill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRecurringBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
    'next_due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoPayMeta = const VerificationMeta(
    'autoPay',
  );
  @override
  late final GeneratedColumn<bool> autoPay = GeneratedColumn<bool>(
    'auto_pay',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_pay" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    name,
    amountCents,
    frequency,
    nextDue,
    categoryId,
    autoPay,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_recurring_bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRecurringBill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('auto_pay')) {
      context.handle(
        _autoPayMeta,
        autoPay.isAcceptableOrUnknown(data['auto_pay']!, _autoPayMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalRecurringBill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRecurringBill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      nextDue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      autoPay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_pay'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalRecurringBillsTable createAlias(String alias) {
    return $LocalRecurringBillsTable(attachedDatabase, alias);
  }
}

class LocalRecurringBill extends DataClass
    implements Insertable<LocalRecurringBill> {
  final int id;
  final int householdId;
  final String name;
  final int amountCents;
  final String frequency;
  final DateTime nextDue;
  final int? categoryId;
  final bool autoPay;
  final DateTime syncedAt;
  const LocalRecurringBill({
    required this.id,
    required this.householdId,
    required this.name,
    required this.amountCents,
    required this.frequency,
    required this.nextDue,
    this.categoryId,
    required this.autoPay,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['name'] = Variable<String>(name);
    map['amount_cents'] = Variable<int>(amountCents);
    map['frequency'] = Variable<String>(frequency);
    map['next_due'] = Variable<DateTime>(nextDue);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['auto_pay'] = Variable<bool>(autoPay);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalRecurringBillsCompanion toCompanion(bool nullToAbsent) {
    return LocalRecurringBillsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      amountCents: Value(amountCents),
      frequency: Value(frequency),
      nextDue: Value(nextDue),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      autoPay: Value(autoPay),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalRecurringBill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRecurringBill(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      frequency: serializer.fromJson<String>(json['frequency']),
      nextDue: serializer.fromJson<DateTime>(json['nextDue']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      autoPay: serializer.fromJson<bool>(json['autoPay']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'name': serializer.toJson<String>(name),
      'amountCents': serializer.toJson<int>(amountCents),
      'frequency': serializer.toJson<String>(frequency),
      'nextDue': serializer.toJson<DateTime>(nextDue),
      'categoryId': serializer.toJson<int?>(categoryId),
      'autoPay': serializer.toJson<bool>(autoPay),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalRecurringBill copyWith({
    int? id,
    int? householdId,
    String? name,
    int? amountCents,
    String? frequency,
    DateTime? nextDue,
    Value<int?> categoryId = const Value.absent(),
    bool? autoPay,
    DateTime? syncedAt,
  }) => LocalRecurringBill(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    amountCents: amountCents ?? this.amountCents,
    frequency: frequency ?? this.frequency,
    nextDue: nextDue ?? this.nextDue,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    autoPay: autoPay ?? this.autoPay,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalRecurringBill copyWithCompanion(LocalRecurringBillsCompanion data) {
    return LocalRecurringBill(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      autoPay: data.autoPay.present ? data.autoPay.value : this.autoPay,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecurringBill(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDue: $nextDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('autoPay: $autoPay, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    name,
    amountCents,
    frequency,
    nextDue,
    categoryId,
    autoPay,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRecurringBill &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.amountCents == this.amountCents &&
          other.frequency == this.frequency &&
          other.nextDue == this.nextDue &&
          other.categoryId == this.categoryId &&
          other.autoPay == this.autoPay &&
          other.syncedAt == this.syncedAt);
}

class LocalRecurringBillsCompanion extends UpdateCompanion<LocalRecurringBill> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<String> name;
  final Value<int> amountCents;
  final Value<String> frequency;
  final Value<DateTime> nextDue;
  final Value<int?> categoryId;
  final Value<bool> autoPay;
  final Value<DateTime> syncedAt;
  const LocalRecurringBillsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LocalRecurringBillsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required String name,
    required int amountCents,
    required String frequency,
    required DateTime nextDue,
    this.categoryId = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : householdId = Value(householdId),
       name = Value(name),
       amountCents = Value(amountCents),
       frequency = Value(frequency),
       nextDue = Value(nextDue);
  static Insertable<LocalRecurringBill> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<String>? name,
    Expression<int>? amountCents,
    Expression<String>? frequency,
    Expression<DateTime>? nextDue,
    Expression<int>? categoryId,
    Expression<bool>? autoPay,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (amountCents != null) 'amount_cents': amountCents,
      if (frequency != null) 'frequency': frequency,
      if (nextDue != null) 'next_due': nextDue,
      if (categoryId != null) 'category_id': categoryId,
      if (autoPay != null) 'auto_pay': autoPay,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LocalRecurringBillsCompanion copyWith({
    Value<int>? id,
    Value<int>? householdId,
    Value<String>? name,
    Value<int>? amountCents,
    Value<String>? frequency,
    Value<DateTime>? nextDue,
    Value<int?>? categoryId,
    Value<bool>? autoPay,
    Value<DateTime>? syncedAt,
  }) {
    return LocalRecurringBillsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      amountCents: amountCents ?? this.amountCents,
      frequency: frequency ?? this.frequency,
      nextDue: nextDue ?? this.nextDue,
      categoryId: categoryId ?? this.categoryId,
      autoPay: autoPay ?? this.autoPay,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (autoPay.present) {
      map['auto_pay'] = Variable<bool>(autoPay.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecurringBillsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDue: $nextDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('autoPay: $autoPay, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $OfflineQueueTable extends OfflineQueue
    with TableInfo<$OfflineQueueTable, OfflineQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFailedMeta = const VerificationMeta(
    'isFailed',
  );
  @override
  late final GeneratedColumn<bool> isFailed = GeneratedColumn<bool>(
    'is_failed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_failed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    method,
    path,
    body,
    retryCount,
    createdAt,
    lastAttemptAt,
    errorMessage,
    isFailed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('is_failed')) {
      context.handle(
        _isFailedMeta,
        isFailed.isAcceptableOrUnknown(data['is_failed']!, _isFailedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      isFailed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_failed'],
      )!,
    );
  }

  @override
  $OfflineQueueTable createAlias(String alias) {
    return $OfflineQueueTable(attachedDatabase, alias);
  }
}

class OfflineQueueData extends DataClass
    implements Insertable<OfflineQueueData> {
  final int id;
  final String method;
  final String path;
  final String? body;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String? errorMessage;
  final bool isFailed;
  const OfflineQueueData({
    required this.id,
    required this.method,
    required this.path,
    this.body,
    required this.retryCount,
    required this.createdAt,
    this.lastAttemptAt,
    this.errorMessage,
    required this.isFailed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['method'] = Variable<String>(method);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['is_failed'] = Variable<bool>(isFailed);
    return map;
  }

  OfflineQueueCompanion toCompanion(bool nullToAbsent) {
    return OfflineQueueCompanion(
      id: Value(id),
      method: Value(method),
      path: Value(path),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      isFailed: Value(isFailed),
    );
  }

  factory OfflineQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineQueueData(
      id: serializer.fromJson<int>(json['id']),
      method: serializer.fromJson<String>(json['method']),
      path: serializer.fromJson<String>(json['path']),
      body: serializer.fromJson<String?>(json['body']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      isFailed: serializer.fromJson<bool>(json['isFailed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'method': serializer.toJson<String>(method),
      'path': serializer.toJson<String>(path),
      'body': serializer.toJson<String?>(body),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'isFailed': serializer.toJson<bool>(isFailed),
    };
  }

  OfflineQueueData copyWith({
    int? id,
    String? method,
    String? path,
    Value<String?> body = const Value.absent(),
    int? retryCount,
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    bool? isFailed,
  }) => OfflineQueueData(
    id: id ?? this.id,
    method: method ?? this.method,
    path: path ?? this.path,
    body: body.present ? body.value : this.body,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    isFailed: isFailed ?? this.isFailed,
  );
  OfflineQueueData copyWithCompanion(OfflineQueueCompanion data) {
    return OfflineQueueData(
      id: data.id.present ? data.id.value : this.id,
      method: data.method.present ? data.method.value : this.method,
      path: data.path.present ? data.path.value : this.path,
      body: data.body.present ? data.body.value : this.body,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      isFailed: data.isFailed.present ? data.isFailed.value : this.isFailed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueData(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('path: $path, ')
          ..write('body: $body, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('isFailed: $isFailed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    method,
    path,
    body,
    retryCount,
    createdAt,
    lastAttemptAt,
    errorMessage,
    isFailed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineQueueData &&
          other.id == this.id &&
          other.method == this.method &&
          other.path == this.path &&
          other.body == this.body &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.errorMessage == this.errorMessage &&
          other.isFailed == this.isFailed);
}

class OfflineQueueCompanion extends UpdateCompanion<OfflineQueueData> {
  final Value<int> id;
  final Value<String> method;
  final Value<String> path;
  final Value<String?> body;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> errorMessage;
  final Value<bool> isFailed;
  const OfflineQueueCompanion({
    this.id = const Value.absent(),
    this.method = const Value.absent(),
    this.path = const Value.absent(),
    this.body = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.isFailed = const Value.absent(),
  });
  OfflineQueueCompanion.insert({
    this.id = const Value.absent(),
    required String method,
    required String path,
    this.body = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.isFailed = const Value.absent(),
  }) : method = Value(method),
       path = Value(path);
  static Insertable<OfflineQueueData> custom({
    Expression<int>? id,
    Expression<String>? method,
    Expression<String>? path,
    Expression<String>? body,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? errorMessage,
    Expression<bool>? isFailed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (method != null) 'method': method,
      if (path != null) 'path': path,
      if (body != null) 'body': body,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (isFailed != null) 'is_failed': isFailed,
    });
  }

  OfflineQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? method,
    Value<String>? path,
    Value<String?>? body,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
    Value<String?>? errorMessage,
    Value<bool>? isFailed,
  }) {
    return OfflineQueueCompanion(
      id: id ?? this.id,
      method: method ?? this.method,
      path: path ?? this.path,
      body: body ?? this.body,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      errorMessage: errorMessage ?? this.errorMessage,
      isFailed: isFailed ?? this.isFailed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (isFailed.present) {
      map['is_failed'] = Variable<bool>(isFailed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueCompanion(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('path: $path, ')
          ..write('body: $body, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('isFailed: $isFailed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $LocalHouseholdsTable localHouseholds = $LocalHouseholdsTable(
    this,
  );
  late final $LocalAccountsTable localAccounts = $LocalAccountsTable(this);
  late final $LocalCategoriesTable localCategories = $LocalCategoriesTable(
    this,
  );
  late final $LocalTransactionsTable localTransactions =
      $LocalTransactionsTable(this);
  late final $LocalBudgetsTable localBudgets = $LocalBudgetsTable(this);
  late final $LocalGoalsTable localGoals = $LocalGoalsTable(this);
  late final $LocalRecurringBillsTable localRecurringBills =
      $LocalRecurringBillsTable(this);
  late final $OfflineQueueTable offlineQueue = $OfflineQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localUsers,
    localHouseholds,
    localAccounts,
    localCategories,
    localTransactions,
    localBudgets,
    localGoals,
    localRecurringBills,
    offlineQueue,
  ];
}

typedef $$LocalUsersTableCreateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<int> id,
      required String name,
      required String email,
      Value<String?> emailVerifiedAt,
      Value<int?> currentHouseholdId,
      Value<DateTime> syncedAt,
    });
typedef $$LocalUsersTableUpdateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String?> emailVerifiedAt,
      Value<int?> currentHouseholdId,
      Value<DateTime> syncedAt,
    });

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentHouseholdId => $composableBuilder(
    column: $table.currentHouseholdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentHouseholdId => $composableBuilder(
    column: $table.currentHouseholdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentHouseholdId => $composableBuilder(
    column: $table.currentHouseholdId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUser,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (
            LocalUser,
            BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>,
          ),
          LocalUser,
          PrefetchHooks Function()
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> emailVerifiedAt = const Value.absent(),
                Value<int?> currentHouseholdId = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalUsersCompanion(
                id: id,
                name: name,
                email: email,
                emailVerifiedAt: emailVerifiedAt,
                currentHouseholdId: currentHouseholdId,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String email,
                Value<String?> emailVerifiedAt = const Value.absent(),
                Value<int?> currentHouseholdId = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                emailVerifiedAt: emailVerifiedAt,
                currentHouseholdId: currentHouseholdId,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUser,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
      LocalUser,
      PrefetchHooks Function()
    >;
typedef $$LocalHouseholdsTableCreateCompanionBuilder =
    LocalHouseholdsCompanion Function({
      Value<int> id,
      required String name,
      required String role,
      Value<DateTime> syncedAt,
    });
typedef $$LocalHouseholdsTableUpdateCompanionBuilder =
    LocalHouseholdsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> role,
      Value<DateTime> syncedAt,
    });

class $$LocalHouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalHouseholdsTable> {
  $$LocalHouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalHouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalHouseholdsTable> {
  $$LocalHouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalHouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalHouseholdsTable> {
  $$LocalHouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalHouseholdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalHouseholdsTable,
          LocalHousehold,
          $$LocalHouseholdsTableFilterComposer,
          $$LocalHouseholdsTableOrderingComposer,
          $$LocalHouseholdsTableAnnotationComposer,
          $$LocalHouseholdsTableCreateCompanionBuilder,
          $$LocalHouseholdsTableUpdateCompanionBuilder,
          (
            LocalHousehold,
            BaseReferences<
              _$AppDatabase,
              $LocalHouseholdsTable,
              LocalHousehold
            >,
          ),
          LocalHousehold,
          PrefetchHooks Function()
        > {
  $$LocalHouseholdsTableTableManager(
    _$AppDatabase db,
    $LocalHouseholdsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalHouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalHouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalHouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalHouseholdsCompanion(
                id: id,
                name: name,
                role: role,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String role,
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalHouseholdsCompanion.insert(
                id: id,
                name: name,
                role: role,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalHouseholdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalHouseholdsTable,
      LocalHousehold,
      $$LocalHouseholdsTableFilterComposer,
      $$LocalHouseholdsTableOrderingComposer,
      $$LocalHouseholdsTableAnnotationComposer,
      $$LocalHouseholdsTableCreateCompanionBuilder,
      $$LocalHouseholdsTableUpdateCompanionBuilder,
      (
        LocalHousehold,
        BaseReferences<_$AppDatabase, $LocalHouseholdsTable, LocalHousehold>,
      ),
      LocalHousehold,
      PrefetchHooks Function()
    >;
typedef $$LocalAccountsTableCreateCompanionBuilder =
    LocalAccountsCompanion Function({
      Value<int> id,
      required int householdId,
      required String name,
      required String type,
      Value<int> balanceCents,
      Value<String> currencyCode,
      Value<bool> isActive,
      Value<DateTime> syncedAt,
    });
typedef $$LocalAccountsTableUpdateCompanionBuilder =
    LocalAccountsCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<String> name,
      Value<String> type,
      Value<int> balanceCents,
      Value<String> currencyCode,
      Value<bool> isActive,
      Value<DateTime> syncedAt,
    });

class $$LocalAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAccountsTable> {
  $$LocalAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAccountsTable> {
  $$LocalAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAccountsTable> {
  $$LocalAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAccountsTable,
          LocalAccount,
          $$LocalAccountsTableFilterComposer,
          $$LocalAccountsTableOrderingComposer,
          $$LocalAccountsTableAnnotationComposer,
          $$LocalAccountsTableCreateCompanionBuilder,
          $$LocalAccountsTableUpdateCompanionBuilder,
          (
            LocalAccount,
            BaseReferences<_$AppDatabase, $LocalAccountsTable, LocalAccount>,
          ),
          LocalAccount,
          PrefetchHooks Function()
        > {
  $$LocalAccountsTableTableManager(_$AppDatabase db, $LocalAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalAccountsCompanion(
                id: id,
                householdId: householdId,
                name: name,
                type: type,
                balanceCents: balanceCents,
                currencyCode: currencyCode,
                isActive: isActive,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                required String name,
                required String type,
                Value<int> balanceCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalAccountsCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                type: type,
                balanceCents: balanceCents,
                currencyCode: currencyCode,
                isActive: isActive,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAccountsTable,
      LocalAccount,
      $$LocalAccountsTableFilterComposer,
      $$LocalAccountsTableOrderingComposer,
      $$LocalAccountsTableAnnotationComposer,
      $$LocalAccountsTableCreateCompanionBuilder,
      $$LocalAccountsTableUpdateCompanionBuilder,
      (
        LocalAccount,
        BaseReferences<_$AppDatabase, $LocalAccountsTable, LocalAccount>,
      ),
      LocalAccount,
      PrefetchHooks Function()
    >;
typedef $$LocalCategoriesTableCreateCompanionBuilder =
    LocalCategoriesCompanion Function({
      Value<int> id,
      required int householdId,
      Value<int?> parentId,
      required String name,
      required String type,
      Value<String?> icon,
      Value<String?> colorHex,
      Value<bool> isSystem,
      Value<DateTime> syncedAt,
    });
typedef $$LocalCategoriesTableUpdateCompanionBuilder =
    LocalCategoriesCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<int?> parentId,
      Value<String> name,
      Value<String> type,
      Value<String?> icon,
      Value<String?> colorHex,
      Value<bool> isSystem,
      Value<DateTime> syncedAt,
    });

class $$LocalCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCategoriesTable,
          LocalCategory,
          $$LocalCategoriesTableFilterComposer,
          $$LocalCategoriesTableOrderingComposer,
          $$LocalCategoriesTableAnnotationComposer,
          $$LocalCategoriesTableCreateCompanionBuilder,
          $$LocalCategoriesTableUpdateCompanionBuilder,
          (
            LocalCategory,
            BaseReferences<_$AppDatabase, $LocalCategoriesTable, LocalCategory>,
          ),
          LocalCategory,
          PrefetchHooks Function()
        > {
  $$LocalCategoriesTableTableManager(
    _$AppDatabase db,
    $LocalCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalCategoriesCompanion(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                type: type,
                icon: icon,
                colorHex: colorHex,
                isSystem: isSystem,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                Value<int?> parentId = const Value.absent(),
                required String name,
                required String type,
                Value<String?> icon = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalCategoriesCompanion.insert(
                id: id,
                householdId: householdId,
                parentId: parentId,
                name: name,
                type: type,
                icon: icon,
                colorHex: colorHex,
                isSystem: isSystem,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCategoriesTable,
      LocalCategory,
      $$LocalCategoriesTableFilterComposer,
      $$LocalCategoriesTableOrderingComposer,
      $$LocalCategoriesTableAnnotationComposer,
      $$LocalCategoriesTableCreateCompanionBuilder,
      $$LocalCategoriesTableUpdateCompanionBuilder,
      (
        LocalCategory,
        BaseReferences<_$AppDatabase, $LocalCategoriesTable, LocalCategory>,
      ),
      LocalCategory,
      PrefetchHooks Function()
    >;
typedef $$LocalTransactionsTableCreateCompanionBuilder =
    LocalTransactionsCompanion Function({
      Value<int> id,
      required int householdId,
      required int accountId,
      Value<int?> categoryId,
      required int amountCents,
      required String type,
      required DateTime date,
      Value<String?> payee,
      Value<String?> notes,
      Value<String?> importHash,
      required int createdBy,
      Value<bool> isPending,
      Value<DateTime> syncedAt,
    });
typedef $$LocalTransactionsTableUpdateCompanionBuilder =
    LocalTransactionsCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<int> accountId,
      Value<int?> categoryId,
      Value<int> amountCents,
      Value<String> type,
      Value<DateTime> date,
      Value<String?> payee,
      Value<String?> notes,
      Value<String?> importHash,
      Value<int> createdBy,
      Value<bool> isPending,
      Value<DateTime> syncedAt,
    });

class $$LocalTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importHash => $composableBuilder(
    column: $table.importHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importHash => $composableBuilder(
    column: $table.importHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get importHash => $composableBuilder(
    column: $table.importHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction,
          $$LocalTransactionsTableFilterComposer,
          $$LocalTransactionsTableOrderingComposer,
          $$LocalTransactionsTableAnnotationComposer,
          $$LocalTransactionsTableCreateCompanionBuilder,
          $$LocalTransactionsTableUpdateCompanionBuilder,
          (
            LocalTransaction,
            BaseReferences<
              _$AppDatabase,
              $LocalTransactionsTable,
              LocalTransaction
            >,
          ),
          LocalTransaction,
          PrefetchHooks Function()
        > {
  $$LocalTransactionsTableTableManager(
    _$AppDatabase db,
    $LocalTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importHash = const Value.absent(),
                Value<int> createdBy = const Value.absent(),
                Value<bool> isPending = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalTransactionsCompanion(
                id: id,
                householdId: householdId,
                accountId: accountId,
                categoryId: categoryId,
                amountCents: amountCents,
                type: type,
                date: date,
                payee: payee,
                notes: notes,
                importHash: importHash,
                createdBy: createdBy,
                isPending: isPending,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                required int accountId,
                Value<int?> categoryId = const Value.absent(),
                required int amountCents,
                required String type,
                required DateTime date,
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> importHash = const Value.absent(),
                required int createdBy,
                Value<bool> isPending = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalTransactionsCompanion.insert(
                id: id,
                householdId: householdId,
                accountId: accountId,
                categoryId: categoryId,
                amountCents: amountCents,
                type: type,
                date: date,
                payee: payee,
                notes: notes,
                importHash: importHash,
                createdBy: createdBy,
                isPending: isPending,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransactionsTable,
      LocalTransaction,
      $$LocalTransactionsTableFilterComposer,
      $$LocalTransactionsTableOrderingComposer,
      $$LocalTransactionsTableAnnotationComposer,
      $$LocalTransactionsTableCreateCompanionBuilder,
      $$LocalTransactionsTableUpdateCompanionBuilder,
      (
        LocalTransaction,
        BaseReferences<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction
        >,
      ),
      LocalTransaction,
      PrefetchHooks Function()
    >;
typedef $$LocalBudgetsTableCreateCompanionBuilder =
    LocalBudgetsCompanion Function({
      Value<int> id,
      required int householdId,
      required int categoryId,
      required int year,
      required int month,
      required int plannedCents,
      Value<DateTime> syncedAt,
    });
typedef $$LocalBudgetsTableUpdateCompanionBuilder =
    LocalBudgetsCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<int> categoryId,
      Value<int> year,
      Value<int> month,
      Value<int> plannedCents,
      Value<DateTime> syncedAt,
    });

class $$LocalBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBudgetsTable> {
  $$LocalBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedCents => $composableBuilder(
    column: $table.plannedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBudgetsTable> {
  $$LocalBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedCents => $composableBuilder(
    column: $table.plannedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBudgetsTable> {
  $$LocalBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get plannedCents => $composableBuilder(
    column: $table.plannedCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalBudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalBudgetsTable,
          LocalBudget,
          $$LocalBudgetsTableFilterComposer,
          $$LocalBudgetsTableOrderingComposer,
          $$LocalBudgetsTableAnnotationComposer,
          $$LocalBudgetsTableCreateCompanionBuilder,
          $$LocalBudgetsTableUpdateCompanionBuilder,
          (
            LocalBudget,
            BaseReferences<_$AppDatabase, $LocalBudgetsTable, LocalBudget>,
          ),
          LocalBudget,
          PrefetchHooks Function()
        > {
  $$LocalBudgetsTableTableManager(_$AppDatabase db, $LocalBudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> plannedCents = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalBudgetsCompanion(
                id: id,
                householdId: householdId,
                categoryId: categoryId,
                year: year,
                month: month,
                plannedCents: plannedCents,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                required int categoryId,
                required int year,
                required int month,
                required int plannedCents,
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalBudgetsCompanion.insert(
                id: id,
                householdId: householdId,
                categoryId: categoryId,
                year: year,
                month: month,
                plannedCents: plannedCents,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalBudgetsTable,
      LocalBudget,
      $$LocalBudgetsTableFilterComposer,
      $$LocalBudgetsTableOrderingComposer,
      $$LocalBudgetsTableAnnotationComposer,
      $$LocalBudgetsTableCreateCompanionBuilder,
      $$LocalBudgetsTableUpdateCompanionBuilder,
      (
        LocalBudget,
        BaseReferences<_$AppDatabase, $LocalBudgetsTable, LocalBudget>,
      ),
      LocalBudget,
      PrefetchHooks Function()
    >;
typedef $$LocalGoalsTableCreateCompanionBuilder =
    LocalGoalsCompanion Function({
      Value<int> id,
      required int householdId,
      required String name,
      required int targetCents,
      required int currentCents,
      Value<DateTime?> dueDate,
      required String type,
      Value<String?> notes,
      Value<DateTime> syncedAt,
    });
typedef $$LocalGoalsTableUpdateCompanionBuilder =
    LocalGoalsCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<String> name,
      Value<int> targetCents,
      Value<int> currentCents,
      Value<DateTime?> dueDate,
      Value<String> type,
      Value<String?> notes,
      Value<DateTime> syncedAt,
    });

class $$LocalGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCents => $composableBuilder(
    column: $table.currentCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCents => $composableBuilder(
    column: $table.currentCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCents => $composableBuilder(
    column: $table.currentCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalGoalsTable,
          LocalGoal,
          $$LocalGoalsTableFilterComposer,
          $$LocalGoalsTableOrderingComposer,
          $$LocalGoalsTableAnnotationComposer,
          $$LocalGoalsTableCreateCompanionBuilder,
          $$LocalGoalsTableUpdateCompanionBuilder,
          (
            LocalGoal,
            BaseReferences<_$AppDatabase, $LocalGoalsTable, LocalGoal>,
          ),
          LocalGoal,
          PrefetchHooks Function()
        > {
  $$LocalGoalsTableTableManager(_$AppDatabase db, $LocalGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetCents = const Value.absent(),
                Value<int> currentCents = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalGoalsCompanion(
                id: id,
                householdId: householdId,
                name: name,
                targetCents: targetCents,
                currentCents: currentCents,
                dueDate: dueDate,
                type: type,
                notes: notes,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                required String name,
                required int targetCents,
                required int currentCents,
                Value<DateTime?> dueDate = const Value.absent(),
                required String type,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalGoalsCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                targetCents: targetCents,
                currentCents: currentCents,
                dueDate: dueDate,
                type: type,
                notes: notes,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalGoalsTable,
      LocalGoal,
      $$LocalGoalsTableFilterComposer,
      $$LocalGoalsTableOrderingComposer,
      $$LocalGoalsTableAnnotationComposer,
      $$LocalGoalsTableCreateCompanionBuilder,
      $$LocalGoalsTableUpdateCompanionBuilder,
      (LocalGoal, BaseReferences<_$AppDatabase, $LocalGoalsTable, LocalGoal>),
      LocalGoal,
      PrefetchHooks Function()
    >;
typedef $$LocalRecurringBillsTableCreateCompanionBuilder =
    LocalRecurringBillsCompanion Function({
      Value<int> id,
      required int householdId,
      required String name,
      required int amountCents,
      required String frequency,
      required DateTime nextDue,
      Value<int?> categoryId,
      Value<bool> autoPay,
      Value<DateTime> syncedAt,
    });
typedef $$LocalRecurringBillsTableUpdateCompanionBuilder =
    LocalRecurringBillsCompanion Function({
      Value<int> id,
      Value<int> householdId,
      Value<String> name,
      Value<int> amountCents,
      Value<String> frequency,
      Value<DateTime> nextDue,
      Value<int?> categoryId,
      Value<bool> autoPay,
      Value<DateTime> syncedAt,
    });

class $$LocalRecurringBillsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRecurringBillsTable> {
  $$LocalRecurringBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPay => $composableBuilder(
    column: $table.autoPay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRecurringBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRecurringBillsTable> {
  $$LocalRecurringBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPay => $composableBuilder(
    column: $table.autoPay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRecurringBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRecurringBillsTable> {
  $$LocalRecurringBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoPay =>
      $composableBuilder(column: $table.autoPay, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalRecurringBillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRecurringBillsTable,
          LocalRecurringBill,
          $$LocalRecurringBillsTableFilterComposer,
          $$LocalRecurringBillsTableOrderingComposer,
          $$LocalRecurringBillsTableAnnotationComposer,
          $$LocalRecurringBillsTableCreateCompanionBuilder,
          $$LocalRecurringBillsTableUpdateCompanionBuilder,
          (
            LocalRecurringBill,
            BaseReferences<
              _$AppDatabase,
              $LocalRecurringBillsTable,
              LocalRecurringBill
            >,
          ),
          LocalRecurringBill,
          PrefetchHooks Function()
        > {
  $$LocalRecurringBillsTableTableManager(
    _$AppDatabase db,
    $LocalRecurringBillsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRecurringBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRecurringBillsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalRecurringBillsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<DateTime> nextDue = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> autoPay = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalRecurringBillsCompanion(
                id: id,
                householdId: householdId,
                name: name,
                amountCents: amountCents,
                frequency: frequency,
                nextDue: nextDue,
                categoryId: categoryId,
                autoPay: autoPay,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int householdId,
                required String name,
                required int amountCents,
                required String frequency,
                required DateTime nextDue,
                Value<int?> categoryId = const Value.absent(),
                Value<bool> autoPay = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => LocalRecurringBillsCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                amountCents: amountCents,
                frequency: frequency,
                nextDue: nextDue,
                categoryId: categoryId,
                autoPay: autoPay,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRecurringBillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRecurringBillsTable,
      LocalRecurringBill,
      $$LocalRecurringBillsTableFilterComposer,
      $$LocalRecurringBillsTableOrderingComposer,
      $$LocalRecurringBillsTableAnnotationComposer,
      $$LocalRecurringBillsTableCreateCompanionBuilder,
      $$LocalRecurringBillsTableUpdateCompanionBuilder,
      (
        LocalRecurringBill,
        BaseReferences<
          _$AppDatabase,
          $LocalRecurringBillsTable,
          LocalRecurringBill
        >,
      ),
      LocalRecurringBill,
      PrefetchHooks Function()
    >;
typedef $$OfflineQueueTableCreateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      required String method,
      required String path,
      Value<String?> body,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<String?> errorMessage,
      Value<bool> isFailed,
    });
typedef $$OfflineQueueTableUpdateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      Value<String> method,
      Value<String> path,
      Value<String?> body,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<String?> errorMessage,
      Value<bool> isFailed,
    });

class $$OfflineQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFailed => $composableBuilder(
    column: $table.isFailed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFailed => $composableBuilder(
    column: $table.isFailed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFailed =>
      $composableBuilder(column: $table.isFailed, builder: (column) => column);
}

class $$OfflineQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineQueueTable,
          OfflineQueueData,
          $$OfflineQueueTableFilterComposer,
          $$OfflineQueueTableOrderingComposer,
          $$OfflineQueueTableAnnotationComposer,
          $$OfflineQueueTableCreateCompanionBuilder,
          $$OfflineQueueTableUpdateCompanionBuilder,
          (
            OfflineQueueData,
            BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
          ),
          OfflineQueueData,
          PrefetchHooks Function()
        > {
  $$OfflineQueueTableTableManager(_$AppDatabase db, $OfflineQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<bool> isFailed = const Value.absent(),
              }) => OfflineQueueCompanion(
                id: id,
                method: method,
                path: path,
                body: body,
                retryCount: retryCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                errorMessage: errorMessage,
                isFailed: isFailed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String method,
                required String path,
                Value<String?> body = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<bool> isFailed = const Value.absent(),
              }) => OfflineQueueCompanion.insert(
                id: id,
                method: method,
                path: path,
                body: body,
                retryCount: retryCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                errorMessage: errorMessage,
                isFailed: isFailed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineQueueTable,
      OfflineQueueData,
      $$OfflineQueueTableFilterComposer,
      $$OfflineQueueTableOrderingComposer,
      $$OfflineQueueTableAnnotationComposer,
      $$OfflineQueueTableCreateCompanionBuilder,
      $$OfflineQueueTableUpdateCompanionBuilder,
      (
        OfflineQueueData,
        BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
      ),
      OfflineQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$LocalHouseholdsTableTableManager get localHouseholds =>
      $$LocalHouseholdsTableTableManager(_db, _db.localHouseholds);
  $$LocalAccountsTableTableManager get localAccounts =>
      $$LocalAccountsTableTableManager(_db, _db.localAccounts);
  $$LocalCategoriesTableTableManager get localCategories =>
      $$LocalCategoriesTableTableManager(_db, _db.localCategories);
  $$LocalTransactionsTableTableManager get localTransactions =>
      $$LocalTransactionsTableTableManager(_db, _db.localTransactions);
  $$LocalBudgetsTableTableManager get localBudgets =>
      $$LocalBudgetsTableTableManager(_db, _db.localBudgets);
  $$LocalGoalsTableTableManager get localGoals =>
      $$LocalGoalsTableTableManager(_db, _db.localGoals);
  $$LocalRecurringBillsTableTableManager get localRecurringBills =>
      $$LocalRecurringBillsTableTableManager(_db, _db.localRecurringBills);
  $$OfflineQueueTableTableManager get offlineQueue =>
      $$OfflineQueueTableTableManager(_db, _db.offlineQueue);
}
