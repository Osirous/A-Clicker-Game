extends Label

func _ready() -> void:
	## uncommenting _update_text() here will make the label appear immediately
	## with it removed, it only shows up once the player gets a goblin ear.
	#_update_text()
	ManagerLoot.ref.goblinEars_updated.connect(_on_loot_updated)

func _update_text() -> void:
	text = "Goblin Ears : %s" %ManagerLoot.ref.get_goblinEars()

func _on_loot_updated() -> void:
	_update_text()
