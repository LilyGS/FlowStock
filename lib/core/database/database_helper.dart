import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lgs5_erp_master.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // ON DELETE CASCADE Para que se borren los productos de la sucursal al borrar la sucursal
    // quite esa opción porque manejo la opción de inventario

    // Para activar las llaves foraneas
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
      CREATE TABLE usuario (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        contrasena TEXT NOT NULL,
        rol TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE sucursal (
      id_sucursal INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      ubicacion TEXT NOT NULL,
      telefono TEXT,
      status TEXT NOT NULL )
    ''');

    await db.execute('''
    CREATE TABLE producto (
      id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      descripcion TEXT,
      categoria TEXT,
      unidad_medida TEXT,
      precio_lista REAL NOT NULL,      
      status TEXT NOT NULL)  
    ''');

    await db.execute('''
      CREATE TABLE inventario (
        id_sucursal INTEGER NOT NULL,
        id_producto INTEGER NOT NULL,
        cantidad_disponible INTEGER NOT NULL,
        precio_compra REAL NOT NULL,
        precio_venta REAL NOT NULL,
        fecha_ingreso TEXT NOT NULL,
        PRIMARY KEY (id_sucursal, id_producto),
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
      )  
    ''');

    await db.execute('''
      CREATE TABLE cliente (
        id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        direccion TEXT,
        telefono TEXT,        
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE venta (
        id_venta INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_venta TEXT NOT NULL,
        id_sucursal INTEGER NOT NULL,        
        id_cliente INTEGER,                  
        metodo_pago TEXT NOT NULL,        
        total REAL NOT NULL,        
        status TEXT NOT NULL,
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)            
      )
    ''');

    await db.execute('''
      CREATE TABLE venta_detalle(
        id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
        id_venta INTEGER NOT NULL,
        id_producto INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,  
        precio_unitario REAL NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
      )
    ''');

    // Transacciones (tabla)
    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      payment_method TEXT NOT NULL,
      status TEXT NOT NULL,
      date TEXT NOT NULL,
      description TEXT )
    ''');

    // Métodos de pago
    await db.execute('''
    CREATE TABLE payment_method (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      is_active BOOLEAN NOT NULL DEFAULT 1
    )
    ''');

    final batch = db.batch();

    // Insertar usuario predeterminado
    batch.insert('usuario', {
      'nombre': 'Administrador',
      'correo': 'admin@fs.com',
      'contrasena': '123456',
      'rol': 'admin',
      'status': 'activo',
    });

    batch.insert('usuario', {
      'nombre': 'Vend1',
      'correo': 'vend1@fs.com',
      'contrasena': '123456',
      'rol': 'vendedor',
      'status': 'activo',
    });

    // Insertar sucursales predeterminadas
    batch.insert('sucursal', {
      'nombre': 'Matriz',
      'ubicacion': 'Calle 123, Colonia 456, Ciudad 789',
      'telefono': '477 780 92 11',
      'status': 'activo'
    });
    batch.insert('sucursal', {
      'nombre': 'Sucursal León',
      'ubicacion': 'Calle Av. Universidad, Col. Lomas del Campestre, León Gto.',
      'telefono': '477 711 37 61',
      'status': 'activo'
    });

    // Insertar métodos de pago predeterminados
    batch.insert('payment_method', {
      'name': 'credit_card',
      'is_active': 1,
    });
    batch.insert('payment_method', {
      'name': 'debit_card',
      'is_active': 1,
    });
    batch.insert('payment_method', {
      'name': 'paypal',
      'is_active': 1,
    });
    batch.insert('payment_method', {
      'name': 'bank_transfer',
      'is_active': 1,
    });
    batch.insert('payment_method', {
      'name': 'cash',
      'is_active': 1,
    });

    await batch.commit();
  }

  // insertar registro
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Actualizar registro
  Future<int> update(String table, Map<String, dynamic> row, String whereClause,
      List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.update(table, row,
        where: whereClause, whereArgs: whereArgs);
  }

  // Sirve para el borrado lógico
  Future<int> updateStatus(
      String table, String idField, int idValue, String statusValue) async {
    Database db = await instance.database;
    return await db.update(
      table,
      {'status': statusValue},
      where: '$idField = ?',
      whereArgs: [idValue],
    );
  }

  // Eliminar registro
  Future<int> delete(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await instance.database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  // Obtener todos los registros de la tabla
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Obtener registro con condiciones
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await instance.database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  // Obtener transacciones dentro de un rango de fechas
  Future<List<Map<String, dynamic>>> getTransactionsByDate(
      DateTime startDate, DateTime endDate) async {
    Database db = await instance.database;
    return await db.query('transactions',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
        orderBy: 'date DESC');
  }

  // Obtener transacciones por status
  Future<List<Map<String, dynamic>>> getTransactionsByStatus(
      String status) async {
    Database db = await instance.database;
    return await db.query('transactions',
        where: 'status = ?', whereArgs: [status], orderBy: 'date DESC');
  }

  Future<void> togglePaymentMethod(int id, bool isActive) async {
    Database db = await instance.database;
    await db.update('payment_method', {'is_active': isActive ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getActivePaymentsMethods() async {
    Database db = await instance.database;
    return await db
        .query('payment_method', where: 'is_active = ?', whereArgs: [1]);
  }
}


/*

import 'package:sqflite/sqflite.dart';
import '../models/inventario.dart';

class InventarioDB {
  final Database db;

  InventarioDB(this.db);

  Future<void> insert(Inventario inv) async {
    await db.insert(
      'inventario',
      inv.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Inventario>> getAll() async {
    final maps = await db.query('inventario');
    return maps.map((map) => Inventario.fromMap(map)).toList();
  }

  Future<void> update(Inventario inv) async {
    await db.update(
      'inventario',
      inv.toMap(),
      where: 'id_sucursal = ? AND id_producto = ?',
      whereArgs: [inv.idSucursal, inv.idProducto],
    );
  }

  Future<void> delete(int idSucursal, int idProducto) async {
    await db.delete(
      'inventario',
      where: 'id_sucursal = ? AND id_producto = ?',
      whereArgs: [idSucursal, idProducto],
    );
  }
}





import 'package:sqflite/sqflite.dart';
import '../models/venta.dart';
import '../models/detalle_venta.dart';

class VentasDB {
  final Database db;

  VentasDB(this.db);

  // Insertar una venta
  Future<int> insertVenta(Venta venta) async {
    return await db.insert(
      'ventas',
      venta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insertar un detalle de venta
  Future<void> insertDetalleVenta(DetalleVenta detalle) async {
    await db.insert(
      'detalle_venta',
      detalle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las ventas
  Future<List<Venta>> getVentas() async {
    final maps = await db.query('ventas');
    return maps.map((map) => Venta.fromMap(map)).toList();
  }

  // Obtener detalles de una venta específica
  Future<List<DetalleVenta>> getDetallesVenta(int idVenta) async {
    final maps = await db.query(
      'detalle_venta',
      where: 'id_venta = ?',
      whereArgs: [idVenta],
    );
    return maps.map((map) => DetalleVenta.fromMap(map)).toList();
  }
}

*/