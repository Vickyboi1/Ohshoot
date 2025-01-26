extends Control


func _ready() -> void:
	
	$OptionButton.selected = $OptionButton.item_count - 1
	
	#Gets level list
	for level in uni.levels:
		if uni.levels.has(level):
			if uni.levels[level]["available"] == true or uni.godmode:
				
					$OptionButton.add_item(level)
	


func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://World/Level" +str($OptionButton.get_item_id($OptionButton.selected) + 1)  + ".tscn")
