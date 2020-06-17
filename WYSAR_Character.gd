extends Sprite

class_name WYSAR_Character

var character: Sprite = Sprite.new()
var texture_list: PoolStringArray = []
var pos: Vector2 = Vector2.ZERO

func _init(tl: PoolStringArray):
	self.texture_list = tl	

func _ready():
	pass # Replace with function body.
	
func _draw():
	draw_texture(self.character.texture, self.pos)
