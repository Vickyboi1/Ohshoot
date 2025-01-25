extends StaticBody2D
@onready var enemyblooddeath = preload("res://Stage elements/enemydeath.tscn")
@onready var splattersound = preload("res://Sounds/splatter.tscn")
@onready var enemylist = get_tree().current_scene.get_parent()
func die():

	$Area2D/CollisionShape2D.set_deferred("disabled",true) 
	$CollisionShape2D.set_deferred("disabled",true) 
	#Implement blood-------------------dddd

	var bloodsound = splattersound.instantiate()
	enemylist.add_child(bloodsound)
	var blood = enemyblooddeath.instantiate()
	enemylist.add_child(blood)
	blood.global_position = global_position
	queue_free()



	


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("bullet"):
		die()
