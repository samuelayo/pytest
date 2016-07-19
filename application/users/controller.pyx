from flask import *
import os
from application import *
from user import *
import json
import ast
from werkzeug import secure_filename
from application.home import sammy
@app.route('/users', methods=[])
def users():
	if session.get('login') != 'value':
		return redirect(url_for('login'), code=302)
	if request.method=='POST':
		f=request.files['upload']
		extension = os.path.splitext(f.filename)[1]
		path = os.path.join(app.config['upload_folder'])+str(session.get('id'))+"/"+session.get('username')+"/"
		if not os.path.exists(path):
			os.makedirs(path)
		f.save(path+secure_filename(f.filename))
		savedfile = str(session.get('id'))+"/"+session.get('username')+"/"+secure_filename(f.filename)
		print savedfile
		print extension

	return render_template('user/user.html')
@app.route('/users/<username>/<int:idss>',  methods=['GET','POST'])
def thisuser(username, idss):
	cdef int ids = idss
	form = userform()
	rows_count = mysql.execute("SELECT* from User where id = %s and Username =%s",[ids, username])
	if rows_count > 0:
		user = mysql.fetchone()
		if request.method =='POST':
			form = userform(request.form)
			if form.validate == False:
				return render_template('user/user.html', user=user, form=form)
			else:
				path = os.path.join(app.config['upload_folder'])+str(session.get('id'))+"/"+session.get('username')+"/"
				if not os.path.exists(path):
					os.makedirs(path)
				twitter = request.form['twitter']
				facebook = request.form['facebook']
				phone_no = request.form['phone_no']
				name = request.form['name']
				website = request.form['website']
				p=request.files['profilepic']
				h=request.files['headerimg']
				if p.filename == '':
					profilepic = user['picture']

				else:
					p.save(path+secure_filename(p.filename))
					profilepic = "uploads/"+str(session.get('id'))+"/"+session.get('username')+"/"+secure_filename(p.filename)
				if h.filename == '':
					headerpic = user['header']
				else:
					h.save(path+secure_filename(h.filename))
					headerpic = "uploads/"+str(session.get('id'))+"/"+session.get('username')+"/"+secure_filename(h.filename)
				mysql.execute("UPDATE User set twitter=%s, facebook=%s, phone=%s, full_name=%s, website=%s, picture=%s, header=%s where id=%s",[twitter, facebook, phone_no, name, website, profilepic, headerpic, ids])
				message = "profile succesfully updated"
				return render_template('user/user.html', user=user, form=form, message=message)
		return render_template('user/user.html', user=user, form=form)
	else:
		return redirect(url_for('users'), code=302)



@app.route('/users/follow', methods=['POST'])
def follow():
	if request.method=='POST':
		ids=request.form['id']
		rows_count = mysql.execute("SELECT* from User where id=%s",[ids])
		if rows_count >0:
			use = mysql.fetchone();
			followers = use['followers']
			if followers == None:
				followers = [str(session['id'])]
			else:
				foll = json.loads(followers)
				fos = [str(item) for item in foll]
				
				fos.append(str(session['id']))
				followers = fos
			mysql.execute("UPDATE User set followers =%s where id = %s", [json.dumps(followers),ids])
			
			rows_coun = mysql.execute("SELECT* from User where id=%s",[session['id']])
			if rows_coun >0:
				user = mysql.fetchone();
				following = user['following']
				if following == None:
					following = [str(ids)]
				else:
					following = json.loads(following)
					fo = [str(item) for item in following]
					
					fo.append(str(ids))
					following = fo
				mysql.execute("UPDATE User set following =%s where id = %s", [json.dumps(following),session['id']])
			return "succesfull"
		else:
			return redirect(url_for('users'), code=404)

@app.route('/users/unfollow', methods=['post'])
def unfollow():
	if request.method=='POST':
		ids = request.form['id']
		rows_count = mysql.execute("SELECT* from User where id=%s",[session['id']])
		if rows_count > 0:
			unfollow_user = mysql.fetchone()
			following = unfollow_user['following'] 
			if following == None:
				return "failed"
			else:
				following = json.loads(following)
				fo = [str(item) for item in following]
				counter = 0
				while counter < len(fo):
					if fo[counter] == str(ids):
						del fo[counter]
						mysql.execute("UPDATE User set following =%s where id = %s", [json.dumps(fo),session['id']])
						break
					else:
						pass
					counter=counter+1
		rows_count = mysql.execute("SELECT * from User where id=%s", [ids])
		if rows_count >0:
			theperson = mysql.fetchone()
			followers = theperson['followers']
			if followers == None:
				return "failed"
			else:
				followers = json.loads(followers)
				fos = [str(item) for item in followers]
				counter = 0
				while counter < len(fos):
					if fos[counter] == str(session['id']):
						del fos[counter]
						mysql.execute("UPDATE User set followers =%s where id=%s", [json.dumps(fos),ids])
						return "succesfull"
						break
					else:
						pass
					counter = counter+1

