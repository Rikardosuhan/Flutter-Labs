import 'package:flutter/material.dart';


void main() {
  runApp(const ProductSearchApp());
}

class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductSearchPage(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final String price;
  final IconData icon;
  const Product(this.name, this.category, this.price, this.icon);
}

const List<Product> allProducts = [
  Product('Wireless Headphones', 'Electronics', 'Rs. 1,499',
      Icons.headphones),
  Product('Smart Watch', 'Electronics', 'Rs. 2,299', Icons.watch),
  Product('Running Shoes', 'Fashion', 'Rs. 1,899',
      Icons.directions_run),
  Product('Travel Backpack', 'Accessories', 'Rs. 999',
      Icons.backpack),
  Product('Bluetooth Speaker', 'Electronics', 'Rs. 1,299',
      Icons.speaker),
  Product('Sports T-Shirt', 'Fashion', 'Rs. 699', Icons.checkroom),
];

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController searchController =
      TextEditingController();
  String searchText = '';
  String selectedCategory = 'All';
  List<Product> get filteredProducts {
    return allProducts.where((product) {
      final matchesSearch = product.name.toLowerCase()
          .contains(searchText.toLowerCase());
      final matchesCategory = selectedCategory == 'All' ||
          product.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchText = '');
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchText = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Filter by category',
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Electronics', 'Fashion', 'Accessories']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Products (${filteredProducts.length})',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(product.icon),
                            ),
                            title: Text(product.name),
                            subtitle: Text(product.category),
                            trailing: Text(product.price),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
