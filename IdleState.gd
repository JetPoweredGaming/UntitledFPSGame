class_name IdleEnemyState

extends EnemyState

@export var SPEED: float = 4
@export var aggro_range := 15.0
@export var attack_range := 2.0
@export var max_HP := 3
@export var attack_damage := 1

@export var animation_player: AnimationPlayer
@export var hurt_sound: AudioStreamPlayer3D 

var HP : int = max_HP:
	set(value):
		if value < HP:
			animation_player.pause()
			animation_player.play("Hurt")
			hurt_sound.play()
		HP = value
		if HP <= 0:
			Global.player.SCORE += 50
			animation_player.play("Death")
			if !animation_player.is_playing():
				queue_free()

func enter() -> void:
	ANIMATION.play("Idle")

func update(delta):
	if !ANIMATION.is_playing():
		ANIMATION.play("Idle")
		
	if ENEMY.provoked == true:
		transition.emit("PursuitEnemyState")
	
	if ENEMY.attacking == true:
		transition.emit("AttackingEnemyState")
		
	
