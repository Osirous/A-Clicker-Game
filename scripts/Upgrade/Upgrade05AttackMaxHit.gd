class_name Upgrade05AttackMaxHit
extends ManagerUpgrades
## Upgrade 05 - Increases click maximum chance to hit

## Load data.
func _init() -> void:
	level = PlayerData.ref.save_data.max_chance_to_hit_upgrade
	title = "Maximum Hit Upgrade"
	base_cost = 1500
	cost_type = "Scrap Metal"
	calculate_cost()


func description() -> String:
	var _description : String = "Increases your maximum chance to hit.\n"
	_description += "Effects: +1 Maximum Hit Chance / Level\n"
	_description += "Cost: %s" %current_cost + " %s" %cost_type
	return _description

func calculate_cost() -> void:
	current_cost = int(base_cost * pow(1.2, level))

func can_afford() -> bool:
	var can_afford_result = ManagerLoot.ref.can_spend(cost_type, current_cost)
	return can_afford_result

func level_up() -> void:
	var error : Error = ManagerLoot.ref.spend_loot(cost_type, current_cost)

	if not error:
		PlayerData.ref.save_data.max_chance_to_hit_upgrade += 1
		level = PlayerData.ref.save_data.max_chance_to_hit_upgrade
		
		calculate_cost()
		
		leveled_up.emit()
