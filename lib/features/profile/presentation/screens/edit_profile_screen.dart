import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controladores para manejar el texto de los campos
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Simula que cargamos los datos actuales del usuario
    _nameController = TextEditingController(text: 'Sofia Ramirez');
    _emailController = TextEditingController(text: 'sofia.ramirezh@email.com');
    _phoneController = TextEditingController(text: '+56 9 1234 5678');
    _addressController = TextEditingController(text: '123 Main Street, Santiago');
  }

  @override
  void dispose() {
    // Limpia los controladores cuando la pantalla se destruye
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Simula la acción de guardar
  void _saveProfile() {
    // Aquí iría la lógica para llamar a Supabase
    // ...
    
    // Mostramos un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil actualizado con éxito'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Regresamos a la pantalla de Perfil
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold!
    return Column(
      children: [
        // --- 1. EL APPBAR REUTILIZABLE ---
        CustomAppBar(
          title: 'Editar Perfil',
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Como llegamos con 'push', podemos usar 'pop'
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ),

        // --- 2. EL FORMULARIO ---
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre Completo',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _addressController,
                  label: 'Dirección',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 40),
                
                // --- 3. EL BOTÓN DE GUARDAR ---
                PrimaryButton(
                  text: 'Guardar Cambios',
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget Helper para crear los campos de texto ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}