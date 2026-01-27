from flask import Flask, render_template_string, request, redirect
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)


# 환경변수에서 DB 정보 끌어오기
# ('환경변수', '기본값') 기본값 없어도 됨
DB_USER = os.environ.get('DB_USER', 'admin')
DB_PASS = os.environ.get('DB_PASSWORD', 'password123')
DB_HOST = os.environ.get('DB_HOST', 'database-1.xxx.amazonaws.com')
DB_NAME = os.environ.get('DB_NAME', 'testdb')

app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


class GuestBook(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(200), nullable=False)


with app.app_context():
    db.create_all()


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        content = request.form.get('content')
        if content:
            new_entry = GuestBook(content=content)
            db.session.add(new_entry)
            db.session.commit()
        return redirect('/')

    entries = GuestBook.query.all()
    
    return render_template_string("""
        <h1>MariaDB Guestbook</h1>
        <form method="POST">
            <input type="text" name="content" placeholder="메시지를 입력하세요" required>
            <button type="submit">등록</button>
        </form>
        <hr>
        <table border="1" style="width:50%; text-align:center;">
            <tr><th>ID</th><th>내용</th></tr>
            {% for entry in entries %}
            <tr><td>{{ entry.id }}</td><td>{{ entry.content }}</td></tr>
            {% endfor %}
        </table>
    """, entries=entries)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)