extends Button


func _on_ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Opening.ref.opening_image.visible = false
	visible = false
	$"../../Fight Enemies/Attack".visible = true
	$"../../LabelLoot".visible = true
	$"../../LabelEnemyStats".visible = true
	AttackScript.ref.enemy_sprite_node.visible = true
