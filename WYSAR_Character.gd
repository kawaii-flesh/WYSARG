extends Node

class_name WYSAR_Character

var texture: Texture
var texture_list: PoolStringArray = []
var pos: Vector2
var vis: bool = false

var c_add: bool = false
var c_delete: bool = false
var c_mod: Color = Color(1, 1, 1, 0)
var c_ch: bool = false
var c_nt: int = 0

func _init(tl: PoolStringArray):
	self.texture_list = tl
