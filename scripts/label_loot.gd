extends Label

var current_enemy_data : Dictionary = EnemyData.ENEMY_DATA[PlayerData.save_data.current_enemy_key]
var loot_name : String = current_enemy_data.loot_name

func _ready() -> void:

	ManagerLoot.ref.loot_updated.connect(_on_loot_updated)
	PlayerData.enemy_changed.connect(_on_enemy_changed)
	StartButton.ref.game_start.connect(_update_text)

func _update_text() -> void:
	var new_text_lines : PackedStringArray
	
	for loot_name_to_display: String in ManagerLoot.ref.ALL_LOOT_TYPES_IN_DISPLAY_ORDER:
		var quantity : int = ManagerLoot.ref.loot.get(loot_name_to_display, 0)
		if quantity > 0:
			new_text_lines.append("%s : %s" % [loot_name_to_display, quantity])

	text = "\n".join(new_text_lines)

func _on_loot_updated() -> void:
	_update_text()

func _on_enemy_changed(_new_enemy_key: String) -> void:
	current_enemy_data = EnemyData.ENEMY_DATA[PlayerData.save_data.current_enemy_key]
	loot_name = current_enemy_data.loot_name
	_update_text()
