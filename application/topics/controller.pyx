
from flask import *
from application import app
from application import mysql
from application.home import sammy
import datetime
import random
import json
from form import *
@app.route('/topics')
def topics():
	return render_template('errors/error.html')
@app.route('/topics/<int:ids>/<slug>', methods=['GET', 'POST'])
def topices(int ids, slug):
	cdef int id = ids
	if request.method == 'POST':

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
		rows_count=mysql.execute("SELECT * from Topics where slug = %s", (slug,))
		if rows_count > 0:
			topic = mysql.fetchone()
		else:
			topic = {}	
		#process post
		get_reply = request.form['reply']
		process= mysql.execute("INSERT into Replies(topic_id, reply, regstamp, reply_by, attachments) VALUES(%s,%s,%s,%s,%s)", (topic['id'],get_reply,datetime.datetime.now(),session['id'],json.dumps({}),))
		new_posts=int(topic['posts'])+1
		topic_to_up = mysql.execute("UPDATE Topics set posts=%s, last_post_by=%s where id = %s",(new_posts, session['id'], topic['id'],))
		#end post
		if topic == {}:
			rows_count=0
			return redirect(url_for('index')+slug)
		else:
			rows_count=mysql.execute("SELECT * from Replies where topic_id = %s", (topic['id'],))
		if rows_count > 0:
			replies = mysql.fetchall()
		else:
			replies = {}
		now = datetime.datetime.now()

		return render_template('topics/topics.html', title=slug+"| Flask Forum", subcategories=subcategories, categories=categories_data, topic=topic, replies=replies, replied="true")

		
	elif request.method =='GET':
	
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
		rows_count=mysql.execute("SELECT * from Topics where slug = %s", (slug,))
		if rows_count > 0:
			topic = mysql.fetchone()
		else:
			topic = {}	

		if topic == {}:
			rows_count=0
			return redirect(url_for('index')+slug)
		else:
			rows_count=mysql.execute("SELECT * from Replies where topic_id = %s", (topic['id'],))
		if rows_count > 0:
			replies = mysql.fetchall()
		else:
			replies = {}
		now = datetime.datetime.now()

		return render_template('topics/topics.html', title=slug+"| Flask Forum", subcategories=subcategories, categories=categories_data, topic=topic, replies=replies)


@app.route('/topics/new', methods=['GET', 'POST'])
def new_topic():

	if session.get('login') == "value":
		

		Reply_form = topicform()
		if request.method=='GET':
			return render_template('topics/new.html', form=Reply_form)

		elif request.method=='POST':
			form = topicform(request.form)
			if form.validate() == False:
				flash("all fields are required")
				return render_template('topics/new.html', form=form)
			else:
				title = request.form['Topic']
				category = request.form['Categories']
				content = request.form['Content']
				slug = title.replace(" ", "-")
				nows_count=mysql.execute("SELECT * from Topics where slug =%s ",(slug,))
				if nows_count > 0:
					slug=slug
				else:
					rand = "gghdzsxkmn"
					slug = slug+"+"+category+"-"+rand
				print slug
				nows_count = mysql.execute("INSERT into Topics(title, slug, content, created_by, last_post_by, regstamp, category, posts) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)", (title,slug,content,session['id'],session['id'],datetime.datetime.now(),category,1,))
				return redirect(url_for('topics')+"/2345/"+slug, code=302)
	else:
		return redirect(url_for('index')+"404notfound")
