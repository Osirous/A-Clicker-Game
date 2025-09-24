class_name ComponentUpgrade2
extends Control

@export var label_title : Label
@export var button : Button
@export var label_description : RichTextLabel

# this needs work all of the things currently commented out are part of the half finished upgrade system... finish this.

## Upgrade to display.
var upgrade2 : ManagerUpgrades

func _ready() -> void:
	StartButton.ref.game_start.connect(_on_game_start_setup_ui)

func _on_game_start_setup_ui() -> void:
	# This ensures the upgrade is created only when needed, and before UI setup
	if not upgrade2:
		upgrade2 = Upgrade02AttackAccuracy.new()
	
	update_label_title()
	update_description()
	update_button()
	
	ManagerLoot.ref.loot_created.connect(update_button)
	ManagerLoot.ref.loot_spent.connect(update_button)
	
	upgrade2.leveled_up.connect(update_label_title)
	upgrade2.leveled_up.connect(update_description)
	upgrade2.leveled_up.connect(update_button)
	

func update_label_title() -> void:
	var text : String = upgrade2.title + " (%s)" %upgrade2.level
	label_title.text = text

func update_description() -> void:
	label_description.text = upgrade2.description()

func update_button(_quantity : int = -1) -> void:
	if upgrade2.can_afford():
		button.disabled = false
		return
	
	button.disabled = true

func _on_purchase_button_pressed() -> void:
	upgrade2.level_up()
