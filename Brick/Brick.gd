extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

var color_index = 0
var color_distance = 0
var color_completed = true

export var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO
var rect_initial_rotation = 0
	
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
	randomize()
	var starting = randf()*2
	if starting >1 :
		position.x = 1124
	else:
		position.x = -100
	position.y = new_position.y
	$Tween.interpolate_property(self, 'position', position, new_position, 0.5 + randf()*1.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()
	if score >= 100: color_index = 0
	elif score >= 90: color_index = 1
	elif score >= 80: color_index = 2
	elif score >= 70: color_index = 3
	elif score >= 60: color_index = 4
	elif score >= 50: color_index = 5
	elif score >= 40: color_index = 6
	else: color_index = 7
	$ColorRect.color = colors[color_index]
	sway_initial_position = $ColorRect.rect_position


	
func _physics_process(_delta):
	if dying and not $Tween.is_active():
		queue_free()
	elif not $Tween.is_active() and not get_tree().paused:
		color_distance = Global.color_position.distance_to(global_position)  / 100
		if Global.color_rotate >= 0:
			$ColorRect.color = colors[(int(floor(color_distance + Global.color_rotate))) % len(colors)]
			color_completed = false
		elif not color_completed:
			$ColorRect.color = colors[color_index]
			color_completed = true
	var pos_y = 0
	var wave_angle = 0
	if self.color_index%2 == 0:
		pos_y = (cos(Global.sway_index)*(sway_amplitude))
		wave_angle = (sin(Global.sway_index)*(sway_amplitude/1.5))
	else :
		pos_y = (cos(Global.sway_index+PI)*(sway_amplitude))
		wave_angle = (sin(Global.sway_index+PI)*(sway_amplitude/1.5))
	$ColorRect.rect_position = Vector2(sway_initial_position.x, sway_initial_position.y + pos_y)
	$ColorRect.rect_rotation = rect_initial_rotation + wave_angle
	
func hit(_ball):
	var brick_sound = get_node_or_null('/root/Game/Brick_Sound')
	if brick_sound != null :
		brick_sound.play()
	Global.color_rotate = Global.color_rotate_amount
	Global.color_position = _ball.global_position
	die()

func die():
	dying = true
	collision_layer = 0
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	$Tween.interpolate_property(self, 'position', position, Vector2(position.x, -100), (700-position.y)/500,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, 'scale', scale, scale*3, (700-position.y)/500,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, 'color:a', $ColorRect.color.a, 0, (700-position.y)/800,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
