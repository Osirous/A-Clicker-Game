extends Node

static var ref : PlayerData

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

var save_data : PlayerSaveData = preload("res://scripts/player_save_data.gd").new()

func increment_enemy_kills(enemy_name: String) -> void:
	if enemy_name in save_data.enemy_kill_counts:
		print(enemy_name)
		save_data.enemy_kill_counts[enemy_name] += 1
		print(save_data.enemy_kill_counts)
	else:
		save_data.enemy_kill_counts[enemy_name] = 1

func get_enemy_kills(enemy_name: String) -> int:
	return save_data.enemy_kill_counts.get(enemy_name, 0)

## Defines our current enemy
var current_enemy_key : String = "goblin"  # Start with first enemy
var enemy_progression : Array = ["goblin", "badger", "assassin", "air_elemental", "animated_armor", "banshee", "succubus", "valkyrie", "red_dragon"]  # Define enemy order

signal enemy_changed(current_enemy_key: String)

## Move to next enemy logic
func can_advance_to_next_enemy() -> bool:
	# Check if current enemy has been killed at least once
	var current_kills : int = get_enemy_kills(save_data.current_enemy_key)
	return current_kills > 0

func get_next_enemy_key() -> String:
	var current_index : int = enemy_progression.find(save_data.current_enemy_key)
	if current_index < enemy_progression.size() - 1:
		return enemy_progression[current_index + 1]
	return save_data.current_enemy_key  # Stay on last enemy if at end

func advance_to_next_enemy() -> void:
	if can_advance_to_next_enemy():
		save_data.current_enemy_key = get_next_enemy_key()
		# Emit signal to update UI, reset enemy health, etc.
		enemy_changed.emit(save_data.current_enemy_key)

## Move to previous enemy logic
func can_retreat_to_previous_enemy() -> bool:
	var current_index : int = enemy_progression.find(save_data.current_enemy_key)
	return current_index > 0

func get_previous_enemy_key() -> String:
	var current_index : int = enemy_progression.find(save_data.current_enemy_key)
	if current_index > 0:
		return enemy_progression[current_index -1]
	return save_data.current_enemy_key # Stay on first enemy if already at beginning

func retreat_to_previous_enemy() -> void:
	if can_retreat_to_previous_enemy():
		save_data.current_enemy_key = get_previous_enemy_key()
		enemy_changed.emit(save_data.current_enemy_key)

## Defines our click damage
var click_damage_upgrade : int = 0
var click_damage : float = 1.0
@export var DAMAGE_BONUS_AT_LEVEL_ZERO : float = 0.0
@export var DAMAGE_BONUS_PER_LEVEL_INCREMENT : float = 1.0	

## Hit Chance: effects right side of the > check. (did we succeed side)
var click_accuracy_upgrade : int = 0
var click_accuracy : int = 0
@export var ACCURACY_QUADRATIC_COEFFICIENT : int = 5
@export var ACCURACY_BONUS_OFFSET : int = 30

## Hit Chance: effects left side of the > check. (Random range side) 
	## Minimums
var min_chance_to_hit_upgrade : int = 0
var min_chance_to_hit : int = 0
@export var MIN_HIT_QUADRATIC_COEFFICIENT : int = 5
@export var MIN_HIT_BONUS_OFFSET : int = 30
	## Maximums
var max_chance_to_hit_upgrade : int = 0
var max_chance_to_hit : int = 1000
@export var MAX_HIT_QUADRATIC_COEFFICIENT : int = 5
@export var MAX_HIT_BONUS_OFFSET : int = 30

## Critical Hit Chance: effects random roll
	## Minimums
var min_critical_hit_chance_upgrade : int = 0
var min_critical_hit_chance : int = 0
@export var MIN_CRIT_QUADRATIC_COEFFICIENT : int = 5
@export var MIN_CRIT_BONUS_OFFSET : int = 30
	## Maximums
var max_critical_hit_chance_upgrade : int = 0
var max_critical_hit_chance : int = 1000
@export var MAX_CRIT_QUADRATIC_COEFFICIENT : int = 5
@export var MAX_CRIT_BONUS_OFFSET : int = 30

## Defines our Critical Hit Damage
var click_crit_damage_upgrade : int = 0
var click_crit_damage : float = 1.0
@export var CRITICAL_BONUS_AT_LEVEL_ZERO : float = 0.25
@export var CRITICAL_BONUS_PER_LEVEL_INCREMENT : float = 0.25

func _exit_tree() -> void:
	save_data.save_to_file()
	if ManagerLogin.ref.is_online:
		save_data.save_data_to_server(ManagerHTTPRequests.ref.save_id)
