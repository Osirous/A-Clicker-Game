class_name ManagerLogin
extends Node

static var ref : ManagerLogin

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var login_username_line_edit : LineEdit = $"Login Manager/Login_User_Name"
@onready var login_password_line_edit : LineEdit = $"Login Manager/Login_Password"
@onready var create_username_line_edit : LineEdit = $"Login Manager/Create_User_Name"
@onready var create_password_line_edit : LineEdit = $"Login Manager/Create_Password"
@onready var create_password_verify_line_edit : LineEdit = $"Login Manager/Verify_Password"

var login_username : String
var login_password : String
var create_username : String
var create_password : String
var create_password_verify : String

func _ready() -> void:
	pass

func _on_login() -> void:
	login_username = login_username_line_edit.text
	login_password = login_password_line_edit.text

func _on_create_login() -> void:
	create_username = create_username_line_edit.text
	create_password =  create_password_line_edit.text
	create_password_verify = create_password_verify_line_edit.text

	if not passwords_match():
		## make a popup box that says they dont match
		# popup_mismatch.visible = true
		#
		return
	
	if ManagerHTTPRequests.send_create_request(create_password, create_password_verify):
		return

func passwords_match() -> bool:
	return create_password == create_password_verify
