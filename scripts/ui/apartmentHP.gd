extends ProgressBar


func _physics_process(_delta):
	self.value = disasterHandler.currentApartmentHP
	self.max_value = disasterHandler.maxApartmentHP
