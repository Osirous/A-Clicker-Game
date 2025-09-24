class_name ComponentUpgrade5
extends Control

@export var label_title : Label
@export var button : Button
@export var label_description : RichTextLabel

# this needs work all of the things currently commented out are part of the half finished upgrade system... finish this.

## Upgrade to display.
var upgrade5 : ManagerUpgrades

func _ready() -> void:
	StartButton.ref.game_start.connect(_on_game_start_setup_ui)

func _on_game_start_setup_ui() -> void:
	# This ensures the upgrade is created only when needed, and before UI setup
	if not upgrade5:
		upgrade5 = Upgrade05AttackMaxHit.new()
	
	update_label_title()
	update_description()
	update_button()
	
	ManagerLoot.ref.loot_created.connect(update_button)
	ManagerLoot.ref.loot_spent.connect(update_button)
	
	upgrade5.leveled_up.connect(update_label_title)
	upgrade5.leveled_up.connect(update_description)
	upgrade5.leveled_up.connect(update_button)
	

func update_label_title() -> void:
	var text : String = upgrade5.title + " (%s)" %upgrade5.level
	label_title.text = text

func update_description() -> void:
	label_description.text = upgrade5.description()

func update_button(_quantity : int = -1) -> void:
	if upgrade5.can_afford():
		button.disabled = false
		return
	
	button.disabled = true

func _on_purchase_button_pressed() -> void:
	upgrade5.level_up()
