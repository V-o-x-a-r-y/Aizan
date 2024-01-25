extends KinematicBody2D


onready var animation_tree = $AnimationTree
#signals
signal health_changed(amount)
signal stamina_changed(amount)
signal score_changed(amount)
signal effect_changed(effect,amount)
signal callInventory()
signal callChestInventory()
signal dialogueEnd()
signal shotListChanged(shotList, shot)
# dialogue
onready var dialogueHUD = $Camera2D/dialogueHUD
onready var dialogueText = $Camera2D/dialogueHUD/text
var dialogueTimer : Timer
# inventory
onready var InventoryUI = $Camera2D/Inventory
var inventory : Array = []
var inventoryUniqueEntry: Array = []
var inventoryCount: Array = []
var inventoryComplete: Array = []
# indirect inventory (chest and such)
onready var chestInventoryUI = $Camera2D/chestInventory
var chestContent : Array = []
var chestID : String
# injector
var shotList : Array = ["heal","heal","heal","stamina","stamina","stamina","antidote","antidote","antidote"]
var shot : String = "heal"
var injector : String = "basicInjector"
var injectorDelay : int = 2

var healShotStrenght : int = 3
var staminaShotStrenght : int = 3
var antidoteShotStrenght : int = 3
#items HUD
var currentItem : String
var currentSlot : int = 0
var previousSlot : int = 4
var nextSlot : int = 1
# stats
var maxhealth : int = 10
var maxstamina : int = 10
var health : int = 10
var stamina : int = 10
var score: int = 0
var attackCooldown : int = 0.1
var attackDamage : int = 1
var knockbackMultiplier : int = 1
var poisonResistance : int = 0
# those are for 'Movement'
var speed : int = 200        # base walk speed
var jumpForce : int = 400
var gravity : int = 1000
var runSpeed : int = 250
var vel : Vector2 = Vector2()
# those are for 'attack'
var playerDirection : bool = 0
var attackCooldownTimer: Timer
# stamina
var staminatimer: Timer
var staminarechargetimer: Timer
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
# warning-ignore:return_value_discarded
	attackCooldownTimer.connect("timeout", self, "_on_attack_cooldown_timeout")
	add_child(attackCooldownTimer)
	# poison timer
	poisontimer = Timer.new()
	poisontimer.one_shot = true
	add_child(poisontimer)
	
	poisonremovetimer = Timer.new()
	poisontimer.one_shot = true # this should've been poisonremovetimer but somehow, it just works.
	add_child(poisonremovetimer)
	# stamina timer
	staminatimer = Timer.new()
	staminatimer.one_shot = true
	staminatimer.connect("timeout", self, "_on_staminaconnect")
	add_child(staminatimer)
	
	staminarechargetimer = Timer.new()
	staminarechargetimer.one_shot = true # this should've been poisonremovetimer but somehow, it just works.
	add_child(staminarechargetimer)

	# dialogue timer
	dialogueTimer = Timer.new()
	dialogueTimer.one_shot = true
	add_child(dialogueTimer)
	
	#get all items in the scene 
	for i in get_parent().get_parent().itemList:
		get_parent().get_parent().get_node(i).connect("itemPickup",self,"_on_itemPickup")
	for i in get_parent().get_parent().enemyList:
		get_parent().get_parent().get_node(i).get_node("Enemy").connect("damagePlayer",self,"_on_damagePlayer")
	for i in get_parent().get_parent().zoneList:
		get_parent().get_parent().get_node(i).connect("applyEffect",self,"_on_applyEffect")
	for i in get_parent().get_parent().zoneList:
		get_parent().get_parent().get_node(i).connect("removeEffect",self,"_on_removeEffect")
	for i in get_parent().get_parent().chestList:
		get_parent().get_parent().get_node(i).connect("chestOpen",self,"_on_chestOpen")
	for i in get_parent().get_parent().NPCList:
		get_parent().get_parent().get_node(i).connect("dialogueChanged",self,"_on_dialogueChanged")

func _physics_process(delta):
	if vel == Vector2(0,vel.y): # check if player moving, if not then start idle anim
		animation_tree.get("parameters/playback").travel("idle")
	
	if health<=0:
		$Camera2D/pauseMenu.visible = false
		$Camera2D/playerHUD.visible = false
		$Camera2D/deathScreen.visible = true
		set_physics_process(false)
		for friend in get_tree().get_nodes_in_group("friendly"):
			friend.set_physics_process(false)
		for enemy in get_tree().get_nodes_in_group("hostile"):
			enemy.set_physics_process(false)
	
	if Input.is_action_just_pressed("next_item"):
		if currentSlot == 4: currentSlot=0
		else: currentSlot+=1
		if nextSlot == 4: nextSlot=0
		else: nextSlot+=1
		if previousSlot == 4: previousSlot=0
		else: previousSlot+=1
		changeHotbar()
	
	if Input.is_action_just_pressed("open_inventory"):
		InventoryUI.visible = !InventoryUI.visible
		emit_signal("callInventory")
	
	if Input.is_action_pressed("toggle_pause"):
		InventoryUI.visible = false
		chestInventoryUI.visible = false
		$Camera2D/pauseMenu.visible = true
		set_physics_process(false)
		for friend in get_tree().get_nodes_in_group("friendly"):
			friend.set_physics_process(false)
		for enemy in get_tree().get_nodes_in_group("hostile"):
			enemy.set_physics_process(false)
	vel.x = 0
	# Movement
	if Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("run"):
			vel.x -= runSpeed
		else: #just walking
			vel.x -= speed
			animation_tree.get("parameters/playback").travel("walk")
			if playerDirection==true:
				$Polygons.scale.x = 1
				$Skeleton2D.scale.x = 1
				$Hitbox.scale.x = 1
		playerDirection = 0
	if Input.is_action_pressed("move_right"):
		
		if Input.is_action_pressed("run"):
			vel.x += runSpeed
		else: #walking
			vel.x += speed
			animation_tree.get("parameters/playback").travel("walk")
			if playerDirection==false:
				$Polygons.scale.x = -1
				$Skeleton2D.scale.x = -1
				$Hitbox.scale.x = -1
		
		playerDirection = 1
	# Velocity
	vel = move_and_slide(vel, Vector2.UP)
	# Gravity
	vel.y += gravity * delta
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
	#attack1
	if Input.is_action_just_pressed("attack") and attackCooldownTimer.time_left <= 0 and stamina>=3:
		animation_tree.get("parameters/playback").travel("attack1")
		stamina -= 3
		emit_signal("stamina_changed",stamina)
		# used to make stamina go back up after unactivity
		staminatimer.start(1.5)
		
		""" # old attack system, might delete later (I should, but could still be of use for now idk prbbly not)
		
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
		"""
	
	#camera_down
	if Input.is_action_pressed("camera_down") and is_on_floor():
		camera.position.y = lowCameraPos # Lowers the camera
		
	else:
		camera.position.y = cameraInitPos.y  # Reset camera position to initial y position
	
	if Input.is_action_just_pressed("use_item"):
		if inventory.count(currentItem)>=1:
			useItem(currentItem)
	
	if Input.is_action_just_pressed("next_shot"):
		match shot:
			"heal":
				shot = "stamina"
			"stamina":
				shot = "antidote"
			"antidote":
				shot = "heal"
		emit_signal("shotListChanged",shotList, shot)
	
	if Input.is_action_just_pressed("use_injector"):
		if shotList.count(shot)>=1:
			useInjector(shot)
func _on_staminaconnect():
	_on_staminarecharge(stamina)

func _on_staminarecharge(amount):
	if staminatimer.time_left<=0:
		for i in range(maxstamina-amount):
			if amount>=maxstamina:
				stamina=10
				break
			stamina+=1
			emit_signal("stamina_changed", stamina)
			staminarechargetimer.start(0.5)
			yield(staminarechargetimer, "timeout")
	

func changeHotbar():
	$Camera2D/playerHUD/currentSlot/image.texture = get_node("Camera2D/Inventory/EquipementTab/items/slot"+str(currentSlot)).texture
	$Camera2D/playerHUD/previousSlot/image.texture = get_node("Camera2D/Inventory/EquipementTab/items/slot"+str(previousSlot)).texture
	$Camera2D/playerHUD/nextSlot/image.texture = get_node("Camera2D/Inventory/EquipementTab/items/slot"+str(nextSlot)).texture
	currentItem = get_node("Camera2D/Inventory/EquipementTab/items/slot"+str(currentSlot)).item

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
			return
	position+=knockBackDirection

func knockbackFromDamage(multiplier, direction):
	match direction:
		false:
			knockBackDirection=Vector2(-10*multiplier,0)
		true:
			knockBackDirection=Vector2(10*multiplier,0)
		_:
			return
	position+=knockBackDirection

func _on_damagePlayer(amount, direction):
	health-=amount
	emit_signal("health_changed", health)
	knockbackFromDamage(knockbackMultiplier, direction)

func _on_itemPickup(ID):
	inventory.append(ID)
	for i in inventory:
		if i in inventoryUniqueEntry:
			pass
		else:
			inventoryUniqueEntry.append(i)
	inventoryCount=[]
	for a in inventoryUniqueEntry:
		inventoryCount.append(inventory.count(a))
	inventoryComplete=[]
	for v in range(len(inventoryUniqueEntry)):
		inventoryComplete.append([inventoryUniqueEntry[v],inventoryCount[v]])
	
	emit_signal("callInventory")

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

func useItem(itemToUse):
	inventory.erase(itemToUse)
	match itemToUse:
		"item4":
			print("used debug Item4") # it's a debug item that'll get deleted afterwards, so a print is fine I guess.

func _on_chestOpen(content, ID):
	$Camera2D/chestInventory.visible = true
	chestContent = content
	chestID = ID
	emit_signal("callChestInventory")

func useInjector(shot):
	match shot:
		"heal":
			shotList.erase(shot)
			health+=healShotStrenght
			if health > 10:
				health=10
			emit_signal("health_changed", health)
		"antidote":
			pass
		"stamina":
			pass
	emit_signal("shotListChanged",shotList, shot)

func _on_dialogueChanged(dialogue, isLast):
	dialogueHUD.visible = true
	dialogueText.bbcode_text = dialogue
	dialogueTimer.start(3)
	yield(dialogueTimer, "timeout")
	if not isLast:
		emit_signal("dialogueEnd")
	elif isLast:
		dialogueHUD.visible = false
		dialogueText.bbcode_text = ""
