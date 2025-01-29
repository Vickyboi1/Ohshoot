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
		"Godlike" : "7.10",
		"Great" : "10.50",
		"Ok" : "18.00"}},
	"2" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "3.50",
		"Great" : "4.50",
		"Ok" : "9.00"}},
	"3" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "3.24",
		"Great" : "4.5",
		"Ok" : "10.00"}},
	"4" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "4.10",
		"Great" : "4.55",
		"Ok" : "14"}},
	"5" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "7.00",
		"Great" : "8.30",
		"Ok" : "13.00"}},
	"6" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "8.50",
		"Great" : "11.0",
		"Ok" : "14.0"}},
	"7" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "6.8",
		"Great" : "9.6",
		"Ok" : "16.00"}},
	"8" : {"available":false,"fastesttime":"0.00","completed": false,"RankTimes" : {
		"Godlike" : "0.00",
		"Great" : "0.00",
		"Ok" : "0.00"}}
		
	
	
}
 
var currenttime = 0.00
var lastselected = 1
