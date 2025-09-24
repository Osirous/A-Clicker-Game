class_name CloseButton

extends Button

static var ref : CloseButton

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var label_enemy_stats : Label = $"../../LabelEnemyStats"
@onready var label_loot : Label = $"../../LabelLoot"
@onready var attack_button : Button = $"../../Fight Enemies/Attack"
@onready var upgrade_button : Button = $"../../ManagerUpgrades/Upgrade"
@onready var retreat_button : Button = $"../../Fight Enemies/RetreatButton"
@onready var advance_button : Button = $"../../Fight Enemies/AdvanceButton"
@onready var upgrade_control : Node = $"../Upgrade Control"

func _on_pressed() -> void:
	visible = false
# show upgrades
	if AttackScript.ref.enemy_sprite_node.visible == false:
		AttackScript.ref.enemy_sprite_node.visible = true
	if attack_button.visible == false:
		attack_button.visible = true
	if label_loot.visible == false:
		label_loot.visible = true
	if label_enemy_stats.visible == false:
		label_enemy_stats.visible = true
	if retreat_button.visible == false:
		retreat_button.visible = true
	if advance_button.visible == false:
		advance_button.visible = true
	if upgrade_control.visible == true:
		upgrade_control.visible = false
	if upgrade_button.visible == false:
		upgrade_button.visible = true
