extends KinematicBody2D

#signals    please know that I'm really bad at using signals, as I've never done it before.
signal health_changed(amount)
signal score_changed(amount)
signal effect_changed(effect,amount)
# inventory
var inventory : Array = []
# stats
var health : int = 10
var score: int = 0
var attackCooldown : int = 0.1
var attackDamage : int = 1
var knockbackMultiplier : int = 1
var poisonResistance : int = 0
# those are for 'Movement'
var speed : int = 100
var jumpForce : int = 400
var gravity : int = 1000
var runSpeed : int = 150
var vel : Vector2 = Vector2()

# those are for 'attack'
var playerDirection : bool = 0
var attackCooldownTimer

# those three are for 'camera_down'
onready var camera = get_node("Camera2D")
onready var cameraInitPos = camera.position
onready var lowCameraPos = cameraInitPos.y + 200

# for effects
var poisontimer
var poisonremovetimer
var playerEffectList : Array = []
var poisonbarvalue: int = 0
var is_poisonclimbing: bool = false

func _ready():
	# Initialize the attack cooldown timer
	attackCooldownTimer = Timer.new()
	attackCooldownTimer.one_shot = true
	poisontimer = Timer.new()
	poisontimer.one_shot = true
	add_child(poisontimer)
	poisonremovetimer = Timer.new()
	poisontimer.one_shot = true
	add_child(poisonremovetimer)
# warning-ignore:return_value_discarded
	attackCooldownTimer.connect("timeout", self, "_on_attack_cooldown_timeout")
	add_child(attackCooldownTimer)
	
	#get all items in the scene 
	for i in get_parent().get_parent().itemList:
		get_parent().get_parent().get_node(i).connect("itemPickup",self,"_on_itemPickup")
	for i in get_parent().get_parent().enemyList:
		get_parent().get_parent().get_node(i).get_node("Enemy").connect("damagePlayer",self,"_on_damagePlayer")
	for i in get_parent().get_parent().zoneList:
		get_parent().get_parent().get_node(i).connect("applyEffect",self,"_on_applyEffect")
	for i in get_parent().get_parent().zoneList:
		get_parent().get_parent().get_node(i).connect("removeEffect",self,"_on_removeEffect")

func _physics_process(delta):
	if health<=0:
		$Camera2D/pauseMenu.visible = false
		$Camera2D/playerHUD.visible = false
		$Camera2D/deathScreen.visible = true
		set_physics_process(false)
		for friend in get_tree().get_nodes_in_group("friendly"):
			friend.set_physics_process(false)
		for enemy in get_tree().get_nodes_in_group("hostile"):
			enemy.set_physics_process(false)
	
	if Input.is_action_pressed("toggle_pause"):
		$Camera2D/pauseMenu.visible = true
		set_physics_process(false)
		for friend in get_tree().get_nodes_in_group("friendly"):
			friend.set_physics_process(false)
		for enemy in get_tree().get_nodes_in_group("hostile"):
			enemy.set_physics_process(false)
	vel.x = 0
	# Movement
	if Input.is_action_pressed("move_left"):
		playerDirection = 0
		if Input.is_action_pressed("run"):
			vel.x -= runSpeed
		else:
			vel.x -= speed
	if Input.is_action_pressed("move_right"):
		playerDirection = 1
		if Input.is_action_pressed("run"):
			vel.x += runSpeed
		else:
			vel.x += speed
	# Velocity
	vel = move_and_slide(vel, Vector2.UP)
	# Gravity
	vel.y += gravity * delta
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
	#attack1
	if Input.is_action_just_pressed("attack") and attackCooldownTimer.time_left <= 0:
		var sword_hit = preload("res://assets//baseplatescenes//greatsword_attack1.tscn").instance()
		match playerDirection: # this is a switch to check the player direction and spawn the attack hitbox correctly.
			false:
				sword_hit.position = self.position - Vector2(15, 0)  # Adjust the position as needed
				sword_hit.scale.x = -1  # Flip the sprite to face the left
			true:
				sword_hit.position = self.position + Vector2(15, 0)  # Adjust the position as needed
			_:
				return
		get_parent().add_child(sword_hit)
		var timer = Timer.new() # timer to make the hitbox despawn.
		timer.wait_time = 0.1
		timer.one_shot = true  # Set the timer to only fire once
		timer.connect("timeout", self, "_on_sword_timeout", [sword_hit])  # Connect the timeout signal to a function
		add_child(timer)
		timer.start()
		sword_hit.get_node("Area2D").connect("body_entered", self, "_on_sword_hit_enter")
		
		attackCooldownTimer.start(attackCooldown)
	
	#camera_down
	if Input.is_action_pressed("camera_down") and is_on_floor():
		camera.position.y = lowCameraPos # Lowers the camera
		
	else:
		camera.position.y = cameraInitPos.y  # Reset camera position to initial y position

func _on_sword_hit_enter(body):
	# if u hit an enemy:
	if body in get_tree().get_nodes_in_group("hostile"):
		if body.health >= 1: # should I use is_dead ? Maybe later, or maybe is_dead will just be useless 4 ever.
			body.health -= 1
			body.knockback(body.knockbackMultiplier,!body.direction)
			if body.health<=0: # if last hit, grant score to player.
				score+=body.heldscore
				emit_signal("score_changed", score)
	# if u hit a wall:
	elif body in get_tree().get_nodes_in_group("wall"):
		knockbackFromWallHit(knockbackMultiplier,!playerDirection)
func _on_attack_cooldown_timeout():
	pass # nothin' to put here for now, could be useful later for HUD things or whatever.

func _on_sword_timeout(sword_hit):
	sword_hit.queue_free()

var knockBackDirection : Vector2

func knockbackFromWallHit(multiplier,direction):
	match direction:
		false:
			knockBackDirection=Vector2(-5*multiplier,0)
		true:
			knockBackDirection=Vector2(5*multiplier,0)
		_:
			pass
	position+=knockBackDirection
func knockbackFromDamage(multiplier, direction):
	match direction:
		false:
			knockBackDirection=Vector2(-10*multiplier,0)
		true:
			knockBackDirection=Vector2(10*multiplier,0)
		_:
			pass
	position+=knockBackDirection

func _on_damagePlayer(amount, direction):
	health-=amount
	emit_signal("health_changed", health)
	knockbackFromDamage(knockbackMultiplier, direction)

func _on_itemPickup(ID):
	inventory.append(ID)

func _on_applyEffect(type,duration,strenght):
	match type:
		"poison":
			poisonbarvalue+=1
			playerEffectList.append("poison")
			emit_signal("effect_changed", "poison", poisonbarvalue)
			if $Camera2D/effectsHUD/Poison.value>=10:
				for i in range(duration):
					health-=(strenght-(0.1*poisonResistance))
					poisonbarvalue-=1
					emit_signal("health_changed", health)
					emit_signal("effect_changed", "poison", poisonbarvalue)
					poisontimer.start(0.5)
					yield(poisontimer, "timeout")
			is_poisonclimbing=true
		"radiation":
			pass
		_:
			return
func _on_removeEffect(type):
	match type:
		"poison":
			if is_poisonclimbing==false:
				for i in range(poisonbarvalue):
					if is_poisonclimbing==false and poisonbarvalue>0:
						poisonbarvalue-=1
						emit_signal("effect_changed", "poison", poisonbarvalue)
						poisonremovetimer.start(0.5)
						yield(poisonremovetimer, "timeout")
		"radiation":
			pass
		_:
			return
