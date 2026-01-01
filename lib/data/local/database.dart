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

// --- UPDATED EXPENSES TABLE ---
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

// --- NEW TAGS TABLE ---
class Tags extends Table {
  TextColumn get name => text()(); // e.g. "Office", "Food" (Primary Key)
  IntColumn get color => integer().nullable()(); // Hex Color Code
  BoolColumn get isCustom => boolean().withDefault(const Constant(true))(); // To protect default tags

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

  // Bump version to 5 to trigger migration
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
        // Warning: This wipes data for dev purposes. 
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

  // --- QUERIES ---

  // 1. Tags
  Stream<List<Tag>> watchAllTags() => select(tags).watch();
  Future<int> insertTag(TagsCompanion entry) => into(tags).insert(entry);
  Future<int> deleteTag(String name) => (delete(tags)..where((t) => t.name.equals(name))).go();

  // 2. Expenses (With Filter Logic!)
  Stream<List<Expense>> watchExpenses({String? filterTag}) {
    if (filterTag == null || filterTag == "All") {
      return (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();
    } else {
      return (select(expenses)
        ..where((t) => t.category.equals(filterTag))
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();
    }
  }

  // 3. Other Basics
  Future<int> deleteExpense(int id) => (delete(expenses)..where((t) => t.id.equals(id))).go();
  Future<int> insertExpense(ExpensesCompanion entry) => into(expenses).insert(entry);
  Future<void> insertExpenseItems(List<ExpenseItemsCompanion> items) async {
    await batch((batch) { batch.insertAll(expenseItems, items); });
  }
  Future<int> saveUserProfile(UserProfilesCompanion entry) => into(userProfiles).insertOnConflictUpdate(entry);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bill_buddy.sqlite'));
    return NativeDatabase(file);
  });
}

final database = AppDatabase();