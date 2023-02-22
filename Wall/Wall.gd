extends StaticBody2D

var decay = 0.01

var colors = [
	Color8(174,62,201)
	,Color8(122,72,232)
	,Color8(66,99,235)
	,Color8(28,126,214)
	,Color8(16,152,173)
	,Color8(12,166,120)
	,Color8(81,207,102)
	,Color8(134,142,150)
]

func _ready():
	pass

func _physics_process(_delta):
	if $ColorRect.color.s > 0:
		$ColorRect.color.s -= decay
	if $ColorRect.color.v < 1:
		$ColorRect.color.v += decay

func hit(_ball):
	var wall_sound = get_node_or_null('/root/Game/Wall_Sound')
	if wall_sound != null :
		wall_sound.play()
	$ColorRect.color = colors[Global.wall_color_index%8]
	Global.wall_color_index += 1
	
