/obj/machinery/sim/cabinet
	name = "V-Space Program Cabinet"
	desc = "A large disk array that controls the active programs loaded into V-Space"
	icon = 'icons/obj/large/32x48.dmi' // TODO: Apple II disk tower sprite
	icon_state = "airack_empty"
	power_usage = 100 // Plus X per program
	/// Maximum number of disks we can have loaded into one cabinet
	var/const/MAX_DISKS = 9
	/// The associated V-Space network. Should match the goggles network.
	var/network = ""
	/// Disks pre-loaded into the cabinet
	var/list/obj/item/disk/data/floppy/vspace/preload_disks = list()
	/// Current loaded disks referenced by slot number
	var/obj/item/disk/data/floppy/vspace/current_disks[MAX_DISKS]
	/// Currently secured disks referenced by slot number
	var/list/secured_disks[MAX_DISKS]

/obj/machinery/sim/cabinet/New()
	. = ..()
	for (var/obj/item/disk/data/floppy/vspace/disk as anything in src.preload_disks)
		src.load_disk(disk, secured=TRUE)

/obj/machinery/sim/cabinet/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/disk/data/floppy/vspace))
		user.drop_item(I)
		src.load_disk(I)
	. = ..()

/obj/machinery/sim/cabinet/update_icon()
	. = ..()
	// TODO: Loaded disk overlays on cabinet

/obj/machinery/sim/cabinet/ui_data(mob/user)
	. = ..()
	for ()

/// Load a disk into the cabinet
/obj/machinery/sim/cabinet/proc/load_disk(obj/item/disk/data/floppy/vspace/disk, secured=FALSE)
	disk.loc = src
	src.current_disks += disk
	// Load allocated zone
	src.UpdateIcon()


/obj/machinery/sim/cabinet/proc/eject_disk() // TODO: i guess we need slots

/obj/machinery/sim/cabinet/arcade
	network = LANDMARK_VR_ARCADE
	preload_disks = list(
		/obj/item/disk/data/floppy/vspace/lobby,
		/obj/item/disk/data/floppy/vspace/murderbox,
	)

/obj/machinery/sim/cabinet/security
	network = LANDMARK_VR_DET_NET
	preload_disks = list(/obj/item/disk/data/floppy/vspace/detnet)

/obj/machinery/sim/cabinet/research
	network = LANDMARK_VR_BOMBTEST
	preload_disks = list(/obj/item/disk/data/floppy/vspace/bomb_test)

/obj/item/storage/vspace_disk_bin
	name = "V-Space Program Storage"
	desc = "A bin containing a bunch of V-Space Program Disks."
	// TODO: Apple II esq sprite

	anchored = ANCHORED
	var/list/obj/item/disk/data/floppy/vr/initial_disks = list(
		/obj/item/disk/data/floppy/vspace/chess,
		/obj/item/disk/data/floppy/vspace/gauntlet,
		/obj/item/disk/data/floppy/vspace/racetrack,
	)
