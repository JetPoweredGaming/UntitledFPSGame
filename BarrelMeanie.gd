extends CharacterBody3D
class_name Enemy



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var death_knell: AudioStreamPlayer3D = $DeathKnell
@onready var hurt_sound: AudioStreamPlayer3D = $HurtSound

@export var SPEED: float = 5.0
@export var aggro_range := 15.0
@export var attack_range := 2.0
@export var max_HP := 3
@export var attack_damage := 1

var player 
var provoked := false
var attacking := false

var HP : int = max_HP:
	set(value):
		if value < HP:
			animation_player.pause()
			animation_player.play("Hurt")
			hurt_sound.play()
			provoked = true
		HP = value
		if HP <= 0:
			player.SCORE += 50
			animation_player.play("Death")
			SPEED = 0
			if !animation_player.is_playing():
				queue_free()
			

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if provoked == true:
		if direction:
			look_at_target(direction)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if distance <= attack_range:
		attacking = true
		
	if distance > attack_range:
		attacking = false
		
	move_and_slide()
	
func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)

func hit():
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		player.HP -= attack_damage
