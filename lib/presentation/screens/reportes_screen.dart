import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/reporte_inventario.dart';
import 'package:flow_stock/presentation/screens/reporte_ventas.dart';
import 'package:flutter/material.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(FlowstockConstants.titleReporte)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reporte de Ventas',
                style: FlowstockTextStyles.listTitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReporteVentas()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Reporte de Inventario',
                style: FlowstockTextStyles.listTitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReporteInventario()),
              );
            },
          ),
        ],
      ),
    );
  }
}
