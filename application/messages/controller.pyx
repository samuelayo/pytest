from flask import *
from application import app
from application import mysql
@app.route('/messages')
def messages():
	return render_template('messages/messages.html')
