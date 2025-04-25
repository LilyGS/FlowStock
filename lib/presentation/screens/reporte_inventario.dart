import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flutter/material.dart';

class ReporteInventario extends StatefulWidget {
  const ReporteInventario({super.key});

  @override
  State<ReporteInventario> createState() => _ReporteInventarioState();
}

class _ReporteInventarioState extends State<ReporteInventario> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _datos = [];
  List<Map<String, dynamic>> _sucursales = [];
  int? _sucursalSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
    _consultarInventario();
  }

  Future<void> _cargarSucursales() async {
    final db = await _databaseHelper.database;
    final resultado = await db.rawQuery('SELECT id_sucursal, nombre FROM sucursal');
    setState(() {
      _sucursales = resultado;
    });
  }

  Future<void> _consultarInventario() async {
    final db = await _databaseHelper.database;

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
    final int total = _datos.length;
    final int criticos = _datos.where((d) => (d['cantidad_disponible'] ?? 0) < (d['stock_minimo'] ?? 5)).length;

    return Scaffold(
      appBar: AppBar(title: const Text(FlowstockConstants.titleReporteInv)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Sucursal', border: OutlineInputBorder()),
              value: _sucursalSeleccionada,
              items: [
                const DropdownMenuItem(value: null, child: Text('Todas')),
                ..._sucursales.map((s) => DropdownMenuItem(
                      value: s['id_sucursal'] as int,
                      child: Text(s['nombre']),
                    )),
              ],
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
                Text('Stock crítico: $criticos', style: TextStyle(color: criticos > 0 ? Colors.red : Colors.green)),
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

                      return Card(
                        color: esCritico ? Colors.red.shade50 : null,
                        child: ListTile(
                          title: Text('${d['producto']} ($unidad)'),
                          subtitle: Text('Sucursal: ${d['sucursal']} • Mínimo: $stockMinimo'),
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
                                const Icon(Icons.warning, color: Colors.red, size: 18),
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
