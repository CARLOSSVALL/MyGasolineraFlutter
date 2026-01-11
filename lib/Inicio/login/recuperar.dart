import 'package:flutter/material.dart';
import 'package:my_gasolinera/Inicio/login/nueva_password.dart';
import 'package:my_gasolinera/services/auth_service.dart';

// Pantalla para solicitar la recuperacion de la contraseña
// Muestra un formulario con un campo de correo y un boton de envío
class RecuperarPassword extends StatefulWidget {
  const RecuperarPassword({super.key});

  @override
  State<RecuperarPassword> createState() => _RecuperarPasswordState();
}

class _RecuperarPasswordState extends State<RecuperarPassword> {
  final _formKey = GlobalKey<FormState>();
  // COntrolador del campo para el boton de envio
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.forgotPassword(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se ha enviado un código a tu correo'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navegar a la pantalla de nueva contraseña pasando el email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NuevaPasswordScreen(email: _emailController.text.trim()),
          ),
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ?? 'Error al solicitar recuperación',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Colores usados en los campos
  @override
  Widget build(BuildContext context) {
    // --- LÓGICA DE COLORES DINÁMICOS ---
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFFE8DA);
    final cardColor =
        isDark ? const Color(0xFF1F1F1F) : const Color(0xFFFFCFB0);
    final accent = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFFF9350); // Botón más discreto en dark
    // Texto
    final textColor = isDark ? Colors.white : const Color(0xFF492714);
    // Inputs
    final inputFill = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final inputText = isDark ? Colors.white : Colors.black;
    final hintText = isDark ? Colors.white70 : const Color(0xFF492714);

    final maxWidth =
        MediaQuery.of(context).size.width * 0.95; // Aumentado de 0.85 a 0.95
    final cardWidth =
        maxWidth > 520.0 ? 520.0 : maxWidth; // Aumentado de 420 a 520

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24), // Aumentado de 20 a 24
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 36,
            ), // Aumentado de 24,28 a 32,36
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16), // Aumentado de 12 a 16
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(
                    0,
                    0,
                    0,
                    0.15,
                  ), // Aumentado de 0.12 a 0.15
                  blurRadius: 16, // Aumentado de 12 a 16
                  offset: const Offset(0, 8), // Aumentado de 6 a 8
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12), // Aumentado de 8 a 12
                  Text(
                    'MyGasolinera',
                    style: TextStyle(
                      fontSize: 28, // Aumentado de 22 a 28
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ), // Aumentado de 12 a 16
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/logo.png',
                          width: 150, // Aumentado de 120 a 150
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16), // Aumentado de 12 a 16
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recuperar contraseña',
                    style: TextStyle(
                      fontSize: 24, // Aumentado de 20 a 24
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 24), // Aumentado de 18 a 24
                  // Campo de correo electrónico más grande
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 16,
                      color: inputText,
                    ), // Añadido tamaño de fuente y color dinámico
                    enabled: !_isLoading,
                    // Añadir el manejador de teclas
                    onFieldSubmitted: (value) => _handleForgotPassword(),
                    decoration: InputDecoration(
                      hintText: 'e-mail',
                      hintStyle: TextStyle(color: hintText),
                      filled: true,
                      fillColor: inputFill,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ), // Aumentado
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Aumentado de 8 a 10
                        borderSide: BorderSide(color: hintText),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: textColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      // Comprueba que el campo del correo no esté vacio
                      if (value == null || value.isEmpty) {
                        return 'Introduce un correo';
                      }
                      if (!value.contains('@')) {
                        return 'Introduce un correo válido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24), // Aumentado de 20 a 24
                  // Botón más grande
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor:
                            isDark ? Colors.white : const Color(0xFF492714),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ), // Aumentado de 14 a 18
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ), // Añadido tamaño de fuente
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark
                                      ? Colors.white
                                      : const Color(0xFF492714),
                                ),
                              ),
                            )
                          : const Text('Solicitar recuperación'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
