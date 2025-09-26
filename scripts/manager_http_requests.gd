class_name ManagerHTTPRequests
extends HTTPRequest

static var ref : ManagerHTTPRequests

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

var user_id : String = ""
var jwt_token : String = ""
var save_id : String = ""
var connection_server_create : String = "http://localhost:8080/api/users"
var connection_server_login : String = "http://localhost:8080/api/login"
var connection_server_save_get : String = "http://localhost:8080/api/savedata"
var login_callback : Callable = Callable()
var current_request_type : String = ""

func send_login_request(username: String, password: String) -> void:
	current_request_type = "login"
	var payload : Dictionary = {
		"username": username,
		"password": password
	}
	var json : String = JSON.stringify(payload)
	var headers : Array[String] = ["Content-Type: application/json"]
	self.request(
		connection_server_login,
		headers,
		HTTPClient.METHOD_POST,
		json
	)

func send_create_request(username: String, password: String) -> void:
	current_request_type = "create account"
	var payload : Dictionary = {
		"username": username,
		"password": password
	}
	var json : String = JSON.stringify(payload)
	var headers : Array[String] = ["Content-Type: application/json"]
	self.request(
		connection_server_create,
		headers,
		HTTPClient.METHOD_POST,
		json
	)

func _on_request_completed(result: int, _response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != OK:
		ManagerLogin.ref.show_feedback("Request failed! Error code: %s" %result)
		return
	
	var json_text : String = body.get_string_from_utf8()
		
	var parse_result = JSON.parse_string(json_text)
	
	# Defense against the dark arts! This will help with those pesky incorrect username or password errors given by the server!
	if parse_result == null:
		ManagerLogin.ref.show_feedback("Failed to parse server response: %s" % json_text)
		return
	
	var response_dict : Dictionary = parse_result
	
	if response_dict.has("error"):
		var error_msg = response_dict.error
		if current_request_type == "login":
			ManagerLogin.ref.show_feedback("Login failed: %s" % error_msg)
		elif "save" in error_msg and "not found" in error_msg and current_request_type == "fetch_save":
			return
		else:
			ManagerLogin.ref.show_feedback("Error: %s" % error_msg)
		return
	
	if current_request_type == "login":
		var is_success : bool = typeof(response_dict) == TYPE_DICTIONARY and response_dict.has("id") and response_dict.has("token") and response_dict.token != ""
		if is_success:
			user_id = response_dict.id
			jwt_token = response_dict.token
			save_id = response_dict.save_id
		if login_callback.is_valid():
			login_callback.call(is_success)
			# Only try to load save data if we have a valid save_id
			if is_success and save_id != null and save_id != "" and save_id != "00000000-0000-0000-0000-000000000000":
				PlayerData.save_data.load_data_from_server(save_id)
			elif is_success:
				return
		else:
			ManagerLogin.ref.show_feedback("Login failed or bad response: %s" % json_text)
	elif current_request_type == "fetch_save":
		# load save data from the parsed response
		PlayerData.save_data.load_save_data(response_dict)
	elif current_request_type == "upload_save_post":
		# Parse the server's response
		if typeof(response_dict) == TYPE_DICTIONARY and response_dict.has("id"):
			var new_save_id = response_dict["id"]
			PlayerData.save_data.save_id = new_save_id
	elif current_request_type == "upload_save_put":
		print("Save updated on server!")
	elif current_request_type == "create account":
		var create_success : bool = typeof(response_dict) == TYPE_DICTIONARY and response_dict.has("id")
		if create_success:
			ManagerLogin.ref.show_feedback("Account created successfully.\nPlease login, press start, close the game and relog in to start playing.\nThis is a current work around for not saving to the server on first log in.")

func upload_save(json: String, save_id: String) -> void:
	var url : String
	var method : int

	if save_id == "" or save_id == "00000000-0000-0000-0000-000000000000":
		url = "http://localhost:8080/api/savedata"
		method = HTTPClient.METHOD_POST
		current_request_type = "upload_save_post"
	else:
		url = "http://localhost:8080/api/savedata/%s" % save_id
		method = HTTPClient.METHOD_PUT
		current_request_type = "upload_save_put"

	var headers : Array = [
		"Authorization: Bearer " + jwt_token,
		"Content-Type: application/json"
	]

	self.request(
		url,
		headers,
		method,
		json
	)
	
func fetch_save(save_id: String) -> void:
	current_request_type = "fetch_save"
	var url : String = "%s/%s" % [connection_server_save_get, save_id]
	var headers : Array[String] = ["Authorization: Bearer " + jwt_token]
	self.request(
		url,
		headers,
		HTTPClient.METHOD_GET,
	)
