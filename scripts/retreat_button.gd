# retreat_button.gd
extends Button

func _ready() -> void:
	PlayerData.enemy_changed.connect(_on_enemy_changed)
	StartButton.ref.game_start.connect(update_visibility)
	# Check initial visibility
	update_visibility()

func update_visibility() -> void:
	visible = PlayerData.can_retreat_to_previous_enemy()

func _on_enemy_changed(_new_enemy_key: String) -> void:
	update_visibility()

func _on_pressed() -> void:
	PlayerData.retreat_to_previous_enemy()
