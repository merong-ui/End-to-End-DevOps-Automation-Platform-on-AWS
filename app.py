from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "DevOps App Running!"

# allows external access (Docker/EC2)
app.run(host='0.0.0.0', port=5000)
