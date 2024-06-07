class_name  AttackingEnemyState

extends EnemyState

@export var SPEED: float = 0.5

@export var animation_player: AnimationPlayer


func enter() -> void:
	ANIMATION.play("Attack")
	ENEMY.attack_cooldown.start()

func update(delta: float) -> void:
	if !ANIMATION.is_playing() && ENEMY.attack_cooldown.is_stopped():
		ANIMATION.play("Attack")
		ENEMY.attack_cooldown.start()

	
	
