extends Node2D

var w = load("res://WYSAR.gd")

var tex = ["res://texts/0"]
var bgs = ["res://bgs/bg.png"]
var fonts = ["res://fonts/0.ttf"]
var wysar = WYSAR.new(tex, bgs, fonts)
func _ready():	
	self.add_child(wysar)	
	
func _process(delta):
	update()
	#var inf = File.new()
	#inf.open("res://texts/0.tres", File.READ)
	#var strd = inf.get_line()
