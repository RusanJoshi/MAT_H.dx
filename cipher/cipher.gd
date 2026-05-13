extends Node2D
#[!] This is script needs to be moved to the 'scripts' folder for the sake of consistency.
@onready var cipher_right_label: Label = $VBoxContainer/CipherHBox/CipherRight/CipherRightLabel
@onready var indicator_right_label: Label = $VBoxContainer/IndicatorHBox/IndicatorRight/IndicatorRightLabel
@onready var detection_right_label: Label = $VBoxContainer/DetectionHBox/DetectionRight/DetectionRightLabel

var cumulative_passkey_visual: String = ""
var passkey_progress_count: int = 0
var repeating_count: int = 0
var cumulative_detection_visual: String = ""
var detection_count: int = 0

func _ready():
	print("cipher.gd... loaded")
	Events.progress_cipher_passkey.connect(progress_cipher_passkey)
	Events.update_cipher_repeating_indicator.connect(update_cipher_repeating_indicator)
	Events.restart_game.connect(restart)
	Events.cipher_ready_to_receive_passkey_actual.emit()
	Events.progress_detection_meter.connect(progress_detection_meter)

func progress_cipher_passkey(pSegCode: String):
	if(cumulative_passkey_visual.length()/2 < ConfigGame.password_length):
		cumulative_passkey_visual += pSegCode
		passkey_progress_count += 1
		win_state()
		
	cipher_right_label.text = "[" + cumulative_passkey_visual
	for hidden_count in ConfigGame.password_length-passkey_progress_count:
		cipher_right_label.text += " *"
	cipher_right_label.text += "]"

func update_cipher_repeating_indicator(pPasskeyActual: String):
	var repeating_characters: String = "!@#$%" #TODO: Scramble this
	var repeating_bar_visual: String = ""
	var unique_characters_array: Array[String] = []
	var is_unique: bool
	
	for alfa_count in pPasskeyActual.length():
		is_unique = true
		for bravo_count in unique_characters_array.size():
			if(pPasskeyActual[alfa_count] == unique_characters_array[bravo_count]):
				is_unique = false
				break
		if(is_unique):
			unique_characters_array.append(pPasskeyActual[alfa_count])
	
	for repeating_count_alfa in unique_characters_array.size():
		for repeating_count_bravo in pPasskeyActual.length():
			if(unique_characters_array[repeating_count_alfa] == pPasskeyActual[repeating_count_bravo]):
				if(repeating_bar_visual.length() == 8):
					repeating_bar_visual += repeating_characters[repeating_count_alfa]
				else: repeating_bar_visual += repeating_characters[repeating_count_alfa] + " "
	indicator_right_label.text = "[" + repeating_bar_visual + "]"

func progress_detection_meter():
	if(detection_count < 5):
		if(detection_count == 0): cumulative_detection_visual += "X"
		else: cumulative_detection_visual += "-X"
		detection_count += 1
	
	if(detection_count == 5):
		lose_state()
	
	# UPDATE VISUAL
	detection_right_label.text = "[" + cumulative_detection_visual
	for visual_count in ConfigGame.password_length-detection_count:
		detection_right_label.text += " -"
	detection_right_label.text += "]"

func win_state():
	print("cipher.gd, WIN")
	if(passkey_progress_count == 5):
		print(detection_count)
		if(detection_count == 0):
			Events.perfect_game.emit()
		Events.victory_event.emit()
	elif(passkey_progress_count >= 5):
		print("[DEBUG, win_state(), cipher.gd] INVALID passkey_progress_count VALUE. (>5) \nOBSERVE, RECORD, DEBUG")

func lose_state():
	print("cipher.gd, LOSE")
	Events.lose_event.emit()

func restart():
	print("Cipher restarting...")
	cumulative_passkey_visual = ""
	passkey_progress_count = 0
	repeating_count = 0
	cumulative_detection_visual = ""
	detection_count = 0
	
	cipher_right_label.text = "[* * * * *]"
	indicator_right_label.text = "[- - - - -]"
	detection_right_label.text = "[- - - - -]"
	
	Events.cipher_ready_to_receive_passkey_actual.emit()
