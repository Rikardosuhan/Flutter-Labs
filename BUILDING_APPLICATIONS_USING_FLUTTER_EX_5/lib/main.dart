import 'package:flutter/material.dart';


void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Budget Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BudgetPage(),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();
  double? balance;
  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount < 0) {
      return 'Enter a valid non-negative amount';
    }
    return null;
  }
  void calculateBalance() {
    if (_formKey.currentState!.validate()) {
      final income = double.parse(_incomeController.text);
      final expenses = double.parse(_expenseController.text);
      setState(() {
        balance = income - expenses;
      });
    }
  }
  void clearData() {
    _incomeController.clear();
    _expenseController.clear();
    setState(() {
      balance = null;
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = balance == null
        ? ''
        : balance! > 0
            ? 'Savings available'
            : balance! < 0
                ? 'Expenses exceed income'
                : 'Income and expenses are equal';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Budget Calculator'),
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
              const Icon(Icons.account_balance_wallet,
                  size: 75, color: Colors.blue),
              const SizedBox(height: 20),
              TextFormField(
                controller: _incomeController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monthly Income (Rs.)',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                validator: validateAmount,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _expenseController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monthly Expenses (Rs.)',
                  prefixIcon: Icon(Icons.receipt_long),
                  border: OutlineInputBorder(),
                ),
                validator: validateAmount,
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: calculateBalance,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Calculate Balance'),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: clearData,
                child: const Text('Clear'),
              ),
              if (balance != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Remaining Balance',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                          'Rs. ${balance!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Status: $status',
                            style: const TextStyle(fontSize: 16)),
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
