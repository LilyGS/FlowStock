import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/usuario.dart';
import 'package:flow_stock/pattern/facade/usuario_facade.dart';

class UsuarioProvider with ChangeNotifier {
  final UsuarioFacade _facade = UsuarioFacade();

  bool isLoading = false;
  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;

  Future<void> cargarUsuarios() async {
    isLoading = true;
    notifyListeners();

    try {
      _usuarios = await _facade.obtenerUsuarios();
    } catch (e) {
      //  error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarUsuario(Usuario usuario) async {
    await _facade.insertarUsuario(usuario);
    await cargarUsuarios();
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _facade.actualizarUsuario(usuario);
    await cargarUsuarios();
  }

  Future<void> eliminarUsuario(int idUsuario) async {
    await _facade.eliminarUsuario(idUsuario);
    await cargarUsuarios();
  }

  Future<void> activarUsuario(int idUsuario) async {
    await _facade.activarUsuario(idUsuario);
    await cargarUsuarios();
  }

  Future<Usuario?> login(String correo, String contrasena) async {
    final usuario = await _facade.loginUsuario(correo, contrasena);
    if (usuario != null) {
      _usuarioActual = usuario;

      notifyListeners();
    }
    return usuario;
  }

  Future<void> cerrarSesion() async {
    _usuarioActual = null;
    notifyListeners();
  }
}
