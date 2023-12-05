extends KinematicBody2D

# signals
signal damagePlayer(amount, direction)
# other nodes
onready var player = get_parent().get_parent().get_node("Player")
onready var playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")

# action status and such
enum EnemyStatus {Idle, Chasing, Attacking, Attack2, Dead} # enumeration to 'assign' what the enemy is doing
var status = EnemyStatus.Idle # start by wandering, shouldn't be changed.
var direction : bool = false # true = right, false = left. So it starts on the left.
var knockBackDirection : Vector2

#movement vars
var vel: Vector2 = Vector2()
var speed: int = 10
var chaseSpeed: int = 20
var gravity: int = 1000

#attack vars
var attack_damage : int = 1
var attack2_damage : int = 1
var attack_delay : float = 1 # time btwn attcks, will probbly change that lter.
var attackCooldownTimer: Timer

#stats and effects vars
var health : int = 3
var detectRange : int = 100
var attackRange : int = 30
var stopchaseRange : int = 250
var knockbackMultiplier : int = 1
var heldscore : int = 1 # score given to the player once this enemy is killed, goes up if the enemy kills the player and resets on death. ()or atleast that's the objective
var is_dead : bool = false # for later?
var is_onfire : bool = false # for later
var is_frozen : bool = false # for later

func _ready():
	# Initialize the attack cooldown timer
	attackCooldownTimer = Timer.new()
	attackCooldownTimer.one_shot = true
# warning-ignore:return_value_discarded
	attackCooldownTimer.connect("timeout", self, "_on_attack_cooldown_timeout")
	add_child(attackCooldownTimer)

# enter/exit zones
func _on_detectionZone_enter(body):
	if body==playerScript:
		direction = global_position.x<playerScript.global_position.x # with this logic: true = right, false = left.
		status = EnemyStatus.Chasing
func _on_detectionZone_exit(body):
	if body==playerScript:
		status = EnemyStatus.Idle

func attack():
	direction = global_position.x<playerScript.global_position.x
	vel.x = 0
	if attackCooldownTimer.time_left <= 0:
		var hit1 = preload("res://assets//baseplatescenes//wanderer_attack1.tscn").instance()
		match direction:
			false:
				hit1.position = Vector2(-50,0)  # Adjust the position as needed
				hit1.scale.x *= -1 #flip sprite
			true:
				hit1.position = Vector2(50,0)  # Adjust the position as needed
			_:
				return
		add_child(hit1)
		var timer = Timer.new() # used to remove the attack hitboxes after a lil' time.
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.connect("timeout", self, "_on_hit1_timeout", [hit1])
		add_child(timer)
		timer.start()
		hit1.get_node("Area2D").connect("body_entered", self, "_on_hit1_enter")
		
		attackCooldownTimer.start(attack_delay)

func attack2(): # this one is for when the player goes away from the attack zone, could have some combo potential for the enemy. It's nice I guess.
	direction = global_position.x<playerScript.global_position.x

	match direction:
		false: # attack on the left
			pass
		true: # attack on the right
			pass

func _on_hit1_enter(body):
	if body == playerScript and playerScript.health>=1:
		emit_signal("damagePlayer", 1, direction)

func chase(direction):
	vel.x = 0
	match direction:
		false:
			vel.x-=chaseSpeed
		true:
			vel.x+=chaseSpeed
		_:
			return
	vel = move_and_slide(vel, Vector2.UP)

func idle():
	pass

func dead():
	set_physics_process(false)

func knockback(multiplier,direction):
	match direction:
		false:
			knockBackDirection=Vector2(-10*multiplier,0)
		true:
			knockBackDirection=Vector2(10*multiplier,0)
		_:
			return
	position+=knockBackDirection

# called every frame
func _physics_process(delta):
	if health<=0:
		is_dead=true
		dead()
	# Gravity
	vel.y += gravity * delta
	if global_position.distance_to(playerScript.global_position)>=stopchaseRange:
		status = EnemyStatus.Idle
	if global_position.distance_to(playerScript.global_position)<=detectRange:
		direction = global_position.x<playerScript.global_position.x
		status = EnemyStatus.Chasing
	if global_position.distance_to(playerScript.global_position)<=attackRange:
		attack() # that or " status = EnemyStatus.Attacking ", which is best?
	match status:
		EnemyStatus.Idle:
			idle()
		EnemyStatus.Attacking:
			attack()
		EnemyStatus.Attack2: # for now, unused.
			attack2()
		EnemyStatus.Chasing:
			chase(direction)
		EnemyStatus.Dead:
			dead()

func _on_hit1_timeout(hit1):
	hit1.queue_free()

func _on_attack_cooldown_timeout():
	status = EnemyStatus.Idle
