from flask import *
from application import app
from application import mysql
import datetime
from form import *
from werkzeug.security import generate_password_hash, check_password_hash
@app.route('/login', methods=['GET','POST'])
def login():
	
	if request.method=='POST':
		username = request.form['username']
		password = request.form['password']
		
		rows_count=mysql.execute("SELECT * from User where Username=%s", (username,))
		if rows_count > 0:

			
			data = mysql.fetchone()
			verify_password = check_password_hash(data['Password'], password)
			if verify_password == True:
				message = "login succesful"
				session['login'] = 'value'
				session['id']= data["id"]
				session['username'] = data["Username"]
				session['role'] = data["role"]
				session['name'] = data["full_name"]
				session['email'] = data["email"]
				session['passport'] = data["picture"]
				session['ban'] = data["ban"]
				return redirect(url_for('index'), code=302)
			else:
				message = "Password is incorrect"
		else:
			message = "Username does not exist"

		return render_template('login.html', message=message)
	else:
		if session.get('login')=="value":
			return redirect(url_for('index'), code=302)
		else:
			return render_template('login.html')






@app.route('/register', methods=['GET','POST'])
def register():
	if session.get('login')=='value':
		return redirect(url_for('index'), code=302)
	else:
		form = registerform()
		if request.method == 'POST':
			form = registerform(request.form)
			if form.validate() == False:
				return render_template('register.html', form=form)
			else:

				password = request.form['Password']
				confirm = request.form['Confirm']
				username = request.form['Username']
				name = request.form['Name']
				gender = request.form['Gender']
				email = request.form['Email']
				phone = request.form['Phone']
				print password
				print confirm
				if password != confirm :
					return render_template('register.html', form=form, message="Passwords do not match")
				else:
					rows_count=mysql.execute("SELECT * from User where Username=%s ", (username,))
					if rows_count > 0:
						return render_template('register.html', form=form, message="Username already taken")
				email_check = mysql.execute("SELECT * from User where email=%s ", (email.lower(),))
				if email_check >0:
					return render_template('register.html', form=form, message="Email already taken")
				new_insert = mysql.execute("INSERT into User(Username,Password,role,email,picture,full_name,gender,phone,header,regstamp) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",(username,generate_password_hash(password),"user",email.lower(),"picture.png",name,gender,phone,"picture.png",datetime.datetime.now(),))	
				return render_template('login.html', message="Account created, you can now login")
		return render_template('register.html', form=form)

@app.route('/logout')
def logout():
	session.pop('login', None)
	session.pop('username', None)
	session.pop('id', None)
	session.pop('role', None)
	session.pop('name', None)
	session.pop('email', None)
	session.pop('passport', None)
	session.pop('ban', None)
	return redirect(url_for('login'), code=302)

	
	