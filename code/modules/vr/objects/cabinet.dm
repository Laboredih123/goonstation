/obj/machinery/sim/cabinet
	name = "VR Program Cabinet"
	desc = "Controls the active programs loaded into V-Space"
	var/list/obj/item/disk/data/floppy/vr/loaded_programs = list()

/obj/machinery/sim/cabinet/proc/load_disk()
	return

/obj/machinery/sim/cabinet/proc/eject_disk()
	return

/obj/item/disk/data/floppy/vr
	name = "VR Program - Undefined"
	var/allocated_zone_file = null
