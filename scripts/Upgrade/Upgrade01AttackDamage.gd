class_name Upgrade01AttackDamage
extends ManagerUpgrades
## Upgrade 01 - Increases stardust created by the clicker.

## Load data.
func _init() -> void:
	level = PlayerData.ref.save_data.click_damage_upgrade
	title = "Attack Damage Upgrade"
	base_cost = 15
	cost_type = "Goblin Ears"
	calculate_cost()


func description() -> String:
	var _description : String = "Increases amount of damage done when attacking.\n"
	_description += "Effects: +1 Damage / Level\n"
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
		PlayerData.ref.save_data.click_damage_upgrade += 1
		level = PlayerData.ref.save_data.click_damage_upgrade
		
		calculate_cost()
		
		leveled_up.emit()
