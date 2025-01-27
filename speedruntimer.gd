extends CanvasLayer

var time  = 0.00
func _ready() -> void:
	time  = 0.00
func _process(delta: float) -> void:
	time += delta
	
	
	update_ui()
func update_ui():
	var formattedtime = str(time)
	var decimal_index = formattedtime.find(".")
	
	if decimal_index > 0:
		formattedtime = formattedtime.left(decimal_index + 3)
	uni.currenttime = formattedtime
	
	$Label.set_text(formattedtime)
	
