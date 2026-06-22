import 'package:flutter/material.dart';

class ExportReportScreen extends StatelessWidget {
  const ExportReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xuất Báo cáo"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download, size: 100, color: Colors.green),
            const SizedBox(height: 30),
            const Text(
              "Xuất báo cáo phân tích",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Chọn định dạng file bạn muốn tải về",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang xuất Excel...")),
                );
              },
              icon: const Icon(Icons.table_chart),
              label: const Text("Xuất Excel (.xlsx)"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.green[600],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang xuất PDF...")),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Xuất PDF"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.red[600],
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "Báo cáo bao gồm: Cronbach, EFA, Regression, Biểu đồ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}