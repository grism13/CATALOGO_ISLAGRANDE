import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sistema_inventario.dart';
import '../providers/inventory_provider.dart';
import '../theme/app_theme.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _urlCtrl;
  String _categoriaSeleccionada = 'Bebidas';
  bool _disponible = true;
  bool _isUploadingImage = false;

  bool _isInit = false;
  late Producto producto;
  bool _isSaving = false;

  final List<String> _categorias = [
    'Bebidas',
    'Snacks',
    'Licores',
    'Protectores',
    'Higiene',
    'Accesorios',
    'Souvenirs'
  ];

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      producto = ModalRoute.of(context)!.settings.arguments as Producto;
      _nombreCtrl = TextEditingController(text: producto.nombre);
      _precioCtrl = TextEditingController(text: producto.precio.toString());
      _stockCtrl = TextEditingController(text: producto.stock.toString());
      _descripcionCtrl = TextEditingController(text: producto.descripcion);
      _urlCtrl = TextEditingController(text: producto.url);
      _disponible = producto.disponible;
      
      if (_categorias.contains(producto.categoria)) {
        _categoriaSeleccionada = producto.categoria;
      } else if (producto.categoria.isNotEmpty && !_categorias.contains(producto.categoria)) {
         _categorias.add(producto.categoria);
         _categoriaSeleccionada = producto.categoria;
      } else {
         _categoriaSeleccionada = _categorias.first;
      }

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _descripcionCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _isUploadingImage = true);
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      final uploadedUrl = await provider.subirImagenImgBB(pickedFile.path);
      if (uploadedUrl != null) {
        setState(() {
          _urlCtrl.text = uploadedUrl;
          producto.url = uploadedUrl; 
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen subida correctamente'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al subir imagen'), backgroundColor: Colors.red));
      }
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSaving = true;
    });

    producto.nombre = _nombreCtrl.text;
    producto.precio = double.tryParse(_precioCtrl.text) ?? 0.0;
    producto.stock = int.tryParse(_stockCtrl.text) ?? 0;
    producto.descripcion = _descripcionCtrl.text;
    producto.url = _urlCtrl.text;
    producto.categoria = _categoriaSeleccionada;
    producto.disponible = _disponible;

    final provider = Provider.of<InventoryProvider>(context, listen: false);
    final exito = await provider.actualizarProducto(producto);

    setState(() {
      _isSaving = false;
    });

    if (exito && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado exitosamente'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(); 
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar producto'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColorLight,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.lightYellow),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logotipo.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.red, size: 40),
            ),
          ),
        ],
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Hero(
                            tag: 'product_image_${producto.id}',
                            child: _urlCtrl.text.isNotEmpty
                                ? FadeInImage(
                                    placeholder: const AssetImage('assets/images/placeholder.png'),
                                    image: NetworkImage(_urlCtrl.text),
                                    height: 200,
                                    fit: BoxFit.contain,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/placeholder.png', height: 200, fit: BoxFit.contain);
                                    },
                                  )
                                : Image.asset('assets/images/placeholder.png', height: 200, fit: BoxFit.contain),
                          ),
                          if (_isUploadingImage)
                            const CircularProgressIndicator(color: AppTheme.primaryColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Toca la imagen para cambiarla', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 20),

                    _buildCustomInputContainer(
                      icon: Icons.edit,
                      label: 'NOMBRE',
                      child: TextFormField(
                        controller: _nombreCtrl,
                        decoration: _buildInputDecoration(),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildCustomInputContainer(
                            icon: Icons.grid_view,
                            label: 'CATEGORIA',
                            child: DropdownButtonFormField<String>(
                              value: _categoriaSeleccionada,
                              decoration: _buildInputDecoration(),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _categorias.map((cat) {
                                return DropdownMenuItem(value: cat, child: Text(cat.toUpperCase()));
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _categoriaSeleccionada = val!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: _buildCustomInputContainer(
                            icon: Icons.edit,
                            label: 'PRECIO (\$)',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _precioCtrl,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: _buildInputDecoration(),
                                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                                  onChanged: (v) => setState(() {}),
                                ),
                                const SizedBox(height: 4),
                                Consumer<InventoryProvider>(
                                  builder: (context, prov, child) {
                                    final double val = double.tryParse(_precioCtrl.text) ?? 0.0;
                                    final double bs = val * (prov.sistema?.configuracion.tasaBcv ?? 1.0);
                                    return Text(
                                      '≈ ${bs.toStringAsFixed(2)} Bs',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    );
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildCustomInputContainer(
                            icon: Icons.inventory,
                            label: 'STOCK',
                            child: TextFormField(
                              controller: _stockCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _buildInputDecoration(),
                              validator: (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 5,
                          child: _buildCustomInputContainer(
                            icon: Icons.visibility,
                            label: 'DISPONIBLE',
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Switch(
                                value: _disponible,
                                activeColor: AppTheme.darkBlue,
                                activeTrackColor: AppTheme.lightYellow,
                                onChanged: (val) {
                                  setState(() {
                                    _disponible = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildCustomInputContainer(
                      icon: Icons.edit,
                      label: 'DESCRIPCION',
                      child: TextFormField(
                        controller: _descripcionCtrl,
                        maxLines: 4,
                        decoration: _buildInputDecoration(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _guardarCambios,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Icon(
                            Icons.save_outlined,
                            color: AppTheme.lightYellow,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCustomInputContainer({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.midBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.darkBlue, width: 2),
      ),
    );
  }
}
