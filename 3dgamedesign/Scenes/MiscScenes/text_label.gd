extends Label

@export var min_font_size: int = 25
@export var max_font_size: int = 100
@export var reference_resolution: Vector2 = Vector2(1920, 1080)
@export var scale_factor: float = 1.0

func _ready():
	set_anchors_preset(Control.PRESET_CENTER)
	get_tree().root.size_changed.connect(_on_window_size_changed)
	
	_update_font_size()

func _on_window_size_changed():
	_update_font_size()

func _update_font_size():
	var viewport_size = get_viewport_rect().size
	
	var scale_x = viewport_size.x / reference_resolution.x
	var scale_y = viewport_size.y / reference_resolution.y
	var scale = min(scale_x, scale_y) * scale_factor
	
	var base_font_size = 35
	var new_font_size = int(base_font_size * scale)
	
	new_font_size = clamp(new_font_size, min_font_size, max_font_size)
	
	add_theme_font_size_override("font_size", new_font_size)
