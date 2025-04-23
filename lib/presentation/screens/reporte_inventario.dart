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
  int? _sucursalSeleccionada; // null = todas

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
    _consultarInventario();
  }

  Future<void> _cargarSucursales() async {
    final db = await _databaseHelper.database;
    final resultado =
        await db.rawQuery('SELECT id_sucursal, nombre FROM sucursal');
    setState(() {
      _sucursales = resultado;
    });
  }

  Future<void> _consultarInventario() async {
    final db = await _databaseHelper.database;

    final resultados = await db.rawQuery('''
      SELECT p.nombre AS producto, s.nombre AS sucursal, i.cantidad_disponible
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
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Inventario')),
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
          Expanded(
            child: _datos.isEmpty
                ? const Center(child: Text('Sin datos'))
                : ListView.builder(
                    itemCount: _datos.length,
                    itemBuilder: (_, i) {
                      final d = _datos[i];
                      final stock = d['cantidad_disponible'] as num;
                      return ListTile(
                        title: Text(d['producto']),
                        subtitle: Text('Sucursal: ${d['sucursal']}'),
                        trailing: Text(
                          'Stock: $stock',
                          style: TextStyle(
                            color: stock < 10 ? Colors.red : Colors.black,
                            fontWeight: stock < 10
                                ? FontWeight.bold
                                : FontWeight.normal,
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
