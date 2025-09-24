class_name Upgrade03AttackCriticalDamage
extends ManagerUpgrades
## Upgrade 01 - Increases stardust created by the clicker.

## Load data.
func _init() -> void:
	level = PlayerData.ref.save_data.click_crit_damage_upgrade
	title = "Attack Critical Damage Upgrade"
	base_cost = 250
	cost_type = "Gold Coins"
	calculate_cost()


func description() -> String:
	var _description : String = "Increases the damage of your critical hits.\n"
	_description += "Effects: +1 Critical Damage / Level\n"
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
		PlayerData.ref.save_data.click_crit_damage_upgrade += 1
		level = PlayerData.ref.save_data.click_crit_damage_upgrade
		
		calculate_cost()
		
		leveled_up.emit()
