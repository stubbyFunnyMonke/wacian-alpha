extends OptionButton

signal initialize_finished

func initialize(input_mapper):
	InputMapper.connect('profile_changed', self, "_on_profile_changed")
	for profile_index in input_mapper.profiles:
		var profile_name = input_mapper.profiles[profile_index].capitalize()
		add_item(profile_name, profile_index)
	emit_signal("initialize_finished")

func _on_profile_changed(_input_profile, _is_customizable=false):
	yield(get_tree(), "idle_frame")
	select(InputMapper.current_profile_id)

func _on_ProfilesMenu_item_selected(ID):
	InputMapper.change_profile(ID)
