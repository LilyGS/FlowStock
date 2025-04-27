import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReporteVentas extends StatefulWidget {
  const ReporteVentas({super.key});

  @override
  State<ReporteVentas> createState() => _ReporteVentasState();
}

class _ReporteVentasState extends State<ReporteVentas> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _ventas = [];
  int? _sucursalSeleccionada;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();

    _cargarSucursal();
    _consultarVentas();
  }

  Future<void> _cargarSucursal() async {
    final context = this.context;

    await Provider.of<SucursalProvider>(context, listen: false)
        .cargarSucursales();
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
      condiciones.add('DATE(v.fecha_venta) BETWEEN ? AND ?');
      args.add(_fechaInicio!.toIso8601String().substring(0, 10));
      args.add(_fechaFin!.toIso8601String().substring(0, 10));
    }

    final where =
        condiciones.isNotEmpty ? 'WHERE ${condiciones.join(' AND ')}' : '';

    final resultado = await db.rawQuery('''
      SELECT v.id_venta, v.fecha_venta, v.total, v.metodo_pago, 
             s.nombre AS sucursal, c.nombre AS cliente
      FROM venta v
      JOIN sucursal s ON v.id_sucursal = s.id_sucursal
      LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
      $where
      ORDER BY v.fecha_venta DESC
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
    final sucursalProvider = Provider.of<SucursalProvider>(context);
    final sucursales = sucursalProvider.sucursales;
    final f = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text(FlowstockConstants.titleReporteVta)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
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
                  onChanged: (val) {
                    setState(() => _sucursalSeleccionada = val);
                    _consultarVentas();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _seleccionarFecha(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha Inicio',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                          ),
                          child: Text(
                            _fechaInicio != null
                                ? f.format(_fechaInicio!)
                                : '---',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _seleccionarFecha(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha Fin',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                          ),
                          child: Text(
                            _fechaFin != null ? f.format(_fechaFin!) : '---',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      final clienteNombre = v['cliente'] ?? 'SIN CLIENTE';
                      final fechav = DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(v['fecha_venta']));

                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(
                            'Venta: ${v['id_venta']} - Cliente: $clienteNombre'),
                        subtitle: Text('Fecha: $fechav - ${v['sucursal']}'),
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
