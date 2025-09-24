class_name UpgradeButton

extends Button

static var ref : UpgradeButton

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
@onready var close_button : Button = $"../Close"

func _on_pressed() -> void:
	visible = false
# show upgrades
	if AttackScript.ref.enemy_sprite_node.visible == true:
		AttackScript.ref.enemy_sprite_node.visible = false
	if attack_button.visible == true:
		attack_button.visible = false
	if label_loot.visible == true:
		label_loot.visible = false
	if label_enemy_stats.visible == true:
		label_enemy_stats.visible = false
	if retreat_button.visible == true:
		retreat_button.visible = false
	if advance_button.visible == true:
		advance_button.visible = false
	if upgrade_control.visible == false:
		upgrade_control.visible = true
	if close_button.visible == false:
		close_button.visible = true
