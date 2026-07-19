import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sistema_inventario.dart';
import '../providers/inventory_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Producto producto = ModalRoute.of(context)!.settings.arguments as Producto;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColorLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomHeader(context, producto),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Hero(
                tag: 'product_image_${producto.id}',
                child: SizedBox(
                   height: 180,
                   child: producto.url.isNotEmpty
                    ? FadeInImage(
                        placeholder: const AssetImage('assets/images/placeholder.png'),
                        image: NetworkImage(producto.url),
                        fit: BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/placeholder.png', fit: BoxFit.contain);
                        },
                      )
                    : Image.asset('assets/images/placeholder.png', fit: BoxFit.contain),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                     BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                     )
                  ]
                ),
                child: Text(
                  producto.descripcion.isNotEmpty ? producto.descripcion : 'Sin descripción',
                  style: const TextStyle(
                     color: AppTheme.midBlue,
                     fontSize: 16,
                     height: 1.4,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text(
                           'CATEGORIA',
                           style: TextStyle(
                             color: AppTheme.midBlue, 
                             fontWeight: FontWeight.bold,
                             letterSpacing: 2,
                           ),
                         ),
                         const SizedBox(height: 10),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                           decoration: BoxDecoration(
                             color: AppTheme.lightTeal,
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Text(
                             producto.categoria,
                             style: const TextStyle(
                               color: AppTheme.midBlue,
                               fontWeight: FontWeight.bold,
                               fontSize: 16
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                        const Text(
                          'PRECIO REF.',
                          style: TextStyle(
                             color: AppTheme.midBlue, 
                             fontWeight: FontWeight.bold,
                             letterSpacing: 2,
                           ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                             color: AppTheme.paleYellow,
                             borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '\$${producto.precio.toInt()}',
                                style: const TextStyle(
                                  color: AppTheme.midBlue,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'REF. USD',
                                style: TextStyle(
                                  color: AppTheme.midBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                     ],
                   )
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: AppTheme.veryLightTeal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'STOCK DISPONIBLE:',
                      style: TextStyle(
                         color: AppTheme.midBlue,
                         fontWeight: FontWeight.bold,
                         letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                         color: AppTheme.darkTeal,
                         borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                           const Icon(Icons.circle, color: AppTheme.midBlue, size: 10),
                           const SizedBox(width: 5),
                           Text(
                             '${producto.stock} unid.',
                             style: const TextStyle(
                                color: AppTheme.midBlue,
                                fontWeight: FontWeight.bold,
                             ),
                           )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 250, 
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                     Navigator.pushNamed(context, 'product_edit', arguments: producto);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkBlue,
                    shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: AppTheme.lightYellow),
                  label: const Text(
                    'EDITAR PRODUCTO',
                    style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, Producto producto) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              left: -10,
              child: Image.asset('assets/images/8.png', width: 90, fit: BoxFit.contain),
            ),
            Positioned(
              bottom: -15,
              left: -10,
              child: Image.asset('assets/images/6.png', width: 70, fit: BoxFit.contain),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/images/7.png', width: 70, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                            Text('Volver', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Producto'),
                          content: const Text('¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final provider = Provider.of<InventoryProvider>(context, listen: false);
                                final exito = await provider.eliminarProducto(producto.id);
                                Navigator.pop(context); 
                                if (exito) {
                                  Navigator.pop(context); 
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Producto eliminado'), backgroundColor: Colors.red),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error al eliminar producto'), backgroundColor: Colors.orange),
                                  );
                                }
                              },
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          
          Text(
            producto.nombre.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              producto.categoria.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ), // Column
    ), // Padding
  ],
), // Stack
      ), // ClipRRect
    );
  }
}
