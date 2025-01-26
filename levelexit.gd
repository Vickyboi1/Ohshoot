extends Area2D

var enemiesleft
var on = false


	
func get_enemies():
	if get_tree().current_scene.has_node("Enemies"):
		enemiesleft = get_tree().current_scene.get_node("Enemies").get_children()
		return enemiesleft
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemiesleft = get_enemies()
	if !on:
		if enemiesleft == []:
		
			$CollisionShape2D.call_deferred("set_disabled",false)
			$CPUParticles2D.set_deferred("emitting",true)
			$Polygon2D.color = Color.ALICE_BLUE
			$AudioStreamPlayer2D.play()
			on = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var curlev = get_tree().current_scene.scene_file_path.replace("res://World/Level","").replace(".tscn","")
		uni.levels[str(int(curlev) + 1)]["available"] = true 
		get_tree().change_scene_to_file.call_deferred("res://levelselect.tscn")
