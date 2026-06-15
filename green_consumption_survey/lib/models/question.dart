class Question {
  final int id;
  final String factorCode;
  final String questionCode;
  final String questionText;
  final int questionOrder;
  final bool isReverse;

  Question({
    required this.id,
    required this.factorCode,
    required this.questionCode,
    required this.questionText,
    required this.questionOrder,
    required this.isReverse,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      factorCode: json['factor_code'],
      questionCode: json['question_code'],
      questionText: json['question_text'],
      questionOrder: json['question_order'],
      isReverse: json['is_reverse'],
    );
  }
}