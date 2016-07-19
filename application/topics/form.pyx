from flask_wtf import *
from wtforms import *
from application import mysql
class topicform(Form):
	nows_count=mysql.execute("SELECT id,name from Subcategory")
	if nows_count > 0:
		subcategories=mysql.fetchall()
	else:
		subcategories = {}
	
	# lines = []
	# for each in subcategories:
	# 	lines.append(line, line)
	# lines = turple(lines)
	# print 

	Topic = TextField("Topic title", [validators.Required("Please input a form title")])
	Categories = SelectField('Category', choices=[(c['id'],c['name']) for c in subcategories], coerce=int)
	Content = TextAreaField("Content", [validators.Required("Please enter a reply")])
	Submit = SubmitField("Save")