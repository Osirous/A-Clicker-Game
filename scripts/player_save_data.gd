class_name PlayerSaveData
extends Resource

var PATH : String = ""

var save_id : String

var enemy_kill_counts : Dictionary
var current_enemy_key : String = "goblin"
var click_damage_upgrade : int = 0
var click_damage : float = 1.0
var click_accuracy_upgrade : int = 0
var click_accuracy : int = 0
var min_chance_to_hit_upgrade : int = 0
var min_chance_to_hit : int = 0
var max_chance_to_hit_upgrade : int = 0
var max_chance_to_hit : int = 1000
var min_critical_hit_chance_upgrade : int = 0
var min_critical_hit_chance : int = 0
var max_critical_hit_chance_upgrade : int = 0
var max_critical_hit_chance : int = 1000
var click_crit_damage_upgrade : int = 0
var click_crit_damage : float = 1.0
var loot : Dictionary = {}

func set_save_path(user_id: String) -> void:
	PATH = "user://save_%s.res" %user_id

func to_dict() -> Dictionary:
	return {
		"enemy_kill_counts": enemy_kill_counts,
		"current_enemy_key": current_enemy_key,
		"click_damage_upgrade": click_damage_upgrade,
		"click_damage": click_damage,
		"click_accuracy_upgrade": click_accuracy_upgrade,
		"click_accuracy": click_accuracy,
		"min_chance_to_hit_upgrade": min_chance_to_hit_upgrade,
		"min_chance_to_hit": min_chance_to_hit,
		"max_chance_to_hit_upgrade": max_chance_to_hit_upgrade,
		"max_chance_to_hit": max_chance_to_hit,
		"min_critical_hit_chance_upgrade": min_critical_hit_chance_upgrade,
		"min_critical_hit_chance": min_critical_hit_chance,
		"max_critical_hit_chance_upgrade": max_critical_hit_chance_upgrade,
		"max_critical_hit_chance": max_critical_hit_chance,
		"click_crit_damage_upgrade": click_crit_damage_upgrade,
		"click_crit_damage": click_crit_damage,
		"loot": loot,
	}

func load_save_data(save: Dictionary) -> void:
	enemy_kill_counts = save.get("enemy_kill_counts", {})
	current_enemy_key = save.get("current_enemy_key", current_enemy_key)
	click_damage_upgrade = save.get("click_damage_upgrade", 0)
	click_damage = save.get("click_damage", 1.0)
	click_accuracy_upgrade = save.get("click_accuracy_upgrade", 0)
	click_accuracy = save.get("click_accuracy", 0)
	min_chance_to_hit_upgrade = save.get("min_chance_to_hit_upgrade", 0)
	min_chance_to_hit = save.get("min_chance_to_hit", 0)
	max_chance_to_hit_upgrade = save.get("max_chance_to_hit_upgrade", 0)
	max_chance_to_hit = save.get("max_chance_to_hit", 1000)
	min_critical_hit_chance_upgrade = save.get("min_critical_hit_chance_upgrade", 0)
	min_critical_hit_chance = save.get("min_critical_hit_chance", 0)
	max_critical_hit_chance_upgrade = save.get("max_critical_hit_chance_upgrade", 0)
	max_critical_hit_chance = save.get("max_critical_hit_chance", 1000)
	click_crit_damage_upgrade = save.get("click_crit_damage_upgrade", 0)
	click_crit_damage = save.get("click_crit_damage", 1.0)
	loot = save.get("loot", {})
	ManagerLoot.ref.loot = loot

func save_to_file() -> void:
	var save_dict : Dictionary = to_dict()
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	if file == null:
		print("Failed to open file for writing in save to file func")
		return
	file.store_string(JSON.stringify(save_dict))
	file.close()

func load_from_file() -> void:
	if not FileAccess.file_exists(PATH):
		return
	var file = FileAccess.open(PATH, FileAccess.READ)
	var save_dict = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(save_dict) == TYPE_DICTIONARY:
		load_save_data(save_dict)

func save_data_to_server(save_id: String) -> void:
	if !ManagerLogin.ref.is_online or ManagerHTTPRequests.ref.jwt_token == "":
		# print("Offline mode: skipping server upload, saving only locally.")
		return
	loot = ManagerLoot.ref.loot
	var save_dict = to_dict()
	
	var json_string = JSON.stringify(save_dict)
	var payload = {"savedata": json_string}
	var json = JSON.stringify(payload)

	ManagerHTTPRequests.ref.upload_save(json, save_id)

func load_data_from_server(save_id: String) -> void:
	ManagerHTTPRequests.ref.fetch_save(save_id)
