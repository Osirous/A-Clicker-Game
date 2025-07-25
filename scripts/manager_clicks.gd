extends Node

static var ref : ManagerClicks

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

## This function probably needs to be moved into an upgrade script
func calculate_linear_upgrade(base_linear_value: float, linear_upgrade_level: int, initial_linear_bonus: float, linear_per_level_bonus: float) -> float:
	var new_linear_base : float = 0.0 # Initialize base to 0.0
	## Calculate the total upgrade bonus using the new formula form
	var total_linear_upgrade_bonus : float = initial_linear_bonus + linear_upgrade_level * linear_per_level_bonus
	## Add the total upgrade bonus to the base upgrade
	new_linear_base = base_linear_value + total_linear_upgrade_bonus
	return new_linear_base

func click_critical_damage() -> float:
	return calculate_linear_upgrade(PlayerData.save_data.click_crit_damage, PlayerData.save_data.click_crit_damage_upgrade, PlayerData.CRITICAL_BONUS_AT_LEVEL_ZERO, PlayerData.CRITICAL_BONUS_PER_LEVEL_INCREMENT)

func click_damage() -> float:
	return calculate_linear_upgrade(PlayerData.save_data.click_damage, PlayerData.save_data.click_damage_upgrade, PlayerData.DAMAGE_BONUS_AT_LEVEL_ZERO, PlayerData.DAMAGE_BONUS_PER_LEVEL_INCREMENT)

## This function probably needs to be moved into an upgrade script
func calculate_quadratic_upgrade(base_quadratic_value: int, quadratic_upgrade_level: int, quadratic_coefficient: int, bonus_offset: int) -> int:
	var total_quadratic_upgrade_bonus : float = 0.0 # Initialize bonus to 0.0
	if quadratic_upgrade_level == 0: 
		total_quadratic_upgrade_bonus = 0 # Explicitly set bonus to 0 for level 0
	else:
		# Calculate the total upgrade bonus using the quadratic formula
		total_quadratic_upgrade_bonus = quadratic_coefficient * pow(quadratic_upgrade_level, 2) + bonus_offset
	# Add the total upgrade bonus to the base upgrade
	var new_quadratic_value : float = base_quadratic_value + total_quadratic_upgrade_bonus
	return int(new_quadratic_value)

func click_accuracy() -> int:
	return calculate_quadratic_upgrade(PlayerData.save_data.click_accuracy, PlayerData.save_data.click_accuracy_upgrade, PlayerData.ACCURACY_QUADRATIC_COEFFICIENT, PlayerData.ACCURACY_BONUS_OFFSET)

func click_min_hit_chance() -> int:
	return calculate_quadratic_upgrade(PlayerData.save_data.min_chance_to_hit, PlayerData.save_data.min_chance_to_hit_upgrade, PlayerData.MIN_HIT_QUADRATIC_COEFFICIENT, PlayerData.MIN_HIT_BONUS_OFFSET)

func click_max_hit_chance() -> int:
	return calculate_quadratic_upgrade(PlayerData.save_data.max_chance_to_hit, PlayerData.save_data.max_chance_to_hit_upgrade, PlayerData.MAX_HIT_QUADRATIC_COEFFICIENT, PlayerData.MAX_HIT_BONUS_OFFSET)

func click_min_critical_chance() -> int:
	return calculate_quadratic_upgrade(PlayerData.save_data.min_critical_hit_chance, PlayerData.save_data.min_critical_hit_chance_upgrade, PlayerData.MIN_CRIT_QUADRATIC_COEFFICIENT, PlayerData.MIN_CRIT_BONUS_OFFSET)

func click_max_critical_chance() -> int:
	return calculate_quadratic_upgrade(PlayerData.save_data.max_critical_hit_chance, PlayerData.save_data.max_critical_hit_chance_upgrade, PlayerData.MAX_CRIT_QUADRATIC_COEFFICIENT, PlayerData.MAX_CRIT_BONUS_OFFSET)
