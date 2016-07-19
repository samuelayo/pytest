from flask_wtf import *
from wtforms import *
from application import *
class userform(Form):
	name = TextField("Full name", [validators.Required("Please input your full name")])
	facebook = TextField("Facebook url")
	twitter = TextField("Twitter url")
	website = TextField("website", )
	phone_no = TextField("phonenumber", [validators.Required("Please input ayour phone number")])
	submit = SubmitField("send")
