import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';

class ReporteInventario extends StatefulWidget {
  const ReporteInventario({super.key});

  @override
  State<ReporteInventario> createState() => _ReporteInventarioState();
}

class _ReporteInventarioState extends State<ReporteInventario> {
  // Instancia única del DatabaseHelper utilizando el patrón Singleton
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _datos = [];
  int? _sucursalSeleccionada;

  @override
  void initState() {
    super.initState();

    // Se ejecuta cuando el widget se renderizó
    // Carga las sucursales y el inventario

    _cargarSucursal();
    _consultarInventario();
  }

  Future<void> _cargarSucursal() async {
    final context = this.context;

    await Provider.of<SucursalProvider>(context, listen: false)
        .cargarSucursales();
  }

  Future<void> _consultarInventario() async {
    final db = await _databaseHelper.database;

    // Consulta del inventario haciendo join con productos y sucursales
    final resultados = await db.rawQuery('''
      SELECT 
        p.nombre AS producto, 
        p.unidad_medida,
        5 as stock_minimo,
        s.nombre AS sucursal, 
        i.cantidad_disponible
      FROM inventario i
      JOIN producto p ON i.id_producto = p.id_producto
      JOIN sucursal s ON i.id_sucursal = s.id_sucursal
      ${_sucursalSeleccionada != null ? 'WHERE i.id_sucursal = ?' : ''}
      ORDER BY s.nombre, p.nombre
    ''', _sucursalSeleccionada != null ? [_sucursalSeleccionada] : []);

    setState(() {
      _datos = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accede al provider de sucursal
    final sucursalProvider = Provider.of<SucursalProvider>(context);
    final sucursales = sucursalProvider.sucursales;

    final int total = _datos.length;
    final int criticos = _datos
        .where(
            (d) => (d['cantidad_disponible'] ?? 0) < (d['stock_minimo'] ?? 5))
        .length;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
              FlowstockConstants.titleReporteInv)), // Emplea constantes
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                  labelText: 'Sucursal', border: OutlineInputBorder()),
              value: _sucursalSeleccionada,
              items: [
                const DropdownMenuItem(value: null, child: Text('Todas')),
                ...sucursales.map((s) => DropdownMenuItem(
                      value: s.idSucursal as int,
                      child: Text(s.nombre),
                    )),
              ],
              // al cambiar la sucursal se actualiza la consulta del inventario
              onChanged: (val) {
                setState(() => _sucursalSeleccionada = val);
                _consultarInventario();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total productos: $total'),
                Text('Stock crítico: $criticos',
                    style: TextStyle(
                        color: criticos > 0 ? Colors.red : Colors.green)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _datos.isEmpty
                ? const Center(child: Text('Sin datos'))
                : ListView.builder(
                    itemCount: _datos.length,
                    itemBuilder: (_, i) {
                      final d = _datos[i];
                      final stock = d['cantidad_disponible'] as num;
                      final stockMinimo = d['stock_minimo'] ?? 5;
                      final unidad = d['unidad_medida'] ?? 'unidad(es)';
                      final esCritico = stock < stockMinimo;

                      // Card para mostrar el inventario
                      return Card(
                        color: esCritico ? Colors.red.shade50 : null,
                        child: ListTile(
                          title: Text('${d['producto']} ($unidad)'),
                          subtitle: Text(
                              'Sucursal: ${d['sucursal']} • Mínimo: $stockMinimo'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Stock: $stock',
                                style: TextStyle(
                                  color: esCritico ? Colors.red : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (esCritico)
                                const Icon(Icons.warning,
                                    color: Colors.red, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
