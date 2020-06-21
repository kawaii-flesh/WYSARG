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
var text_pos: Vector2 = Vector2.ZERO
var name_pos: Vector2 = Vector2.ZERO
var text_clr: Color = Color("000000")
var name_clr: Color = Color("000000")
var text_csh: int = 0
var text_csv: int = 0
var name_csh: int = 0
var delay_text: float = 0.0
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
var vars: PoolStringArray = []

var bg_b: bool = false
var bg_l: bool = false
var bg_c: bool = false
var bgsp: float = 0.0
var bgid: int = 0
var bgm: Color = Color(1.0, 1.0, 1.0, 1.0)

var sh_c: bool = false
var ch_t: PoolStringArray = []
var ch_dt: PoolStringArray = []
var ch_rt: PoolStringArray = []
var ch_p: Vector2 = Vector2.ZERO
var ch_cur: int = 0
var ch_mkd: bool = false
var ch_prsd: bool = false

func _init(stf: String, bgs: PoolStringArray, fnts: PoolStringArray, sn: PoolStringArray, ms: PoolStringArray, cha, vb: PoolStringArray):
	self.bg_list = bgs
	self.fonts_list = fnts
	self.sound_list = sn
	self.music_list = ms
	self.character_list = cha
	for i in self.character_list:
		self.add_child(i)
	self.bg.centered = false
	self.vars = vb
	open_file(stf)	

func read_file():
	if current_pos_in_file >= current_file_text.length():
		return ''
	var ch = current_file_text[current_pos_in_file]
	self.current_pos_in_file += 1
	return ch
	
func delay(t: float):
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() - time < t:
		pass
	
func open_file(nf):
	current_file.close()
	current_file.open(nf, File.READ)
	current_file_text = current_file.get_as_text()
	current_pos_in_file = 0

var time = 0.0

func _input(event):
	if wait_enter:
		if Input.is_key_pressed(KEY_ENTER):
			wait_enter = false
			if clear_text:
				text_str = ""

var fr = 0
var cfr = 4
var fir_s = true
var fir_c = false
func draw_wait_symbol():
	if fr < cfr and fir_s:
		self.text_str += '_'
		fir_s = false
		fir_c = true
	elif fr > cfr and fir_c:
		self.text_str = self.text_str.substr(0, len(self.text_str)-1)
		fir_c = false
		fir_s = true
	fr += 1
	if fr == cfr*2:
		fr = 0
		
func choice_action(ch):
	open_file(ch)
	
func _process(delta):
	if self.sh_c and self.ch_mkd == false:
		make_choice()
		update()
		return
	if self.ch_mkd:
		choice_action(self.ch_rt[self.ch_cur])
		self.ch_mkd = false
		self.sh_c = false
		
	for i in character_list:
		if i.c_add or i.c_delete:
			update()
			return
	if bg_b or bg_l:
		update()
		return
	var dt = delay_text
	if Input.is_key_pressed(KEY_SPACE) and not Input.is_key_pressed(KEY_ENTER):
		dt /= 3
	delay(dt)
	if wait_enter:
		update()
		return
	var symb = self.read_file()
	if symb == '': 
		update()
		return
	
	if symb == ';':
		self.wait_enter = true
		self.clear_text = true
		if current_file_text[current_pos_in_file] == '\n':
			current_pos_in_file += 1
	elif symb == '$':
		self.wait_enter = true
		if current_file_text[current_pos_in_file] == '\n':
			current_pos_in_file += 1
	elif symb == '~':
		delay(dt)
		if current_file_text[current_pos_in_file] == '\n':
			current_pos_in_file += 1
	elif symb == '^':
		self.text_str = ""
		if current_file_text[current_pos_in_file] == '\n':
			current_pos_in_file += 1
	elif symb == '\\':
		symb = self.read_file()
		self.text_str += symb
	elif symb == '|':
		command_section()
	else:
		self.text_str += symb
	
	update()

func draw_text():
	var pos = self.text_pos
	for i in self.text_str:
		draw_string(self.text_fnt, pos, i, self.text_clr)
		if i == '\n':
			pos.y += self.text_csv
			pos.x = self.text_pos.x
		else:
			pos.x += self.text_csh

func draw_name():	
	draw_string(self.name_fnt, self.name_pos, self.name_str, self.name_clr)

func draw_choice():
	var pos = self.ch_p
	var cnt = 0
	for i in self.ch_t:
		if self.ch_cur == cnt:
			i = '>' + i 
		draw_string(self.text_fnt, pos, i, self.text_clr)
		pos.y += self.text_csv
		cnt += 1

func make_choice():
	if self.ch_mkd == false:
		if Input.is_key_pressed(KEY_UP) and self.ch_prsd == false:
			if self.ch_cur == 0:
				self.ch_cur = len(self.ch_rt) - 1
			else:
				self.ch_cur -= 1
			self.ch_prsd = true
		elif Input.is_key_pressed(KEY_DOWN) and self.ch_prsd == false:
			if self.ch_cur == len(self.ch_rt) - 1:
				self.ch_cur = 0
			else:
				self.ch_cur += 1
			self.ch_prsd = true
		elif Input.is_key_pressed(KEY_ENTER):
			self.ch_mkd = true
		elif Input.is_key_pressed(KEY_UP) == false and Input.is_key_pressed(KEY_DOWN) == false:			
			self.ch_prsd = false
			
func draw_characters():
	for i in character_list:
		if i.vis or i.c_ch:
			if i.c_delete:
				if i.c_mod.a > 0:
					i.c_mod.a -= 0.05
					if i.c_mod.a < 0:
						i.c_mod = Color(1, 1, 1, 0)
					draw_texture(i.character.get_texture(), i.pos, i.c_mod)
				else:
					i.c_delete = false
					i.vis = false
					draw_texture(i.character.get_texture(), i.pos, i.c_mod)
					if i.c_ch:
						i.character.set_texture(load(i.texture_list[i.c_nt]))
						i.c_ch = false
						i.c_add = true
						i.vis = true
			elif i.c_add:
				if i.c_mod.a < 1:
					i.c_mod.a += 0.05
					if(i.c_mod.a > 1):
						i.c_mod = Color(1, 1, 1, 1)
					draw_texture(i.character.get_texture(), i.pos, i.c_mod)
				else:
					i.c_add = false
					draw_texture(i.character.get_texture(), i.pos, i.c_mod)
			else:
				draw_texture(i.character.get_texture(), i.pos, self.bgm)
			
func _draw():	
	if self.bg_b == false and self.bg_l == true and self.bg_c == true:
		self.bg.set_texture(load(bg_list[bgid]))
		self.bg_c = false
	if bg_b:
		delay(bgsp)
		if self.bgm.r > 0:
			self.bgm.r -= 0.01
			self.bgm.g -= 0.01
			self.bgm.b -= 0.01
		else:
			self.bg_b = false
			self.bgm = Color(0, 0, 0, 1)
		draw_texture(self.bg.texture, Vector2.ZERO, self.bgm)
		draw_characters()
	elif self.bg_l:
		delay(self.bgsp)
		if self.bgm.r < 1.0:
			self.bgm.r += 0.01
			self.bgm.g += 0.01
			self.bgm.b += 0.01
		else:
			self.bg_l = false
			self.bgm = Color(1, 1, 1, 1)
		draw_texture(self.bg.texture, Vector2.ZERO, self.bgm)
		draw_characters()
	else:
		draw_texture(self.bg.texture, Vector2.ZERO, self.bgm)
		draw_characters()
	if not self.bg_b and not self.bg_l:
		if self.wait_enter:
			draw_wait_symbol()
		draw_text()
		draw_name()
		if self.sh_c:
			draw_choice()

func command_section():	
	var ch = self.read_file()
	var com_id = ""
	while ch != '|':
		com_id += ch
		ch = self.read_file()
	
	if com_id == "0":		
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == '0':
			var x = ""
			var y = ""
			ch = self.read_file()
			while ch != ',':
				x += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				y += ch
				ch = self.read_file()
			self.text_pos.x = int(x)
			self.text_pos.y = int(y)
		elif com_id == '1':
			var x = ""
			var y = ""
			ch = self.read_file()
			while ch != ',':
				x += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				y += ch
				ch = self.read_file()
			self.name_pos.x = int(x)
			self.name_pos.y = int(y)
		elif com_id == '2': #argb
			var nclr = ""
			ch = self.read_file()
			while ch != '|':
				nclr += ch
				ch = self.read_file()
			self.text_clr = Color(nclr)
		elif com_id == '3':
			var nclr = ""
			ch = self.read_file()
			while ch != '|':
				nclr += ch
				ch = self.read_file()
			self.name_clr = Color(nclr)
		elif com_id == '4':
			var f_id = ""
			var f_s = ""
			ch = self.read_file()
			while ch != ',':
				f_id += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				f_s += ch
				ch = self.read_file()
			self.text_fnt.set_font_data(load(fonts_list[int(f_id)]))
			self.text_fnt.set_size(int(f_s))
		elif com_id == '5':
			var f_id = ""
			var f_s = ""
			ch = self.read_file()
			while ch != ',':
				f_id += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				f_s += ch
				ch = self.read_file()
			self.name_fnt.set_font_data(load(fonts_list[int(f_id)]))
			self.name_fnt.set_size(int(f_s))
		elif com_id == '6':
			var t = ""
			ch = self.read_file()
			while ch != '|':
				t += ch
				ch = self.read_file()
			self.text_str = t
		elif com_id == '7':
			var t = ""
			ch = self.read_file()
			while ch != '|':
				t += ch
				ch = self.read_file()
			self.name_str = t
		elif com_id == '8':
			var d = ""
			ch = self.read_file()
			while ch != '|':
				d += ch
				ch = self.read_file()
			self.delay_text = float(d)
		elif com_id == '9':
			var tcsh = ""
			ch = self.read_file()
			while ch != '|':
				tcsh += ch
				ch = self.read_file()
			self.text_csh = int(tcsh)
		elif com_id == 'a':
			var tcsv = ""
			ch = self.read_file()
			while ch != '|':
				tcsv += ch
				ch = self.read_file()
			self.text_csv = int(tcsv)
		elif com_id == 'b':
			var ncsh = ""
			ch = self.read_file()
			while ch != '|':
				ncsh += ch
				ch = self.read_file()
			self.name_csh = int(ncsh)
	elif com_id == "1":
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == "0":
			var bid = ""
			ch = self.read_file()
			while ch != '|':
				bid += ch
				ch = self.read_file()
			self.bg.set_texture(load(bg_list[int(bid)]))
		elif com_id == "1":
			var sp = ""
			ch = self.read_file()
			while ch != '|':
				sp += ch
				ch = self.read_file()
			self.bg_b = true
			self.bgsp = float(sp)
		elif com_id == "2":
			var sp = ""
			ch = self.read_file()
			while ch != '|':
				sp += ch
				ch = self.read_file()
			self.bg_l = true
			self.bgsp = float(sp)
		elif com_id == "3":
			var sp = ""
			ch = self.read_file()
			while ch != '|':
				sp += ch
				ch = self.read_file()
			self.bg_b = true
			self.bg_l = true
			self.bgsp = float(sp)
		elif com_id == "4":
			var sp = ""
			var bid = ""
			ch = self.read_file()
			while ch != ',':
				sp += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				bid += ch
				ch = self.read_file()
			self.bg_b = true
			self.bg_l = true
			self.bg_c = true
			self.bgsp = float(sp)
			self.bgid = int(bgid)
	elif com_id == "2":
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == "0":
			var cid = ""
			var tid = ""
			var xp = ""
			var yp = ""
			ch = self.read_file()
			while ch != ',':
				cid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				tid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				xp += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				yp += ch
				ch = self.read_file()
			self.character_list[int(cid)].character.set_texture(load(self.character_list[int(cid)].texture_list[int(tid)]))
			self.character_list[int(cid)].pos = Vector2(int(xp), int(yp))
			self.character_list[int(cid)].vis = true
			self.character_list[int(cid)].c_add = true
		elif com_id == "1":
			var cid = ""
			ch = self.read_file()
			while ch != '|':
				cid += ch
				ch = self.read_file()
			if cid == "-1":
				for i in self.character_list:
					i.c_delete = true
			else:
				self.character_list[int(cid)].c_delete = true
		elif com_id == "2":
			var cid = ""
			ch = self.read_file()
			while ch != '|':
				cid += ch
				ch = self.read_file()
			if cid == "-1":
				for i in self.character_list:
					i.c_add = true
					i.vis = true
			else:
				self.character_list[int(cid)].c_add = true
				self.character_list[int(cid)].vis = true
		elif com_id == "3":
			var cid = ""
			var tid = ""
			ch = self.read_file()
			while ch != ',':
				cid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				tid += ch
				ch = self.read_file()
			self.character_list[int(cid)].c_delete = true
			self.character_list[int(cid)].c_ch = true
			self.character_list[int(cid)].c_nt = int(tid)
	elif com_id == "3":
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == "0":
			var noc = ""
			var xp = ""
			var yp = ""
			var tx = []
			var rt = []
			ch = self.read_file()
			while ch != ',':
				noc += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				xp += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				yp += ch
				ch = self.read_file()
			ch = self.read_file()
			for i in range(0, int(noc)):
				var t = ""
				while ch != ';':
					t += ch
					ch = self.read_file()
				ch = self.read_file()
				tx += [t]
			for i in range(0, int(noc)):
				var n = ""
				while ch != ',' and ch != '|':
					n += ch
					ch = self.read_file()
				ch = self.read_file()
				rt += [n]
			self.ch_cur = 0
			self.ch_mkd = false
			self.ch_p = Vector2(int(xp), int(yp))
			self.ch_t = tx
			self.ch_rt = rt
			self.sh_c = true
	elif com_id == "t":
		var tid = ""
		ch = self.read_file()
		while ch != '|':
			tid += ch
			ch = self.read_file()
		self.current_file_text = self.current_file_text.insert(self.current_pos_in_file, self.vars[int(tid)])
	elif com_id == "n":
		var tid = ""
		ch = self.read_file()
		while ch != '|':
			tid += ch
			ch = self.read_file()
		self.name_str = self.vars[int(tid)] 
	if current_file_text[current_pos_in_file] == '\n':
		current_pos_in_file += 1
