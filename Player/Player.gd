extends CharacterBody2D

# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var x_dir := 1

@export var max_speed: float = 560
@export var max_velocity: float = 2500
@export var acceleration: float = 2880
@export var turning_acceleration : float = 9600
@export var deceleration: float = 3200
var incontrol : bool = true
var canreload : bool = true
var consecutivebounces = 0
var currentveloc : Vector2

# aim line size---------------------------------------- #
var size = 0
var basesize = 1
# GRAVITY ----- #
@export var gravity_acceleration : float = 3840
@export var gravity_max : float = 1020
# ------------- #

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 1400
@export var jump_cut : float = 0.25
@export var jump_gravity_max : float = 500
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.1
# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# Sounds------------------------------ #
@onready var reloadsounds = preload("res://Sounds/Reload.tscn")
@onready var gunshotsounds = preload("res://Sounds/Shoot.tscn")


#Packedscenes-----------------------
var Bullet : PackedScene = preload("res://bullet.tscn")

func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		"y": int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
		"drop" : Input.is_action_pressed("down") or  Input.is_action_just_pressed("down"),
		"shoot" : Input.is_action_just_released("shoot"),
		"aim" : Input.is_action_pressed("shoot") ,
		"bounce" : Input.is_action_pressed("bounce"),
		"reload" : Input.is_action_just_pressed("reload")
	}


func _ready() -> void:

	uni.camerazoom.emit(Vector2(0.8,0.8))
	uni.blowback.connect(barrelblowback)

func _process(float):
	if incontrol:
		$Sprite/Ammooutline/haveammo.show()
	else:
		$Sprite/Ammooutline/haveammo.hide()
func _physics_process(delta: float) -> void:

	
	if !global_position.distance_to(get_global_mouse_position()) <= 50:
		queue_redraw()
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)



	x_dir = get_input()["x"]
	uni.playervelocity = currentveloc
	uni.playerpos = global_position
	

	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	
	timers(delta)
	move_and_slide()
	
	if get_input()["drop"]:
		#Disables an renables the one way plat collisions
		self.set_collision_mask_value(4,false)
	else:
		self.set_collision_mask_value(4,true)
	if get_input()["shoot"] and incontrol:
		var shootsound = gunshotsounds.instantiate()
		add_child(shootsound)
		var knock_back_direction = (global_position - get_global_mouse_position()).normalized() * 2500
		velocity = knock_back_direction
		move_and_slide()
		incontrol = false
		var b = Bullet.instantiate()
		b.transform = $Sprite/Marker2D.global_transform
		owner.add_child(b)
		$justshot.start()
		#Offset rotation
	#if is_on_wall() and get_input()["bounce"]:
		#consecutivebounces += 1
		#if currentveloc.x > 0:
			#velocity.x = ((currentveloc.x - 50 )* -1.0) 
		#elif currentveloc.x < 0:
			#velocity.x = ((currentveloc.x + 50 )* -1.0) 
		#else:
			#return
		#velocity.y = currentveloc.y * 1.5
	#
		#incontrol = false
		#if consecutivebounces <= 1:
			#canreload = true
	if get_input()["reload"] and canreload and $reloadcool.is_stopped():
		canreload = false
		$reloadcool.start()
		#Converts x velocity into y velocity
		velocity.y += -(abs(currentveloc.x * 0.9)) - (jump_force)
		velocity.x = 0
		
		#Tells sprite to play the reload animation
		uni.reload.emit()
		#Sound
		var reload = reloadsounds.instantiate()
		add_child(reload)
		
		#Allows the player to shoot again
		incontrol = true

	if get_input()["aim"] and incontrol:

		size = basesize
		$Sprite/Polygon2D.flip_h = false
		$Sprite/AnimationPlayer.play("RESET")
		
		tween.tween_property(Engine,"time_scale",0.1,0.5)
		tween.tween_property(AudioServer,"playback_speed_scale",0.8,0.5)
		uni.camerazoom.emit(Vector2(0.4,0.4))
		if !global_position.distance_to(get_global_mouse_position()) <= 50:
			look_at(get_global_mouse_position())
	else:
		#if !abs(uni.playervelocity.x) > 1800 or !abs(uni.playervelocity.y) > 2000:
			#uni.camerazoom.emit(Vector2(0.8,0.8))
			#print("Hi")
		size = 0
		rotation = 0
		tween.tween_property(Engine,"time_scale",1,0.1)
		tween.tween_property(AudioServer,"playback_speed_scale",1,1.1)

	if abs(velocity.x) >= max_velocity:
		velocity.x = max_velocity * x_dir
		
		
	
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file.call_deferred("res://levelselect.tscn")
	if Input.is_action_just_pressed("mute"):
		uni.musicon = !uni.musicon
	
	
	if uni.musicon:
		$Levelmusic.volume_db = -12.7
	else:
		$Levelmusic.volume_db = -1000
	
	
	
func x_movement(delta: float) -> void:
	x_dir = get_input()["x"]
	#Regular movement -------------------------------------------
	
		# Stop if we're not doing movement inputs.
	if x_dir == 0 :
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0,0), deceleration * delta).x
		return
	if is_on_floor():
		$Sprite/Polygon2D.rotation = 0
	if incontrol:
		if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:

			return

		var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	
	# Accelerate
		velocity.x += x_dir * accel_rate * delta
	if (!is_on_floor() and !incontrol) and (velocity.y >= 400 and abs(velocity.x) <= 50):
		velocity.x = x_dir * 500

	#Player sprite flipping -------
	set_direction(x_dir) # This is purely for visuals


func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	if hor_direction > 0:
		$Sprite/Polygon2D.flip_h = false
	elif hor_direction < 0:
		$Sprite/Polygon2D.flip_h = true


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	# Reloads the player ----------------------------
	
	#Coyote + jump buffer. Ignore ---4----------------------------
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	

	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0

		if velocity.y > 0:
			velocity.y -= velocity.y
		
		velocity.y = -jump_force
		if !$justshot.is_stopped():
			velocity.x *= 1.3
			
		
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	

	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0
	if is_on_floor():	
		
		jump_coyote_timer = jump_coyote
		is_jumping = false
		canreload = true
		incontrol = true

func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta

func _draw() -> void:
	draw_dashed_line(Vector2.ZERO,Vector2(15,0) * 500,Color.WHITE_SMOKE,size,35,false,true)
func _on_updateveloc_timeout() -> void:
	currentveloc = velocity





func barrelblowback(barrelpos):

	velocity += uni.barrelpower * -1 * global_position.direction_to(barrelpos)
	incontrol = true
