extends OptionButton

func initialize(input_mapper):
	for profile_index in input_mapper.profiles:
		var profile_name = input_mapper.profiles[profile_index].capitalize()
		add_item(profile_name, profile_index)

func _on_ProfilesMenu_item_selected(ID):
	InputMapper.change_profile(ID)
