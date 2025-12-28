import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ==========================================
// 1. TABLE DEFINITIONS
// ==========================================

// --- TABLE 1: EXPENSES (The Bill Header) ---
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()(); // To link to Firebase User
  
  // Financial Details
  RealColumn get amount => real()();
  RealColumn get tax => real().withDefault(const Constant(0.0))();
  
  // Meta Details
  TextColumn get merchant => text()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
}

// --- TABLE 2: EXPENSE ITEMS (Individual items inside a bill) ---
// I renamed 'BillItems' to 'ExpenseItems' to match the table above
class ExpenseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get expenseId => integer().references(Expenses, #id)(); // Link to parent
  TextColumn get name => text()();
  RealColumn get amount => real()();
}

// --- TABLE 3: USER PROFILES ---
class UserProfiles extends Table {
  TextColumn get uid => text()(); // Firebase UID
  TextColumn get name => text()();
  TextColumn get email => text()();
  IntColumn get age => integer()();
  
  @override
  Set<Column> get primaryKey => {uid};
}

// ==========================================
// 2. DATABASE CLASS & MIGRATION
// ==========================================

@DriftDatabase(tables: [Expenses, ExpenseItems, UserProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // ✅ Bumping version to 3 to trigger the migration logic below
  @override
  int get schemaVersion => 3; 

  // 👇 MIGRATION STRATEGY (The Fix for your Crash) 👇
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll(); // Create tables for new users
      },
      onUpgrade: (Migrator m, int from, int to) async {
        print("⚠️ Database version bumped from $from to $to. Wiping and recreating tables...");
        
        // This prevents the "Schema" crash.
        // It deletes old tables and creates fresh ones.
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
      },
    );
  }

  // ==========================================
  // 3. QUERIES (The functions your App needs)
  // ==========================================

  // --- EXPENSE QUERIES ---
  
  // Get all expenses (Stream for real-time UI)
  Stream<List<Expense>> watchAllExpenses() => 
      (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();

  // Insert a new expense (Returns the ID of the new row)
  Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  
  // Delete an expense
  Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();

  // Insert items in batch (Efficiently)
  Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(expenseItems, items);
    });
  }

  // --- USER PROFILE QUERIES ---
  
  Future<int> saveUserProfile(UserProfilesCompanion entry) {
    return into(userProfiles).insertOnConflictUpdate(entry);
  }
  
  Future<UserProfile?> getUserProfile(String uid) {
    return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
  }
}

// ==========================================
// 4. CONNECTION HELPER
// ==========================================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
    return NativeDatabase(file);
  });
}