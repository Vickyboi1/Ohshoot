extends Node
@warning_ignore("unused_signal")
signal reload
var playervelocity : Vector2
var playerpos : Vector2
@warning_ignore("unused_signal")
signal camerazoom(value)
signal blowback(barrelposition)
signal levelend(currentlevel)

var barrelpower = Vector2(1500,1800)
var barrelrad = 0

@onready var currentlevel : int = 1
