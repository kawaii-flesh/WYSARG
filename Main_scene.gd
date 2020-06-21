extends Node2D

var wc = load("res://WYSAR_Character.gd")
var w = load("res://WYSAR.gd")

var bgs = ["res://bgs/bg.png", "res://bgs/bg1.jpg"]
var fonts = ["res://fonts/0.ttf"]
var sn = ["res://fonts/0.ttf"]
var ms = ["res://fonts/0.ttf"]
var ch = [WYSAR_Character.new(["res://MCH/1.png", "res://MCH/2.png"])]
var v_t = ["vhs317ch"]

var wysar = WYSAR.new("res://texts/0.tres", bgs, fonts, sn, ms, ch, v_t)

func _ready():	
	self.add_child(wysar)
