// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';

class Users extends Table with TableInfo<Users, UsersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Users(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways(' PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime(2024, 1, 1)));
  @override
  List<GeneratedColumn> get $columns => [id, creationTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
    );
  }

  @override
  Users createAlias(String alias) {
    return Users(attachedDatabase, alias);
  }
}

class UsersData extends DataClass implements Insertable<UsersData> {
  final int id;
  final DateTime creationTime;
  const UsersData({required this.id, required this.creationTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creation_time'] = Variable<DateTime>(creationTime);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      creationTime: Value(creationTime),
    );
  }

  factory UsersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersData(
      id: serializer.fromJson<int>(json['id']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creationTime': serializer.toJson<DateTime>(creationTime),
    };
  }

  UsersData copyWith({int? id, DateTime? creationTime}) => UsersData(
        id: id ?? this.id,
        creationTime: creationTime ?? this.creationTime,
      );
  UsersData copyWithCompanion(UsersCompanion data) {
    return UsersData(
      id: data.id.present ? data.id.value : this.id,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersData(')
          ..write('id: $id, ')
          ..write('creationTime: $creationTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, creationTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersData &&
          other.id == this.id &&
          other.creationTime == this.creationTime);
}

class UsersCompanion extends UpdateCompanion<UsersData> {
  final Value<int> id;
  final Value<DateTime> creationTime;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.creationTime = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.creationTime = const Value.absent(),
  });
  static Insertable<UsersData> custom({
    Expression<int>? id,
    Expression<DateTime>? creationTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creationTime != null) 'creation_time': creationTime,
    });
  }

  UsersCompanion copyWith({Value<int>? id, Value<DateTime>? creationTime}) {
    return UsersCompanion(
      id: id ?? this.id,
      creationTime: creationTime ?? this.creationTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('creationTime: $creationTime')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Users users = Users(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
  @override
  int get schemaVersion => 2;
}
