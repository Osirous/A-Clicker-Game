class_name ManagerHTTPRequests
extends HTTPRequest

static var ref : ManagerHTTPRequests

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

func _ready() -> void:
	pass

func send_create_request(username, password):
	pass
	

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if result != OK:
		# Handle error, such as showing a message
		pass
	else:
		# Process the successful response
		pass
