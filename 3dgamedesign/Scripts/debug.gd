extends PanelContainer

@onready var property_container = %VBoxContainer

var frames_per_second: String

func _ready() -> void:
	Global.debug = self
	
	visible = false

func _process(delta: float) -> void:
	frames_per_second = "%.2f" % (1.0/delta)
	
	Global.debug.add_property("FPS", frames_per_second, 1)
		
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible
		
func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
