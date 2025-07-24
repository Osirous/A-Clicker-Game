extends Label

const UNLOCK_KILLS_NEEDED : Array = [1, 10, 25, 100]

var current_enemy_data : Dictionary

func _ready() -> void:
	current_enemy_data = EnemyData.ENEMY_DATA[PlayerData.current_enemy_key]
	AttackScript.ref.health_updated.connect(_on_health_updated)
	AttackScript.ref.enemy_died.connect(_on_enemy_died)
	PlayerData.enemy_changed.connect(_on_enemy_changed)

func _on_enemy_changed(new_enemy_key: String) -> void:
	# Update the enemy data
	current_enemy_data = EnemyData.ENEMY_DATA[PlayerData.current_enemy_key]
	# Refresh the display
	_update_text()

func _update_text() -> void:
	var analysis : Dictionary = get_revealed_stats(current_enemy_data.name)
	var stats : Dictionary = calculate_enemy_stats(current_enemy_data.to_hit_threshold) # Display: "Animated Armor: 10% avoidance, 65% hit chance"
	text = "Enemy: %s" % current_enemy_data.name + "\nHealth: %s" % AttackScript.ref.health
	if analysis.level >= 1:
		text += "\nKill Count: %d" % analysis.kills
	if analysis.level >= 2:
		text += "\nHit chance: %d%%" % stats.hit_chance
	if analysis.level >= 3:
		text += "\nAvoidance: %d%%" % stats.avoidance

func _on_enemy_died(_enemy_name: String) -> void:
	# Update display after kill count changes
	_update_text()

func _on_health_updated(_new_health: float) -> void :
	_update_text()

func calculate_enemy_stats(enemy_threshold: int, base_threshold: int = 750) -> Dictionary:
	# Avoidance is straightforward - just enemy vs base
	var avoidance_difference : int = enemy_threshold - base_threshold
	var avoidance_percent : int = (avoidance_difference / 1000.0) * 100
	
	# Hit chance factors in player's current upgrades
	var player_accuracy : int = ManagerClicks.ref.click_accuracy()  # Player's accuracy bonus
	var effective_threshold : int = enemy_threshold - player_accuracy
	var hit_chance : int = ((1000 - effective_threshold) / 1000.0) * 100
	
	return {
		"avoidance": int(avoidance_percent),
		"hit_chance": int(hit_chance)
	}

func get_revealed_stats(_enemy_name: String) -> Dictionary:
	var kills : int = PlayerData.enemy_kill_counts.get(PlayerData.current_enemy_key, 0)
	var analysis_level : int = 0
	
	if kills >= UNLOCK_KILLS_NEEDED[0]:  # Level 1
		analysis_level = 1
	if kills >= UNLOCK_KILLS_NEEDED[1]:  # Level 2
		analysis_level = 2
	if kills >= UNLOCK_KILLS_NEEDED[2]:  # Level 3
		analysis_level = 3

	return {"level": analysis_level, "kills": kills}
