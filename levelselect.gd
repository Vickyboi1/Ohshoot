extends Control


func _ready() -> void:
	
	
	#Gets level list
	for level in uni.levels:
		if uni.levels.has(level):
			if uni.levels[level]["available"] == true or uni.godmode:
				
					$OptionButton.add_item(level)
	
	$OptionButton.selected = $OptionButton.item_count 
	


func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://World/Level" +str($OptionButton.get_item_id($OptionButton.selected))  + ".tscn")


func _process(delta: float) -> void:
	#Show times
	$besttime.set_text("Best Time : " + str(uni.levels[str($OptionButton.selected)]["fastesttime"]))
