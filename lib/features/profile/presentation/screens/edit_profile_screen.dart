import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart' show rootBundle; // Para cargar el JSON
import 'dart:convert'; // Para decodificar el JSON

import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/profile/data/profile_repository.dart';
import 'package:huerto_hogar_2/features/profile/domain/profile_model.dart';
// Asumo que este es el modelo correcto para el JSON:
import 'package:huerto_hogar_2/common/models/chile_location_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileRepository = ProfileRepository();
  late final Stream<ProfileModel> _profileStream;

  // Controladores para campos de texto
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController(); // Calley y Número
  final _postalCodeController = TextEditingController(); // Código Postal (Lectura)

  // --- VARIABLES PARA EL MANEJO DE UBICACIÓN (JSON) ---
  List<Region> _regions = [];
  Region? _selectedRegion;
  Communa? _selectedCommuna;
  // ----------------------------------------------------

  bool _isProfileLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileStream = _profileRepository.getProfileStream();
    _loadLocationData(); // Cargar datos de ubicación al inicio
  }

  // Carga el JSON de ubicación (Asume assets/chile_regions_communes.json)
  Future<void> _loadLocationData() async {
    // Asegúrate de que tu archivo JSON se llama 'chile_regions_communes.json'
    // y está declarado en pubspec.yaml
    final String response = await rootBundle.loadString('assets/data/chile_locations.json');
    final data = json.decode(response) as Map<String, dynamic>;
    
    // Asumo que el JSON tiene una clave 'regiones'
    setState(() {
      _regions = (data['regions'] as List)
          .map((regionJson) => Region.fromJson(regionJson))
          .toList();
    });
  }

  // Inicializa los controladores y dropdowns con datos del perfil
  void _initializeFieldsWithProfile(ProfileModel profile) {
    if (_isProfileLoaded) return; // Evitar inicializar múltiples veces

    _nameController.text = profile.fullName;
    _phoneController.text = profile.telefonNumber;
    _streetAddressController.text = profile.streetAddress;
    _postalCodeController.text = profile.postalCode;

    // 1. Inicializar la región seleccionada
    _selectedRegion = _regions.firstWhere(
      (region) => region.name == profile.region,
    );

    // 2. Inicializar la comuna seleccionada
    if (_selectedRegion != null) {
      _selectedCommuna = _selectedRegion!.communes.firstWhere(
        (communa) => communa.name == profile.commune,
      );
    }
    
    // Marcar como cargado
    _isProfileLoaded = true;
  }


  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  // Función _saveProfile REAL
  Future<void> _saveProfile() async { 
    // Validación básica y de ubicación
    if (_nameController.text.trim().isEmpty || 
        _phoneController.text.trim().isEmpty ||
        _streetAddressController.text.trim().isEmpty ||
        _selectedRegion == null ||
        _selectedCommuna == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, completa todos los campos de nombre, teléfono y dirección.')),
        );
      }
      return;
    }

    setState(() { _isLoading = true; });
    
    try {
      // Llama al repositorio para guardar todos los campos, incluyendo dirección
      await _profileRepository.updateProfile( 
        fullName: _nameController.text.trim(),
        telefon_number: _phoneController.text.trim(),
        region: _selectedRegion!.name,
        commune: _selectedCommuna!.name,
        streetAddress: _streetAddressController.text.trim(),
        postalCode: _postalCodeController.text.trim(), // Enviamos el CP que ya está en el controller
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito!')),
        );
        context.pop(); // Vuelve a la pantalla de Perfil
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Editar Perfil',
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: StreamBuilder<ProfileModel>(
        stream: _profileStream,
        builder: (context, snapshot) {
          // Si el JSON no ha cargado O el Stream está en espera
          if (snapshot.connectionState == ConnectionState.waiting || _regions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          // Estado de error o sin datos
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró el perfil.'));
          }

          final profile = snapshot.data!;

          // Inicializamos los campos solo una vez, después de que los datos estén listos
          if (!_isProfileLoaded) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeFieldsWithProfile(profile);
                setState(() {}); // Forzar el rebuild para mostrar valores en dropdowns
             });
          }

          // Mostramos el formulario
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- CAMPOS PERSONALES ---
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre Completo',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Dirección de Envío', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
                const Divider(height: 20, thickness: 1),

                // --- SELECTOR DE REGIONES ---
                _buildDropdownField<Region>(
                  'Región',
                  Icons.public_outlined,
                  _regions,
                  _selectedRegion,
                  (Region? newValue) {
                    setState(() {
                      _selectedRegion = newValue;
                      _selectedCommuna = null; // Resetear comuna al cambiar región
                      _postalCodeController.text = '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // --- SELECTOR DE COMUNAS ---
                _buildDropdownField<Communa>(
                  'Comuna',
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

                // --- CALLE Y NÚMERO ---
                _buildTextField(
                  controller: _streetAddressController,
                  label: 'Calle y Número',
                  icon: Icons.home_outlined,
                ),
                const SizedBox(height: 16),

                // --- CÓDIGO POSTAL (SOLO LECTURA) ---
                TextFormField(
                  controller: _postalCodeController,
                  readOnly: true,
                  enabled: false,
                  decoration: _inputDecoration('Código Postal', Icons.tag).copyWith(
                    fillColor: Colors.grey.shade100,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 40),
                
                PrimaryButton(
                  text: _isLoading ? 'Guardando...' : 'Guardar Cambios',
                  onPressed: _isLoading ? null : _saveProfile,
                  isLoading: _isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper para TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce tu $label.';
        }
        return null;
      },
    );
  }

  // Helper para InputDecoration
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      
    );
  }

  // Helper para DropdownField (Adaptado para Region o Communa)
  Widget _buildDropdownField<T>(
    String hintText,
    IconData icon,
    List<T> items,
    T? selectedValue,
    ValueChanged<T?> onChanged, {
    bool isDisabled = false,
  }) {
    return DropdownButtonFormField<T>(
      decoration: _inputDecoration(hintText, icon).copyWith(
        fillColor: isDisabled ? Colors.grey[100] : Colors.grey[200],
      ),
      initialValue: selectedValue,
      hint: Text(hintText),
      isExpanded: true,
      onChanged: isDisabled ? null : onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        String displayText;
        if (value is Region) {
          displayText = value.name;
        } else if (value is Communa) {
          displayText = value.name;
        } else {
          displayText = value.toString();
        }
        return DropdownMenuItem<T>(
          value: value,
          child: Text(displayText),
        );
      }).toList(),
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
    );
  }
}
