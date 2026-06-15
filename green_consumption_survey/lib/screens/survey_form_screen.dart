import 'package:flutter/material.dart';
import '../models/question.dart';
import '../core/api/api_client.dart';

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  List<Question> questions = [];
  Map<String, int> answers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await ApiClient.getQuestions();
      setState(() {
        questions = data.map((q) => Question.fromJson(q)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Khảo sát Tiêu dùng Xanh"),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${q.questionOrder}. ${q.questionText}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final value = i + 1;
                      return Column(
                        children: [
                          Radio<int>(
                            value: value,
                            groupValue: answers[q.questionCode],
                            onChanged: (val) {
                              setState(() {
                                answers[q.questionCode] = val!;
                              });
                            },
                          ),
                          Text("$value"),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Gọi API submit response
            print("Answers: $answers");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Khảo sát đã được gửi (chức năng submit đang phát triển)")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("GỬI KHẢO SÁT", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}