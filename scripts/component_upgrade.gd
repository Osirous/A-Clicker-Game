class_name ComponentUpgrade
extends Control

@export var label_title : Label
@export var button : Button
@export var label_description : RichTextLabel

# this needs work all of the things currently commented out are part of the half finished upgrade system... finish this.

## Upgrade to display.
var upgrade : ManagerUpgrades

func _ready() -> void:
	#if not upgrade:
		#upgrade = Upgrade01Clicker.new()
	
	update_label_title()
	update_description()
	#update_button()
	
	ManagerLoot.ref.loot_created.connect(update_button)
#	ManagerLoot.ref.spend_loot.connect(update_button)
	
	upgrade.leveled_up.connect(update_label_title)
	upgrade.leveled_up.connect(update_description)
	upgrade.leveled_up.connect(update_button)
	

func update_label_title() -> void:
	var text : String = upgrade.title + " (%s)" %upgrade.level
	label_title.text = text

func update_description() -> void:
	label_description.text = upgrade.description()

func update_button(_quantity : int = -1) -> void:
	if upgrade.can_afford():
		button.disabled = false
		return
	
	button.disabled = true

func _on_purchase_button_pressed() -> void:
	upgrade.level_up()
