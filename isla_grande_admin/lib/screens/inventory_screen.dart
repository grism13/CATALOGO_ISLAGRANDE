import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/inventory_provider.dart';
import '../models/sistema_inventario.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.darkBlue, 
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue, 
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.lightYellow, size: 30), 
          onPressed: () {},
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              height: 50, 
              decoration: BoxDecoration(
                color: AppTheme.midBlue, 
                borderRadius: BorderRadius.circular(25), 
              ),
              child: TextField(
                onChanged: (value) => inventoryProvider.setBusqueda(value),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar producto a editar',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor, 
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), 
                  topRight: Radius.circular(30),
                ),
              ),
              
              child: inventoryProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CATEGORIAS',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  letterSpacing: 2,
                                  fontSize: 28,
                                ),
                          ),
                          const SizedBox(height: 16),
                          
                          GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              _CategoryPill(text: 'TODOS', icon: Icons.border_all),
                              _CategoryPill(text: 'BEBIDAS', icon: Icons.local_drink),
                              _CategoryPill(text: 'SNACKS', icon: Icons.fastfood),
                              _CategoryPill(text: 'LICORES', icon: Icons.liquor),
                              _CategoryPill(text: 'PROTECTORES', icon: Icons.wb_sunny),
                              _CategoryPill(text: 'HIGIENE', icon: Icons.clean_hands),
                              _CategoryPill(text: 'ACCESORIOS', icon: Icons.watch),
                              _CategoryPill(text: 'SOUVENIRS', icon: Icons.card_giftcard),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'product_create');
                                },
                                icon: const Icon(Icons.add_circle_outline, color: AppTheme.lightYellow),
                                label: const Text(
                                  'AGREGAR NUEVO PRODUCTO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor, 
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PRODUCTOS',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppTheme.lightYellow,
                                        fontSize: 24, 
                                        letterSpacing: 4,
                                      ),
                                ),
                                Text(
                                  '${inventoryProvider.productosFiltrados.length} artículos',
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inventoryProvider.productosFiltrados.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65, 
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              final producto = inventoryProvider.productosFiltrados[index];
                              return _ProductCard(producto: producto);
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String text;
  final IconData icon;

  const _CategoryPill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final isActive = inventoryProvider.categoriaSeleccionada == text;

    return GestureDetector(
      onTap: () {
        inventoryProvider.setCategoria(text);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppTheme.darkBlue : AppTheme.lightYellow, 
          borderRadius: BorderRadius.circular(15), 
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppTheme.darkBlue, 
              size: 24, 
            ),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.darkBlue, 
                fontSize: 10, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;

  const _ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    final bool mostrarBs = provider.mostrarEnBolivares;
    final double tasa = provider.sistema?.configuracion.tasaBcv ?? 1.0;
    final String precioText = mostrarBs 
        ? '${(producto.precio * tasa).toStringAsFixed(2)} Bs' 
        : 'REF.${producto.precio}\$';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'product_detail', arguments: producto);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, 
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.lightYellow, 
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  child: Text(
                    'STOCK: ${producto.stock}',
                    style: const TextStyle(
                      color: AppTheme.darkBlue, 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.lightYellow, 
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  child: Text(
                    producto.categoria.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.darkBlue, 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'product_image_${producto.id}',
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(producto.url.isNotEmpty ? producto.url : 'https://via.placeholder.com/100'),
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/no-image.jpg', fit: BoxFit.contain);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              producto.nombre,
              style: const TextStyle(
                color: AppTheme.darkBlue, 
                fontSize: 19, 
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  precioText,
                  style: const TextStyle(
                    color: AppTheme.primaryColor, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'product_edit', arguments: producto);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.darkBlue, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white, 
                      size: 20, 
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
