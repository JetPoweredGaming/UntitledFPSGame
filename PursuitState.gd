class_name PursuitEnemyState

extends EnemyState

@export var SPEED: float = 5.25

func enter() -> void:
	ANIMATION.play("Pursuit")
	ENEMY.SPEED = 5.25

func update(delta):
		
	if ENEMY.velocity.length() < 0.0 or ENEMY.provoked == false:
		transition.emit("IdleEnemyState")
	
	if ENEMY.attacking == true:
		transition.emit("AttackingEnemyState")
