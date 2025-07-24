class_name EnemyData
extends Node

static var ref : EnemyData

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

## to_hit_threshold is base 0-1000
## to_crit_threshold is base 0-1000
## these can be upgraded by the player.
const ENEMY_DATA : Dictionary = {
	"goblin": {
		"name": "Goblin",
		"health": 12.5,
		"sprite_node": "Goblin-HD",
		"to_hit_threshold": 550,
		"to_crit_threshold": 750,
		"kill_message": "You killed a goblin!!",
		"no_loot_message": "You mangled the ears and got nothing!",
		"miss_messages": [
			"You missed!",
			"The goblin dodges!",
			"The goblin parries your blow!",
			"The goblin ducks under your swing!"
		],
		"loot_name": "Goblin Ears",
		"min_drops": 0,
		"max_drops": 2,
		"drop_manager": "ManagerLoot"
	},
	"badger": {
		"name": "Badger",
		"health": 20.0,
		"sprite_node": "Badger-HD",
		"to_hit_threshold": 700,
		"to_crit_threshold": 950,
		"kill_message": "You have defeated a badger!",
		"no_loot_message": "You marred the badger fangs!",
		"miss_messages": [
			"You missed!",
			"The badger burrows quickly, avoiding your attack!",
			"The ferocious badger snarls and sidesteps your swing!",
			"Your attack whooshes over the low-crouched badger!"
		],
		"loot_name": "Badger Claws",
		"min_drops": 0,
		"max_drops": 3,
		"drop_manager": "ManagerLoot"
	},
	"assassin": {
		"name": "Assassin",
		"health": 35.0,
		"sprite_node": "Assassin-HD",
		"to_hit_threshold": 850,
		"to_crit_threshold": 925,
		"kill_message": "You have slain an assassin!",
		"no_loot_message": "His pockets were empty!",
		"miss_messages": [
			"Your swing passes harmlessly through the air!",
			"The assassin parries your blow!",
			"The assassin leaps backward, avoiding your swing!"
		],
		"loot_name": "Gold Coins",
		"min_drops": 0,
		"max_drops": 10,
		"drop_manager": "ManagerLoot"
	},
	"air_elemental": {
		"name": "Air Elemental",
		"health": 50.0,
		"sprite_node": "Air Elemental-HD",
		"to_hit_threshold": 975,
		"to_crit_threshold": 1000,
		"kill_message": "You vanquish an air elemental!",
		"no_loot_message": "Wisps of air dissipate, nothing remains!",
		"miss_messages": [
			"You missed!",
			"The air elemental evades your attack!",
			"Your attack passes through the swirling air!",
			"The elemental disperses and reforms!"
		],
		"loot_name": "Elemental Core",
		"min_drops": 0,
		"max_drops": 1,
		"drop_manager": "ManagerLoot"
	},
	"animated_armor": {
		"name": "Animated Armor",
		"health": 90.0,
		"sprite_node": "Animated Armor-HD",
		"to_hit_threshold": 850,
		"to_crit_threshold": 975,
		"kill_message": "The animated armor falls to your feet, lifeless!",
		"no_loot_message": "The armor immediately rusts, leaving nothing!",
		"miss_messages": [
			"You missed!",
			"Your weapon clangs harmlessly off the enchanted plates!",
			"The armor shifts, deflecting your strike with a metallic screech!",
			"The empty helm turns mockingly as your attack misses its mark!"
		],
		"loot_name": "Scrap Metal",
		"min_drops": 0,
		"max_drops": 3,
		"drop_manager": "ManagerLoot"
	},
	"banshee": {
		"name": "Banshee",
		"health": 45.0,
		"sprite_node": "Banshee-HD",
		"to_hit_threshold": 1000,
		"to_crit_threshold": 1100,
		"kill_message": "You have slain a banshee!",
		"no_loot_message": "Her cackling screech chills your bones!",
		"miss_messages": [
			"You missed!",
			"Your weapon passes through the ethereal banshee!",
			"The banshee phases out of existence, avoiding your strike!",
			"The wailing spirit becomes incorporeal as you attack!"
		],
		"loot_name": "Ghostly Essence",
		"min_drops": 0,
		"max_drops": 1,
		"drop_manager": "ManagerLoot"
	},
	"succubus": {
		"name": "Succubus",
		"health": 100.0,
		"sprite_node": "Succubus-HD",
		"to_hit_threshold": 1200,
		"to_crit_threshold": 1250,
		"kill_message": "You annihilated a Succubus!",
		"no_loot_message": "Her body erupts in flames, leaving nothing!",
		"miss_messages": [
			"You missed!",
			"The succubus gracefully pirouettes away from your clumsy swing!",
			"She blows you a kiss as your weapon misses by inches!",
			"The seductive demon vanishes in a puff of smoke!"
		],
		"loot_name": "Succubus Tails",
		"min_drops": 0,
		"max_drops": 1,
		"drop_manager": "ManagerLoot"
	},
	"valkyrie": {
		"name": "Valkyrie",
		"health": 250.0,
		"sprite_node": "Valkyrie-HD",
		"to_hit_threshold": 1400,
		"to_crit_threshold": 1550,
		"kill_message": "You obliterated a Valkyrie!",
		"no_loot_message": "Her lifeless body vanishes!",
		"miss_messages": [
			"You missed!",
			"The warrior maiden's javelin intercepts your attack!",
			"She parries with her javelin in a flash of light!",
			"The valkyrie's divine armor glows, repelling your strike!"
		],
		"loot_name": "Valkyrie Feathers",
		"min_drops": 0,
		"max_drops": 2,
		"drop_manager": "ManagerLoot"
	},
	"red_dragon": {
		"name": "Red Dragon",
		"health": 800.0,
		"sprite_node": "Red Dragon-HD",
		"to_hit_threshold": 1600,
		"to_crit_threshold": 1950,
		"kill_message": "You vanquished the furious Dragon!",
		"no_loot_message": "Her lifeless body vanishes!",
		"miss_messages": [
			"You missed!",
			"The ancient dragon's scales deflect your puny weapon!",
			"The massive dragon shifts slightly, making you miss entirely!",
			"Your attack bounces off the dragon's armored hide!"
		],
		"loot_name": "Dragon Scales",
		"min_drops": 0,
		"max_drops": 3,
		"drop_manager": "ManagerLoot"
	}
}
