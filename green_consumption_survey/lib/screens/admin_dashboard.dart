import 'package:flutter/material.dart';
import 'analysis_results_screen.dart';
import 'export_report_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalResponses = 0;
  int analyzedResponses = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // Giả lập lấy dữ liệu từ API
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      totalResponses = 156;
      analyzedResponses = 124;
      isLoading = false;
    });
  }

  Future<void> _runAllAnalysis() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text("Đang chạy phân tích"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Cronbach Alpha, EFA, Regression..."),
          ],
        ),
      ),
    );

    // Giả lập chạy phân tích
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pop(context); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phân tích hoàn tất! Kết quả đã được lưu vào database."),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        analyzedResponses = totalResponses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thống kê chính
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.people, size: 40, color: Colors.green),
                                  Text(
                                    totalResponses.toString(),
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Tổng mẫu khảo sát"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Card(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.analytics, size: 40, color: Colors.blue),
                                  Text(
                                    analyzedResponses.toString(),
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Đã phân tích"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text("Chức năng quản trị", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Nút Chạy phân tích
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.play_arrow, color: Colors.orange, size: 40),
                        title: const Text("Chạy phân tích thống kê"),
                        subtitle: const Text("Cronbach, EFA, Regression"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: _runAllAnalysis,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Xem kết quả
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.table_chart, color: Colors.purple),
                        title: const Text("Xem kết quả phân tích"),
                        subtitle: const Text("Bảng và biểu đồ chi tiết"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AnalysisResultsScreen()),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Xuất báo cáo
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.download, color: Colors.teal),
                        title: const Text("Xuất báo cáo"),
                        subtitle: const Text("Excel / PDF"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExportReportScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}