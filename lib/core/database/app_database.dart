import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String databaseName = 'registro_llamadas_salientes.db';
  static const int databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    final current = _database;
    if (current != null) return current;

    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, databaseName);

    final opened = await openDatabase(
      fullPath,
      version: databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    _database = opened;
    return opened;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE llamadas_salientes (
        id INTEGER PRIMARY KEY,
        fecha DATE,
        hora TIME,
        numero TEXT,
        nombre_contacto TEXT,
        duracion INTEGER,
        estado TEXT,
        timestamp INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE numeros_excluidos (
        id INTEGER PRIMARY KEY,
        numero TEXT,
        tipo TEXT
      )
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX idx_llamadas_timestamp_numero
      ON llamadas_salientes(timestamp, numero)
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX idx_excluidos_numero_tipo
      ON numeros_excluidos(numero, tipo)
    ''');

    await db.execute('''
      CREATE INDEX idx_llamadas_busqueda
      ON llamadas_salientes(nombre_contacto, numero, estado, fecha, hora, duracion)
    ''');
  }

  Future<void> close() async {
    final current = _database;
    if (current != null) {
      await current.close();
      _database = null;
    }
  }
}
