extends Sprite

var w = load("res://WYSAR.gd")

var wysar = WYSAR.new()
func _ready():
	self.centered = false	
	self.add_child(wysar)	
	
func _process(delta):
	var tex = ["res://texts/0"]
	var bgs = ["res://bgs/bg.png"]
	var fonts = ["res://fonts/0.ttf"]
	update()
	#var inf = File.new()
	#inf.open("res://texts/0.tres", File.READ)
	#var strd = inf.get_line()

var text_fnt = DynamicFont.new()
func _draw():
	text_fnt.font_data = load("res://fonts/0.ttf")
	text_fnt.size = 24
	draw_string(text_fnt, Vector2(40, 40), "Test text", Color("000000"))
