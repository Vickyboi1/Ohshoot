extends Node2D
# This is a hacky way of doing animation
# I do not advise you using this in real projects
# Instead learn how to use a STATE MACHINE
# https://www.youtube.com/results?search_query=godot+state+machine
# Choose a video of your liking

@export var player_path : NodePath
@onready var Player := get_node(player_path)
@onready var Animator := $AnimationPlayer

var previous_frame_velocity := Vector2(0,0)
var hasreloaded = false

# Avoid errors
func _ready() -> void:
	uni.reload.connect(reloaded)
	if Player == null:
		print("Sprite.gd is missing player_path")
		set_process(false)


func _process(_delta: float) -> void:
	if hasreloaded:

		Animator.play("Reload")
		hasreloaded = false
		
	elif previous_frame_velocity.y > 0 and Player.is_on_floor() :
		Animator.play("RESET")

		Animator.play("Land")

	elif previous_frame_velocity.y >= 0 and Player.velocity.y < 0:


		Animator.play("Jump")
		

	# It's important that this is the last thing done
	previous_frame_velocity = Player.velocity

func reloaded():
	hasreloaded = true
	


func _on_animationreset_timeout() -> void:
	Animator.play("RESET")
