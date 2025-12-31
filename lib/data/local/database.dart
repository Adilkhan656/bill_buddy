// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

// part 'database.g.dart';

// // ==========================================
// // 1. TABLE DEFINITIONS
// // ==========================================

// // --- TABLE 1: EXPENSES (The Bill Header) ---
// class Expenses extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get userId => text()(); // To link to Firebase User
  
//   // Financial Details
//   RealColumn get amount => real()();
//   RealColumn get tax => real().withDefault(const Constant(0.0))();
  
//   // Meta Details
//   TextColumn get merchant => text()();
//   TextColumn get category => text()();
//   DateTimeColumn get date => dateTime()();
// }

// // --- TABLE 2: EXPENSE ITEMS (Individual items inside a bill) ---
// // I renamed 'BillItems' to 'ExpenseItems' to match the table above
// class ExpenseItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get expenseId => integer().references(Expenses, #id)(); // Link to parent
//   TextColumn get name => text()();
//   RealColumn get amount => real()();
// }

// // --- TABLE 3: USER PROFILES ---
// class UserProfiles extends Table {
//   TextColumn get uid => text()(); // Firebase UID
//   TextColumn get name => text()();
//   TextColumn get email => text()();
//   IntColumn get age => integer()();
  
//   @override
//   Set<Column> get primaryKey => {uid};
// }

// // ==========================================
// // 2. DATABASE CLASS & MIGRATION
// // ==========================================

// @DriftDatabase(tables: [Expenses, ExpenseItems, UserProfiles])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   // ✅ Bumping version to 3 to trigger the migration logic below
//   @override
//   int get schemaVersion => 3; 

//   // 👇 MIGRATION STRATEGY (The Fix for your Crash) 👇
//   @override
//   MigrationStrategy get migration {
//     return MigrationStrategy(
//       onCreate: (Migrator m) async {
//         await m.createAll(); // Create tables for new users
//       },
//       onUpgrade: (Migrator m, int from, int to) async {
//         print("⚠️ Database version bumped from $from to $to. Wiping and recreating tables...");
        
//         // This prevents the "Schema" crash.
//         // It deletes old tables and creates fresh ones.
//         for (final table in allTables) {
//           await m.deleteTable(table.actualTableName);
//         }
//         await m.createAll();
//       },
//     );
//   }

//   // ==========================================
//   // 3. QUERIES (The functions your App needs)
//   // ==========================================

//   // --- EXPENSE QUERIES ---
  
//   // Get all expenses (Stream for real-time UI)
//   Stream<List<Expense>> watchAllExpenses() => 
//       (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();

//   // Insert a new expense (Returns the ID of the new row)
//   Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  
//   // Delete an expense
//   Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();

//   // Insert items in batch (Efficiently)
//   Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
//     await batch((batch) {
//       batch.insertAll(expenseItems, items);
//     });
//   }

//   // --- USER PROFILE QUERIES ---
  
//   Future<int> saveUserProfile(UserProfilesCompanion entry) {
//     return into(userProfiles).insertOnConflictUpdate(entry);
//   }
  
//   Future<UserProfile?> getUserProfile(String uid) {
//     return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
//   }
// }

// // ==========================================
// // 4. CONNECTION HELPER
// // ==========================================
// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
//     return NativeDatabase(file);
//   });
// }
// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

// part 'database.g.dart';

// // ==========================================
// // 1. TABLE DEFINITIONS
// // ==========================================

// class Expenses extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   // We can make userId nullable for now if you aren't using Firebase yet
//   TextColumn get userId => text().nullable()(); 
  
//   RealColumn get amount => real()();
//   RealColumn get tax => real().withDefault(const Constant(0.0))();
  
//   TextColumn get merchant => text()();
//   TextColumn get category => text().withDefault(const Constant('General'))();
//   DateTimeColumn get date => dateTime()();
//   TextColumn get imagePath => text().nullable()();
// }

// class ExpenseItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get expenseId => integer().references(Expenses, #id)(); 
//   TextColumn get name => text()();
//   RealColumn get amount => real()();
// }

// class UserProfiles extends Table {
//   TextColumn get uid => text()(); 
//   TextColumn get name => text()();
//   TextColumn get email => text()();
//   IntColumn get age => integer()();
  
//   @override
//   Set<Column> get primaryKey => {uid};
// }

// // ==========================================
// // 2. DATABASE CLASS
// // ==========================================

// @DriftDatabase(tables: [Expenses, ExpenseItems, UserProfiles])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 3; 

//   @override
//   MigrationStrategy get migration {
//     return MigrationStrategy(
//       onCreate: (Migrator m) async {
//         await m.createAll();
//       },
//       onUpgrade: (Migrator m, int from, int to) async {
//         // Warning: This wipes data on upgrade. 
//         // Good for dev, change this for production later.
//         for (final table in allTables) {
//           await m.deleteTable(table.actualTableName);
//         }
//         await m.createAll();
//       },
//     );
//   }

//   // --- QUERIES ---
  
//   Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  
//   Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
//     await batch((batch) {
//       batch.insertAll(expenseItems, items);
//     });
//   }

//   Stream<List<Expense>>? watchAllExpenses() {}

//   void deleteExpense(int id) {}
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
//     return NativeDatabase(file);
//   });
// }

// // ✅ GLOBAL INSTANCE (Add this line!)
// final database = AppDatabase();

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
  TextColumn get category => text().withDefault(const Constant('General'))();
  DateTimeColumn get date => dateTime()();
  
  // Image Path for the receipt photo
  TextColumn get imagePath => text().nullable()(); 
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

@DriftDatabase(tables: [Expenses, ExpenseItems, UserProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4; 

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
      },
    );
  }

  // ==========================================
  // 3. QUERIES
  // ==========================================

  // --- EXPENSE QUERIES ---
  Stream<List<Expense>> watchAllExpenses() {
    return (select(expenses)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> deleteExpense(int id) {
    return (delete(expenses)..where((t) => t.id.equals(id))).go();
  }

  Future<int> insertExpense(ExpensesCompanion entry) {
    return into(expenses).insert(entry);
  }
  
  Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(expenseItems, items);
    });
  }

  // --- USER PROFILE QUERIES (✅ Added This!) ---
  Future<int> saveUserProfile(UserProfilesCompanion entry) {
    // insertOnConflictUpdate ensures if the user already exists, we just update their info
    return into(userProfiles).insertOnConflictUpdate(entry);
  }
  
  // Optional: To read user data later
  Future<UserProfile?> getUserProfile(String uid) {
    return (select(userProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
  }
}

// ==========================================
// 4. CONNECTION
// ==========================================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
    return NativeDatabase(file);
  });
}

// Global Instance
final database = AppDatabase();