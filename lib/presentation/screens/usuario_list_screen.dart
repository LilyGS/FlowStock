import 'package:flow_stock/data/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/providers/usuario_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/usuario_form_screen.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  @override
  void initState() {
    super.initState();

    // Se ejecuta cuando el widget se renderizó
    // Carga los usuarios desde el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UsuarioProvider>(context, listen: false);
      provider.cargarUsuarios();
    });
  }

  // Método del diálogo para eliminar usuario
  void _confirmarEliminarUsuario(int idUsuario) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final provider =
                    Provider.of<UsuarioProvider>(context, listen: false);
                await provider.eliminarUsuario(idUsuario);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario eliminado con éxito.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Método para reactivar usuario
  void _activarUsuario(int idUsuario) async {
    final provider = Provider.of<UsuarioProvider>(context, listen: false);
    await provider.activarUsuario(idUsuario);
    await provider.cargarUsuarios();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario restaurado con éxito.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Método que llama pantalla para editar usuario
  Future<void> _editarUsuario(Usuario usuario) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsuarioFormScreen(usuario: usuario),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<UsuarioProvider>(context, listen: false);
      await provider.cargarUsuarios();
    }
  }
  
  // Método que llama pantalla para registrar nuevo usuario
  Future<void> _showUsuarioScreen() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => UsuarioFormScreen()));
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<UsuarioProvider>(context, listen: false);
      await provider.cargarUsuarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accede al provider de usuario
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuarios = usuarioProvider.usuarios;
    final isLoading = usuarioProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleUsuario), // Empleo de constantes
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await usuarioProvider.cargarUsuarios();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final usuario = usuarios[index];

                      // Card para cada usuario
                      return Card(
                        color: usuario.status == 'inactivo'
                            ? Colors.grey[300]
                            : null,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(usuario.nombre,
                              style: FlowstockTextStyles.listTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(usuario.correo,
                                  style: FlowstockTextStyles.listSubTitle),
                              Text(usuario.status,
                                  style: FlowstockTextStyles.listSubTitle)
                            ],
                          ),
                          // Al dar clic abre la pantalla para editar el usuario
                          onTap: () => _editarUsuario(usuario),
                          trailing: usuario.status == 'activo'
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.blue),
                                  onPressed: () => _confirmarEliminarUsuario(
                                      usuario.idUsuario!),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.restore,
                                      color: Colors.orange),
                                  onPressed: () =>
                                      _activarUsuario(usuario.idUsuario!),
                                ),
                        ),
                      );
                    }, childCount: usuarios.length),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUsuarioScreen,
        label: const Text(FlowstockConstants.titleNewUsuario),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
