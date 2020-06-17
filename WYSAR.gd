extends Sprite

class_name WYSAR

var wc = preload("res://WYSAR_Character.gd")

var current_file: File = File.new()
var current_file_text: String = ""
var current_pos_in_file: int = 0

var bg: Sprite = Sprite.new()
var text_str: String
var name_str: String
var text_fnt: DynamicFont = DynamicFont.new()
var name_fnt: DynamicFont = DynamicFont.new()
var text_pos: Vector2 = Vector2(100, 100)
var name_pos: Vector2 = Vector2.ZERO
var text_clr: Color = Color("000000")
var name_clr: Color = Color("000000")
var text_csh: int = 16
var text_csv: int = text_csh + 6
var name_csh: int = 16
var delay_text: float = 100.0
var vis_text: bool = true
var vis_name: bool = true

var wait_enter: bool = false
var clear_text: bool = false

var text_list: PoolStringArray = []
var bg_list: PoolStringArray = []
var fonts_list: PoolStringArray = []
var sound_list: PoolStringArray = []
var music_list: PoolStringArray = []
var character_list: = []

func _init(stf: String, tex: PoolStringArray, bgs: PoolStringArray, fnts: PoolStringArray, sn: PoolStringArray, ms: PoolStringArray, cha):
	self.text_list = tex
	self.bg_list = bgs
	self.fonts_list = fnts
	self.sound_list = sn
	self.music_list = ms
	self.character_list = cha
	print(position)
	for i in self.character_list:
		self.add_child(i)
	self.text_fnt.font_data = load("res://fonts/0.ttf")
	self.text_fnt.size = 24
	self.bg.texture = load("res://bgs/bg.png")
	self.bg.centered = false
	open_file(stf)
	
	print("Constructed!")


func read_file():
	var ch = current_file_text[current_pos_in_file]	
	self.current_pos_in_file += 1
	return ch

func command_section():
	pass
	
func delay(t: float):
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() - time < t:
		pass
	
func open_file(nf):
	current_file.close()
	current_file.open(nf, File.READ)
	current_file_text = current_file.get_as_text()

var time = 0.0

func _input(event):
	if event is InputEventKey and event.scancode == KEY_ENTER:
		wait_enter = false
		if clear_text:
			text_str = ""
			
func _process(delta):
	var dt = delay_text
	if Input.is_key_pressed(KEY_SPACE):
		dt /= 2
	delay(dt)
	if wait_enter:		
		return
	var symb = self.read_file()
	
	if symb == ';':
		self.wait_enter = true
		self.clear_text = true
	elif symb == '$':
		self.wait_enter = true
	elif symb == '~':
		delay(dt)
	elif symb == '^':
		self.text_str = ""
	elif symb == '\\':
		symb = self.read_file()
		self.text_str += symb
	elif symb == '|':
		command_section() # TODO
	else:
		self.text_str += symb
	
	update()

func draw_text():
	var pos = self.text_pos
	for i in self.text_str:		
		draw_string(self.text_fnt, pos, i, self.text_clr)
		if i == '\n':
			pos.y += self.text_csh + 5
			pos.x = self.text_pos.x
		else:
			pos.x += self.text_csh

func draw_name():	
	draw_string(self.name_fnt, self.name_pos, self.name_str, self.name_clr)
	
func _draw():
	draw_texture(self.bg.texture, Vector2.ZERO)
	draw_text()
	draw_name()
