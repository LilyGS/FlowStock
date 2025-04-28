import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  
  static Database? _database;

  // Instancia única de DatabaseHelper (patrón Singleton)
  static final DatabaseHelper instance = DatabaseHelper._();

  // Constructor privado 'nombrado' -> ._
  // para implementar singleton
  DatabaseHelper._();

  // Si la base de datos (_database) ya está abierta, la devuelve.
  // Si no está abierta, inicializa la base de datos llamando a _initDB
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flowstock_erp_master.db');
    return _database!;
  }
  

  // Este método obtiene la ruta del almacenamiento de bases de datos en el dispositivo:
  //Combina la ruta con el nombre del archivo (flowstock_erp_master.db).
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Abre o crea el archivo de base de datos usando:
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }


  // Si la base de datos ya existe, la abre.
  // Si no existe, ejecuta el método onCreate, es decir, llama a _createDB().
  Future<void> _createDB(Database db, int version) async {
   
    // Para activar las llaves foraneas
    await db.execute('PRAGMA foreign_keys = ON');

    // Ejecuta todos los comandos CREATE TABLE para construir la estructura inicial
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

      

    final batch = db.batch();

    // Insertar usuario predeterminado
    batch.insert('usuario', {
      'nombre': 'Administrador',
      'correo': 'admin@fs.com',
      'contrasena': '123',
      'rol': 'admin',
      'status': 'activo',
    });

    batch.insert('usuario', {
      'nombre': 'Vend1',
      'correo': 'vend1@fs.com',
      'contrasena': '123',
      'rol': 'vendedor',
      'status': 'activo',
    });

    // Insertar sucursales predeterminadas
    batch.insert('sucursal', {
      'nombre': 'Matriz',
      'ubicacion': 'Calle Av. Universidad 602, Col. Lomas del Campestre, León Gto.',
      'telefono': '477 710 85 00',
      'status': 'activo'
    });
    batch.insert('sucursal', {
      'nombre': 'Sucursal Centro',
      'ubicacion': 'Calle Madero, Col. Centro, León Gto.',
      'telefono': '477 711 37 61',
      'status': 'activo'
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

 
}

