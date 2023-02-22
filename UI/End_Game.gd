extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Score.text = "Score: " + str(Global.score)	
