import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart' as drift;

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
  MigrationStrategy get migration => MigrationStrategy(
    // 1. ON CREATE: Run this when the app is installed for the first time
    onCreate: (Migrator m) async {
      await m.createAll(); // Creates the tables
      
      // ✅ INSERT DEFAULT TAGS (Matches your new Asset Icons)
      await batch((batch) {
        batch.insertAll(tags, [
          // Basic Needs
          TagsCompanion.insert(name: "General", color: const drift.Value(0xFF9E9E9E), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Food", color: const drift.Value(0xFFFF5722), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Grocery", color: const drift.Value(0xFF4CAF50), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Fuel", color: const drift.Value(0xFFF44336), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Rent", color: const drift.Value(0xFF795548), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "House", color: const drift.Value(0xFF8D6E63), isCustom: const drift.Value(false)), 
          
          // Lifestyle
          TagsCompanion.insert(name: "Shopping", color: const drift.Value(0xFFE91E63), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Entertainment", color: const drift.Value(0xFF9C27B0), isCustom: const drift.Value(false)), 
          TagsCompanion.insert(name: "Travel", color: const drift.Value(0xFFFF9800), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Gym", color: const drift.Value(0xFF3F51B5), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Pets", color: const drift.Value(0xFF795548), isCustom: const drift.Value(false)), 
          
          // Bills & Work
          TagsCompanion.insert(name: "Electric Bill", color: const drift.Value(0xFFFFC107), isCustom: const drift.Value(false)), 
          TagsCompanion.insert(name: "Electronics", color: const drift.Value(0xFF607D8B), isCustom: const drift.Value(false)), 
          TagsCompanion.insert(name: "Education", color: const drift.Value(0xFFFFC107), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Medical", color: const drift.Value(0xFFE53935), isCustom: const drift.Value(false)), 
          TagsCompanion.insert(name: "Office", color: const drift.Value(0xFF607D8B), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Investment", color: const drift.Value(0xFF4CAF50), isCustom: const drift.Value(false)),
          
          // Income/People
          TagsCompanion.insert(name: "Salary", color: const drift.Value(0xFF009688), isCustom: const drift.Value(false)),
          TagsCompanion.insert(name: "Personal", color: const drift.Value(0xFF3F51B5), isCustom: const drift.Value(false)), 
        ]);
      });
    },
    
    // 2. ON UPGRADE: If you change schema version, this handles updates
    // For development, we often just want to wipe and restart
    beforeOpen: (details) async {
       await customStatement('PRAGMA foreign_keys = ON');
    },
  );
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