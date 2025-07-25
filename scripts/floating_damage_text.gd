extends Node2D


func display_text(value: String, display_position: Vector2) -> void:
	var number : Label = Label.new()
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color : String = "#BB2222"
	if value == "You missed!":
		color = "#FFFF00"
	if value.begins_with("You found"):
		color = "#7BB35D"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 75
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 10
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	number.global_position = display_position - number.pivot_offset

	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position:y", number.position.y - 200, 1.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "position:y", number.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
