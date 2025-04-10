/obj/item/disk/data/floppy/vspace/murderbox
	name = "\improper V-Space Program - Murder Box"
	icon_state = "arcade-disk1"

ABSTRACT_TYPE(/area/sim/gunsim)
/area/sim/gunsim
	name = "V-Space Murder Box Zone"
	icon_state = "gunsim"

	arena
		name = "V-Space Murder Box Arena"

	lobby
		name = "V-Space Murder Box Lobby"
		icon_state = "gunsim-lobby"
		sanctuary = TRUE

	maintenance
		name = "V-Space Murder Box Maintenance"
		force_fullbright = FALSE
		icon_state = "gunsim-maint"
		sanctuary = TRUE
