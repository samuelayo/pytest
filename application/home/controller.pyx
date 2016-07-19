from flask import *
from application import *
from sammy import *
import json
@app.route('/')
def index():
	
	rows_count=mysql.execute("SELECT * from Categories")
	if rows_count > 0:

		categories_data = mysql.fetchall()
		
		nows_count=mysql.execute("SELECT * from Subcategory")
		if nows_count > 0:
			subcategories=mysql.fetchall()
		else:
			subcategories = {}
	else:
		categories_data = {}
	rows_count = mysql.execute("SELECT * FROM Topics where featured='yes' limit 10")
	if rows_count > 0:
		featured = mysql.fetchall()
	else:
		featured={}
	rows_count = mysql.execute("SELECT * FROM Topics where featured is null order by posts desc limit 10 ")
	if rows_count > 0:
		toppost=mysql.fetchall()
	else:
		toppost={}
	return render_template('home.html', title="Homepage | Flask Forum", featured=featured, toppost=toppost, categories=categories_data, subcategories=subcategories)







'''[socket io listening page]

[written after the whole routings of the page]
'''
username = []
user_id = []
@socketio.on('message')
def transmit(message):
	print "recieved: "+message['username']
	
	if message['username'] =='':
		user_id.append("guest"+str(len(user_id)))
		username.append("guest")
	else:
		if message['user'] in user_id:
			print "duplicate"
		else:
			user_id.append(message['user'])
			username.append(message['username'])
	socketio.emit('message', json.dumps([{"user":user_id, "username":username}]));

@socketio.on('disco')
def disco(message):
	if message['username']!='':
		if message['user'] in user_id:
			del message['user']
			socketio.emit('message', {"user":user_id, "username":username});

