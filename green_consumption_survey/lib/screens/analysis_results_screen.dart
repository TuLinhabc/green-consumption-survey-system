import 'package:flutter/material.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kết quả Phân tích Thống kê"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tổng quan phân tích", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Thống kê Cronbach
            Card(
              child: ListTile(
                leading: const Icon(Icons.checklist, color: Colors.green),
                title: const Text("Cronbach's Alpha"),
                subtitle: const Text("Tất cả yếu tố > 0.7 (Đáng tin cậy)"),
                trailing: const Text("Tốt", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 12),

            // EFA
            Card(
              child: ListTile(
                leading: const Icon(Icons.analytics, color: Colors.blue),
                title: const Text("EFA - Phân tích yếu tố khám phá"),
                subtitle: const Text("KMO = 0.82 | 7 yếu tố"),
                trailing: TextButton(onPressed: () {}, child: const Text("Xem chi tiết")),
              ),
            ),

            const SizedBox(height: 12),

            // Regression
            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.orange),
                title: const Text("Hồi quy đa biến"),
                subtitle: const Text("R² = 0.68 | GC là biến phụ thuộc"),
                trailing: TextButton(onPressed: () {}, child: const Text("Xem chi tiết")),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Xếp hạng tác động của các nhân tố", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildRankItem("1. Nhận thức môi trường (NTMT)", "0.42"),
            _buildRankItem("2. Thái độ (TD)", "0.38"),
            _buildRankItem("3. Ảnh hưởng xã hội (AHXH)", "0.31"),
            _buildRankItem("4. Niềm tin xanh (NTX)", "0.29"),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem(String title, String beta) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: Text("β = $beta", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
      ),
    );
  }
}