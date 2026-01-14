import 'package:flutter/material.dart';
import 'goal_page.dart';
import 'tentang_page.dart';
import 'dart:math' as math;
import '../helpers/database_helper.dart';

class BmiHistory {
  final String id;
  final double berat;
  final double tinggi;
  final double bmi;
  final String kategori;
  final String jenisKelamin;
  final DateTime waktu;
  final String unitSystem; // "Metric" or "US"

  BmiHistory({
    required this.id,
    required this.berat,
    required this.tinggi,
    required this.bmi,
    required this.kategori,
    required this.jenisKelamin,
    required this.waktu,
    this.unitSystem = "Metric", // Default Metric untuk backward compatibility
  });

  // Convert ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'berat': berat,
      'tinggi': tinggi,
      'bmi': bmi,
      'kategori': kategori,
      'jenisKelamin': jenisKelamin,
      'waktu': waktu.millisecondsSinceEpoch,
      'unitSystem': unitSystem,
    };
  }

  // Create dari Map (database)
  factory BmiHistory.fromMap(Map<String, dynamic> map) {
    return BmiHistory(
      id: map['id'],
      berat: map['berat'],
      tinggi: map['tinggi'],
      bmi: map['bmi'],
      kategori: map['kategori'],
      jenisKelamin: map['jenisKelamin'],
      waktu: DateTime.fromMillisecondsSinceEpoch(map['waktu']),
      unitSystem: map['unitSystem'] ?? "Metric", // Default Metric jika tidak ada
    );
  }
}

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();

  double bmi = 0;
  String kategori = "";
  String jenisKelamin = "Laki-laki"; // Default jenis kelamin
  String unitSystem = "Metric"; // Default unit system: "Metric" or "US"
  List<BmiHistory> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Load history dari database
  Future<void> _loadHistory() async {
    try {
      final data = await DatabaseHelper.instance.getAllBmiHistory();
      setState(() {
        history = data.map((item) => BmiHistory.fromMap(item)).toList();
      });
    } catch (e) {
      print('Error loading history: $e');
      // Jika terjadi error, set history kosong
      setState(() {
        history = [];
      });
    }
  }

  void hitungBMI() {
    double berat = double.parse(beratController.text);
    double tinggi;

    // Konversi ke metric jika menggunakan US unit
    if (unitSystem == "US") {
      // Convert pounds to kg: 1 lb = 0.453592 kg
      berat = berat * 0.453592;
      // Convert feet and inches to meters
      double feet = double.parse(feetController.text);
      double inches = double.parse(inchesController.text);
      // Total inches = (feet * 12) + inches
      double totalInches = (feet * 12) + inches;
      // Convert total inches to meters: 1 inch = 0.0254 m
      tinggi = totalInches * 0.0254;
    } else {
      // Metric: convert cm to meters
      tinggi = double.parse(tinggiController.text) / 100;
    }

    setState(() {
      bmi = berat / (tinggi * tinggi);

      // Kategori BMI berbeda untuk laki-laki dan perempuan
      if (jenisKelamin == "Laki-laki") {
        if (bmi < 18.5) {
          kategori = "Kurus";
        } else if (bmi < 25) {
          kategori = "Normal";
        } else if (bmi < 27) {
          kategori = "Gemuk";
        } else {
          kategori = "Obesitas";
        }
      } else {
        // Perempuan
        if (bmi < 17) {
          kategori = "Kurus";
        } else if (bmi < 23) {
          kategori = "Normal";
        } else if (bmi < 27) {
          kategori = "Gemuk";
        } else {
          kategori = "Obesitas";
        }
      }

      // Tambahkan ke history (simpan dalam satuan yang diinput)
      double beratDisplay = double.parse(beratController.text);
      double tinggiDisplay;
      
      if (unitSystem == "US") {
        // Untuk US, simpan total inches
        double feet = double.parse(feetController.text);
        double inches = double.parse(inchesController.text);
        tinggiDisplay = (feet * 12) + inches; // total inches
      } else {
        tinggiDisplay = double.parse(tinggiController.text);
      }
      
      final newHistory = BmiHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        berat: beratDisplay,
        tinggi: tinggiDisplay,
        bmi: bmi,
        kategori: kategori,
        jenisKelamin: jenisKelamin,
        waktu: DateTime.now(),
        unitSystem: unitSystem,
      );
      
      // Simpan ke database dengan error handling
      try {
        DatabaseHelper.instance.insertBmiHistory(newHistory.toMap());
        history.insert(0, newHistory);
      } catch (e) {
        print('Error saving to database: $e');
        // Tetap tampilkan di UI meskipun gagal disimpan
        history.insert(0, newHistory);
      }
    });
  }

  Future<void> _hapusHistory(String id) async {
    await DatabaseHelper.instance.deleteBmiHistory(id);
    setState(() {
      history.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _hapusSemuaHistory() async {
    await DatabaseHelper.instance.deleteAllBmiHistory();
    setState(() {
      history.clear();
    });
  }

  Color _getKategoriColor() {
    if (kategori == "Kurus") {
      return Colors.blue;
    } else if (kategori == "Normal") {
      return Colors.green;
    } else if (kategori == "Gemuk") {
      return Colors.orange;
    } else if (kategori == "Obesitas") {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final padding = isDesktop ? 40.0 : 20.0;
    final maxWidth = isDesktop ? 1200.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Cek BMI"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.fitness_center, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Aplikasi Kesehatan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Hitung BMI'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Goal'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoalPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TentangPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildUnitSelector(),
        const SizedBox(height: 20),
        _buildGenderSelector(),
        const SizedBox(height: 20),
        _buildInputFields(),
        const SizedBox(height: 20),
        _buildCalculateButton(),
        const SizedBox(height: 30),
        _buildGaugeIndicator(),
        const SizedBox(height: 20),
        _buildResultText(),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 40),
          _buildHistorySection(),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Inputs
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildUnitSelector(),
                  const SizedBox(height: 20),
                  _buildGenderSelector(),
                  const SizedBox(height: 20),
                  _buildInputFields(),
                  const SizedBox(height: 20),
                  _buildCalculateButton(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Right side - Results
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildGaugeIndicator(),
                  const SizedBox(height: 20),
                  _buildResultText(),
                ],
              ),
            ),
          ],
        ),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 40),
          _buildHistorySection(),
        ],
      ],
    );
  }

  Widget _buildUnitSelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        const Text(
          "Unit: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ChoiceChip(
          label: const Text("Metric (kg/cm)"),
          selected: unitSystem == "Metric",
          onSelected: (selected) {
            setState(() {
              unitSystem = "Metric";
              // Clear inputs when switching units
              beratController.clear();
              tinggiController.clear();
              feetController.clear();
              inchesController.clear();
            });
          },
          selectedColor: Colors.teal,
        ),
        ChoiceChip(
          label: const Text("US (lbs/in)"),
          selected: unitSystem == "US",
          onSelected: (selected) {
            setState(() {
              unitSystem = "US";
              // Clear inputs when switching units
              beratController.clear();
              tinggiController.clear();
              feetController.clear();
              inchesController.clear();
            });
          },
          selectedColor: Colors.deepOrange,
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        const Text(
          "Jenis Kelamin: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ChoiceChip(
          label: const Text("Laki-laki"),
          selected: jenisKelamin == "Laki-laki",
          onSelected: (selected) {
            setState(() {
              jenisKelamin = "Laki-laki";
            });
          },
          selectedColor: Colors.blue,
        ),
        ChoiceChip(
          label: const Text("Perempuan"),
          selected: jenisKelamin == "Perempuan",
          onSelected: (selected) {
            setState(() {
              jenisKelamin = "Perempuan";
            });
          },
          selectedColor: Colors.pink,
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    final beratLabel = unitSystem == "Metric" ? "Berat Badan (kg)" : "Weight (lbs)";
    
    return Column(
      children: [
        TextField(
          controller: beratController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: beratLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.monitor_weight),
          ),
        ),
        const SizedBox(height: 15),
        if (unitSystem == "Metric")
          TextField(
            controller: tinggiController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Tinggi Badan (cm)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.height),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: feetController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Feet",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.height),
                    suffixText: "ft",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: inchesController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Inches",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.straighten),
                    suffixText: "in",
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hitungBMI,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          "Hitung BMI",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildGaugeIndicator() {
    return SizedBox(
      height: 150,
      child: CustomPaint(
        painter: BmiGaugePainter(
          bmi: bmi,
          jenisKelamin: jenisKelamin,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                bmi > 0 ? bmi.toStringAsFixed(1) : "--",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                bmi > 0 ? kategori : "BMI",
                style: TextStyle(
                  fontSize: 16,
                  color: bmi > 0 ? _getKategoriColor() : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultText() {
    return Column(
      children: [
        Text(
          "Jenis Kelamin: $jenisKelamin",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          "BMI: ${bmi.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Kategori: $kategori",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Riwayat BMI",
              style: TextStyle(
                fontSize: isDesktop ? 22 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (history.length > 1)
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Hapus Semua Riwayat"),
                      content: const Text("Apakah Anda yakin ingin menghapus semua riwayat BMI?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            _hapusSemuaHistory();
                            Navigator.pop(context);
                          },
                          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text("Hapus Semua", style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
        const SizedBox(height: 15),
        ...history.map((item) => _buildHistoryCard(item, isDesktop)).toList(),
      ],
    );
  }

  Widget _buildHistoryCard(BmiHistory item, bool isDesktop) {
    Color cardColor = Colors.blue.shade50;
    Color borderColor = Colors.blue;
    
    if (item.kategori == "Kurus") {
      cardColor = Colors.blue.shade50;
      borderColor = Colors.blue;
    } else if (item.kategori == "Normal") {
      cardColor = Colors.green.shade50;
      borderColor = Colors.green;
    } else if (item.kategori == "Gemuk") {
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orange;
    } else if (item.kategori == "Obesitas") {
      cardColor = Colors.red.shade50;
      borderColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      item.jenisKelamin == "Laki-laki" ? Icons.male : Icons.female,
                      size: isDesktop ? 20 : 18,
                      color: borderColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.jenisKelamin,
                      style: TextStyle(
                        fontSize: isDesktop ? 15 : 14,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "${item.waktu.day}/${item.waktu.month}/${item.waktu.year} ${item.waktu.hour}:${item.waktu.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: isDesktop ? 13 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildHistoryInfo(
                      "Berat", 
                      item.unitSystem == "Metric" 
                        ? "${item.berat.toStringAsFixed(1)} kg" 
                        : "${item.berat.toStringAsFixed(1)} lbs",
                      isDesktop
                    ),
                    const SizedBox(width: 20),
                    _buildHistoryInfo(
                      "Tinggi", 
                      item.unitSystem == "Metric" 
                        ? "${item.tinggi.toStringAsFixed(0)} cm" 
                        : "${(item.tinggi / 12).floor()}' ${(item.tinggi % 12).toStringAsFixed(0)}\"",
                      isDesktop
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildHistoryInfo("BMI", item.bmi.toStringAsFixed(1), isDesktop),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.kategori,
                        style: TextStyle(
                          fontSize: isDesktop ? 13 : 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _hapusHistory(item.id),
            tooltip: "Hapus",
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryInfo(String label, String value, bool isDesktop) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isDesktop ? 14 : 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isDesktop ? 14 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk Gauge BMI
class BmiGaugePainter extends CustomPainter {
  final double bmi;
  final String jenisKelamin;

  BmiGaugePainter({required this.bmi, required this.jenisKelamin});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 15);
    final radius = size.width / 3.5;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Define BMI ranges and colors based on gender
    List<BmiRange> ranges;
    if (jenisKelamin == "Laki-laki") {
      ranges = [
        BmiRange(0, 18.5, Colors.blue, "Kurus"),
        BmiRange(18.5, 25, Colors.green, "Normal"),
        BmiRange(25, 27, Colors.orange, "Gemuk"),
        BmiRange(27, 40, Colors.red, "Obesitas"),
      ];
    } else {
      ranges = [
        BmiRange(0, 17, Colors.blue, "Kurus"),
        BmiRange(17, 23, Colors.green, "Normal"),
        BmiRange(23, 27, Colors.orange, "Gemuk"),
        BmiRange(27, 40, Colors.red, "Obesitas"),
      ];
    }

    // Draw colored sections
    const minBmi = 10.0;
    const maxBmi = 40.0;
    
    for (var range in ranges) {
      final sectionStart = ((range.min - minBmi) / (maxBmi - minBmi)) * sweepAngle;
      final sectionSweep = ((range.max - range.min) / (maxBmi - minBmi)) * sweepAngle;
      
      final sectionPaint = Paint()
        ..color = range.color.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + sectionStart,
        sectionSweep,
        false,
        sectionPaint,
      );
    }

    // Draw indicator needle
    if (bmi > 0) {
      final clampedBmi = bmi.clamp(minBmi, maxBmi);
      final indicatorAngle = startAngle + ((clampedBmi - minBmi) / (maxBmi - minBmi)) * sweepAngle;
      
      final indicatorPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      // Draw needle
      final needleLength = radius - 10;
      final needleEnd = Offset(
        center.dx + needleLength * math.cos(indicatorAngle),
        center.dy + needleLength * math.sin(indicatorAngle),
      );

      canvas.drawLine(center, needleEnd, Paint()
        ..color = Colors.black
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round);

      // Draw center circle
      canvas.drawCircle(center, 6, indicatorPaint);
      canvas.drawCircle(center, 4, Paint()..color = Colors.white);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Min label
    textPainter.text = TextSpan(
      text: minBmi.toInt().toString(),
      style: const TextStyle(color: Colors.black, fontSize: 11),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - radius - 20, center.dy - 5));

    // Max label
    textPainter.text = TextSpan(
      text: maxBmi.toInt().toString(),
      style: const TextStyle(color: Colors.black, fontSize: 11),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + radius + 8, center.dy - 5));
  }

  @override
  bool shouldRepaint(BmiGaugePainter oldDelegate) {
    return oldDelegate.bmi != bmi || oldDelegate.jenisKelamin != jenisKelamin;
  }
}

// Helper class for BMI ranges
class BmiRange {
  final double min;
  final double max;
  final Color color;
  final String label;

  BmiRange(this.min, this.max, this.color, this.label);
}
