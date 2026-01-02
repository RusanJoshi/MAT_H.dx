extends Node

func _ready():
	print("events.gd... loaded")

signal cell_clicked(pSegCode: String)
signal progress_cipher_passkey(pSegCode: String)
signal update_cipher_repeating_indicator(pPasskeyActual: String)
signal cipher_ready_to_receive_passkey_actual # Emitted when the cipher scene is ready for the matrix scene to send the passkey_actual over.
signal progress_detection_meter
signal victory_event
signal restart_game
