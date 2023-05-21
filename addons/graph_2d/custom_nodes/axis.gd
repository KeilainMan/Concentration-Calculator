tool
extends Control

var default_font: Font

var vert_grad: Array # [[px: Vector2, text: String], ...]
var hor_grad: Array
var x_label: String
var y_label: String
var original_points: Array # [pos: Vector1, pos: Vector2...]

var _x_label = Label.new()
var _y_label = Label.new()

func _ready():
	default_font = Control.new().get_font("font")
	add_child(_x_label)
	_y_label.rect_rotation = -90
	add_child(_y_label)

func _draw() -> void:
	var topleft: Vector2 = vert_grad.front()[0]
	var topright: Vector2 = Vector2(hor_grad.back()[0].x, vert_grad.front()[0].y)
	var bottomright: Vector2 = hor_grad.back()[0]
	
	for grad in vert_grad:
		draw_line(grad[0], grad[0] - Vector2(10, 0), Color.white)
		draw_string(default_font, grad[0] + Vector2(-35, -5), grad[1])
	# draw vertical line
	draw_line(topleft, vert_grad.back()[0], Color.white)
	_y_label.text = y_label
	_y_label.rect_position = Vector2(5, (bottomright.y + topleft.y)/2)
		
	for grad in hor_grad:
		draw_set_transform(rect_position, 0, Vector2(1,1))
		draw_line(grad[0], grad[0] + Vector2(0, 10), Color.white)
		draw_set_transform(grad[0] + Vector2(0, 20), 45, Vector2(1,1))
		draw_string(default_font, rect_position, grad[1])

	# draw horizontal line
	draw_set_transform(rect_position, 0, Vector2(1,1))
	draw_line(hor_grad.front()[0], hor_grad.back()[0], Color.white)
	_x_label.text = x_label
	_x_label.rect_position = Vector2((bottomright.x + topleft.x)/2, bottomright.y + 20)
	
	

	var orig_point_position: Array = []
	for axis_relative in original_points:

		var x_position: float = ((bottomright.x - topleft.x) * axis_relative.x) + topleft.x
		var y_position: float = bottomright.y - ((bottomright.y - topleft.y) * axis_relative.y)
		orig_point_position.append(Vector2(x_position, y_position))
	# draw given points
	for point_pos in orig_point_position:
		#draw_set_transform(point_pos, 0, Vector2(1,1))
		draw_circle(point_pos, 3, Color.orange)
	
