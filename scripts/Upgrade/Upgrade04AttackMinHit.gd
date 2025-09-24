class_name Upgrade04AttackMinHit
extends ManagerUpgrades
## Upgrade 04 - Increases click minimum chance to hit

## Load data.
func _init() -> void:
	level = PlayerData.ref.save_data.min_chance_to_hit_upgrade
	title = "Minimum Hit Upgrade"
	base_cost = 1050
	cost_type = "Elemental Core"
	calculate_cost()


func description() -> String:
	var _description : String = "Increases your minimum chance to hit.\n"
	_description += "Effects: +1 Minimum Hit Chance / Level\n"
	_description += "Cost: %s" %current_cost + " %s" %cost_type
	return _description

func calculate_cost() -> void:
	current_cost = int(base_cost * pow(1.25, level))

func can_afford() -> bool:
	var can_afford_result = ManagerLoot.ref.can_spend(cost_type, current_cost)
	return can_afford_result

func level_up() -> void:
	var error : Error = ManagerLoot.ref.spend_loot(cost_type, current_cost)

	if not error:
		PlayerData.ref.save_data.min_chance_to_hit_upgrade += 1
		level = PlayerData.ref.save_data.min_chance_to_hit_upgrade
		
		calculate_cost()
		
		leveled_up.emit()
