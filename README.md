# Green Consumption Survey System

Hệ thống hỗ trợ khảo sát và phân tích các nhân tố ảnh hưởng đến hành vi tiêu dùng xanh trên sàn thương mại điện tử.

## Công nghệ sử dụng

- Backend: Python, FastAPI
- Database: PostgreSQL
- ORM: SQLAlchemy
- Data processing: pandas, numpy
- Frontend: Flutter, phát triển ở giai đoạn sau

## Chức năng hiện tại

- Lưu trữ 28 câu hỏi khảo sát theo 7 nhóm nhân tố:
  - NTMT: Nhận thức môi trường
  - TD: Thái độ đối với tiêu dùng xanh
  - AHXH: Ảnh hưởng xã hội
  - NTX: Niềm tin xanh
  - TTT: Chất lượng thông tin sản phẩm
  - GC: Cảm nhận về giá
  - HVX: Hành vi tiêu dùng xanh

- API lấy danh sách câu hỏi
- API lưu phản hồi khảo sát
- Lưu câu trả lời Likert vào PostgreSQL

## Cài đặt backend

```bash
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt