import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/producto.dart';

class ProductoSearchDelegate extends SearchDelegate<Producto?> {
  final List<Producto> productos;

  ProductoSearchDelegate({required this.productos});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultados = productos.where((p) =>
        p.nombre.toLowerCase().contains(query.toLowerCase()));

    if (resultados.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }

    return ListView(
      children: resultados.map((p) {
        return ListTile(
          title: Text(p.nombre),
          subtitle: Text('ID: ${p.idProducto}'),
          onTap: () => close(context, p),
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugerencias = productos.where((p) =>
        p.nombre.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: sugerencias.map((p) {
        return ListTile(
          title: Text(p.nombre),
          onTap: () {
            query = p.nombre;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
