extends LineEdit

func saveObject() -> Dictionary:
	var dict := {
		"filepath": get_path(),
		"savedText": text
	}
	return dict
	
func loadObject(loadedDict: Dictionary) -> void:
	text = loadedDict.savedText
