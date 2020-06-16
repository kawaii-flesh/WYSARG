extends Sprite


class_name WYSAR

var bg: Sprite = Sprite.new()
var text_str: String = "Hello"
var name_str: String
var text_fnt: DynamicFont = DynamicFont.new()
var name_fnt: DynamicFont = DynamicFont.new()
var text_pos: Vector2 = Vector2(100, 100)
var name_pos: Vector2 = Vector2.ZERO
var text_clr: Color = Color("000000")
var name_clr: Color = Color("000000")
var text_csh: int = 16
var name_csh: int = 16
var delay_text: float = 1
var vis_text: bool = true
var vis_name: bool = true

var wait_enter: bool = false

func _init(tex, bgs, fnts):
	self.text_fnt.font_data = load("res://fonts/0.ttf")
	self.text_fnt.size = 24
	self.bg.texture = load("res://bgs/bg.png")
	self.bg.centered = false
	print("Constructed!")	

func _process(delta):
	read_file()
func read_file():
	pass
	
func draw_text():
	var pos = self.text_pos
	for ch in self.text_str:
		draw_string(self.text_fnt, pos, ch, self.text_clr)
		pos.x += text_csh

func draw_name():	
	draw_string(self.name_fnt, self.name_pos, self.name_str, self.name_clr)
	
func _draw():
	draw_texture(self.bg.texture, Vector2.ZERO)
	draw_text()
	draw_name()
	yield(get_tree().create_timer(delay_text), "timeout")
	self.text_str += '!'
	update()
