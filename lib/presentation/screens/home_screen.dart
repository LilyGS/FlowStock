import 'package:flow_stock/presentation/screens/reporte_inventario.dart';
import 'package:flow_stock/presentation/screens/reporte_ventas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/providers/usuario_provider.dart';
import 'package:flow_stock/presentation/screens/cliente_list_screen.dart';
import 'package:flow_stock/presentation/screens/producto_list_screen.dart';
import 'package:flow_stock/presentation/screens/usuario_list_screen.dart';
import 'package:flow_stock/presentation/screens/sucursal_list_screen.dart';
import 'package:flow_stock/presentation/screens/login_screen.dart';
import 'package:flow_stock/presentation/screens/inventario_list_screen.dart';
import 'package:flow_stock/presentation/screens/reportes_screen.dart';
import 'package:flow_stock/presentation/screens/venta_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String rol;

  const HomeScreen({super.key, required this.rol});

  @override
  Widget build(BuildContext context) {
    final isAdmin = rol == 'admin';
    final isVendedor = rol == 'vendedor';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Flow Stock',
          style: FlowstockTextStyles.titleAppBar,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final usuarioProvider =
                  Provider.of<UsuarioProvider>(context, listen: false);
              await usuarioProvider.cerrarSesion();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isAdmin) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationButton(
                        context, 'Usuarios', Icons.people_alt_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsuarioListScreen()));
                    }),
                    _buildNavigationButton(context, 'Sucursales', Icons.store,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SucursalListScreen()));
                    }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationButton(
                        context, 'Productos', Icons.add_business_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductoListScreen()));
                    }),
                    _buildNavigationButton(context, 'Inventario',
                        Icons.insert_chart_outlined_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventarioListScreen()));
                    })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationButton(context, 'Clientes',
                        Icons.insert_chart_outlined_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClienteListScreen()));
                    }),
                    _buildNavigationButton(
                        context, 'Ventas', Icons.point_of_sale_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VentaListScreen()));
                    })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*  _buildNavigationButton(
                      context,
                      'Reportes',
                      Icons.search,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportesScreen()));
                      },
                    ),*/

                    _buildNavigationButton(
                      context,
                      'Reporte de Ventas',
                      Icons.bar_chart,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReporteVentas()));
                      },
                    ),
                    _buildNavigationButton(
                      context,
                      'Reporte de Inventario',
                      Icons.inventory,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReporteInventario()));
                      },
                    ),
                  ],
                ),
              ],
              if (isVendedor) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationButton(
                        context, 'Ventas', Icons.point_of_sale_rounded, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VentaListScreen()));
                    }),
                    _buildNavigationButton(
                      context,
                      'Reportes',
                      Icons.search,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportesScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text,
      IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: const CircleBorder(),
            fixedSize: const Size(115, 115),
            elevation: 10,
            padding: const EdgeInsets.all(10),
          ),
          child: Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: FlowstockTextStyles.titleOptions,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
