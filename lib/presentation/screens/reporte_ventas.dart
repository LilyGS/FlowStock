import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReporteVentas extends StatefulWidget {
  const ReporteVentas({super.key});

  @override
  State<ReporteVentas> createState() => _ReporteVentasState();
}

class _ReporteVentasState extends State<ReporteVentas> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _ventas = [];
  List<Map<String, dynamic>> _sucursales = [];
  int? _sucursalSeleccionada;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
    _consultarVentas();
  }

  Future<void> _cargarSucursales() async {
    final db = await _databaseHelper.database;
    final resultado =
        await db.rawQuery('SELECT id_sucursal, nombre FROM sucursales');
    setState(() => _sucursales = resultado);
  }

  Future<void> _consultarVentas() async {
    final db = await _databaseHelper.database;
    final condiciones = <String>[];
    final args = <dynamic>[];

    if (_sucursalSeleccionada != null) {
      condiciones.add('v.id_sucursal = ?');
      args.add(_sucursalSeleccionada);
    }
    if (_fechaInicio != null && _fechaFin != null) {
      condiciones.add('DATE(v.fecha) BETWEEN ? AND ?');
      args.add(_fechaInicio!.toIso8601String().substring(0, 10));
      args.add(_fechaFin!.toIso8601String().substring(0, 10));
    }

    final where =
        condiciones.isNotEmpty ? 'WHERE ${condiciones.join(' AND ')}' : '';

    final resultado = await db.rawQuery('''
      SELECT v.id_venta, v.fecha, v.total, v.metodo_pago, 
             s.nombre AS sucursal, c.nombre AS cliente
      FROM ventas v
      JOIN sucursales s ON v.id_sucursal = s.id_sucursal
      JOIN clientes c ON v.id_cliente = c.id_cliente
      $where
      ORDER BY v.fecha DESC
    ''', args);

    setState(() => _ventas = resultado);
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esInicio) async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (seleccionada != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = seleccionada;
        } else {
          _fechaFin = seleccionada;
        }
        _consultarVentas();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Ventas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Sucursal'),
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
                    _consultarVentas();
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _seleccionarFecha(context, true),
                        child: Text(
                            'Inicio: ${_fechaInicio != null ? f.format(_fechaInicio!) : '---'}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _seleccionarFecha(context, false),
                        child: Text(
                            'Fin: ${_fechaFin != null ? f.format(_fechaFin!) : '---'}'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: _ventas.isEmpty
                ? const Center(child: Text('No hay ventas registradas'))
                : ListView.builder(
                    itemCount: _ventas.length,
                    itemBuilder: (_, i) {
                      final v = _ventas[i];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('${v['cliente']}'),
                        subtitle: Text('${v['fecha']} - ${v['sucursal']}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${v['total'].toStringAsFixed(2)}'),
                            Text('${v['metodo_pago'] ?? ''}',
                                style: const TextStyle(fontSize: 12)),
                          ],
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
