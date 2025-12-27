import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// --- TABLE 1: EXPENSES ---
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  RealColumn get amount => real()();
  TextColumn get merchant => text()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
}

// --- TABLE 2: USER PROFILE (New!) ---
class UserProfiles extends Table {
  TextColumn get uid => text()(); // Firebase UID (Primary Key)
  TextColumn get name => text()();
  TextColumn get email => text()();
  IntColumn get age => integer()();
  
  @override
  Set<Column> get primaryKey => {uid};
}

@DriftDatabase(tables: [Expenses, UserProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // INCREMENT VERSION because we changed the schema!

  // --- EXPENSE QUERIES ---
  Stream<List<Expense>> watchAllExpenses() => 
      (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();

  Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();

  // --- USER PROFILE QUERIES (New!) ---
  Future<int> saveUserProfile(UserProfilesCompanion entry) {
    return into(userProfiles).insertOnConflictUpdate(entry);
  }
  
  Future<UserProfile?> getUserProfile(String uid) {
    return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}