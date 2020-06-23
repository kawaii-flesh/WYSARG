extends Sprite

class_name WYSAR

var wc = preload("res://WYSAR_Character.gd")

var current_file: File = File.new()
var current_file_text: String = ""
var current_pos_in_file: int = 0

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
var choice_t: PoolStringArray = []
var choice_rt: PoolStringArray = []
var choice_p: Vector2 = Vector2.ZERO
var choice_cur: int = 0
var choice_mkd: bool = false
var choice_prsd: bool = false

var sound: AudioStreamPlayer = AudioStreamPlayer.new()
var sound_lp: bool = false
var sound_dl = 0
var sound_stp: bool = false
var sound_str: bool = false 
var sound_vl: float = 0.0
var music: AudioStreamPlayer = AudioStreamPlayer.new()
var music_lp: bool = false
var music_dl = 0
var music_stp = false
var music_str: bool = false 
var music_vl: float = 0.0

func _init(stf: String, bgs: PoolStringArray, fnts: PoolStringArray, sn: PoolStringArray, ms: PoolStringArray, cha, vb: PoolStringArray):
	self.bg_list = bgs
	self.fonts_list = fnts
	self.sound_list = sn
	self.music_list = ms
	self.character_list = cha
	for i in self.character_list:
		self.add_child(i)
	self.add_child(sound)
	sound.connect("finished", self, "sound_loop")
	self.add_child(music)
	music.connect("finished", self, "music_loop")
	self.centered = false
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

var key_enter_prs = false
var key_enter_rel = true
func _input(event):
	if wait_enter:
		if Input.is_key_pressed(KEY_ENTER):
			key_enter_prs = true
			key_enter_rel = false
		else:
			key_enter_rel = true
		if key_enter_prs and key_enter_rel:
			wait_enter = false
			if clear_text:
				text_str = ""
			key_enter_prs = false
			key_enter_rel = false

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
	if self.sound_stp and not self.sound_str:
		delay(sound_dl)
		if self.sound.get_volume_db() >= -60:
			self.sound.volume_db -= 2
		else:
			self.sound_stp = false
			self.sound_lp = false
			self.sound.stop()
	elif self.sound_str and not self.sound_stp:
		delay(sound_dl)
		if self.sound.get_volume_db() + 2 < self.sound_vl:
			self.sound.volume_db += 2
		else:
			self.sound_str = false
			self.sound.set_volume_db(self.sound_vl)
			
	if self.music_stp and not self.music_str:
		delay(music_dl)
		if self.music.get_volume_db() >= -60:
			self.music.volume_db -= 2
		else:
			self.music_stp = false
			self.music_lp = false
			self.music.stop()
	elif self.music_str and not self.music_stp:
		delay(music_dl)
		if self.music.get_volume_db() + 2 < self.music_vl:
			self.music.volume_db += 2
		else:
			self.music_str = false
			self.music.set_volume_db(self.sound_vl)
			
	if self.sh_c and self.choice_mkd == false:
		make_choice()
		update()
		return
	if self.choice_mkd:
		choice_action(self.choice_rt[self.choice_cur])
		self.choice_mkd = false
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

func sound_loop():
	if self.sound_lp:
		self.sound.play()

func music_loop():
	if self.music_lp:
		self.music.play()

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
	var pos = self.choice_p
	var cnt = 0
	for i in self.choice_t:
		if self.choice_cur == cnt:
			i = '>' + i 
		draw_string(self.text_fnt, pos, i, self.text_clr)
		pos.y += self.text_csv
		cnt += 1

func make_choice():
	if self.choice_mkd == false:
		if Input.is_key_pressed(KEY_UP) and self.choice_prsd == false:
			if self.choice_cur == 0:
				self.choice_cur = len(self.choice_rt) - 1
			else:
				self.choice_cur -= 1
			self.choice_prsd = true
		elif Input.is_key_pressed(KEY_DOWN) and self.choice_prsd == false:
			if self.choice_cur == len(self.choice_rt) - 1:
				self.choice_cur = 0
			else:
				self.choice_cur += 1
			self.choice_prsd = true
		elif Input.is_key_pressed(KEY_ENTER):
			self.choice_mkd = true
		elif Input.is_key_pressed(KEY_UP) == false and Input.is_key_pressed(KEY_DOWN) == false:			
			self.choice_prsd = false
			
func draw_characters():
	if len(character_list) == 0:
		return
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

func draw_bg_b():
	delay(bgsp)
	if self.bgm.r > 0:
		self.bgm.r -= 0.01
		self.bgm.g -= 0.01
		self.bgm.b -= 0.01
	else:
		self.bg_b = false
		self.bgm = Color(0, 0, 0, 1)
	draw_texture(self.texture, Vector2.ZERO, self.bgm)
	draw_characters()
		
func draw_bg_l():
	delay(self.bgsp)
	if self.bgm.r < 1.0:
		self.bgm.r += 0.01
		self.bgm.g += 0.01
		self.bgm.b += 0.01
	else:
		self.bg_l = false
		self.bgm = Color(1, 1, 1, 1)
	draw_texture(self.texture, Vector2.ZERO, self.bgm)
	draw_characters()
	
func _draw():
	if self.get_texture() == null:
		return
	if self.bg_b == false and self.bg_l == true and self.bg_c == true:
		self.set_texture(load(bg_list[bgid]))
		self.bg_c = false
	if bg_b:
		draw_bg_b()
	elif self.bg_l:
		draw_bg_l()
	else:
		draw_texture(self.texture, Vector2.ZERO, self.bgm)
		draw_characters()
		
	if not self.bg_b and not self.bg_l:		
		draw_text()
		draw_name()
		if self.wait_enter:
			draw_wait_symbol()
		else:
			fr = 0
			cfr = 4
			fir_s = true
			fir_c = false
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
			self.set_texture(load(bg_list[int(bid)]))
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
			self.choice_cur = 0
			self.choice_mkd = false
			self.choice_p = Vector2(int(xp), int(yp))
			self.choice_t = tx
			self.choice_rt = rt
			self.sh_c = true
	elif com_id == "4":
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == "0":
			var sid = ""
			var lp = ""
			var vl = ""
			ch = self.read_file()
			while ch != ',':
				sid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				lp += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				vl += ch
				ch = self.read_file()
			self.sound_lp = false
			self.sound.stop()
			self.sound.set_stream(load(self.sound_list[int(sid)]))
			self.sound.set_volume_db(float(vl))
			self.sound_lp = bool(int(lp))
			self.sound.play()
		elif com_id == "1":
			self.sound.stream_paused = true
			ch = self.read_file()
		elif com_id == "2":
			self.sound.stream_paused = false
			ch = self.read_file()
		elif com_id == "3":
			var vl = ""
			ch = self.read_file()
			while ch != '|':
				vl += ch
				ch = self.read_file()
			self.sound.set_volume_db(float(vl))
		elif com_id == "4":
			var dl = ""
			ch = self.read_file()
			while ch != '|':
				dl += ch
				ch = self.read_file()
			sound_dl = int(dl)
			sound_stp = true
		elif com_id == "5":
			var sid = ""
			var dl = ""
			var vl = ""
			var lp = ""
			ch = self.read_file()
			while ch != ',':
				sid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				dl += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				vl += ch
				ch = self.read_file()
			while ch != '|':
				lp += ch
				ch = self.read_file()
			ch = self.read_file()
			self.sound_lp = false
			self.sound.stop()
			self.sound_dl = int(dl)
			self.sound_vl = float(vl)
			self.sound_str = true
			self.sound.set_volume_db(-60)
			self.sound.set_stream(load(self.sound_list[int(sid)]))
			self.sound_lp = bool(int(lp))
			self.sound.play()
	elif com_id == "5":
		com_id = ""
		ch = self.read_file()
		while ch != '|':
			com_id += ch
			ch = self.read_file()
		if com_id == "0":
			var sid = ""
			var lp = ""
			var vl = ""
			ch = self.read_file()
			while ch != ',':
				sid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				lp += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != '|':
				vl += ch
				ch = self.read_file()
			self.music_lp = false
			self.music.stop()
			self.music.set_stream(load(self.music_list[int(sid)]))
			self.music.set_volume_db(float(vl))
			self.music_lp = bool(int(lp))
			self.music.play()
		elif com_id == "1":
			self.music.stream_paused = true
			ch = self.read_file()
		elif com_id == "2":
			self.music.stream_paused = false
			ch = self.read_file()
		elif com_id == "3":
			var vl = ""
			ch = self.read_file()
			while ch != '|':
				vl += ch
				ch = self.read_file()
			self.music.set_volume_db(float(vl))
		elif com_id == "4":
			var dl = ""
			ch = self.read_file()
			while ch != '|':
				dl += ch
				ch = self.read_file()
			music_dl = int(dl)
			music_stp = true
		elif com_id == "5":
			var sid = ""
			var dl = ""
			var vl = ""
			var lp = ""
			ch = self.read_file()
			while ch != ',':
				sid += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				dl += ch
				ch = self.read_file()
			ch = self.read_file()
			while ch != ',':
				vl += ch
				ch = self.read_file()
			while ch != '|':
				lp += ch
				ch = self.read_file()
			ch = self.read_file()
			self.music_lp = false
			self.music.stop()
			self.music_dl = int(dl)
			self.music_vl = float(vl)
			self.music_str = true
			self.music.set_volume_db(-60)
			self.music.set_stream(load(self.music_list[int(sid)]))
			self.music_lp = bool(int(lp))
			self.music.play()
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
		
	
func save_g(fn:String):
	var save_game = File.new()
	save_game.open(fn, File.WRITE)
	save_game.store_line(current_file.get_path())
	save_game.store_line(String(current_pos_in_file))
	save_game.store_line(text_str)
	save_game.store_line(name_str)
	if text_fnt.get_font_data() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(text_fnt.get_font_data().get_font_path())
	if name_fnt.get_font_data() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(name_fnt.get_font_data().get_font_path())
	save_game.store_line(String(text_pos))
	save_game.store_line(String(name_pos))
	save_game.store_line(text_clr.to_html())
	save_game.store_line(name_clr.to_html())
	save_game.store_line(String(text_csh))
	save_game.store_line(String(text_csv))
	save_game.store_line(String(name_csh))
	save_game.store_line(String(delay_text))
	save_game.store_line(String(int(vis_text)))
	save_game.store_line(String(int(vis_name)))
	
	save_game.store_line(String(int(wait_enter)))
	save_game.store_line(String(int(clear_text)))

	save_game.store_line(String(bg_list))
	save_game.store_line(String(fonts_list))
	save_game.store_line(String(sound_list))
	save_game.store_line(String(music_list))
	save_game.store_line(String(vars))

	save_game.store_line(String(int(bg_b)))
	save_game.store_line(String(int(bg_l)))
	save_game.store_line(String(int(bg_c)))
	save_game.store_line(String(bgsp))
	save_game.store_line(String(bgid))
	save_game.store_line(bgm.to_html())

	save_game.store_line(String(int(sh_c)))
	save_game.store_line(String(choice_t))
	save_game.store_line(String(choice_rt))
	save_game.store_line(String(choice_p))
	save_game.store_line(String(choice_cur))
	save_game.store_line(String(int(choice_mkd)))
	save_game.store_line(String(int(choice_prsd)))
	
	if sound.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(sound.get_stream().get_path())
	if sound.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(sound.get_volume_db()))
	if sound.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(sound.get_playback_position()))
	if sound.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(int(sound.get_stream_paused())))
	save_game.store_line(String(int(sound_lp)))
	save_game.store_line(String(sound_dl))
	save_game.store_line(String(int(sound_stp)))
	save_game.store_line(String(int(sound_str)))
	save_game.store_line(String(sound_vl))
	if music.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(music.get_stream().get_path())
	if music.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(music.get_volume_db()))
	if music.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(music.get_playback_position()))
	if music.get_stream() == null:
		save_game.store_line("-")
	else:
		save_game.store_line(String(int(music.get_stream_paused())))
	save_game.store_line(String(int(music_lp)))
	save_game.store_line(String(music_dl))
	save_game.store_line(String(int(music_stp)))
	save_game.store_line(String(int(music_str)))
	save_game.store_line(String(music_vl))
	
	save_game.store_line(String(time))
	save_game.store_line(String(int(key_enter_prs)))
	save_game.store_line(String(int(key_enter_rel)))
	
	save_game.store_line(String(fr))
	save_game.store_line(String(cfr))
	save_game.store_line(String(int(fir_s)))
	save_game.store_line(String(int(fir_c)))
	
	save_game.store_line(String(len(character_list)))
	for i in character_list:
		if i.character.get_texture() == null:
			save_game.store_line("-")
		else:
			save_game.store_line(i.character.get_texture().get_path())
		save_game.store_line(String(i.texture_list))
		save_game.store_line(String(i.pos))
		save_game.store_line(String(int(i.vis)))
		save_game.store_line(String(int(i.c_add)))
		save_game.store_line(String(int(i.c_delete)))
		save_game.store_line(i.c_mod.to_html())
		save_game.store_line(String(int(i.c_ch)))
		save_game.store_line(String(i.c_nt))
	
	save_game.close()
	
func load_g(fn:String):
	var save_game = File.new()
	save_game.open(fn, File.READ)
	
	var file_pat = save_game.get_line()
	var file_pos = int(save_game.get_line())
	var text_string = save_game.get_line()
	var name_string = save_game.get_line()
	var text_font = save_game.get_line()
	var name_font = save_game.get_line()
	
	var text_position = str2pst(save_game.get_line())
	var name_position = str2pst(save_game.get_line())
	var text_color = Color(save_game.get_line())
	var name_color = Color(save_game.get_line())
	var text_chsph = int(save_game.get_line())
	var text_chspv = int(save_game.get_line())
	var name_chsph = int(save_game.get_line())
	var delay_symb = float(save_game.get_line())
	var visual_text = bool(int(save_game.get_line()))
	var visual_name = bool(int(save_game.get_line()))
	
	var wait_enterb = bool(int(save_game.get_line()))
	var clear_textb = bool(int(save_game.get_line()))

	var bkg_list = str2lst(save_game.get_line())
	var fnts_list = str2lst(save_game.get_line())
	var snd_list = str2lst(save_game.get_line())
	var msc_list = str2lst(save_game.get_line())
	var vrs_list = str2lst(save_game.get_line())
	
	var bg_bb = bool(int(save_game.get_line()))
	var bg_lb = bool(int(save_game.get_line()))
	var bg_cb = bool(int(save_game.get_line()))
	var bg_sp = float(save_game.get_line())
	var bg_id = int(save_game.get_line())
	var bg_md = Color(save_game.get_line())

	var show_choice = bool(int(save_game.get_line()))
	var choice_text = str2lst(save_game.get_line())
	var choice_return = str2lst(save_game.get_line())
	var choice_pos = str2pst(save_game.get_line())
	var choice_cur = int(save_game.get_line())
	var choice_maked = bool(int(save_game.get_line()))
	var choice_pressed = bool(int(save_game.get_line()))
	
	var snd_pat = save_game.get_line()
	var snd_vl_db = float(save_game.get_line())
	var snd_pos = float(save_game.get_line())
	var snd_stpd = bool(int(save_game.get_line()))
	var snd_lop = bool(int(save_game.get_line()))
	var snd_dl = float(bool(int(save_game.get_line())))
	var snd_need_stp = bool(int(save_game.get_line()))
	var snd_need_str = bool(int(save_game.get_line()))
	var snd_need_vl_db = float(save_game.get_line())
	
	var msc_pat = save_game.get_line()
	var msc_vl_db = float(save_game.get_line())
	var msc_pos = float(save_game.get_line())
	var msc_stpd = bool(int(save_game.get_line()))
	var msc_lop = bool(int(save_game.get_line()))
	var msc_dl = float(bool(int(save_game.get_line())))
	var msc_need_stp = bool(int(save_game.get_line()))
	var msc_need_str = bool(int(save_game.get_line()))
	var msc_need_vl_db = float(save_game.get_line())
	
	var tmn = float(save_game.get_line())
	var keprs = bool(int(save_game.get_line()))
	var kerel = bool(int(save_game.get_line()))
	
	var frame_cur = int(save_game.get_line())
	var frame_cfr = int(save_game.get_line())
	var fir_sym = bool(int(save_game.get_line()))
	var fir_clr = bool(int(save_game.get_line()))
	
	var chr_cnt = int(save_game.get_line())
	var chr_lst = []
	for i in range(0, chr_cnt):
		var texture_pat = save_game.get_line()
		var texture_lst = str2lst(save_game.get_line())
		var texture_pos = str2pst(save_game.get_line())
		var texture_visual = bool(int(save_game.get_line()))
		var texture_add = bool(int(save_game.get_line()))
		var texture_delete = bool(int(save_game.get_line()))
		var texture_mod = Color(save_game.get_line())
		var texture_chg = bool(int(save_game.get_line()))
		var texture_new_tex = int(save_game.get_line())
		chr_lst.append(WYSAR_Character.new(texture_lst))
	
	save_game.close()

func str2lst(strg: String):
	return strg.substr(1, len(strg)-2).split(", ")

func str2pst(strg: String):
	return Vector2(int(strg.substr(1, len(strg)-2).split(", ")[0]), int(strg.substr(1, len(strg)-2).split(", ")[1]))
