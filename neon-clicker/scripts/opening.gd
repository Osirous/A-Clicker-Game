class_name Opening
extends Node

static var ref : Opening

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var opening_image : Sprite2D = $"Opening Image"
# move this to the login.gd when its created
@onready var start_button : Button = $Start_Button

func on_ready() -> void:
	
	if opening_image.visible == false:
		opening_image.visible = true
	# move this to the login.gd when its created
	#if start_button.visible == false:
	#	start_button.visible = true
