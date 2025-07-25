extends Button

func _ready() -> void:
	visible = false

	AttackScript.ref.enemy_died.connect(_on_enemy_died)
	PlayerData.enemy_changed.connect(_on_enemy_changed)
	StartButton.ref.game_start.connect(update_button_visibility)

func _on_enemy_died(_enemy_name: String) -> void:
	update_button_visibility()
	
func update_button_visibility() -> void:
	if PlayerData.can_advance_to_next_enemy():
		visible = true
	else:
		visible = false

func _on_pressed() -> void:
	PlayerData.advance_to_next_enemy()

func _on_enemy_changed(_new_enemy_key: String) -> void:
	update_button_visibility()
