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
var godmode = true

var levels = {
	"1" : {"available":true,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "7.35",
		"Great" : "10.50",
		"Ok" : "18.00"}},
	"2" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "3.50",
		"Great" : "4.50",
		"Ok" : "9.00"}},
	"3" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "3.30",
		"Great" : "4.5",
		"Ok" : "10.00"}},
	"4" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "4.2",
		"Great" : "4.55",
		"Ok" : ""}},
	"5" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "",
		"Great" : "",
		"Ok" : ""}},
	"6" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "",
		"Great" : "",
		"Ok" : ""}}
	
	
}
 
var currenttime = 0.00
var lastselected = 1
