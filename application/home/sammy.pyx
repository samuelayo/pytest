from flask import *
from application import app
from application import mysql
import random
import json
def get_category(id):
	rows_count=mysql.execute("SELECT * from Subcategory where id = %s",(id,))
	if rows_count > 0:
		cat = mysql.fetchone()
	else:
		cat = {}
	return cat

def random_number():
	return random.randint(2000, 9000)
def last_comment(id):
	rows_count=mysql.execute("SELECT * from User where id = %s",(id,))
	if rows_count > 0:
		user = mysql.fetchall()
	else:
		user = {}
	return user
def followingthis(lists):
	if not lists:
		return False
	lists = json.loads(lists)
	i = str(session.get('id'))
	if not lists:
		return False
	if len(lists)==1:

		if lists[0]==i:
			return True
	newlist = [str(item) for item in lists]
	counter = 0
	while counter < len(newlist):
		if newlist[counter]==i:
			return True
			break
		else: 
			pass
		counter = counter+1
	return False
def no_of_friends(followers, following):
	if following ==None:
		return 0
	if followers == None:
		return 0
	if following =="":
		return 0
	if followers == "":
		return 0
	following = json.loads(following)
	followers = json.loads(followers)
	follows = [str(item) for item in following]
	followed = [str(item) for item in followers]
	if len(follows)==0:
		return 0
	if len(followed)==0:
		return 0
	counter = 0
	while counter < len(follows):
		if follows[counter] in followed:
			counter = counter+1
		else:
			pass			
	return counter	
def friends(followers, following):
	if following ==None:
		return []
	if followers == None:
		return []

	if following =="":
		return []
	if followers == "":
		return []
	
	following = json.loads(following)
	followers = json.loads(followers)
	follows = [str(item) for item in following]
	followed = [str(item) for item in followers]
	if len(follows)==0:
		return []
	if len(followed)==0:
		return []
	finalist = []
	counter = 0
	while counter < len(follows):
		if follows[counter] in followed:
			finalist.append(follows[counter])
		else:
			pass
		counter = counter+1			
	return finalist
app.jinja_env.globals.update(last_comment=last_comment)
app.jinja_env.globals.update(random_number=random_number)
app.jinja_env.globals.update(get_category=get_category)
app.jinja_env.globals.update(followingthis=followingthis)
app.jinja_env.globals.update(no_of_friends=no_of_friends)
app.jinja_env.globals.update(friends=friends)

