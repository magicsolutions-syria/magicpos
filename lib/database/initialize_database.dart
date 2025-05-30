import "package:flutter/foundation.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class PosData {
  //check that data is not null
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialNew();
      return _db;
    } else {
      return _db;
    }
  }

//create data
  initialNew() async {
    var newDataPath = await getDatabasesPath();
    if (kDebugMode) {
      print(newDataPath);
    }
    String path = join(newDataPath, "magicPOS.db");
    Database myDb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
      readOnly: false,
    );
    return myDb;
  }

//add a new row in a table
  insertData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawInsert(sql);
    return response;
  }

//read data form tables
  readData(String sql) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }

//delete a row in table
  deleteData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawDelete(sql);
    return response;
  }

//update data
  changeData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }

//delete the whole data
  deleteDataBase(String delete) async {
    String newDataPath = await getDatabasesPath();
    String path = join(newDataPath, delete);
    if (kDebugMode) {
      print('delete data complete ');
    }
    await deleteDatabase(path);
  }

//upgrade data
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print("upgraded");
    }
  }

//tables
  _onCreate(Database db, int oldVersion) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "printers"(
      "id" INTEGER PRIMARY KEY,
      "width" INTEGER DEFAULT 80,
      "name" TEXT NOT NULL
    )
    ''');
    print("printers");
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "users"(
      'id_user' INTEGER  PRIMARY KEY,
      'Print_Name' TEXT(20) NOT NULL,
      'ar_name' TEXT NOT NULL,
      'en_name' TEXT DEFAULT "",
      'password' TEXT NOT NULL,
      'mobile' TEXT DEFAULT "",
      'email' TEXT DEFAULT "",
      'jop_title' INTEGER DEFAULT 1,
      "sold_quantity_one" REAL DEFAULT 0,
      "sold_quantity_two" REAL DEFAULT 0,
      "total_sells_price_one" REAL DEFAULT 0.0,
      "total_sells_price_two" REAL DEFAULT 0.0,
      FOREIGN KEY(jop_title) REFERENCES jop_titles(id)
    )
      ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "permissions"(
      'id' INTEGER PRIMARY KEY, 
      'permission_name' TEXT (11) NOT NULL
    )
      ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "jop_titles"(
      'id' INTEGER PRIMARY KEY, 
      'jop_title_name' TEXT (25) NOT NULL
    )
      ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "user_permissions"(
    user_id INTEGER,
    permission_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES users(id_user),
    FOREIGN KEY(permission_id) REFERENCES permissions(id)
    )
      ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS "reports"(
      'report_name' TEXT (11) NOT NULL,
      'X' INTEGER DEFAULT 0,
      'Z' INTEGER DEFAULT 0,
      'X2' INTEGER DEFAULT 0,
      'Z2' INTEGER DEFAULT 0
      
    )
      ''');
    //clients table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "clients"(
        'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        'Print_Arabic_Name' TEXT(20) NOT NULL,
        'Barcode' TEXT(13) NOT NULL,
        'In' REAL NOT NULL,
        'Out' REAL NOT NULL,
        'Balance' REAL NOT NULL,
        'Name_Arabic' TEXT(30) NOT NULL,
        'Name_English' TEXT(30) NOT NULL,
        'Tel' TEXT(10) NOT NULL,
        'Whatsapp' TEXT(10) NOT NULL,
        'Email' TEXT(30) NOT NULL
      )''');
    //suppliers table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "suppliers"(
      'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'Barcode' TEXT(13) NOT NULL,
      'Print_Arabic_Name' TEXT(20) NOT NULL,
      'In' REAL NOT NULL,
      'Out' REAL NOT NULL,
      'Balance' REAL NOT NULL,
      'Name_Arabic' TEXT(30) NOT NULL,
      'Name_English' TEXT(30) NOT NULL,
      'Tel' TEXT(10) NOT NULL,
      'Whatsapp' TEXT(10) NOT NULL,
      'Email' TEXT(30) NOT NULL
    )
      ''');
//function keys table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "functions_keys"(
      'key_name' TEXT (11) NOT NULL,
      'clicks_1' INTEGER DEFAULT 0,
      'amount_1' REAL DEFAULT 0.0,
      'cash_amount_1' REAL DEFAULT 0.0,
      'clicks_2' INTEGER DEFAULT 0,
      'amount_2' REAL DEFAULT 0.0,
      'cash_amount_2' REAL DEFAULT 0.0
    )
      ''');

//depts table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "dept"(
      'id_dept' INTEGER  PRIMARY KEY,
      'name' TEXT,
      'Print_Name' TEXT(20) NOT NULL,
      'department' INTEGER DEFAULT 0,
      'clicks_1' INTEGER DEFAULT 0,
      'amount_1' REAL DEFAULT 0.0,
      'clicks_2' INTEGER DEFAULT 0,
      'amount_2' REAL DEFAULT 0.0,
      'cash_amount_1' REAL DEFAULT 0.0,
      'cash_amount_2' REAL DEFAULT 0.0,
     FOREIGN KEY(department) REFERENCES departments(id_department)
    )
      ''');

    // departments table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "departments"(
      'id_department' INTEGER  PRIMARY KEY,
      'section_name' TEXT NOT NULL,
      'Print_Name_department' TEXT(20) DEFAULT "",
      'selected_department' INTEGER DEFAULT 0,
      'products_QTY'REAL DEFAULT 0,
      "sold_quantity_one" REAL DEFAULT 0,
      "sold_quantity_two" REAL DEFAULT 0,
      "total_sells_price_one" REAL DEFAULT 0.0,
      "total_sells_price_two" REAL DEFAULT 0.0,
      "cash_total_sells_price_one" REAL DEFAULT 0.0,
      "cash_total_sells_price_two" REAL DEFAULT 0.0,
      'printer_id' INTEGER DEFAULT -1,
      FOREIGN KEY ('id_department') REFERENCES groups (section_number),
      FOREIGN KEY ('printer_id') REFERENCES printers (id)
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "units_names_1"(
      'id' INTEGER  PRIMARY KEY,
      'names' TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "units_names_2"(
      'id' INTEGER  PRIMARY KEY,
      'names' TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS "units_names_3"(
      'id' INTEGER  PRIMARY KEY,
      'names' TEXT NOT NULL
    )
    ''');

//groups table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "groups"(
      'id_group' INTEGER  PRIMARY KEY,
      'group_name' TEXT NOT NULL,
      'Print_Name_group' TEXT(20) DEFAULT "",
      'section_number' INTEGER NOT NULL,
       'products_QTY' REAL DEFAULT 0,
       'selected_group' INTEGER DEFAULT 0,
       "sold_quantity_one" REAL DEFAULT 0,
        "sold_quantity_two" REAL DEFAULT 0,
        "total_sells_price_one" REAL DEFAULT 0.0,
        "total_sells_price_two" REAL DEFAULT 0.0,
        'printer_id' INTEGER DEFAULT -1,
        FOREIGN KEY ('printer_id') REFERENCES printers (id)
        
    )
    ''');
    /*
     name:
     buy_price:
     group_price:
     piece_price:
     code:
    */
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "unit_1"(
      'id_1' INTEGER  PRIMARY KEY,
      "name_1" TEXT DEFAULT "unit 1",
      'Print_Name_1' TEXT(20) DEFAULT "",
      "cost_price_1" REAL NOT NULL,
      "group_price_1" REAL NOT NULL,
      "piece_price_1" REAL NOT NULL,
      "code_1" TEXT NOT NULL,
       "In_quantity_1" REAL DEFAULT 0.0,
      "Out_quantity_1" REAL DEFAULT 0.0,
      "current_quantity_1" REAL DEFAULT 0.0,
      "sold_quantity_one_1" REAL DEFAULT 0.0,
      "sold_quantity_two_1" REAL DEFAULT 0.0,
      "total_sells_price_one_1" REAL DEFAULT 0.0,
      "total_sells_price_two_1" REAL DEFAULT 0.0
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "unit_2"(
      'id_2' INTEGER  PRIMARY KEY,
      "name_2" TEXT DEFAULT "unit 1",
      'Print_Name_2' TEXT(20) DEFAULT "",
      "cost_price_2" REAL NOT NULL,
      "group_price_2" REAL NOT NULL,
      "piece_price_2" REAL NOT NULL,
      "code_2" TEXT NOT NULL,
      "pieces_quantity_2" REAL NOT NULL,
       "In_quantity_2" REAL DEFAULT 0.0,
      "Out_quantity_2" REAL DEFAULT 0.0,
      "current_quantity_2" REAL DEFAULT 0.0,
      "sold_quantity_one_2" REAL DEFAULT 0.0,
      "sold_quantity_two_2" REAL DEFAULT 0.0,
      "total_sells_price_one_2"REAL DEFAULT 0.0,
      "total_sells_price_two_2"REAL DEFAULT 0.0
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS "unit_3"(
      'id_3' INTEGER  PRIMARY KEY,
      "name_3" TEXT DEFAULT "unit 1",
      'Print_Name_3' TEXT(20) DEFAULT "",
      "cost_price_3" REAL NOT NULL,
      "group_price_3" REAL NOT NULL,
      "piece_price_3" REAL NOT NULL,
      "code_3" TEXT NOT NULL,
      "pieces_quantity_3" REAL NOT NULL,
      "In_quantity_3" REAL DEFAULT 0.0,
      "Out_quantity_3" REAL DEFAULT 0.0,
      "current_quantity_3" REAL DEFAULT 0.0,
      "sold_quantity_one_3" REAL DEFAULT 0.0,
      "sold_quantity_two_3" REAL DEFAULT 0.0,
      "total_sells_price_one_3" REAL DEFAULT 0.0,
      "total_sells_price_two_3" REAL DEFAULT 0.0
    )
    ''');

//products table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "products"(
      'id' INTEGER  PRIMARY KEY,
      'Print_Name' TEXT(20) NOT NULL,
      'image_dir' TEXT DEFAULT "",
      'description' TEXT DEFAULT "",
      'ar_name' TEXT NOT NULL,
      'en_name' TEXT NOT NULL,
      'department' INTEGER NOT NULL,
      'group' INTEGER NOT NULL,
      "min_amount" INTEGER DEFAULT 0,
      "max_amount" INTEGER DEFAULT 0,
      "product_type"INTEGER(1) DEFAULT 0,
         "unit_one_id" INTEGER NOT NULL,
         "unit_two_id" INTEGER DEFAULT 0,
         "unit_three_id" INTEGER DEFAULT 0,
      FOREIGN KEY ('department') REFERENCES departments (id_department),
      FOREIGN KEY ('group') REFERENCES groups (id_group),
      FOREIGN KEY ('unit_one_id') REFERENCES unit_one (id_1),
      FOREIGN KEY ('unit_two_id') REFERENCES unit_two (id_2),
      FOREIGN KEY ('unit_three_id') REFERENCES unit_three (id_3)
    )
      ''');
  }
}
