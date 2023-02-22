extends KinematicBody2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02
var time_bounce = 0.75

func _ready():
	width = $CollisionShape2D.get_shape().get_extents().x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	position = target
	for c in $Powerups.get_children():
		c.payload()
	if $Images/Highlight.modulate.a > 0 :
		$Images/Highlight.modulate.a -= 0.01
	var ball_container = get_node_or_null('/root/Game/Ball_Container')
	if ball_container != null and ball_container.get_child_count() > 0 :
		var ball = ball_container.get_child(0)
		$Eye1/Pupil/Sprite.position.x = 7
		$Eye2/Pupil/Sprite.position.x = 7
		$Eye1/Pupil.look_at(ball.position)
		$Eye2/Pupil.look_at(ball.position)
		var d = ((($Mouth.global_position.y - ball.global_position.y)/Global.VP.y)-0.2)*2
		d = clamp(d, -1, 1)
		$Mouth.scale.y = d
	else:
		$Eye1/Pupil/Sprite.position.x = 0
		$Eye2/Pupil/Sprite.position.x = 0
		$Mouth.scale.y = 1
	if Global.feverish :
		$Stars.emitting = true

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	$Images/Highlight.modulate.a = 1
	$Tween.interpolate_property($Images/Sprite, "position:y", 30, 10, time_bounce, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.interpolate_property($Images/Highlight, "position:y", 30, 10, time_bounce, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	var paddle_sound = get_node_or_null('/root/Game/Paddle_Sound')
	if paddle_sound != null :
		paddle_sound.play()


func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
