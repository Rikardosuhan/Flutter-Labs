import 'package:flutter/material.dart';


void main() {
  runApp(const ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductCatalogPage(),
    );
  }
}

class Product {
  final String name;
  final String description;
  final String price;
  final IconData icon;
  final Color color;
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
}

const List<Product> products = [
  Product(name: 'Wireless Headphones',
      description: 'Clear sound and comfortable fit',
      price: 'Rs. 1,499', icon: Icons.headphones, color: Colors.blue),
  Product(name: 'Smart Watch',
      description: 'Track your daily activity',
      price: 'Rs. 2,299', icon: Icons.watch, color: Colors.deepPurple),
  Product(name: 'Running Shoes',
      description: 'Lightweight everyday shoes',
      price: 'Rs. 1,899', icon: Icons.directions_run, color: Colors.orange),
  Product(name: 'Travel Backpack',
      description: 'Spacious and durable',
      price: 'Rs. 999', icon: Icons.backpack, color: Colors.green),
  Product(name: 'Camera',
      description: 'Capture memorable moments',
      price: 'Rs. 8,499', icon: Icons.camera_alt, color: Colors.red),
  Product(name: 'Bluetooth Speaker',
      description: 'Portable high-quality audio',
      price: 'Rs. 1,299', icon: Icons.speaker, color: Colors.teal),
];

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});
  int getColumnCount(double width) {
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEasy'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = getColumnCount(constraints.maxWidth);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Featured Products',
                        style: TextStyle(fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('Explore our latest collection'),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 2.3 : 0.95,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: product.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(product.icon,
                    size: 52, color: product.color),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(product.price,
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
