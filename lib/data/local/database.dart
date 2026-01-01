import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ==========================================
// 1. TABLE DEFINITIONS
// ==========================================

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().nullable()();
  RealColumn get amount => real()();
  RealColumn get tax => real().withDefault(const Constant(0.0))();
  TextColumn get merchant => text()();
  
  // Stores the tag name (e.g., "Grocery", "Rent")
  TextColumn get category => text().withDefault(const Constant('General'))(); 
  
  DateTimeColumn get date => dateTime()();
  TextColumn get imagePath => text().nullable()(); 
}

class Tags extends Table {
  TextColumn get name => text()(); // Primary Key
  IntColumn get color => integer().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(true))(); 

  @override
  Set<Column> get primaryKey => {name};
}

class ExpenseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get expenseId => integer().references(Expenses, #id)(); 
  TextColumn get name => text()();
  RealColumn get amount => real()();
}

class UserProfiles extends Table {
  TextColumn get uid => text()(); 
  TextColumn get name => text()();
  TextColumn get email => text()();
  IntColumn get age => integer()();
  @override
  Set<Column> get primaryKey => {uid};
}

// ==========================================
// 2. DATABASE CLASS
// ==========================================

@DriftDatabase(tables: [Expenses, ExpenseItems, UserProfiles, Tags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5; 

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertDefaultTags();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
        await _insertDefaultTags();
      },
    );
  }

  Future<void> _insertDefaultTags() async {
    await batch((batch) {
      batch.insertAll(tags, [
        TagsCompanion.insert(name: "General", isCustom: const Value(false), color: const Value(0xFF9E9E9E)),
        TagsCompanion.insert(name: "Office Expense", isCustom: const Value(false), color: const Value(0xFF2196F3)),
        TagsCompanion.insert(name: "House Rent", isCustom: const Value(false), color: const Value(0xFFE91E63)),
        TagsCompanion.insert(name: "Electronics", isCustom: const Value(false), color: const Value(0xFFFF9800)),
        TagsCompanion.insert(name: "Grocery", isCustom: const Value(false), color: const Value(0xFF4CAF50)),
        TagsCompanion.insert(name: "Electric Bill", isCustom: const Value(false), color: const Value(0xFFFFEB3B)),
        TagsCompanion.insert(name: "Personal", isCustom: const Value(false), color: const Value(0xFF9C27B0)),
      ]);
    });
  }

  // ==========================================
  // 3. QUERIES
  // ==========================================

  // --- TAGS ---
  Stream<List<Tag>> watchAllTags() => select(tags).watch();
  Future<int> insertTag(TagsCompanion entry) => into(tags).insert(entry);
  Future<int> deleteTag(String name) => (delete(tags)..where((t) => t.name.equals(name))).go();

  // --- EXPENSES ---
  Stream<List<Expense>> watchExpenses({String? filterTag}) {
    if (filterTag == null || filterTag == "All") {
      return (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();
    } else {
      return (select(expenses)
        ..where((t) => t.category.equals(filterTag))
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();
    }
  }

  // ✅ Bridge to prevent Home Screen crash
  Stream<List<Expense>> watchAllExpenses() => watchExpenses();

  Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();
  Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
    await batch((batch) { batch.insertAll(expenseItems, items); });
  }

  // --- USER PROFILES ---
  Future<int> saveUserProfile(UserProfilesCompanion entry) => into(userProfiles).insertOnConflictUpdate(entry);

  // ✅ THIS IS THE MISSING FUNCTION YOU NEED
  Future<UserProfile?> getUserProfile(String uid) {
    return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
    return NativeDatabase(file);
  });
}

final database = AppDatabase();