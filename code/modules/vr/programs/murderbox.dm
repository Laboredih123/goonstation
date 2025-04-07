/obj/item/disk/data/floppy/vr/murderbox
	name = "VR Program - Murderbox"

ABSTRACT_TYPE(/area/sim/gunsim)
/area/sim/gunsim
	name = "V-Space Gun Sim Zone"
	icon_state = "gunsim"

	arena
		name = "V-Space Gun Sim Arena"

	lobby
		name = "V-Space Gun Sim Lobby"
		icon_state = "gunsim-lobby"
		sanctuary = TRUE

	maintenance
		name = "V-Space Gun Sim Maintenance"
		force_fullbright = FALSE
		icon_state = "gunsim-maint"
		sanctuary = TRUE
