extends Button

@onready var label_enemy_stats : Label = $"../../LabelEnemyStats"
@onready var label_loot : Label = $"../../LabelLoot"
@onready var attack_button : Button = $"../../Fight Enemies/Attack"

func _on_ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Opening.ref.opening_image.visible = false
	visible = false
	attack_button.visible = true
	label_loot.visible = true
	label_enemy_stats.visible = true
	AttackScript.ref.enemy_sprite_node.visible = true

func _on_save_timer_timeout() -> void:
	PlayerData.save_data.save_to_file()
	if ManagerLogin.ref.is_online:
		PlayerData.save_data.save_data_to_server(ManagerHTTPRequests.ref.save_id)
