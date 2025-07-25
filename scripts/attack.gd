class_name AttackScript
extends Button

static var ref : AttackScript

func _init() -> void:
	if not ref : ref = self
	else : queue_free()

@onready var floating_damage_origin : Node2D = $"../FloatingDamageOrigin"
@onready var floating_text_origin : Node2D = $"../FloatingTextOrigin"
@onready var floating_reward_origin : Node2D = $"../FloatingRewardOrigin"
@onready var floating_kill_origin : Node2D = $"../FloatingKillOrigin"

var current_enemy_data : Dictionary
var enemy_sprite_node : Node2D
var health : float
var to_hit_threshold : int
var to_crit_threshold : int
var min_drops : int
var max_drops : int
var kill_message : String
var no_loot_message : String
# Initialize to true so we can attack right away!
var can_click : bool = true

signal health_updated(new_health: float)
signal enemy_died(enemy_name: String)

func _ready() -> void:
	pressed.connect(_on_pressed)

	PlayerData.enemy_changed.connect(_on_enemy_changed)
	StartButton.ref.game_start.connect(setup_current_enemy)
	
	setup_current_enemy()
	enemy_sprite_node.visible = false

func _on_enemy_changed(_new_enemy_key: String) -> void:
	setup_current_enemy()
	
	# Force emit the health signal so labels update immediately
	health_updated.emit(health)

func setup_current_enemy() -> void:
	# Hide the current enemy sprite first (if it exists)
	if enemy_sprite_node:
		enemy_sprite_node.visible = false
# Get the current enemies data and set up vars
	current_enemy_data = EnemyData.ENEMY_DATA[PlayerData.save_data.current_enemy_key]

# Hide all enemy sprites first, then show the current one
	enemy_sprite_node = get_node("../" + current_enemy_data.sprite_node)
	enemy_sprite_node.visible = true

# Get the rest of the enemy data setup vars.
	health = current_enemy_data.health
	health_updated.emit(health)
	to_hit_threshold = current_enemy_data.to_hit_threshold
	to_crit_threshold = current_enemy_data.to_hit_threshold
	min_drops = current_enemy_data.min_drops
	max_drops = current_enemy_data.max_drops
	kill_message = current_enemy_data.kill_message
	no_loot_message = current_enemy_data.no_loot_message

func _on_pressed() -> void: 
	var attack_timer : Timer = $AttackTimer

	if can_click:
		can_click = false
		attack_timer.start()
		_on_hit()

func _on_attack_timer_timeout() -> void:
	can_click = true

func _on_hit() -> void:
	if randi_range(ManagerClicks.ref.click_min_hit_chance(), ManagerClicks.ref.click_max_hit_chance()) > (to_hit_threshold - ManagerClicks.ref.click_accuracy()): return on_damage()
	else: return on_miss()

func on_miss() -> void:
	var miss_messages : Array = current_enemy_data.miss_messages
	var random_message : String = miss_messages[randi() % miss_messages.size()]
	FloatingDamageText.display_text(random_message, floating_text_origin.global_position)

func on_damage() -> void:
	var damage : float = ManagerClicks.ref.click_damage()
	var is_critical : bool = randi_range(ManagerClicks.ref.click_min_critical_chance(), ManagerClicks.ref.click_max_critical_chance()) > (to_crit_threshold - ManagerClicks.ref.click_accuracy())
	if is_critical:
		damage *= ManagerClicks.ref.click_critical_damage()
	health -= damage
	# send enemy health to label_enemy_stats.gd
	health_updated.emit(health)
	
	FloatingDamageNumbers.display_number(damage, floating_damage_origin.global_position, is_critical)
	if health <= 0:
		on_death()

func on_death() -> void:
	health = current_enemy_data.health
	## send new enemy health to label_enemy_stats.gd
	health_updated.emit(health)
	
	PlayerData.increment_enemy_kills(PlayerData.save_data.current_enemy_key)
	
	## send enemy death to label_enemy_stats.gd
	enemy_died.emit(current_enemy_data.name)
	FloatingDamageText.display_text("%s" %kill_message, floating_kill_origin.global_position)
	
	if ManagerLoot.ref.on_successful_loot():
		var drops : int = randi_range(min_drops, max_drops)
		ManagerLoot.ref.create_loot(current_enemy_data.loot_name, drops)
		if drops == 0:
			FloatingDamageText.display_text("%s" %no_loot_message, floating_reward_origin.global_position)
	else:
		FloatingDamageText.display_text("%s" %no_loot_message, floating_reward_origin.global_position)
