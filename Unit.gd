extends Node2D

onready var st = $Sprite.texture

export var offset_topLeft = Vector2()
export var offset_topRight = Vector2()
export var offset_bottomLeft = Vector2()
export var offset_bottemRight = Vector2()

export var factor_topLeft = 1
export var factor_topRight  = 1
export var factor_bottomRight = 1
export var factor_bottomLeft = 1

export var y_bottomLeft = 0
export var y_bottomRight = 0

onready var last_pos = global_position

func _ready():
	set_process(true)
	

var down = false
func _process(delta):
	
	if !down:
		global_position = global_position.linear_interpolate(last_pos+Vector2(0,-20), 10 * delta)
		if(global_position.y < last_pos.y-19):
			down = true
	else:
		global_position = global_position.linear_interpolate(last_pos, 5 * delta)
		if(global_position.y > last_pos.y-1):
			down = false
	
	update()
	
func _draw():
	var gl = global_position.y - last_pos.y
	var uvs = [Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,1)]
	var p1 = Vector2(-st.get_width()/2, -st.get_height()/2) + offset_topLeft - Vector2(gl*factor_topLeft, 0)
	var p2 = Vector2(st.get_width()/2, -st.get_height()/2) + offset_topRight - Vector2(gl*factor_topRight,0)
	var p3 = Vector2(st.get_width()/2, st.get_height()/2) + offset_bottemRight - Vector2(gl*factor_bottomRight,gl*y_bottomRight)
	var p4 = Vector2(-st.get_width()/2, st.get_height()/2) + offset_bottomLeft- Vector2(gl*factor_bottomLeft,gl*y_bottomLeft)
	var points = [p1,p2,p3,p4]
	var colors = [Color(0,0,0,0.5),Color(0,0,0,0.5),Color(0,0,0,0.5),Color(0,0,0,0.5)]
	draw_primitive(points, colors, uvs, st)
