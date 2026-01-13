import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class Goal {
  final String id;
  final String nama;
  final double beratSekarang;
  final double targetBerat;
  final DateTime tenggat;
  final DateTime dibuat;

  Goal({
    required this.id,
    required this.nama,
    required this.beratSekarang,
    required this.targetBerat,
    required this.tenggat,
    required this.dibuat,
  });

  double get selisih => targetBerat - beratSekarang;
  
  String get keterangan {
    if (selisih > 0) {
      return "Tambah ${selisih.toStringAsFixed(1)} kg";
    } else if (selisih < 0) {
      return "Turunkan ${(-selisih).toStringAsFixed(1)} kg";
    } else {
      return "Sudah sesuai target";
    }
  }

  int get sisaHari {
    final now = DateTime.now();
    return tenggat.difference(now).inDays;
  }

  // Convert ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'beratSekarang': beratSekarang,
      'targetBerat': targetBerat,
      'tenggat': tenggat.millisecondsSinceEpoch,
      'dibuat': dibuat.millisecondsSinceEpoch,
    };
  }

  // Create dari Map (database)
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      nama: map['nama'],
      beratSekarang: map['beratSekarang'],
      targetBerat: map['targetBerat'],
      tenggat: DateTime.fromMillisecondsSinceEpoch(map['tenggat']),
      dibuat: DateTime.fromMillisecondsSinceEpoch(map['dibuat']),
    );
  }
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final TextEditingController namaGoalController = TextEditingController();
  final TextEditingController targetBeratController = TextEditingController();
  final TextEditingController beratSekarangController = TextEditingController();
  DateTime? selectedDate;
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Load goals dari database
  Future<void> _loadGoals() async {
    final data = await DatabaseHelper.instance.getAllGoals();
    setState(() {
      goals = data.map((item) => Goal.fromMap(item)).toList();
    });
  }

  void _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _tambahGoal() async {
    if (namaGoalController.text.isEmpty ||
        beratSekarangController.text.isEmpty ||
        targetBeratController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newGoal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: namaGoalController.text,
      beratSekarang: double.parse(beratSekarangController.text),
      targetBerat: double.parse(targetBeratController.text),
      tenggat: selectedDate!,
      dibuat: DateTime.now(),
    );

    // Simpan ke database
    await DatabaseHelper.instance.insertGoal(newGoal.toMap());

    setState(() {
      goals.add(newGoal);

      // Clear inputs
      namaGoalController.clear();
      beratSekarangController.clear();
      targetBeratController.clear();
      selectedDate = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Goal berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _hapusGoal(String id) async {
    await DatabaseHelper.instance.deleteGoal(id);
    setState(() {
      goals.removeWhere((goal) => goal.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final padding = isDesktop ? 40.0 : 20.0;
    final maxWidth = isDesktop ? 1000.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal Berat Badan"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Tambah Goal Baru",
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isDesktop ? 30 : 20),
                  
                  // Form Input
                  TextField(
                    controller: namaGoalController,
                    decoration: const InputDecoration(
                      labelText: "Nama Goal",
                      hintText: "Contoh: Diet Sehat, Penurunan Berat",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: beratSekarangController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Berat Badan Sekarang (kg)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: targetBeratController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Target Berat Badan (kg)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flag),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Date Picker
                  InkWell(
                    onTap: _pilihTanggal,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Tenggat Waktu",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "Pilih tanggal tenggat",
                        style: TextStyle(
                          color: selectedDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  ElevatedButton.icon(
                    onPressed: _tambahGoal,
                    icon: const Icon(Icons.add),
                    label: Text(
                      "Tambah Goal",
                      style: TextStyle(fontSize: isDesktop ? 18 : 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 18 : 15,
                      ),
                    ),
                  ),
                  
                  // Daftar Goals
                  if (goals.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    Text(
                      "Daftar Goal Anda",
                      style: TextStyle(
                        fontSize: isDesktop ? 22 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...goals.map((goal) => _buildGoalCard(goal, isDesktop)).toList(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, bool isDesktop) {
    final isExpired = goal.sisaHari < 0;
    final isUrgent = goal.sisaHari <= 7 && goal.sisaHari >= 0;
    
    Color cardColor = Colors.blue.shade50;
    Color borderColor = Colors.blue;
    
    if (isExpired) {
      cardColor = Colors.red.shade50;
      borderColor = Colors.red;
    } else if (isUrgent) {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(isDesktop ? 20 : 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.nama,
                  style: TextStyle(
                    fontSize: isDesktop ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _hapusGoal(goal.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  Icons.monitor_weight,
                  "Sekarang",
                  "${goal.beratSekarang.toStringAsFixed(1)} kg",
                  isDesktop,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInfoRow(
                  Icons.flag,
                  "Target",
                  "${goal.targetBerat.toStringAsFixed(1)} kg",
                  isDesktop,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.trending_up,
            "Selisih",
            goal.keterangan,
            isDesktop,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.calendar_today,
            "Tenggat",
            "${goal.tenggat.day}/${goal.tenggat.month}/${goal.tenggat.year}",
            isDesktop,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isExpired
                  ? Colors.red
                  : isUrgent
                      ? Colors.orange
                      : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  isExpired
                      ? "Sudah lewat ${-goal.sisaHari} hari"
                      : "Sisa ${goal.sisaHari} hari",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDesktop) {
    return Row(
      children: [
        Icon(icon, size: isDesktop ? 20 : 18, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isDesktop ? 15 : 14,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 15 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    namaGoalController.dispose();
    targetBeratController.dispose();
    beratSekarangController.dispose();
    super.dispose();
  }
}
