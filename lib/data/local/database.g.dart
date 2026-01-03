// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExpensesTable extends Expenses
    with drift.TableInfo<$ExpensesTable, Expense> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta = const drift.VerificationMeta(
    'id',
  );
  @override
  late final drift.GeneratedColumn<int> id = drift.GeneratedColumn<int>(
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
  static const drift.VerificationMeta _userIdMeta =
      const drift.VerificationMeta('userId');
  @override
  late final drift.GeneratedColumn<String> userId =
      drift.GeneratedColumn<String>(
        'user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _amountMeta =
      const drift.VerificationMeta('amount');
  @override
  late final drift.GeneratedColumn<double> amount =
      drift.GeneratedColumn<double>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _taxMeta = const drift.VerificationMeta(
    'tax',
  );
  @override
  late final drift.GeneratedColumn<double> tax = drift.GeneratedColumn<double>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const drift.Constant(0.0),
  );
  static const drift.VerificationMeta _merchantMeta =
      const drift.VerificationMeta('merchant');
  @override
  late final drift.GeneratedColumn<String> merchant =
      drift.GeneratedColumn<String>(
        'merchant',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _categoryMeta =
      const drift.VerificationMeta('category');
  @override
  late final drift.GeneratedColumn<String> category =
      drift.GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const drift.Constant('General'),
      );
  static const drift.VerificationMeta _dateMeta = const drift.VerificationMeta(
    'date',
  );
  @override
  late final drift.GeneratedColumn<DateTime> date =
      drift.GeneratedColumn<DateTime>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _imagePathMeta =
      const drift.VerificationMeta('imagePath');
  @override
  late final drift.GeneratedColumn<String> imagePath =
      drift.GeneratedColumn<String>(
        'image_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [
    id,
    userId,
    amount,
    tax,
    merchant,
    category,
    date,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
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
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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
      ),
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
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends drift.DataClass implements drift.Insertable<Expense> {
  final int id;
  final String? userId;
  final double amount;
  final double tax;
  final String merchant;
  final String category;
  final DateTime date;
  final String? imagePath;
  const Expense({
    required this.id,
    this.userId,
    required this.amount,
    required this.tax,
    required this.merchant,
    required this.category,
    required this.date,
    this.imagePath,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = drift.Variable<String>(userId);
    }
    map['amount'] = drift.Variable<double>(amount);
    map['tax'] = drift.Variable<double>(tax);
    map['merchant'] = drift.Variable<String>(merchant);
    map['category'] = drift.Variable<String>(category);
    map['date'] = drift.Variable<DateTime>(date);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = drift.Variable<String>(imagePath);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: drift.Value(id),
      userId: userId == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(userId),
      amount: drift.Value(amount),
      tax: drift.Value(tax),
      merchant: drift.Value(merchant),
      category: drift.Value(category),
      date: drift.Value(date),
      imagePath: imagePath == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(imagePath),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      tax: serializer.fromJson<double>(json['tax']),
      merchant: serializer.fromJson<String>(json['merchant']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String?>(userId),
      'amount': serializer.toJson<double>(amount),
      'tax': serializer.toJson<double>(tax),
      'merchant': serializer.toJson<String>(merchant),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  Expense copyWith({
    int? id,
    drift.Value<String?> userId = const drift.Value.absent(),
    double? amount,
    double? tax,
    String? merchant,
    String? category,
    DateTime? date,
    drift.Value<String?> imagePath = const drift.Value.absent(),
  }) => Expense(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    amount: amount ?? this.amount,
    tax: tax ?? this.tax,
    merchant: merchant ?? this.merchant,
    category: category ?? this.category,
    date: date ?? this.date,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
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
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
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
          ..write('date: $date, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, amount, tax, merchant, category, date, imagePath);
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
          other.date == this.date &&
          other.imagePath == this.imagePath);
}

class ExpensesCompanion extends drift.UpdateCompanion<Expense> {
  final drift.Value<int> id;
  final drift.Value<String?> userId;
  final drift.Value<double> amount;
  final drift.Value<double> tax;
  final drift.Value<String> merchant;
  final drift.Value<String> category;
  final drift.Value<DateTime> date;
  final drift.Value<String?> imagePath;
  const ExpensesCompanion({
    this.id = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    this.amount = const drift.Value.absent(),
    this.tax = const drift.Value.absent(),
    this.merchant = const drift.Value.absent(),
    this.category = const drift.Value.absent(),
    this.date = const drift.Value.absent(),
    this.imagePath = const drift.Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const drift.Value.absent(),
    this.userId = const drift.Value.absent(),
    required double amount,
    this.tax = const drift.Value.absent(),
    required String merchant,
    this.category = const drift.Value.absent(),
    required DateTime date,
    this.imagePath = const drift.Value.absent(),
  }) : amount = drift.Value(amount),
       merchant = drift.Value(merchant),
       date = drift.Value(date);
  static drift.Insertable<Expense> custom({
    drift.Expression<int>? id,
    drift.Expression<String>? userId,
    drift.Expression<double>? amount,
    drift.Expression<double>? tax,
    drift.Expression<String>? merchant,
    drift.Expression<String>? category,
    drift.Expression<DateTime>? date,
    drift.Expression<String>? imagePath,
  }) {
    return drift.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (tax != null) 'tax': tax,
      if (merchant != null) 'merchant': merchant,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  ExpensesCompanion copyWith({
    drift.Value<int>? id,
    drift.Value<String?>? userId,
    drift.Value<double>? amount,
    drift.Value<double>? tax,
    drift.Value<String>? merchant,
    drift.Value<String>? category,
    drift.Value<DateTime>? date,
    drift.Value<String?>? imagePath,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      tax: tax ?? this.tax,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = drift.Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = drift.Variable<double>(amount.value);
    }
    if (tax.present) {
      map['tax'] = drift.Variable<double>(tax.value);
    }
    if (merchant.present) {
      map['merchant'] = drift.Variable<String>(merchant.value);
    }
    if (category.present) {
      map['category'] = drift.Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = drift.Variable<DateTime>(date.value);
    }
    if (imagePath.present) {
      map['image_path'] = drift.Variable<String>(imagePath.value);
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
          ..write('date: $date, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $ExpenseItemsTable extends ExpenseItems
    with drift.TableInfo<$ExpenseItemsTable, ExpenseItem> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseItemsTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta = const drift.VerificationMeta(
    'id',
  );
  @override
  late final drift.GeneratedColumn<int> id = drift.GeneratedColumn<int>(
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
  static const drift.VerificationMeta _expenseIdMeta =
      const drift.VerificationMeta('expenseId');
  @override
  late final drift.GeneratedColumn<int> expenseId = drift.GeneratedColumn<int>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id)',
    ),
  );
  static const drift.VerificationMeta _nameMeta = const drift.VerificationMeta(
    'name',
  );
  @override
  late final drift.GeneratedColumn<String> name = drift.GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _amountMeta =
      const drift.VerificationMeta('amount');
  @override
  late final drift.GeneratedColumn<double> amount =
      drift.GeneratedColumn<double>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [id, expenseId, name, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_items';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<ExpenseItem> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseItem(
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
  $ExpenseItemsTable createAlias(String alias) {
    return $ExpenseItemsTable(attachedDatabase, alias);
  }
}

class ExpenseItem extends drift.DataClass
    implements drift.Insertable<ExpenseItem> {
  final int id;
  final int expenseId;
  final String name;
  final double amount;
  const ExpenseItem({
    required this.id,
    required this.expenseId,
    required this.name,
    required this.amount,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<int>(id);
    map['expense_id'] = drift.Variable<int>(expenseId);
    map['name'] = drift.Variable<String>(name);
    map['amount'] = drift.Variable<double>(amount);
    return map;
  }

  ExpenseItemsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseItemsCompanion(
      id: drift.Value(id),
      expenseId: drift.Value(expenseId),
      name: drift.Value(name),
      amount: drift.Value(amount),
    );
  }

  factory ExpenseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return ExpenseItem(
      id: serializer.fromJson<int>(json['id']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'expenseId': serializer.toJson<int>(expenseId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
    };
  }

  ExpenseItem copyWith({
    int? id,
    int? expenseId,
    String? name,
    double? amount,
  }) => ExpenseItem(
    id: id ?? this.id,
    expenseId: expenseId ?? this.expenseId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
  );
  ExpenseItem copyWithCompanion(ExpenseItemsCompanion data) {
    return ExpenseItem(
      id: data.id.present ? data.id.value : this.id,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseItem(')
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
      (other is ExpenseItem &&
          other.id == this.id &&
          other.expenseId == this.expenseId &&
          other.name == this.name &&
          other.amount == this.amount);
}

class ExpenseItemsCompanion extends drift.UpdateCompanion<ExpenseItem> {
  final drift.Value<int> id;
  final drift.Value<int> expenseId;
  final drift.Value<String> name;
  final drift.Value<double> amount;
  const ExpenseItemsCompanion({
    this.id = const drift.Value.absent(),
    this.expenseId = const drift.Value.absent(),
    this.name = const drift.Value.absent(),
    this.amount = const drift.Value.absent(),
  });
  ExpenseItemsCompanion.insert({
    this.id = const drift.Value.absent(),
    required int expenseId,
    required String name,
    required double amount,
  }) : expenseId = drift.Value(expenseId),
       name = drift.Value(name),
       amount = drift.Value(amount);
  static drift.Insertable<ExpenseItem> custom({
    drift.Expression<int>? id,
    drift.Expression<int>? expenseId,
    drift.Expression<String>? name,
    drift.Expression<double>? amount,
  }) {
    return drift.RawValuesInsertable({
      if (id != null) 'id': id,
      if (expenseId != null) 'expense_id': expenseId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
    });
  }

  ExpenseItemsCompanion copyWith({
    drift.Value<int>? id,
    drift.Value<int>? expenseId,
    drift.Value<String>? name,
    drift.Value<double>? amount,
  }) {
    return ExpenseItemsCompanion(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<int>(id.value);
    }
    if (expenseId.present) {
      map['expense_id'] = drift.Variable<int>(expenseId.value);
    }
    if (name.present) {
      map['name'] = drift.Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = drift.Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseItemsCompanion(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with drift.TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _uidMeta = const drift.VerificationMeta(
    'uid',
  );
  @override
  late final drift.GeneratedColumn<String> uid = drift.GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _nameMeta = const drift.VerificationMeta(
    'name',
  );
  @override
  late final drift.GeneratedColumn<String> name = drift.GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _emailMeta = const drift.VerificationMeta(
    'email',
  );
  @override
  late final drift.GeneratedColumn<String> email =
      drift.GeneratedColumn<String>(
        'email',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _ageMeta = const drift.VerificationMeta(
    'age',
  );
  @override
  late final drift.GeneratedColumn<int> age = drift.GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [uid, name, email, age];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {uid};
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

class UserProfile extends drift.DataClass
    implements drift.Insertable<UserProfile> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['uid'] = drift.Variable<String>(uid);
    map['name'] = drift.Variable<String>(name);
    map['email'] = drift.Variable<String>(email);
    map['age'] = drift.Variable<int>(age);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      uid: drift.Value(uid),
      name: drift.Value(name),
      email: drift.Value(email),
      age: drift.Value(age),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      uid: serializer.fromJson<String>(json['uid']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      age: serializer.fromJson<int>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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

class UserProfilesCompanion extends drift.UpdateCompanion<UserProfile> {
  final drift.Value<String> uid;
  final drift.Value<String> name;
  final drift.Value<String> email;
  final drift.Value<int> age;
  final drift.Value<int> rowid;
  const UserProfilesCompanion({
    this.uid = const drift.Value.absent(),
    this.name = const drift.Value.absent(),
    this.email = const drift.Value.absent(),
    this.age = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String uid,
    required String name,
    required String email,
    required int age,
    this.rowid = const drift.Value.absent(),
  }) : uid = drift.Value(uid),
       name = drift.Value(name),
       email = drift.Value(email),
       age = drift.Value(age);
  static drift.Insertable<UserProfile> custom({
    drift.Expression<String>? uid,
    drift.Expression<String>? name,
    drift.Expression<String>? email,
    drift.Expression<int>? age,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    drift.Value<String>? uid,
    drift.Value<String>? name,
    drift.Value<String>? email,
    drift.Value<int>? age,
    drift.Value<int>? rowid,
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (uid.present) {
      map['uid'] = drift.Variable<String>(uid.value);
    }
    if (name.present) {
      map['name'] = drift.Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = drift.Variable<String>(email.value);
    }
    if (age.present) {
      map['age'] = drift.Variable<int>(age.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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

class $TagsTable extends Tags with drift.TableInfo<$TagsTable, Tag> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _nameMeta = const drift.VerificationMeta(
    'name',
  );
  @override
  late final drift.GeneratedColumn<String> name = drift.GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _colorMeta = const drift.VerificationMeta(
    'color',
  );
  @override
  late final drift.GeneratedColumn<int> color = drift.GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const drift.VerificationMeta _isCustomMeta =
      const drift.VerificationMeta('isCustom');
  @override
  late final drift.GeneratedColumn<bool> isCustom = drift.GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const drift.Constant(true),
  );
  @override
  List<drift.GeneratedColumn> get $columns => [name, color, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {name};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends drift.DataClass implements drift.Insertable<Tag> {
  final String name;
  final int? color;
  final bool isCustom;
  const Tag({required this.name, this.color, required this.isCustom});
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['name'] = drift.Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = drift.Variable<int>(color);
    }
    map['is_custom'] = drift.Variable<bool>(isCustom);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      name: drift.Value(name),
      color: color == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(color),
      isCustom: drift.Value(isCustom),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return Tag(
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Tag copyWith({
    String? name,
    drift.Value<int?> color = const drift.Value.absent(),
    bool? isCustom,
  }) => Tag(
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    isCustom: isCustom ?? this.isCustom,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, color, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.name == this.name &&
          other.color == this.color &&
          other.isCustom == this.isCustom);
}

class TagsCompanion extends drift.UpdateCompanion<Tag> {
  final drift.Value<String> name;
  final drift.Value<int?> color;
  final drift.Value<bool> isCustom;
  final drift.Value<int> rowid;
  const TagsCompanion({
    this.name = const drift.Value.absent(),
    this.color = const drift.Value.absent(),
    this.isCustom = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  TagsCompanion.insert({
    required String name,
    this.color = const drift.Value.absent(),
    this.isCustom = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : name = drift.Value(name);
  static drift.Insertable<Tag> custom({
    drift.Expression<String>? name,
    drift.Expression<int>? color,
    drift.Expression<bool>? isCustom,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    drift.Value<String>? name,
    drift.Value<int?>? color,
    drift.Value<bool>? isCustom,
    drift.Value<int>? rowid,
  }) {
    return TagsCompanion(
      name: name ?? this.name,
      color: color ?? this.color,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (name.present) {
      map['name'] = drift.Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = drift.Variable<int>(color.value);
    }
    if (isCustom.present) {
      map['is_custom'] = drift.Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends drift.GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $ExpenseItemsTable expenseItems = $ExpenseItemsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  @override
  Iterable<drift.TableInfo<drift.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<drift.TableInfo<drift.Table, Object?>>();
  @override
  List<drift.DatabaseSchemaEntity> get allSchemaEntities => [
    expenses,
    expenseItems,
    userProfiles,
    tags,
  ];
}

typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      drift.Value<int> id,
      drift.Value<String?> userId,
      required double amount,
      drift.Value<double> tax,
      required String merchant,
      drift.Value<String> category,
      required DateTime date,
      drift.Value<String?> imagePath,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      drift.Value<int> id,
      drift.Value<String?> userId,
      drift.Value<double> amount,
      drift.Value<double> tax,
      drift.Value<String> merchant,
      drift.Value<String> category,
      drift.Value<DateTime> date,
      drift.Value<String?> imagePath,
    });

final class $$ExpensesTableReferences
    extends drift.BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static drift.MultiTypedResultKey<$ExpenseItemsTable, List<ExpenseItem>>
  _expenseItemsRefsTable(_$AppDatabase db) =>
      drift.MultiTypedResultKey.fromTable(
        db.expenseItems,
        aliasName: drift.$_aliasNameGenerator(
          db.expenses.id,
          db.expenseItems.expenseId,
        ),
      );

  $$ExpenseItemsTableProcessedTableManager get expenseItemsRefs {
    final manager = $$ExpenseItemsTableTableManager(
      $_db,
      $_db.expenseItems,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseItemsRefsTable($_db));
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.Expression<bool> expenseItemsRefs(
    drift.Expression<bool> Function($$ExpenseItemsTableFilterComposer f) f,
  ) {
    final $$ExpenseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseItems,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseItemsTableFilterComposer(
            $db: $db,
            $table: $db.expenseItems,
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
    extends drift.Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  drift.GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  drift.GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  drift.GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  drift.GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  drift.GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  drift.Expression<T> expenseItemsRefs<T extends Object>(
    drift.Expression<T> Function($$ExpenseItemsTableAnnotationComposer a) f,
  ) {
    final $$ExpenseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseItems,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseItems,
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
        drift.RootTableManager<
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
          drift.PrefetchHooks Function({bool expenseItemsRefs})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        drift.TableManagerState(
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
                drift.Value<int> id = const drift.Value.absent(),
                drift.Value<String?> userId = const drift.Value.absent(),
                drift.Value<double> amount = const drift.Value.absent(),
                drift.Value<double> tax = const drift.Value.absent(),
                drift.Value<String> merchant = const drift.Value.absent(),
                drift.Value<String> category = const drift.Value.absent(),
                drift.Value<DateTime> date = const drift.Value.absent(),
                drift.Value<String?> imagePath = const drift.Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                userId: userId,
                amount: amount,
                tax: tax,
                merchant: merchant,
                category: category,
                date: date,
                imagePath: imagePath,
              ),
          createCompanionCallback:
              ({
                drift.Value<int> id = const drift.Value.absent(),
                drift.Value<String?> userId = const drift.Value.absent(),
                required double amount,
                drift.Value<double> tax = const drift.Value.absent(),
                required String merchant,
                drift.Value<String> category = const drift.Value.absent(),
                required DateTime date,
                drift.Value<String?> imagePath = const drift.Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                userId: userId,
                amount: amount,
                tax: tax,
                merchant: merchant,
                category: category,
                date: date,
                imagePath: imagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseItemsRefs = false}) {
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expenseItemsRefs) db.expenseItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseItemsRefs)
                    await drift.$_getPrefetchedData<
                      Expense,
                      $ExpensesTable,
                      ExpenseItem
                    >(
                      currentTable: table,
                      referencedTable: $$ExpensesTableReferences
                          ._expenseItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ExpensesTableReferences(
                        db,
                        table,
                        p0,
                      ).expenseItemsRefs,
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
    drift.ProcessedTableManager<
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
      drift.PrefetchHooks Function({bool expenseItemsRefs})
    >;
typedef $$ExpenseItemsTableCreateCompanionBuilder =
    ExpenseItemsCompanion Function({
      drift.Value<int> id,
      required int expenseId,
      required String name,
      required double amount,
    });
typedef $$ExpenseItemsTableUpdateCompanionBuilder =
    ExpenseItemsCompanion Function({
      drift.Value<int> id,
      drift.Value<int> expenseId,
      drift.Value<String> name,
      drift.Value<double> amount,
    });

final class $$ExpenseItemsTableReferences
    extends
        drift.BaseReferences<_$AppDatabase, $ExpenseItemsTable, ExpenseItem> {
  $$ExpenseItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.expenses.createAlias(
        drift.$_aliasNameGenerator(db.expenseItems.expenseId, db.expenses.id),
      );

  $$ExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<int>('expense_id')!;

    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseItemsTableFilterComposer
    extends drift.Composer<_$AppDatabase, $ExpenseItemsTable> {
  $$ExpenseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => drift.ColumnFilters(column),
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

class $$ExpenseItemsTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $ExpenseItemsTable> {
  $$ExpenseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => drift.ColumnOrderings(column),
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

class $$ExpenseItemsTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $ExpenseItemsTable> {
  $$ExpenseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  drift.GeneratedColumn<double> get amount =>
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

class $$ExpenseItemsTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $ExpenseItemsTable,
          ExpenseItem,
          $$ExpenseItemsTableFilterComposer,
          $$ExpenseItemsTableOrderingComposer,
          $$ExpenseItemsTableAnnotationComposer,
          $$ExpenseItemsTableCreateCompanionBuilder,
          $$ExpenseItemsTableUpdateCompanionBuilder,
          (ExpenseItem, $$ExpenseItemsTableReferences),
          ExpenseItem,
          drift.PrefetchHooks Function({bool expenseId})
        > {
  $$ExpenseItemsTableTableManager(_$AppDatabase db, $ExpenseItemsTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<int> id = const drift.Value.absent(),
                drift.Value<int> expenseId = const drift.Value.absent(),
                drift.Value<String> name = const drift.Value.absent(),
                drift.Value<double> amount = const drift.Value.absent(),
              }) => ExpenseItemsCompanion(
                id: id,
                expenseId: expenseId,
                name: name,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                drift.Value<int> id = const drift.Value.absent(),
                required int expenseId,
                required String name,
                required double amount,
              }) => ExpenseItemsCompanion.insert(
                id: id,
                expenseId: expenseId,
                name: name,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseId = false}) {
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends drift.TableManagerState<
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
                                referencedTable: $$ExpenseItemsTableReferences
                                    ._expenseIdTable(db),
                                referencedColumn: $$ExpenseItemsTableReferences
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

typedef $$ExpenseItemsTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $ExpenseItemsTable,
      ExpenseItem,
      $$ExpenseItemsTableFilterComposer,
      $$ExpenseItemsTableOrderingComposer,
      $$ExpenseItemsTableAnnotationComposer,
      $$ExpenseItemsTableCreateCompanionBuilder,
      $$ExpenseItemsTableUpdateCompanionBuilder,
      (ExpenseItem, $$ExpenseItemsTableReferences),
      ExpenseItem,
      drift.PrefetchHooks Function({bool expenseId})
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String uid,
      required String name,
      required String email,
      required int age,
      drift.Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      drift.Value<String> uid,
      drift.Value<String> name,
      drift.Value<String> email,
      drift.Value<int> age,
      drift.Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends drift.Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  drift.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  drift.GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  drift.GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        drift.RootTableManager<
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
            drift.BaseReferences<
              _$AppDatabase,
              $UserProfilesTable,
              UserProfile
            >,
          ),
          UserProfile,
          drift.PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        drift.TableManagerState(
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
                drift.Value<String> uid = const drift.Value.absent(),
                drift.Value<String> name = const drift.Value.absent(),
                drift.Value<String> email = const drift.Value.absent(),
                drift.Value<int> age = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
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
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => UserProfilesCompanion.insert(
                uid: uid,
                name: name,
                email: email,
                age: age,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    drift.ProcessedTableManager<
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
        drift.BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      drift.PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String name,
      drift.Value<int?> color,
      drift.Value<bool> isCustom,
      drift.Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      drift.Value<String> name,
      drift.Value<int?> color,
      drift.Value<bool> isCustom,
      drift.Value<int> rowid,
    });

class $$TagsTableFilterComposer
    extends drift.Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer
    extends drift.Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends drift.Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  drift.GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  drift.GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        drift.RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, drift.BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          drift.PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        drift.TableManagerState(
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
                drift.Value<String> name = const drift.Value.absent(),
                drift.Value<int?> color = const drift.Value.absent(),
                drift.Value<bool> isCustom = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => TagsCompanion(
                name: name,
                color: color,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                drift.Value<int?> color = const drift.Value.absent(),
                drift.Value<bool> isCustom = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => TagsCompanion.insert(
                name: name,
                color: color,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, drift.BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      drift.PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$ExpenseItemsTableTableManager get expenseItems =>
      $$ExpenseItemsTableTableManager(_db, _db.expenseItems);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
}
