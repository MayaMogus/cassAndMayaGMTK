extends Node

var SoundFXEnabled := true
var SoundFXLevel := 1.0:
	get:
		return SoundFXLevel if SoundFXEnabled else 0.0
	set(value):
		SoundFXLevel = value

var MusicEnabled := true
var MusicLevel := 1.0:
	get:
		return MusicLevel if MusicEnabled else 0.0
	set(value):
		MusicLevel = value

var displayStageTimer := true
var displayRunTimer := true
var displaySplits := false

var autoNextStage := false

<<<<<<< HEAD
var runTimer :float=0
=======
var inMenu := true:
	set(value):
		if value:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		inMenu = value
>>>>>>> 8ca9aa55649b05340d79e8c8d636d4325737ac9f
