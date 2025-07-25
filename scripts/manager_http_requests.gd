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

func _ready() -> void:
	pass

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
	var parse_result : Dictionary = JSON.parse_string(json_text)
	print(parse_result)
	
	if current_request_type == "login":
		var is_success : bool = typeof(parse_result) == TYPE_DICTIONARY and parse_result.has("id") and parse_result.has("token") and parse_result.token != ""
		if is_success:
			user_id = parse_result.id
			jwt_token = parse_result.token
			save_id = parse_result.save_id
		if login_callback.is_valid():
			login_callback.call(is_success)
			PlayerData.save_data.load_data_from_server(save_id)
		else:
			ManagerLogin.ref.show_feedback("Login failed or bad response: %s" % json_text)
	elif current_request_type == "fetch_save":
		# load save data from the parsed response
		PlayerData.save_data.load_save_data(parse_result)
		# emit a signal or trigger a UI update now?
	elif current_request_type == "upload_save_post":
		# Parse the server's response
		if typeof(parse_result) == TYPE_DICTIONARY and parse_result.has("id"):
			var new_save_id = parse_result["id"]
			# Store this for future PUTs!
			# For example, on your PlayerSaveData or Manager singleton:
			PlayerData.save_data.save_id = new_save_id
			# Optionally, emit a signal or call a callback to update the UI or workflow
	elif current_request_type == "upload_save_put":
 		# You may want to confirm success, check for errors, or refresh data
		print("Save updated on server!")
#		emit_signal("save_data_updated")

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
		json  # <-- Send only this, which you built in save_data_to_server
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
