import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final padding = isDesktop ? 40.0 : 20.0;
    final maxWidth = isDesktop ? 900.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'web/icons/Icon-192.png',
                      width: isDesktop ? 120 : 100,
                      height: isDesktop ? 120 : 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fitness_center,
                          size: isDesktop ? 120 : 100,
                          color: Colors.blue,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Aplikasi Cek BMI",
                    style: TextStyle(
                      fontSize: isDesktop ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Versi 1.0.0",
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "Fitur Aplikasi:",
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureItem(
                    Icons.calculate,
                    "Hitung BMI",
                    "Menghitung Body Mass Index berdasarkan jenis kelamin",
                    isDesktop,
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureItem(
                    Icons.flag,
                    "Goal",
                    "Menentukan target berat badan ideal Anda",
                    isDesktop,
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "Tentang BMI:",
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Body Mass Index (BMI) adalah ukuran yang digunakan untuk menilai berat badan seseorang berdasarkan tinggi badan. BMI membantu menentukan apakah seseorang memiliki berat badan yang sehat.",
                    style: TextStyle(fontSize: isDesktop ? 16 : 14),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "Kontak:",
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.blue,
                        size: isDesktop ? 24 : 20,
                      ),
                      SizedBox(width: isDesktop ? 12 : 10),
                      Expanded(
                        child: Text(
                          "tyobro40@gmail.com",
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KebijakanPrivasiPage(),
                          ),
                        );
                      },
                      child: const Text("Kebijakan & Privasi"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "© 2026 Aplikasi Kesehatan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, bool isDesktop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: isDesktop ? 28 : 24),
        SizedBox(width: isDesktop ? 15 : 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: isDesktop ? 15 : 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Halaman Kebijakan & Privasi
class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final padding = isDesktop ? 40.0 : 20.0;
    final maxWidth = isDesktop ? 900.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kebijakan & Privasi"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kebijakan Privasi",
                    style: TextStyle(
                      fontSize: isDesktop ? 26 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    "1. Pengumpulan Data",
                    "Aplikasi BMI Kalkulator menyimpan data perhitungan BMI Anda secara lokal di perangkat Anda. Kami tidak mengumpulkan, menyimpan, atau mengirim data pribadi Anda ke server eksternal.",
                    isDesktop,
                  ),
                  _buildSection(
                    "2. Penggunaan Data",
                    "Data yang Anda masukkan (berat badan, tinggi badan) hanya digunakan untuk menghitung BMI dan disimpan dalam riwayat lokal perangkat Anda. Data ini tidak dibagikan dengan pihak ketiga manapun.",
                    isDesktop,
                  ),
                  _buildSection(
                    "3. Keamanan Data",
                    "Semua data tersimpan secara lokal di perangkat Anda dan tidak dikirim melalui internet. Anda memiliki kontrol penuh untuk menghapus riwayat kapan saja.",
                    isDesktop,
                  ),
                  _buildSection(
                    "4. Cookies",
                    "Aplikasi ini tidak menggunakan cookies atau teknologi pelacakan lainnya.",
                    isDesktop,
                  ),
                  _buildSection(
                    "5. Perubahan Kebijakan",
                    "Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Perubahan akan diberitahukan melalui pembaruan aplikasi.",
                    isDesktop,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Terakhir diperbarui: 13 Januari 2026",
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: isDesktop ? 15 : 14,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

// Halaman Hak Cipta
class HakCiptaPage extends StatelessWidget {
  const HakCiptaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final padding = isDesktop ? 40.0 : 20.0;
    final maxWidth = isDesktop ? 900.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hak Cipta"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.copyright,
                      size: isDesktop ? 80 : 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Hak Cipta © 2026",
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Aplikasi BMI Kalkulator",
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "Ketentuan Hak Cipta",
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildCopyrightItem(
                    "Hak Cipta Aplikasi",
                    "Seluruh kode sumber, desain, dan konten aplikasi BMI Kalkulator dilindungi oleh hak cipta. Dilarang menyalin, memodifikasi, atau mendistribusikan ulang tanpa izin tertulis.",
                    isDesktop,
                  ),
                  _buildCopyrightItem(
                    "Merek Dagang",
                    "Logo dan nama 'BMI Kalkulator' adalah merek dagang yang terdaftar dan dilindungi undang-undang.",
                    isDesktop,
                  ),
                  _buildCopyrightItem(
                    "Penggunaan yang Diizinkan",
                    "Pengguna diizinkan untuk menggunakan aplikasi ini untuk keperluan pribadi dan non-komersial. Untuk penggunaan komersial, hubungi kami untuk mendapatkan lisensi.",
                    isDesktop,
                  ),
                  _buildCopyrightItem(
                    "Lisensi Pihak Ketiga",
                    "Aplikasi ini menggunakan beberapa pustaka open-source yang tunduk pada lisensi masing-masing.",
                    isDesktop,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(isDesktop ? 20 : 15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: isDesktop ? 32 : 28,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Untuk pertanyaan mengenai hak cipta atau lisensi, silakan hubungi:",
                          style: TextStyle(
                            fontSize: isDesktop ? 15 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "tyobro40@gmail.com",
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Dilindungi oleh Undang-Undang Hak Cipta Indonesia",
                      style: TextStyle(
                        fontSize: isDesktop ? 13 : 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyrightItem(String title, String content, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
            size: isDesktop ? 24 : 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: isDesktop ? 14 : 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
