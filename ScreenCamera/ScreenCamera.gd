extends Camera2D

# Camera script follwing a target (usually the player)
# This camera is snapped to a grid, therefore only moves when the character exits a screen.

@export var target : NodePath
@export var align_time : float = 0.2
@export var screen_size := Vector2(1920, 1080)

@onready var Target = get_node_or_null(target)
@export var speedyzoom = Vector2(0.3,0.3)
@export var basezoom = zoom

func _ready():
	uni.camerazoom.connect(to_zoom)
	
func _physics_process(_delta: float) -> void:
	if not is_instance_valid(Target):
		var targets: Array = get_tree().get_nodes_in_group("Player")
		if targets: Target = targets[0]
	if not is_instance_valid(Target):
		return
	global_position = Target.get_node("Sprite/Marker2D").global_position
	# Actual movement

	#tween.tween_property(self, "global_position", desired_position(), align_time)
	if abs(uni.playervelocity.x) > 2000 or abs(uni.playervelocity.y) > 2500:

		to_zoom(speedyzoom)
		
		$lines.material.set("shader_parameter/line_color",Color(1,1,1))
	else:
		to_zoom(basezoom)
		$lines.material.set("shader_parameter/line_color",Color(1,1,1,0))
# Calculating the gridnapped position
#func desired_position() -> Vector2:
	#return (Target.global_position / screen_size).floor() * screen_size + screen_size/2

func to_zoom(value):
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tw.tween_property(self,"zoom",value,1) 
