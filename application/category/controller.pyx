from flask import *
from application import app
from application import mysql
@app.route('/category')
def category():
	return render_template('errors/error.html')
@app.route('/category/<int:id>/<category>')
def categories(int id, category):
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
	rows_count=mysql.execute("SELECT * from Topics where category = %s", (id,))
	if rows_count > 0:
		topics = mysql.fetchall()
	else:
		topics = {}
	return render_template('category/category.html', title=category+"| Flask Forum", categories=categories_data, subcategories=subcategories, category=category, topics=topics)
