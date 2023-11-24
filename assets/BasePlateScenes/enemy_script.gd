"""
Hey, please rearange any misplaced variables or delete the unused ones.
Also, remove any "print" statements you find, if needs be just replace them by a "pass" (like after an "if" or smthn)
Either remove this message once you're done, or just leave it here.
"""
extends KinematicBody2D

var player  # we'll need those to track the player
var sprite
var player_script

var zone # for the enemy's detect/chase zone.

# movement vars
var speed : int = 100
var gravity : int = 1000
var chaseSpeed : int = 150
var vel : Vector2 = Vector2()
# attacks vars
var attack_range : int = 10
var attack_damage : int = 10
var attack_delay : int = 1.0
var attack_timer # just declaring it here

func _ready():
	# get the player
	player = get_parent().get_parent().get_node("Player")
	player_script = get_parent().get_parent().get_node("Player/KinematicBody2D")
	# get this enemy's zone
	zone = get_parent().get_node("EnemyDetectionZoneNode/EnemyDetectionZone")
	sprite = get_node("AnimatedSprite") # this enemy's sprite
	
	# Initialize the attack timer
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_delay
	attack_timer.autostart = false

func _physics_process(delta):
	# Calculate the distance to the player
	var distance_to_player = self.position.distance_to(player.position)
	if zone.playerDetected: # if there's a player in this enemy's chase zone
		# attack or chase depending on distance
		if distance_to_player <= attack_range and not attack_timer.is_stopped():
			attack()
		else:
			var direction_to_player = (player.position - position).normalized()
			if direction_to_player.x < 0: # on the left
				vel.x -= chaseSpeed
			elif direction_to_player.x >0: # on the right
				vel.x += chaseSpeed
			else:
				print("nah")
	
	""" won't do it like that I think. If I send you the code and this is still here, remove it. (unless I say otherwise ofc)
	# don't chase a dead player
	if player_script.health > 0:
		if distance_to_player <= attack_range and not attack_timer.is_stopped():
			attack()
		else:
			# get closer
			var direction_to_player = (player.position - position).normalized()
			move_and_slide(direction_to_player * speed)
	"""

func attack():
	player_script.health -= attack_damage
	print(player_script.health) # remove that if I forget to, please.
	# Play the attack animation
	#sprite.play("attack") # not my job.

	attack_timer.start() # for the delay between attacks
