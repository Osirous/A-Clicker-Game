class_name ManagerLoot
extends Node

static var ref : ManagerLoot

func _init() -> void:
	if not ref : ref = self
	else : queue_free()
	print(ManagerLoot.ref.get_instance_id())

signal loot_updated
signal loot_created(quantity : int)
signal loot_spent(quantity : int)

@onready var floating_reward_origin : Node2D = $"../Fight Enemies/FloatingRewardOrigin"
var loot : Dictionary = {}

const ALL_LOOT_TYPES_IN_DISPLAY_ORDER : PackedStringArray = [
	"Goblin Ears",
	"Badger Claws",
	"Gold Coins",
	"Elemental Core",
	"Scrap Metal",
	"Ghostly Essence",
	"Succubus Tails",
	"Valkyrie Feathers",
	"Dragon Scales",
]

func on_successful_loot() -> bool:
	var min_loot_chance : int = 1
	var max_loot_chance : int = 100
	var to_loot_threshold : int = 50
	var loot_chance : int = randi_range(min_loot_chance, max_loot_chance)
	if loot_chance > to_loot_threshold:
		return true
	return false

func get_loot(enemy_name: String) -> int:
	print("--- Inside get_loot ---")
	print("  'loot' dictionary contents: ", loot) # <--- Add this!
	var retrieved_loot = loot.get(enemy_name, 0)
	print("  Getting loot for key: ", enemy_name, ". Found: ", retrieved_loot)
	return retrieved_loot


func create_loot(enemy_name: String, quantity : int) -> void:
	if quantity <= 0 : return
	
	if enemy_name in loot:
		loot[enemy_name] += quantity
	else:
		loot[enemy_name] = quantity
	
	loot_created.emit(quantity)
	loot_updated.emit()
	
	FloatingDamageText.display_text("You found %s" %AttackScript.ref.current_enemy_data.loot_name, floating_reward_origin.global_position)

func can_spend(enemy_name: String, quantity : int) -> bool:
	print("--- In ManagerLoot.can_spend ---")
	print("  Checking if can spend ", quantity, " of ", enemy_name)
	var loot_available = get_loot(enemy_name)
	print("  Loot available for ", enemy_name, ": ", loot_available)
	print(ManagerLoot.ref.get_instance_id())
	if quantity <= 0:
		print("  Quantity is 0 or less, returning false")
		return false
	
	if quantity > get_loot(enemy_name):
		print("  Not enough loot (", loot_available, ") for quantity (", quantity, "), returning false")
		return false
	print("  Enough loot, returning true")
	return true

func spend_loot(enemy_name: String, quantity : int) -> Error:
	if quantity < 0 : return Error.FAILED
	
	if quantity > get_loot(enemy_name) : return Error.FAILED
	
	if enemy_name in loot:
		loot[enemy_name] -= quantity
	
	loot_spent.emit(quantity)
	loot_updated.emit()
	
	return Error.OK
