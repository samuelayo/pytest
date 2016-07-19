from flask_wtf import *
from wtforms import *
class registerform(Form):
	Username = TextField("Username", [validators.Required("Please input a username")])
	Name = TextField("Full Name", [validators.Required("Please input your fullName")])
	Gender = RadioField("Gender", choices=[('M','MALE'),('F','FEMALE')])
	Phone = IntegerField("Phone No", [validators.Required("Please enter your phone number")])
	Email = TextField("Email", [validators.Required("Please input a username"), validators.Email("Please enter a valid email")])
	Password = PasswordField("Password", [validators.Required("Please enter a default password")])
	Confirm = PasswordField("Confirm Password", [validators.Required("Please passwords do not match")])
	Submit = SubmitField("Send")