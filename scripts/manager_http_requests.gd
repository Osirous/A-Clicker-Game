class_name ManagerHTTPRequests
extends HTTPRequest

static var ref : ManagerHTTPRequests

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

var connection_server_create : String = "http://localhost:8080/api/users"
var connection_server_login : String = "http://localhost:8080/api/login"
var login_callback : Callable = Callable()

func _ready() -> void:
	pass

func send_login_request(username: String, password: String) -> void:
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

func _on_request_completed(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != OK:
		ManagerLogin.ref.show_feedback("Request failed! Error code: %s" %result)
		return
	
	var json_text : String = body.get_string_from_utf8()
	var parse_result : Dictionary = JSON.parse_string(json_text)
	print(parse_result)
	
	var is_success : bool = typeof(parse_result) == TYPE_DICTIONARY and parse_result.has("id") and parse_result.has("token") and parse_result.token != ""
	if login_callback.is_valid():
		login_callback.call(is_success)
	else:
		ManagerLogin.ref.show_feedback("Login failed or bad response: %s" %json_text)
