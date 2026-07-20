import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/inventory_provider.dart';
import '../models/sistema_inventario.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.darkBlue, 
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: AppTheme.darkBlue,
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
                  Center(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent, 
                      ),
                      child: Image.asset('assets/images/ISLA GRANDE.png', fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: AppTheme.lightYellow, size: 35),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

          Expanded(
            child: Container(
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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.currency_exchange, color: AppTheme.lightYellow, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'BCV - ${inventoryProvider.sistema?.configuracion.fechaActualizacion.day.toString().padLeft(2, '0')}/${inventoryProvider.sistema?.configuracion.fechaActualizacion.month.toString().padLeft(2, '0')}/${inventoryProvider.sistema?.configuracion.fechaActualizacion.year}\n${inventoryProvider.sistema?.configuracion.tasaBcv.toStringAsFixed(2)} Bs',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Ver Bs', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    Switch(
                                      value: inventoryProvider.mostrarEnBolivares,
                                      activeThumbColor: AppTheme.lightYellow,
                                      onChanged: (val) {
                                        inventoryProvider.toggleMoneda();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'RESUMEN',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  letterSpacing: 4,
                                ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _VerticalMetricCard(
                                  icon: Icons.attach_money,
                                      value: '\$${inventoryProvider.ingresos.toStringAsFixed(2)}',
                                      title: 'INGRESOS',
                                      color: AppTheme.midBlue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    _HorizontalMetricCard(
                                      icon: Icons.check_circle_outline,
                                      value: '${inventoryProvider.pedidosConcretados}',
                                      title: 'CONCRETADOS',
                                      color: AppTheme.concretado, 

                                    ),
                                    const SizedBox(height: 16),
                                    _HorizontalMetricCard(
                                      icon: Icons.access_time,
                                  value: '${inventoryProvider.pedidosPendientes}',
                                  title: 'PENDIENTES',
                                  color: AppTheme.rechazado, 
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'STOCK BAJO',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      letterSpacing: 4,
                                    ),
                              ),
                              const Text(
                                'MOSTRAR TODO',
                                style: TextStyle(
                                  color: AppTheme.midBlue, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15, 
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250, 
                            child: inventoryProvider.lowStockProductos.isEmpty
                                ? const Center(child: Text('Todo el stock está normal'))
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: inventoryProvider.lowStockProductos.length,
                                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                                    itemBuilder: (context, index) {
                                      final producto = inventoryProvider.lowStockProductos[index];
                                      return _LowStockItem(producto: producto);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      )),
    );
  }
}

class _VerticalMetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color color;

  const _VerticalMetricCard({
    required this.icon,
    required this.value,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, 
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.lightYellow, size: 40), 
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 60, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.lightYellow,
              fontSize: 20,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalMetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color color;

  const _HorizontalMetricCard({
    required this.icon,
    required this.value,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, 
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.lightYellow, size: 30), 
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 35, 
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockItem extends StatelessWidget {
  final Producto producto;

  const _LowStockItem({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, 
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color:AppTheme.backgroundColor), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15), 
                ),
                child: Hero(
                  tag: 'lowstock_${producto.id}',
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
          ),
          const SizedBox(height: 10),
          Text(
            producto.nombre,
            style: const TextStyle(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16, 
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.lightYellow, 
              borderRadius: BorderRadius.circular(10), 
            ),
            child: Text(
              'Stock: ${producto.stock}',
              style: const TextStyle(
                color: AppTheme.rechazado,
                fontWeight: FontWeight.bold,
                fontSize: 11, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
