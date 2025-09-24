class_name StartButton

extends Button

static var ref : StartButton

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var label_enemy_stats : Label = $"../../LabelEnemyStats"
@onready var label_loot : Label = $"../../LabelLoot"
@onready var attack_button : Button = $"../../Fight Enemies/Attack"
@onready var upgrade_button : Button = $"../../ManagerUpgrades/Upgrade"

signal game_start()


func _on_pressed() -> void:
	Opening.ref.opening_image.visible = false
	visible = false
	attack_button.visible = true
	upgrade_button.visible = true
	label_loot.visible = true
	label_enemy_stats.visible = true
	#AttackScript.ref.enemy_sprite_node.visible = true
	game_start.emit()

func _on_save_timer_timeout() -> void:
	PlayerData.save_data.save_to_file()
	if ManagerLogin.ref.is_online:
		PlayerData.save_data.save_data_to_server(ManagerHTTPRequests.ref.save_id)
