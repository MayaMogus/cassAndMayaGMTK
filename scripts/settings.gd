extends Node

var SoundFXEnabled := true
var SoundFXLevel := 1.0:
	get:
		return SoundFXLevel if SoundFXEnabled else 0.0
	set(value):
		SoundFXLevel = value

signal MusicStateChanged
var MusicEnabled := true:
	set(value):
		emit_signal("MusicStateChanged", value)
		MusicEnabled = value
var MusicLevel := 1.0:
	get:
		return MusicLevel if MusicEnabled else 0.0
	set(value):
		MusicLevel = value

var displayTimer : bool = true

var timer : float = 0
