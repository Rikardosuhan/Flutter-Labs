import 'package:flutter/material.dart';


void main() {
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Basket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FruitHomePage(),
    );
  }
}

class Fruit {
  final String name;
  final String description;
  final String price;
  final IconData icon;
  final Color color;
  const Fruit({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
}

const List<Fruit> fruits = [
  Fruit(name: 'Apple', description: 'Crisp, sweet and rich in fibre',
      price: 'Rs.120 / kg', icon: Icons.apple, color: Colors.red),
  Fruit(name: 'Banana', description: 'A quick source of energy',
      price: 'Rs.50 / dozen',
      icon: Icons.energy_savings_leaf, color: Colors.amber),
  Fruit(name: 'Orange', description: 'Juicy fruit rich in vitamin C',
      price: 'Rs.80 / kg', icon: Icons.circle, color: Colors.orange),
  Fruit(name: 'Grapes', description: 'Small, sweet and refreshing',
      price: 'Rs.90 / kg', icon: Icons.grain, color: Colors.purple),
  Fruit(name: 'Mango', description: 'A delicious seasonal fruit',
      price: 'Rs.100 / kg', icon: Icons.spa, color: Colors.deepOrange),
];

class FruitHomePage extends StatelessWidget {
  const FruitHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Basket'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Explore fresh and healthy fruits',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                return FruitCard(fruit: fruits[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable custom widget for displaying one fruit.

class FruitCard extends StatelessWidget {
  final Fruit fruit;
  const FruitCard({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: fruit.color.withOpacity(0.15),
              child: Icon(fruit.icon,
                  color: fruit.color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fruit.name,
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(fruit.description,
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 5),
                  Text(fruit.price,
                      style: const TextStyle(color: Colors.blue,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
