class_name Opening
extends Node

static var ref : Opening

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var opening_image : Sprite2D = $"Opening Image"
@onready var login_manager : Control = $"Login Control"

func _ready() -> void:
	
	if opening_image.visible == false:
		opening_image.visible = true

	if login_manager.visible == false:
		login_manager.visible = true
