import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// --- TABLE 1: EXPENSES (Header) ---
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  
  // Financial Details
  RealColumn get amount => real()();
  RealColumn get tax => real().withDefault(const Constant(0.0))(); // Tax amount
  
  // Meta Details
  TextColumn get merchant => text()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
}

// --- TABLE 2: BILL ITEMS (Individual Items in a bill) ---
class BillItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get expenseId => integer().references(Expenses, #id)(); // Link to parent bill
  TextColumn get name => text()();
  RealColumn get amount => real()();
}

// --- TABLE 3: USER PROFILE ---
class UserProfiles extends Table {
  TextColumn get uid => text()(); // Firebase UID (Primary Key)
  TextColumn get name => text()();
  TextColumn get email => text()();
  IntColumn get age => integer()();
  
  @override
  Set<Column> get primaryKey => {uid};
}

// --- DATABASE CLASS ---
@DriftDatabase(tables: [Expenses, UserProfiles, BillItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Version 3

  // --- EXPENSE QUERIES ---
  
  // 1. Get all expenses (Stream for real-time UI)
  Stream<List<Expense>> watchAllExpenses() => 
      (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();

  // 2. Insert a new expense (Returns the ID of the new row)
  Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  
  // 3. Delete an expense
  Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();

  // 4. Insert multiple items at once (Batch)
  Future<void> insertBillItems(List<BillItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(billItems, items);
    });
  }

  // --- USER PROFILE QUERIES ---
  
  // 5. Save or Update User Profile
  Future<int> saveUserProfile(UserProfilesCompanion entry) {
    return into(userProfiles).insertOnConflictUpdate(entry);
  }
  
  // 6. Get User Profile
  Future<UserProfile?> getUserProfile(String uid) {
    return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
  }
}

// --- CONNECTION HELPER ---
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}