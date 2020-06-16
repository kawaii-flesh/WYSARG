extends Node2D

var w = load("res://WYSAR.gd")

var tex = ["res://texts/0"]
var bgs = ["res://bgs/bg.png"]
var fonts = ["res://fonts/0.ttf"]
var wysar = WYSAR.new("res://texts/0.tres", tex, bgs, fonts)
func _ready():	
	self.add_child(wysar)	
