extends Node

class_name Other_sprite

var texture: Texture
var pos: Vector2
var vis: bool = false

var c_mod: Color = Color(1, 1, 1, 1)

func _init(t: String, p: Vector2, v: bool):
	self.texture = load(t)
	self.pos = p
	self.vis = v
