from flask import Flask, render_template
from flask import request

app = Flask(__name__)

# Home route
@app.route('/')
def home():
    return render_template('index.html')  # Render the index.html template

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/greet', methods=['POST'])
def greet():
    username = request.form.get('username')
    return f"Hello, {username}!"



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

