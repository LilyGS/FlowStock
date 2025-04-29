import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/usuario.dart';
import 'package:flow_stock/pattern/facade/usuario_facade.dart';

class UsuarioProvider with ChangeNotifier {

  // Instancia de UsuarioFacade para interactuar con la base de datos
  final UsuarioFacade _facade = UsuarioFacade();

  bool isLoading = false;
  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;

  // Carga todos los usuarios.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
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

  // Agrega un nuevo usuario y recarga la lista de usuarios
  Future<void> agregarUsuario(Usuario usuario) async {
    await _facade.insertarUsuario(usuario);
    await cargarUsuarios();
  }

  // Actualiza un usuario y recarga la lista de usuarios
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _facade.actualizarUsuario(usuario);
    await cargarUsuarios();
  }

  // Realiza un borrado lógico de un usuario y recarga la lista
  Future<void> eliminarUsuario(int idUsuario) async {
    await _facade.eliminarUsuario(idUsuario);
    await cargarUsuarios();
  }

  // Activa un usuario previamente inactivo y recarga la lista de usuarios
  Future<void> activarUsuario(int idUsuario) async {
    await _facade.activarUsuario(idUsuario);
    await cargarUsuarios();
  }

  // Regresa el usuario y recarga la lista de usuarios
  Future<Usuario?> login(String correo, String contrasena) async {
    final usuario = await _facade.loginUsuario(correo, contrasena);
    if (usuario != null) {
      _usuarioActual = usuario;

      notifyListeners();
    }
    return usuario;
  }

  // Cierra la sesión y recarga la lista de usuarios
  Future<void> cerrarSesion() async {
    _usuarioActual = null;
    notifyListeners();
  }
}
