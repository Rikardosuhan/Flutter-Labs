import 'package:flutter/material.dart';


void main() {
  runApp(const MileageApp());
}

class MileageApp extends StatelessWidget {
  const MileageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Mileage Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MileagePage(),
    );
  }
}

class MileagePage extends StatefulWidget {
  const MileagePage({super.key});

  @override
  State<MileagePage> createState() => _MileagePageState();
}

class _MileagePageState extends State<MileagePage> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _fuelController = TextEditingController();
  double? mileage;
  String? validatePositiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Enter a valid number greater than zero';
    }
    return null;
  }
  void calculateMileage() {
    if (_formKey.currentState!.validate()) {
      final distance = double.parse(_distanceController.text);
      final fuel = double.parse(_fuelController.text);
      setState(() {
        mileage = distance / fuel;
      });
    }
  }
  void clearFields() {
    _distanceController.clear();
    _fuelController.clear();
    setState(() {
      mileage = null;
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _fuelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Mileage Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.directions_car,
                  size: 75, color: Colors.blue),
              const SizedBox(height: 20),
              TextFormField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Distance travelled (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.route),
                ),
                validator: validatePositiveNumber,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _fuelController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Fuel used (litres)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                validator: validatePositiveNumber,
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: calculateMileage,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Calculate Mileage'),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: clearFields,
                child: const Text('Clear'),
              ),
              if (mileage != null) ...[
                const SizedBox(height: 25),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Calculated Mileage',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                          '${mileage!.toStringAsFixed(2)} km/litre',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
