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
@onready var start_button : Button = $"../Start_Button"
@onready var login_manager : VBoxContainer = $"Login Manager"
@onready var feedback : AcceptDialog = $FeedbackPopup

var login_username : String
var login_password : String
var create_username : String
var create_password : String
var create_password_verify : String

func show_feedback(message: String):
	feedback.dialog_text = message
	feedback.popup_centered()

func _on_login() -> void:
	login_username = login_username_line_edit.text
	login_password = login_password_line_edit.text

func _on_create_login() -> void:

	create_username = create_username_line_edit.text
	create_password =  create_password_line_edit.text
	create_password_verify = create_password_verify_line_edit.text

	if create_username == "" or create_password == "":
		# pop up that they are a failure for not putting in credentials
		show_feedback("Please enter both a username and a password.")
		return

	if not passwords_match():
		## make a popup box that says they dont match
		show_feedback("Passwords must match to create a new account.")
		return
	
	ManagerHTTPRequests.ref.send_create_request(create_username, create_password)

func passwords_match() -> bool:
	return create_password == create_password_verify


func _on_create_account_button_pressed() -> void:
	_on_create_login()


func _on_login_button_pressed() -> void:
	_on_login()
	ManagerHTTPRequests.ref.login_callback = self._on_login_result
	ManagerHTTPRequests.ref.send_login_request(login_username, login_password)

func _on_login_result(success: bool) -> void:
	if success:
		# this is currently annoying so its commented out.
		#show_feedback("Login Successful!")
		start_button.visible = true
		login_manager.visible = false
	else:
		show_feedback("Login Failed.")


func _on_offline_button_pressed() -> void:
	start_button.visible = true
	login_manager.visible = false
