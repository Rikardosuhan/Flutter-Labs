import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Records',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentPage(),
    );
  }
}

class Student {
  final int? id;
  final String name;
  final String registerNo;
  final String department;
  Student({
    this.id,
    required this.name,
    required this.registerNo,
    required this.department,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registerNo': registerNo,
      'department': department,
    };
  }
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      registerNo: map['registerNo'],
      department: map['department'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            registerNo TEXT NOT NULL,
            department TEXT NOT NULL
          )
        ''');
      },
    );
  }
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }
  Future<List<Student>> getStudents() async {
    final db = await database;
    final result = await db.query('students', orderBy: 'id DESC');
    return result.map((map) => Student.fromMap(map)).toList();
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _registerController = TextEditingController();
  final _departmentController = TextEditingController();
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }
  Future<void> loadStudents() async {
    final data = await DatabaseHelper.instance.getStudents();
    setState(() => students = data);
  }
  Future<void> saveStudent() async {
    if (!_formKey.currentState!.validate()) return;
    final student = Student(
      name: _nameController.text.trim(),
      registerNo: _registerController.text.trim(),
      department: _departmentController.text.trim(),
    );
    await DatabaseHelper.instance.insertStudent(student);
    _nameController.clear();
    _registerController.clear();
    _departmentController.clear();
    await loadStudents();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _registerController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records (SQLite)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter student name'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _registerController,
                    decoration: const InputDecoration(
                      labelText: 'Register Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter register number'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter department'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveStudent,
                      child: const Text('Save Student'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Saved Students',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text('No student records found'))
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(student.name),
                            subtitle: Text(
                              '${student.registerNo} • '
                              '${student.department}',
                            ),
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
