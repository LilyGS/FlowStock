import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/producto.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';


// Widget para mostrar, en un formato de tabla, el detalle de la venta
// Este widget se utiliza en la pantalla de captura de la venta y
// En la pantalla de consulta de la venta.

class DetalleVentaTable extends StatelessWidget {
  final List<VentaDetalle> detalles;
  final List<Producto> productos;
  final void Function(int index) onDelete;
  final bool editable;

  const DetalleVentaTable({
    super.key,
    required this.detalles,
    required this.productos,
    required this.onDelete,  
    this.editable = true,  // Cuando se ejecuta en la consulta de la venta, editable es false
  });

  @override
  Widget build(BuildContext context) {
    double total = detalles.fold(0, (sum, item) => sum + item.subtotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalle de la venta:',
          style: FlowstockTextStyles.buttonAction,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: const [
              Expanded(
                  flex: 3,
                  child:
                      Text('PRODUCTO', style: FlowstockTextStyles.listTitle)),
              Expanded(
                  flex: 2,
                  child: Text('UNIDAD', style: FlowstockTextStyles.listTitle)),
              Expanded(
                  flex: 2,
                  child: Text('PRECIO', style: FlowstockTextStyles.listTitle)),
              Expanded(
                  flex: 2,
                  child:
                      Text('CANTIDAD', style: FlowstockTextStyles.listTitle)),
              Expanded(
                  flex: 2,
                  child:
                      Text('SUBTOTAL', style: FlowstockTextStyles.listTitle)),
              SizedBox(width: 40),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ...detalles.asMap().entries.map((e) {
          final d = e.value;
          final prod =
              productos.firstWhere((p) => p.idProducto == d.idProducto);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    prod.nombre.length > 30
                        ? '${prod.nombre.substring(0, 30)}...'
                        : prod.nombre,
                  ),
                ),
                Expanded(flex: 2, child: Text(prod.unidadMedida!)),
                Expanded(
                    flex: 2,
                    child: Text('\$${d.precioUnitario.toStringAsFixed(2)}')),
                Expanded(flex: 2, child: Text('${d.cantidad}')),
                Expanded(
                    flex: 2, child: Text('\$${d.subtotal.toStringAsFixed(2)}')),
                if (editable)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black87),
                    onPressed: () => onDelete(e.key),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: FlowstockTextStyles.buttonAction,
            ),
          ),
        ),
      ],
    );
  }
}
