import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/providers/usuario_provider.dart';
import 'package:flow_stock/presentation/screens/home_screen.dart';
import 'package:flow_stock/presentation/widgets/login_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);

    // Accede al provider de usuario
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);

    // Busca el usuario con el correo y contraseña    
    final usuario = await usuarioProvider.login(
      _correoController.text.trim(),
      _contrasenaController.text.trim(),
    );

    setState(() => isLoading = false);

    if (usuario != null) {
      // Si regresa un usuario ejecuta pantalla de menú pasando el rol
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(rol: usuario.rol),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: LoginBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: _buidLoginContent(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  
  // Widget que contienen los controladores del correo y contraseña
  Widget _buidLoginContent() {
    return Container(
      padding: EdgeInsets.all(64),
      width: 600,
      decoration: BoxDecoration(
          color: Colors.blueGrey, borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('/stock.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'ERP Flow Stock', 
            style: TextStyle(
              fontSize: 24, 
              color: Colors.white, 
              
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text("Iniciar Sesión"),
          ),
        ],
      ),
    );
  }
}
