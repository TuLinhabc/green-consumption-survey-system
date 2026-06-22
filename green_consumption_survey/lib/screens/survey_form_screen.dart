import 'package:flutter/material.dart';
import '../models/question.dart';
import '../core/api/api_client.dart';
import 'thank_you_screen.dart';

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
// Câu hỏi lọc
  bool? buyEcommerce6m;
  bool? buyGreenProductBefore;

  // Demographic
  String? gender;
  String? ageGroup;
  String? incomeGroup;
  String? purchaseFrequency;
  String? mainPlatform;

  List<Question> questions = [];
  Map<String, int> answers = {};
  bool isLoading = true;
  bool isSubmitting = false;

  // Nhóm câu hỏi
  final Map<String, String> factorTitles = {
    "NTMT": "Nhận thức môi trường",
    "TD": "Thái độ đối với tiêu dùng xanh",
    "AHXH": "Ảnh hưởng xã hội",
    "NTX": "Niềm tin xanh",
    "TTT": "Chất lượng thông tin sản phẩm",
    "GC": "Cảm nhận về giá",
    "HVX": "Hành vi tiêu dùng xanh",
  };

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await ApiClient.getQuestions();
      setState(() {
        questions = data.map((q) => Question.fromJson(q)).toList()
          ..sort((a, b) => a.questionOrder.compareTo(b.questionOrder));
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  bool get _canSubmit {
    return buyEcommerce6m == true &&
        gender != null &&
        ageGroup != null &&
        incomeGroup != null &&
        purchaseFrequency != null &&
        mainPlatform != null &&
        answers.length == questions.length;
  }

  Future<void> _submitSurvey() async {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng trả lời đầy đủ tất cả câu hỏi')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await ApiClient.submitResponse(
        buyEcommerce6m: buyEcommerce6m!,
        gender: gender,
        ageGroup: ageGroup,
        incomeGroup: incomeGroup,
        purchaseFrequency: purchaseFrequency,
        mainPlatform: mainPlatform,
        answers: answers,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ThankYouScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi thất bại: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Khảo sát Tiêu dùng Xanh trên Sàn Thương mại Điện tử"), backgroundColor: Colors.green[700]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // === PHẦN GIỚI THIỆU ===
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Chiếm 90% chiều rộng
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.eco, size: 80, color: Colors.green),
                      const SizedBox(height: 16),
                      const Text(
                        "Khảo sát Hành vi Tiêu dùng Xanh trên Sàn Thương mại Điện tử",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Mục đích: Nghiên cứu các yếu tố ảnh hưởng đến hành vi mua sắm sản phẩm thân thiện với môi trường trên sàn TMĐT.\n\n"
                        "Cam kết: Dữ liệu chỉ dùng cho mục đích nghiên cứu khoa học, được bảo mật tuyệt đối.\n\n"
                        "Hướng dẫn: Chọn mức độ đồng ý từ 1 (Hoàn toàn không đồng ý) đến 5 (Hoàn toàn đồng ý).",
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === CÂU HỎI LỌC 1 ===
            const Text("1. Câu hỏi sàng lọc", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bạn đã từng mua hàng trên sàn thương mại điện tử trong 6 tháng gần đây chưa?"),
                    Row(
                      children: [
                        Radio<bool>(value: true, groupValue: buyEcommerce6m, onChanged: (val) => setState(() => buyEcommerce6m = val)),
                        const Text("Có"),
                        const SizedBox(width: 20),
                        Radio<bool>(value: false, groupValue: buyEcommerce6m, onChanged: (val) => setState(() => buyEcommerce6m = val)),
                        const Text("Không"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === CÂU HỎI LỌC 2 (MỚI) ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bạn đã từng mua sản phẩm được quảng bá là xanh, bền vững hoặc thân thiện với môi trường trên sàn thương mại điện tử chưa?"),
                    Row(
                      children: [
                        Radio<bool>(value: true, groupValue: buyGreenProductBefore, onChanged: (val) => setState(() => buyGreenProductBefore = val)),
                        const Text("Có"),
                        const SizedBox(width: 20),
                        Radio<bool>(value: false, groupValue: buyGreenProductBefore, onChanged: (val) => setState(() => buyGreenProductBefore = val)),
                        const Text("Không"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === THÔNG TIN CÁ NHÂN ===
            const Text("2. Thông tin cá nhân", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDropdown("Giới tính", ["Nam", "Nữ", "Khác"], gender, (val) => setState(() => gender = val)),
            _buildDropdown("Nhóm tuổi", ["Dưới 18", "18-22", "23-26", "trên 26", "Khác"], ageGroup, (val) => setState(() => ageGroup = val)),
            _buildDropdown("Thu nhập hàng tháng", ["Dưới 3 triệu", "3-7 triệu", "7-15 triệu", "Trên 15 triệu", "Khác"], incomeGroup, (val) => setState(() => incomeGroup = val)),
            _buildDropdown("Tần suất mua sắm online", ["Dưới 1 lần/tháng", "1 đến 2 lần/tháng", "3 đến 5 lần/tháng", "Trên 5 lần/tháng"], purchaseFrequency, (val) => setState(() => purchaseFrequency = val)),
            _buildDropdown("Sàn TMĐT thường sử dụng", ["Shopee", "TikTok Shop", "Lazada", "Khác"], mainPlatform, (val) => setState(() => mainPlatform = val)),

            const SizedBox(height: 30),

            // === CÂU HỎI THEO NHÓM ===
            const Text("3. Ý kiến của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ..._buildGroupedQuestions(),

            const SizedBox(height: 30),

            // Nút Gửi
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isSubmitting || buyEcommerce6m != true) ? null : _submitSurvey,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("GỬI KHẢO SÁT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedQuestions() {
    final grouped = <String, List<Question>>{};
    for (var q in questions) {
      grouped.putIfAbsent(q.factorCode, () => []).add(q);
    }

    return grouped.entries.map((entry) {
      final factorCode = entry.key;
      final qs = entry.value;
      final title = factorTitles[factorCode] ?? factorCode;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          ),
          ...qs.map((q) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${q.questionOrder}. ${q.questionText}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (i) {
                          final value = i + 1;
                          return Expanded(
                            child: Column(
                              children: [
                                Radio<int>(value: value, groupValue: answers[q.questionCode], onChanged: (val) => setState(() => answers[q.questionCode] = val!)),
                                Text("$value"),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      );
    }).toList();
  }

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}