import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/sistema_inventario.dart';
import '../theme/app_theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _showPendientes = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    
    final provider = Provider.of<InventoryProvider>(context);
    final List<Pedido> bdPedidos = provider.sistema?.pedidos.values.toList() ?? [];

    final List<Map<String, dynamic>> mockPedidos = bdPedidos.map((p) {
      String hora = "${p.fecha.hour > 12 ? p.fecha.hour - 12 : p.fecha.hour}:${p.fecha.minute.toString().padLeft(2, '0')} ${p.fecha.hour >= 12 ? 'p. m.' : 'a. m.'}";
      String fechaCorta = "${p.fecha.day}/${p.fecha.month}/${p.fecha.year}";
      
      return {
        'id': p.codigoCorto,
        'cliente': p.cliente,
        'estado': p.estado,
        'total': p.totalDivisas,
        'hora': hora,
        'fecha': fechaCorta,
        'fecha_ui': "$hora · ${p.articulos.length} artículo(s)",
        'articulos': p.articulos.length,
        '_modelo_original': p, 
      };
    }).toList();

    final List<Map<String, dynamic>> pedidosMostrados = mockPedidos.where((p) {
      final matchesTab = _showPendientes 
          ? p['estado'].toString().toLowerCase() == 'pendiente' 
          : p['estado'].toString().toLowerCase() != 'pendiente';
      final matchesSearch = p['cliente'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            p['id'].toString().contains(_searchQuery);
      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/logotipo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.lightYellow, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.midBlue, 
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar pedido...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
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
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'PEDIDOS',
                    style: TextStyle(
                      color: AppTheme.darkBlue,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _showPendientes = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                            color: _showPendientes ? AppTheme.primaryColor : AppTheme.darkBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'PENDIENTES',
                            style: TextStyle(
                              color: AppTheme.lightYellow,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => setState(() => _showPendientes = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                            color: !_showPendientes ? AppTheme.primaryColor : AppTheme.darkBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'FINALIZADO',
                            style: TextStyle(
                              color: AppTheme.lightYellow,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: pedidosMostrados.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final pedido = pedidosMostrados[index];
                        return _OrderCard(
                          pedido: pedido,
                          onTap: () {
                            Navigator.pushNamed(context, 'order_detail', arguments: pedido);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final VoidCallback onTap;

  const _OrderCard({required this.pedido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;
    String statusText = pedido['estado'].toString().capitalize();

    if (pedido['estado'] == 'pendiente') {
      statusBgColor = AppTheme.paleYellow; 
      statusTextColor = const Color(0xFFF39C12); 
    } else if (pedido['estado'] == 'concretado') {
      statusBgColor = const Color(0xFFD5F5E3); 
      statusTextColor = AppTheme.concretado; 
    } else {
      statusBgColor = const Color(0xFFFADBD8); 
      statusTextColor = AppTheme.concretado; 
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido['cliente'],
                  style: const TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${pedido['id']}',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${pedido['total'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido['fecha_ui'] ?? '00:00 · 0 artículo(s)',
                  style: const TextStyle(
                    color: AppTheme.midBlue,
                    fontSize: 15,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
