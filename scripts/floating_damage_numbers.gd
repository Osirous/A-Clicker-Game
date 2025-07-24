extends Node2D

func display_number(value: float, position: Vector2, is_critical: bool = false) -> void:
	var number : Node = Label.new()
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color : String = "#FFF"
	if is_critical:
		color = "#B22"
	if value == 0.0:
		color = "#FFF0"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 100
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 10
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	## This makes the text center on the node
	## Use number.global_position = position 
	## to make the text start from the top left corner of the node instead
	number.global_position = position - number.pivot_offset

	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	if is_critical:
		# Critical numbers move RIGHT
		tween.tween_property(number, "position:x", number.position.x + 100, 0.75).set_ease(Tween.EASE_OUT)
	else:
		# Normal numbers move LEFT
		tween.tween_property(number, "position:x", number.position.x - 100, 0.75).set_ease(Tween.EASE_OUT)	
		
	tween.tween_property(number, "position:y", number.position.y - 200, 0.75).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "position:y", number.position.y, 0.75).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_IN).set_delay(0.75)
	
	await tween.finished
	number.queue_free()
