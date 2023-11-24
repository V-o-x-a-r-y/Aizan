extends KinematicBody2D

# 'team' identifier for player hits; player can hit 'hostile' and 'neutral', but not 'friendly'. There's probably a better way to do this but I can't think rn so that's all we get.
var team = "hostile"

# other nodes
onready var detectionZone = get_parent().get_node("detectZone")
onready var attackZone = get_node("attackZone")
onready var player = get_parent().get_parent().get_node("Player")
onready var playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")

# action status and such
enum EnemyStatus {Wandering, Chasing, Attacking, Attack2} # enumeration to 'assign' what the enemy is doing
var status = EnemyStatus.Wandering # start by wandering, shouldn't be changed.
var direction : bool = false # true = right, false = left. So it starts on the left.

#movement vars
var vel: Vector2 = Vector2()
var speed: int = 10
var chaseSpeed: int = 20
var gravity: int = 1000

#attack vars
var attack_damage : int = 1
var attack2_damage : int = 1
var attack_delay : float = 0.5 # time btwn attcks, will probbly change that lter.
var attackCooldownTimer: Timer

#stats and effects vars
var hp : int = 3
var heldscore : int = 1 # score given to the player once this enemy is killed, goes up if the enemy kills the player and resets on death. ()or atleast that's the objective
var is_dead : bool = false # for later?
var is_onfire : bool = false # for later
var is_frozen : bool = false # for later

func _ready():
	# connect signals to detect entry/exit
	detectionZone.connect("body_entered", self, "_on_detectionZone_enter")
	detectionZone.connect("body_exited", self, "_on_detectionZone_exit")
	attackZone.connect("body_entered", self, "_on_attackZone_enter")
	attackZone.connect("body_exited", self, "_on_attackZone_exit")
	
	# Initialize the attack cooldown timer
	attackCooldownTimer = Timer.new()
	attackCooldownTimer.one_shot = true
	attackCooldownTimer.connect("timeout", self, "_on_attack_cooldown_timeout")
	add_child(attackCooldownTimer)

# enter/exit zones
func _on_detectionZone_enter(body):
	if body==playerScript:
		direction = global_position.x<playerScript.global_position.x # with this logic: true = right, false = left.
		status = EnemyStatus.Chasing
func _on_detectionZone_exit(body):
	if body==playerScript:
		status = EnemyStatus.Wandering
func _on_attackZone_enter(body):
	if body == playerScript and attackCooldownTimer.time_left <= 0:
		status = EnemyStatus.Attacking
func _on_attackZone_exit(body):
	if body == playerScript:
		status = EnemyStatus.Attack2

func attack():
# warning-ignore:shadowed_variable
	var direction = global_position.x<playerScript.global_position.x
	vel.x = 0
	if attackCooldownTimer.time_left <= 0:
		match direction:
			false: # attack on the left
				call_deferred("_attack_left")
			true: # attack on the right
				call_deferred("_attack_right")
		attackCooldownTimer.start(attack_delay)

func attack2(): # this one is for when the player goes away for the attack zone, could have some combo potential for the enemy. It's nice I guess.
# warning-ignore:shadowed_variable
	var direction = global_position.x<playerScript.global_position.x

	match direction:
		false: # attack on the left
			pass
		true: # attack on the right
			pass

# should problalby change those two and make them a single one, but I'm too lazy rn.
func _attack_left():
	var hit1 = preload("res://assets//baseplatescenes//wanderer_attack1.tscn").instance()
	hit1.position = Vector2(-50,0)  # Adjust the position as needed
	hit1.scale.x *= -1 #flip sprite
	add_child(hit1)
	var timer = Timer.new() # used to remove the attack hitboxes after a lil' time.
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.connect("timeout", self, "_on_hit1_timeout", [hit1])
	add_child(timer)
	timer.start()
	if playerScript.health >= 1: # that's not finished, same down in _attack_right
		playerScript.health -= 1
		print('player HP: ',playerScript.health)
		print(get_node("wanderer_attack1/Area2D").get_overlapping_bodies())

func _attack_right():
	var hit1 = preload("res://assets//baseplatescenes//wanderer_attack1.tscn").instance()
	hit1.position = Vector2(50,0)  # Adjust the position as needed
	add_child(hit1)
	var timer = Timer.new() # used to remove the attack hitboxes after a lil' time.
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.connect("timeout", self, "_on_hit1_timeout", [hit1])
	add_child(timer)
	timer.start()
	if playerScript.health >= 1: # that's not finished, same down in _attack_right
		playerScript.health -= 1
		print('player HP: ',playerScript.health)
		print(get_node("wanderer_attack1/Area2D").get_overlapping_bodies())
	

# warning-ignore:shadowed_variable
func chase(direction):
	vel.x = 0
	match direction:
		false:
			vel.x-=chaseSpeed
		true:
			vel.x+=chaseSpeed
		_:
			pass
	vel = move_and_slide(vel, Vector2.UP)
func wander():
	pass

# called every frame
func _physics_process(delta):
	# Gravity
	vel.y += gravity * delta
	
	if detectionZone.get_overlapping_bodies().find(playerScript) >= 1 and not attackZone.get_overlapping_bodies().find(playerScript) >= 1:
		status = EnemyStatus.Chasing
	
	match status:
		EnemyStatus.Wandering:
			wander()
		EnemyStatus.Attacking:
			attack()
		EnemyStatus.Attack2:
			attack2()
		EnemyStatus.Chasing:
			chase(direction)

func _on_hit1_timeout(hit1):
	hit1.queue_free()

func _on_attack_cooldown_timeout():
	status = EnemyStatus.Wandering
