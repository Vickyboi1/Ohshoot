extends Control


func _ready() -> void:
	
	
	#Gets level list
	for level in uni.levels:
		if uni.levels.has(level):
			if uni.levels[level]["available"] == true or uni.godmode:
				
					$OptionButton.add_item(level)
	print(uni.lastselected)
	$OptionButton.select(uni.lastselected)
	


func _on_confirm_pressed() -> void:
	
	uni.lastselected = $OptionButton.selected
	get_tree().change_scene_to_file("res://World/Level" +str($OptionButton.get_item_id($OptionButton.selected))  + ".tscn")


func _process(delta: float) -> void:
	#Show times
	$besttime.set_text("Best Time : " + str(uni.levels[str($OptionButton.selected)]["fastesttime"]))


	#Display Rank
	#var time = float(uni.levels[str($OptionButton.selected)]["fastesttime"])
	#var timelist = uni.levels[str($OptionButton.selected)]["RankTimes"]
	#if time <= float(timelist["Godlike"]) and time != 0.00:
		#$Rank.play("Godlike")
	#elif time <= float(timelist["Great"]) and time != 0.00:
		#$Rank.play("Great")
	#elif time <= float(timelist["Ok"]) and time != 0.00:
		#$Rank.play("Ok")
	#elif time > float(timelist["Ok"]) and time != 0.00:
		##If worse than OK rank, worst rank :(((
		#$Rank.play("Bad")
	#else:
		#$Rank.play("NA")
