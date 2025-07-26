extends Node

static var ref : ManagerClicks

func _init() -> void:
	if not ref : ref = self
	else : queue_free()


func click_critical_damage() -> float:
	return ManagerUpgrades.ref.calculate_linear_upgrade(PlayerData.save_data.click_crit_damage, PlayerData.save_data.click_crit_damage_upgrade, PlayerData.CRITICAL_BONUS_AT_LEVEL_ZERO, PlayerData.CRITICAL_BONUS_PER_LEVEL_INCREMENT)

func click_damage() -> float:
	return ManagerUpgrades.ref.calculate_linear_upgrade(PlayerData.save_data.click_damage, PlayerData.save_data.click_damage_upgrade, PlayerData.DAMAGE_BONUS_AT_LEVEL_ZERO, PlayerData.DAMAGE_BONUS_PER_LEVEL_INCREMENT)

func click_accuracy() -> int:
	return ManagerUpgrades.ref.calculate_quadratic_upgrade(PlayerData.save_data.click_accuracy, PlayerData.save_data.click_accuracy_upgrade, PlayerData.ACCURACY_QUADRATIC_COEFFICIENT, PlayerData.ACCURACY_BONUS_OFFSET)

func click_min_hit_chance() -> int:
	return ManagerUpgrades.ref.calculate_quadratic_upgrade(PlayerData.save_data.min_chance_to_hit, PlayerData.save_data.min_chance_to_hit_upgrade, PlayerData.MIN_HIT_QUADRATIC_COEFFICIENT, PlayerData.MIN_HIT_BONUS_OFFSET)

func click_max_hit_chance() -> int:
	return ManagerUpgrades.ref.calculate_quadratic_upgrade(PlayerData.save_data.max_chance_to_hit, PlayerData.save_data.max_chance_to_hit_upgrade, PlayerData.MAX_HIT_QUADRATIC_COEFFICIENT, PlayerData.MAX_HIT_BONUS_OFFSET)

func click_min_critical_chance() -> int:
	return ManagerUpgrades.ref.calculate_quadratic_upgrade(PlayerData.save_data.min_critical_hit_chance, PlayerData.save_data.min_critical_hit_chance_upgrade, PlayerData.MIN_CRIT_QUADRATIC_COEFFICIENT, PlayerData.MIN_CRIT_BONUS_OFFSET)

func click_max_critical_chance() -> int:
	return ManagerUpgrades.ref.calculate_quadratic_upgrade(PlayerData.save_data.max_critical_hit_chance, PlayerData.save_data.max_critical_hit_chance_upgrade, PlayerData.MAX_CRIT_QUADRATIC_COEFFICIENT, PlayerData.MAX_CRIT_BONUS_OFFSET)
