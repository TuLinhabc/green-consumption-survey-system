INSERT INTO survey_questions
(factor_code, question_code, question_text, question_order, is_reverse)
VALUES

-- NTMT - Nhận thức môi trường
('NTMT', 'NTMT1', 'Tôi quan tâm đến các vấn đề ô nhiễm môi trường hiện nay.', 1, FALSE),
('NTMT', 'NTMT2', 'Tôi nhận thức được rằng hành vi mua sắm của cá nhân có thể ảnh hưởng đến môi trường.', 2, FALSE),
('NTMT', 'NTMT3', 'Tôi cho rằng việc lựa chọn sản phẩm thân thiện môi trường là cần thiết.', 3, FALSE),
('NTMT', 'NTMT4', 'Tôi thường chú ý đến tác động môi trường của sản phẩm khi mua sắm.', 4, FALSE),

-- TD - Thái độ đối với tiêu dùng xanh
('TD', 'TD1', 'Tôi cho rằng tiêu dùng xanh là một hành vi tích cực.', 5, FALSE),
('TD', 'TD2', 'Tôi cảm thấy việc mua sản phẩm thân thiện môi trường là có ích.', 6, FALSE),
('TD', 'TD3', 'Tôi đánh giá cao các sản phẩm được sản xuất theo hướng bền vững.', 7, FALSE),
('TD', 'TD4', 'Tôi có thiện cảm với các thương hiệu chú trọng yếu tố môi trường.', 8, FALSE),

-- AHXH - Ảnh hưởng xã hội
('AHXH', 'AHXH1', 'Gia đình hoặc bạn bè có ảnh hưởng đến việc tôi lựa chọn sản phẩm xanh.', 9, FALSE),
('AHXH', 'AHXH2', 'Các đánh giá trên mạng xã hội ảnh hưởng đến quyết định mua sản phẩm xanh của tôi.', 10, FALSE),
('AHXH', 'AHXH3', 'Tôi có xu hướng lựa chọn sản phẩm xanh khi thấy nhiều người xung quanh sử dụng.', 11, FALSE),
('AHXH', 'AHXH4', 'Người nổi tiếng hoặc KOL/KOC có thể ảnh hưởng đến quyết định lựa chọn sản phẩm xanh của tôi.', 12, FALSE),

-- NTX - Niềm tin xanh
('NTX', 'NTX1', 'Tôi tin rằng một số sản phẩm xanh trên sàn TMĐT thật sự thân thiện với môi trường.', 13, FALSE),
('NTX', 'NTX2', 'Tôi tin tưởng các thông tin môi trường được cung cấp rõ ràng bởi người bán.', 14, FALSE),
('NTX', 'NTX3', 'Tôi tin rằng các chứng nhận hoặc nhãn xanh giúp tăng độ tin cậy của sản phẩm.', 15, FALSE),
('NTX', 'NTX4', 'Tôi nghi ngờ một số sản phẩm xanh trên sàn TMĐT chỉ là quảng cáo phóng đại.', 16, TRUE),

-- TTT - Chất lượng thông tin sản phẩm
('TTT', 'TTT1', 'Thông tin về chất liệu sản phẩm trên sàn TMĐT được trình bày rõ ràng.', 17, FALSE),
('TTT', 'TTT2', 'Người bán cung cấp đầy đủ thông tin về nguồn gốc và đặc điểm bền vững của sản phẩm.', 18, FALSE),
('TTT', 'TTT3', 'Hình ảnh và mô tả sản phẩm giúp tôi đánh giá yếu tố thân thiện môi trường.', 19, FALSE),
('TTT', 'TTT4', 'Đánh giá của người mua trước cung cấp thêm thông tin giúp tôi đánh giá sản phẩm xanh.', 20, FALSE),

-- GC - Cảm nhận về giá
('GC', 'GC1', 'Tôi cho rằng sản phẩm xanh thường có giá cao hơn sản phẩm thông thường.', 21, FALSE),
('GC', 'GC2', 'Giá cao khiến tôi cân nhắc khi mua sản phẩm xanh.', 22, FALSE),
('GC', 'GC3', 'Tôi e ngại mua sản phẩm xanh khi giá của chúng cao hơn đáng kể so với sản phẩm thông thường.', 23, FALSE),
('GC', 'GC4', 'Tôi ít chọn sản phẩm xanh nếu mức giá chênh lệch quá lớn so với sản phẩm thông thường.', 24, FALSE),

-- HVX - Hành vi tiêu dùng xanh
('HVX', 'HVX1', 'Tôi ưu tiên lựa chọn sản phẩm thân thiện môi trường khi mua hàng trên sàn TMĐT.', 25, FALSE),
('HVX', 'HVX2', 'Trong các lần mua hàng trên sàn TMĐT, tôi có xu hướng lựa chọn sản phẩm xanh khi có lựa chọn phù hợp.', 26, FALSE),
('HVX', 'HVX3', 'Tôi thường tìm hiểu thông tin môi trường của sản phẩm trước khi mua.', 27, FALSE),
('HVX', 'HVX4', 'Tôi có xu hướng tiếp tục mua sản phẩm xanh trong tương lai.', 28, FALSE);