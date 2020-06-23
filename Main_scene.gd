extends Node2D

var wc = load("res://WYSAR_Character.gd")
var w = load("res://WYSAR.gd")

var bgs = ["res://bgs/bg.png", "res://bgs/bg1.jpg"]
var fonts = ["res://fonts/0.ttf"]
var sn = ["res://music/fx.wav"]
var ms = ["res://music/bg.ogg", "res://music/bgdr.ogg"]
var ch = [WYSAR_Character.new(["res://MCH/1.png", "res://MCH/2.png"])]
var v_t = ["vhs317ch", "Test string from vars"]

var wysar = WYSAR.new("res://texts/0.tres", bgs, fonts, sn, ms, ch, v_t)

func _ready():
	self.add_child(wysar)
	var bt = Button.new()
	bt.set_text("Save")
	bt.connect("button_up", self, "save_game")
	self.add_child(bt)
	var bt2 = Button.new()
	bt2.set_text("Load")
	bt2.connect("button_up", self, "load_game")
	bt2.set_position(Vector2(0, 25))
	self.add_child(bt2)
	
func save_game():
	wysar.save_g("save.dat")

func load_game():
	wysar.load_g("save.dat")
