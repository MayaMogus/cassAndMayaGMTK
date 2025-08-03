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

var displayTimer := true

var timer := 0.0
