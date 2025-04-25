import 'package:flow_stock/providers/venta_detalle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/presentation/screens/login_screen.dart';
import 'package:flow_stock/providers/cliente_provider.dart';
import 'package:flow_stock/providers/inventario_provider.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/providers/usuario_provider.dart';
import 'package:flow_stock/providers/venta_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  sqfliteFfiInit();
  databaseFactoryOrNull = createDatabaseFactoryFfiWeb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => SucursalProvider()),
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ChangeNotifierProvider(create: (_) => InventarioProvider()),
        ChangeNotifierProvider(create: (_) => VentaProvider()),
        ChangeNotifierProvider(create: (_) => VentaDetalleProvider()),
      ],
      child: MaterialApp(
          title: 'Flow Stock',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue, brightness: Brightness.light),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0)),
          home: LoginScreen()),
    );
  }
}
