import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/auth/presentation/widgets/auth_layout.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/auth/data/auth_repository.dart';
// Importamos el modelo de datos
import 'package:huerto_hogar_2/common/models/chile_location_model.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores existentes
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController(); // Calle y Número
  final _postalCodeController = TextEditingController();
  // --- VARIABLES PARA EL SELECTOR DE UBICACIÓN ---
  List<Region> _regions = [];
  Region? _selectedRegion;
  Communa? _selectedCommuna;
  // ---------------------------------------------
  
  final _authRepository = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocationData(); // Carga los datos del JSON al iniciar
  }

  // --- FUNCIÓN PARA CARGAR EL JSON ---
  Future<void> _loadLocationData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/chile_locations.json');
      final data = await json.decode(response);
      
      setState(() {
        final List<dynamic> regionsData = data['regions'];
        _regions = regionsData.map((r) => Region.fromJson(r as Map<String, dynamic>)).toList();
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos de ubicación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- FUNCIÓN DE REGISTRO ACTUALIZADA ---
  Future<void> _register() async {
    // VALIDACIÓN BÁSICA
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _streetController.text.isEmpty || 
        _selectedRegion == null || 
        _selectedCommuna == null) { 
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos de registro.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Validación de Contraseña
    if (_passwordController.text != _confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          backgroundColor: Colors.red,
        ),
      );
      return; 
    }

    setState(() { _isLoading = true; });

try {
      // 1. EXTRAER los valores de ubicación (¡CORRECCIÓN AQUÍ!)
      final regionName = _selectedRegion!.name;
      final communeName = _selectedCommuna!.name;
      final postalCode = _selectedCommuna!.postalCode; // Se obtiene automáticamente
      final streetAddress = _streetController.text.trim(); // Calle y Número

      // NOTA: Se elimina la variable 'fullAddress' que ya no usamos
      
      // 2. LLAMAR A signUp con los 8 argumentos separados
      await _authRepository.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(), // fullName
        _phoneController.text.trim(), // phone
        regionName,        // region
        communeName,       // commune
        streetAddress,     // street_address
        postalCode,        // postal_code
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada con éxito! Por favor, inicia sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Vuelve a Login
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Crear Cuenta',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Completa tus datos de contacto y ubicación.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              
              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nombre Completo', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              
              // Teléfono
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Teléfono +569 1234 5678', Icons.phone_outlined),
              ),
              const SizedBox(height: 24),

              // --- SELECTOR DE REGIONES ---
              _buildDropdownField<Region>(
                'Selecciona Región',
                Icons.public,
                _regions,
                _selectedRegion,
                (Region? newValue) {
                  setState(() {
                    _selectedRegion = newValue;
                    // Resetear la comuna y el código postal al cambiar la región
                    _selectedCommuna = null; 
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // --- SELECTOR DE COMUNAS (Depende de la Región) ---
              _buildDropdownField<Communa>(
                _selectedRegion == null ? 'Selecciona Comuna' : 'Selecciona Comuna',
                Icons.location_city_outlined,
                _selectedRegion?.communes ?? [],
                _selectedCommuna,
                (Communa? newValue) {
                  setState(() {
                    _selectedCommuna = newValue;
                    if (newValue != null) {
                      _postalCodeController.text = newValue.postalCode;
                    } else {
                      _postalCodeController.text = '';
                    }
                  });
                },
                isDisabled: _selectedRegion == null, // Desactivado si no hay región
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _postalCodeController,
                readOnly: true, // ¡Importante! No se puede editar
                enabled: false, // ¡Importante! Se ve deshabilitado
                decoration: _inputDecoration('Código Postal', Icons.tag).copyWith(
                  // Estilo para que se vea diferente si quieres
                  fillColor: Colors.grey.shade100,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Calle y Número 
              TextFormField(
                controller: _streetController,
                decoration: _inputDecoration('Calle, N° y Depto (opcional)', Icons.house_outlined),
              ),
              const SizedBox(height: 24),
              
              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration('Contraseña', Icons.lock_outline),
              ),
              const SizedBox(height: 16),
              
              // Confirmar Contraseña
              TextFormField(
                controller: _confirmPasswordController, 
                obscureText: true,
                decoration: _inputDecoration('Confirmar Contraseña', Icons.lock_reset_outlined),
              ),
              
              const SizedBox(height: 40),

              PrimaryButton(
                onPressed: _isLoading ? null : () => _register(),
                text: 'Crear Cuenta',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper para simplificar la decoración de TextFields
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // --- WIDGET HELPER PARA LOS DROPDOWNS ---
  // Se usa una T (Generic) para que funcione tanto con Region como con Communa
  Widget _buildDropdownField<T> (
    String label, 
    IconData icon, 
    List<T> items, 
    T? selectedValue, 
    ValueChanged<T?> onChanged,
    {bool isDisabled = false}) {
    
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      initialValue: selectedValue,
      isExpanded: true,
      hint: Text(label),
      // Si está deshabilitado, el onChanged es nulo
      onChanged: isDisabled ? null : onChanged, 
      items: items.map<DropdownMenuItem<T>>((T value) {
        // Obtenemos el nombre dinámicamente
        String name = (value is Region) ? value.name : (value as Communa).name;
        return DropdownMenuItem<T>(
          value: value,
          child: Text(name),
        );
      }).toList(),
    );
  }
}