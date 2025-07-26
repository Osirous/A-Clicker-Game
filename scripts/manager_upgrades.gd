extends Node

static var ref : ManagerUpgrades

func _init() -> void:
	if not ref : ref = self
	else : queue_free()


signal leveled_up

var level : int = -1

var title : String = "Undefined"

var base_cost : int = -1

var current_cost : int = -1

## Virtual Class, must be overwritten.[br]
## Returns the description of the upgrade.
func description() -> String:
	return "Description not defined."

## Virtual Class, must be overwritten.[br]
## Calculate the cost of the upgrade.
func calculate_cost() -> void:
	printerr("calculate_cost() method not defined.")

func can_afford() -> bool:
	return false

func level_up() -> void:
	printerr("level_up() method not defined.")

func calculate_linear_upgrade(base_linear_value: float, linear_upgrade_level: int, initial_linear_bonus: float, linear_per_level_bonus: float) -> float:
	var new_linear_base : float = 0.0 # Initialize base to 0.0
	## Calculate the total upgrade bonus using the new formula form
	var total_linear_upgrade_bonus : float = initial_linear_bonus + linear_upgrade_level * linear_per_level_bonus
	## Add the total upgrade bonus to the base upgrade
	new_linear_base = base_linear_value + total_linear_upgrade_bonus
	return new_linear_base

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
