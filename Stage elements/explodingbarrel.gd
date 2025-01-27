extends StaticBody2D
@onready var enemyblooddeath = preload("res://Stage elements/enemydeath.tscn")
@onready var explosion = preload("res://Sounds/explosion.tscn")
#Code almost indentical to enemy with a few tweaks'
var circlewidth = 5
var currentwidth = 0
var live = true
func _ready() -> void:
	uni.barrelrad = $Area2D2/CollisionShape2D.shape.radius
	
	
func die():

	live = false
	if $Area2D2.has_overlapping_bodies():
		if $Area2D2.get_overlapping_bodies()[0].is_in_group("Player"):
		
		
			uni.blowback.emit(global_position)
			
	
	$deathtimer.start()
	$Polygon2D.set_deferred("visible",false)
	$Area2D/CollisionShape2D.set_deferred("disabled",true) 
	$CollisionShape2D.set_deferred("disabled",true) 
	$Area2D2/CollisionShape2D.set_deferred("disabled",true)
	$Explosion/CollisionShape2D.set_deferred("disabled",false)
	currentwidth = 0

	var blood = enemyblooddeath.instantiate()
	add_child(blood)
	
	blood.global_position = global_position
	var explop = explosion.instantiate()
	add_child(explop)
	#Implement fire-------------------dddd
	

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("bullet"):
		die()
	

 
func _on_deathtimer_timeout() -> void:
	queue_free()

func _draw() -> void:
	if live:
		draw_circle(Vector2.ZERO,uni.barrelrad,Color.FIREBRICK,false,currentwidth,false)
	else:
		draw_circle(Vector2.ZERO,uni.barrelrad,Color.FIREBRICK,false,0,false)

func _process(delta: float) -> void:
	
	queue_redraw()


		


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var widthtween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
		widthtween.tween_property(self,"currentwidth",circlewidth,0.5)


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var widthtween = create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BOUNCE)
		widthtween.tween_property(self,"currentwidth",0,0.25)
