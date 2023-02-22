extends Node2D


func _ready():
	pass

func _physics_process(_delta):
	for c in get_children() :
		c.scale *= 0.975
		if c.modulate.a > 0 :
			c.modulate.a -=.02
		else :
			c.queue_free()
		if c.scale.length() <= 0.1 :
			c.queue_free()
