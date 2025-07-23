extends Button

func _ready() -> void:
	visible = false
	print("Advance button ready, starting hidden")

	AttackScript.ref.enemy_died.connect(_on_enemy_died)
	PlayerData.enemy_changed.connect(_on_enemy_changed)
#	pressed.connect(_on_pressed)

func _on_enemy_died(enemy_name: String) -> void:
	print("Enemy died: ", enemy_name)
	print("Current enemy key: ", PlayerData.current_enemy_key)
	print("Enemy kills for current: ", PlayerData.get_enemy_kills(PlayerData.current_enemy_key))
	print("Can advance: ", PlayerData.can_advance_to_next_enemy())
	update_button_visibility()
	
func update_button_visibility() -> void:
	if PlayerData.can_advance_to_next_enemy():
		visible = true
	else:
		visible = false

func _on_pressed() -> void:
	PlayerData.advance_to_next_enemy()

func _on_enemy_changed(new_enemy_key: String) -> void:
	update_button_visibility()
	print("Enemy changed to: ", new_enemy_key)
