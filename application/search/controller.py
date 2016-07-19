from flask import *
from application import app
from application.home import sammy
@app.route('/search', methods=['POST'])
def search():
	post_data = request.form['data']
	
	return render_template('500.html')