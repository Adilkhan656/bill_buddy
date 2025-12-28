// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    amount,
    tax,
    merchant,
    category,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String userId;
  final double amount;
  final double tax;
  final String merchant;
  final String category;
  final DateTime date;
  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.tax,
    required this.merchant,
    required this.category,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['amount'] = Variable<double>(amount);
    map['tax'] = Variable<double>(tax);
    map['merchant'] = Variable<String>(merchant);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      tax: Value(tax),
      merchant: Value(merchant),
      category: Value(category),
      date: Value(date),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      tax: serializer.fromJson<double>(json['tax']),
      merchant: serializer.fromJson<String>(json['merchant']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'amount': serializer.toJson<double>(amount),
      'tax': serializer.toJson<double>(tax),
      'merchant': serializer.toJson<String>(merchant),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Expense copyWith({
    int? id,
    String? userId,
    double? amount,
    double? tax,
    String? merchant,
    String? category,
    DateTime? date,
  }) => Expense(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    amount: amount ?? this.amount,
    tax: tax ?? this.tax,
    merchant: merchant ?? this.merchant,
    category: category ?? this.category,
    date: date ?? this.date,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      tax: data.tax.present ? data.tax.value : this.tax,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('tax: $tax, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, amount, tax, merchant, category, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.tax == this.tax &&
          other.merchant == this.merchant &&
          other.category == this.category &&
          other.date == this.date);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> userId;
  final Value<double> amount;
  final Value<double> tax;
  final Value<String> merchant;
  final Value<String> category;
  final Value<DateTime> date;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.tax = const Value.absent(),
    this.merchant = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required double amount,
    this.tax = const Value.absent(),
    required String merchant,
    required String category,
    required DateTime date,
  }) : userId = Value(userId),
       amount = Value(amount),
       merchant = Value(merchant),
       category = Value(category),
       date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<double>? amount,
    Expression<double>? tax,
    Expression<String>? merchant,
    Expression<String>? category,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (tax != null) 'tax': tax,
      if (merchant != null) 'merchant': merchant,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<double>? amount,
    Value<double>? tax,
    Value<String>? merchant,
    Value<String>? category,
    Value<DateTime>? date,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      tax: tax ?? this.tax,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('tax: $tax, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [uid, name, email, age];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
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
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String uid;
  final String name;
  final String email;
  final int age;
  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['age'] = Variable<int>(age);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      uid: Value(uid),
      name: Value(name),
      email: Value(email),
      age: Value(age),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      uid: serializer.fromJson<String>(json['uid']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      age: serializer.fromJson<int>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'age': serializer.toJson<int>(age),
    };
  }

  UserProfile copyWith({String? uid, String? name, String? email, int? age}) =>
      UserProfile(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        age: age ?? this.age,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      uid: data.uid.present ? data.uid.value : this.uid,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      age: data.age.present ? data.age.value : this.age,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uid, name, email, age);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.uid == this.uid &&
          other.name == this.name &&
          other.email == this.email &&
          other.age == this.age);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> uid;
  final Value<String> name;
  final Value<String> email;
  final Value<int> age;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.uid = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String uid,
    required String name,
    required String email,
    required int age,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       name = Value(name),
       email = Value(email),
       age = Value(age);
  static Insertable<UserProfile> custom({
    Expression<String>? uid,
    Expression<String>? name,
    Expression<String>? email,
    Expression<int>? age,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? uid,
    Value<String>? name,
    Value<String>? email,
    Value<int>? age,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillItemsTable extends BillItems
    with TableInfo<$BillItemsTable, BillItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id)',
    ),
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, expenseId, name, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $BillItemsTable createAlias(String alias) {
    return $BillItemsTable(attachedDatabase, alias);
  }
}

class BillItem extends DataClass implements Insertable<BillItem> {
  final int id;
  final int expenseId;
  final String name;
  final double amount;
  const BillItem({
    required this.id,
    required this.expenseId,
    required this.name,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['expense_id'] = Variable<int>(expenseId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  BillItemsCompanion toCompanion(bool nullToAbsent) {
    return BillItemsCompanion(
      id: Value(id),
      expenseId: Value(expenseId),
      name: Value(name),
      amount: Value(amount),
    );
  }

  factory BillItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillItem(
      id: serializer.fromJson<int>(json['id']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'expenseId': serializer.toJson<int>(expenseId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
    };
  }

  BillItem copyWith({int? id, int? expenseId, String? name, double? amount}) =>
      BillItem(
        id: id ?? this.id,
        expenseId: expenseId ?? this.expenseId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
      );
  BillItem copyWithCompanion(BillItemsCompanion data) {
    return BillItem(
      id: data.id.present ? data.id.value : this.id,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillItem(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, expenseId, name, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillItem &&
          other.id == this.id &&
          other.expenseId == this.expenseId &&
          other.name == this.name &&
          other.amount == this.amount);
}

class BillItemsCompanion extends UpdateCompanion<BillItem> {
  final Value<int> id;
  final Value<int> expenseId;
  final Value<String> name;
  final Value<double> amount;
  const BillItemsCompanion({
    this.id = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
  });
  BillItemsCompanion.insert({
    this.id = const Value.absent(),
    required int expenseId,
    required String name,
    required double amount,
  }) : expenseId = Value(expenseId),
       name = Value(name),
       amount = Value(amount);
  static Insertable<BillItem> custom({
    Expression<int>? id,
    Expression<int>? expenseId,
    Expression<String>? name,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expenseId != null) 'expense_id': expenseId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
    });
  }

  BillItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? expenseId,
    Value<String>? name,
    Value<double>? amount,
  }) {
    return BillItemsCompanion(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillItemsCompanion(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $BillItemsTable billItems = $BillItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    expenses,
    userProfiles,
    billItems,
  ];
}

typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required String userId,
      required double amount,
      Value<double> tax,
      required String merchant,
      required String category,
      required DateTime date,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<double> amount,
      Value<double> tax,
      Value<String> merchant,
      Value<String> category,
      Value<DateTime> date,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillItemsTable, List<BillItem>>
  _billItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billItems,
    aliasName: $_aliasNameGenerator(db.expenses.id, db.billItems.expenseId),
  );

  $$BillItemsTableProcessedTableManager get billItemsRefs {
    final manager = $$BillItemsTableTableManager(
      $_db,
      $_db.billItems,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billItemsRefs(
    Expression<bool> Function($$BillItemsTableFilterComposer f) f,
  ) {
    final $$BillItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billItems,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillItemsTableFilterComposer(
            $db: $db,
            $table: $db.billItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  Expression<T> billItemsRefs<T extends Object>(
    Expression<T> Function($$BillItemsTableAnnotationComposer a) f,
  ) {
    final $$BillItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billItems,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.billItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool billItemsRefs})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                userId: userId,
                amount: amount,
                tax: tax,
                merchant: merchant,
                category: category,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required double amount,
                Value<double> tax = const Value.absent(),
                required String merchant,
                required String category,
                required DateTime date,
              }) => ExpensesCompanion.insert(
                id: id,
                userId: userId,
                amount: amount,
                tax: tax,
                merchant: merchant,
                category: category,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billItemsRefs) db.billItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billItemsRefs)
                    await $_getPrefetchedData<
                      Expense,
                      $ExpensesTable,
                      BillItem
                    >(
                      currentTable: table,
                      referencedTable: $$ExpensesTableReferences
                          ._billItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ExpensesTableReferences(
                        db,
                        table,
                        p0,
                      ).billItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.expenseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool billItemsRefs})
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String uid,
      required String name,
      required String email,
      required int age,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> uid,
      Value<String> name,
      Value<String> email,
      Value<int> age,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
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

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
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

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                uid: uid,
                name: name,
                email: email,
                age: age,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String name,
                required String email,
                required int age,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                uid: uid,
                name: name,
                email: email,
                age: age,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$BillItemsTableCreateCompanionBuilder =
    BillItemsCompanion Function({
      Value<int> id,
      required int expenseId,
      required String name,
      required double amount,
    });
typedef $$BillItemsTableUpdateCompanionBuilder =
    BillItemsCompanion Function({
      Value<int> id,
      Value<int> expenseId,
      Value<String> name,
      Value<double> amount,
    });

final class $$BillItemsTableReferences
    extends BaseReferences<_$AppDatabase, $BillItemsTable, BillItem> {
  $$BillItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.expenses.createAlias(
        $_aliasNameGenerator(db.billItems.expenseId, db.expenses.id),
      );

  $$ExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<int>('expense_id')!;

    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BillItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpensesTableFilterComposer get expenseId {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpensesTableOrderingComposer get expenseId {
    final $$ExpensesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableOrderingComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$ExpensesTableAnnotationComposer get expenseId {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillItemsTable,
          BillItem,
          $$BillItemsTableFilterComposer,
          $$BillItemsTableOrderingComposer,
          $$BillItemsTableAnnotationComposer,
          $$BillItemsTableCreateCompanionBuilder,
          $$BillItemsTableUpdateCompanionBuilder,
          (BillItem, $$BillItemsTableReferences),
          BillItem,
          PrefetchHooks Function({bool expenseId})
        > {
  $$BillItemsTableTableManager(_$AppDatabase db, $BillItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> expenseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
              }) => BillItemsCompanion(
                id: id,
                expenseId: expenseId,
                name: name,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int expenseId,
                required String name,
                required double amount,
              }) => BillItemsCompanion.insert(
                id: id,
                expenseId: expenseId,
                name: name,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (expenseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expenseId,
                                referencedTable: $$BillItemsTableReferences
                                    ._expenseIdTable(db),
                                referencedColumn: $$BillItemsTableReferences
                                    ._expenseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BillItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillItemsTable,
      BillItem,
      $$BillItemsTableFilterComposer,
      $$BillItemsTableOrderingComposer,
      $$BillItemsTableAnnotationComposer,
      $$BillItemsTableCreateCompanionBuilder,
      $$BillItemsTableUpdateCompanionBuilder,
      (BillItem, $$BillItemsTableReferences),
      BillItem,
      PrefetchHooks Function({bool expenseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$BillItemsTableTableManager get billItems =>
      $$BillItemsTableTableManager(_db, _db.billItems);
}
