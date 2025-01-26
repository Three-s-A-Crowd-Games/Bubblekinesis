class_name Inputable

extends Node2D

var this_was_meant := false

func input() -> void:
	this_was_meant = true

func release_input(already_handled :bool) -> bool:
	this_was_meant = false
	return false
