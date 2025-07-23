class_name ManagerLoot
extends Node

static var ref : ManagerLoot

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

signal goblinEars_updated
signal goblinEars_created(quantity : int)
signal goblinEars_spent(quantity : int)

var _goblinEars : int = 0

func on_successful_loot() -> bool:
	var min_loot_chance : int = 1
	var max_loot_chance : int = 100
	var to_loot_threshold : int = 50
	var loot_chance : int = randi_range(min_loot_chance, max_loot_chance)
	if loot_chance > to_loot_threshold:
		return true
	return false

func get_goblinEars() -> int:
	return _goblinEars
	

func create_goblinEars(quantity : int) -> void:
	if quantity <= 0 : return
	
	_goblinEars += quantity
	
	goblinEars_created.emit(quantity)
	goblinEars_updated.emit()

func can_spend(quantity : int) -> bool:
	if quantity <= 0 : return false
	
	if quantity > _goblinEars : return false
	
	return true

func spend_goblinEars(quantity : int) -> Error:
	if quantity < 0 : return Error.FAILED
	
	if quantity > _goblinEars : return Error.FAILED
	
	_goblinEars -= quantity
	
	goblinEars_spent.emit(quantity)
	goblinEars_updated.emit()
	
	return Error.OK
