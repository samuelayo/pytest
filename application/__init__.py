
import pyximport
pyximport.install()
import os
#upload= os.path.dirname(os.path.abspath(__file__))+"/uploads"
# Import flask and template operators
from flask import *
from flask_socketio import SocketIO
#

# Import MYSQL

import MySQLdb
import MySQLdb.cursors


# Define the WSGI application object
app = Flask(__name__)
socketio = SocketIO(app)
mysq = MySQLdb.connect(host="sleepingdemon.mysql.pythonanywhere-services.com", user="sleepingdemon", passwd="passworded", db="flask_forum", cursorclass=MySQLdb.cursors.DictCursor)
mysq.autocommit(True)
mysql = mysq.cursor()

# Configurations
app.config.from_object('config')
app.config['upload_folder']=os.path.dirname(os.path.abspath(__file__))+"/static/uploads/"

# Define the database object which is imported
# by modules and controllers


# Sample HTTP error handling
@app.errorhandler(404)
def not_found(error):
    return render_template('errors/error.html'), 404
@app.errorhandler(405)
def this_found(error):
    return render_template('errors/error.html'), 404
@app.errorhandler(500)
def this_found(error):
    return render_template('errors/500.html'), 500

# Import a module / component using its blueprint handler variable (mod_auth)
from home import controller
from users import controller
from search import controller
from auth import controller
from category import controller
from topics import controller
from messages import controller

# Register blueprint(s)

# app.register_blueprint(xyz_module)
# ..

# Build the database:
# This will create the database file using SQLAlchemy

