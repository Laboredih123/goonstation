#define DISK_SECURITY_UNSECURED 0
#define DISK_SECURITY_SECURED 1
#define DISK_SECURITY_PERMANENT 2
#define DISK_SECURITY_IN_USE 3

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
	/// Currently secured disks referenced by slot number. Uses `DISK_SECURITY_` defines.
	var/list/secured_disks[MAX_DISKS]

/obj/machinery/sim/cabinet/New()
	. = ..()
	for (var/obj/item/disk/data/floppy/vspace/disk as anything in src.preload_disks)
		src.load_disk(user=null, disk=disk, slot_num=null, secured=DISK_SECURITY_PERMANENT)

/obj/machinery/sim/disposing() // TODO: unload all programs, drop disks?
	. = ..()

/obj/machinery/sim/cabinet/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/disk/data/floppy/vspace))
		if (length(crrent_disks) >= src.MAX_DISKS)
			boutput(user, "\The [src] has no open slots for [I]!")
			return
		user.drop_item(I)
		src.load_disk(I)
	. = ..()

/obj/machinery/sim/cabinet/update_icon()
	. = ..()
	// TODO: Loaded disk overlays on cabinet

/obj/machinery/sim/cabinet/ui_data(mob/user)
	. = ..() // TODO: UI to eject disks

/// Load a disk into the cabinet
/obj/machinery/sim/cabinet/proc/load_disk(mob/user, obj/item/disk/data/floppy/vspace/disk, slot_num=null, secured=DISK_SECURITY_UNSECURED)
	var/inserted = FALSE
	var/slot_to_insert = slot_num
	if(isnull(slot_num))
		while (!inserted && slot_to_insert <= MAX_CIRCUITS)
			if (!src.current_disks[count])
				inserted = TRUE
			else
				slot_to_insert++
		if (!inserted)
			if (user)
				boutput(user,SPAN_ALERT("There's no more space on the rack!"))
			else
				CRASH("Non-mob attempted to load disk [disk] into a full [src]! This is probably a code issue!")

	disk.set_loc(src)
	src.current_disks[slot_to_insert] = disk
	src.secured_disks[slot_to_insert] = secured
	if (user)
		src.visible_message(SPAN_NOTICE("[user] loads \the [disk] into \the [src]"))

	// TODO: Load allocated zone

	src.UpdateIcon()

/// Eject a loaded, unsecured disk.
/obj/machinery/sim/cabinet/proc/eject_disk(mob/user, slot_num = null, force=FALSE)
	if (!slot_num)
		return
	switch (src.secured_disks[slot_num])
		if (DISK_SECURITY_UNSECURED)
			if(user)
				var/obj/item/disk/data/floppy/vspace/disk = src.current_disks[slot_num]
				var/mob/living/carbon/human/H = user
				if (istype(H))
					H.put_in_hand_or_eject(disk)
				else
					disk.set_loc(get_turf(src))
				src.current_disks[slot_num] = null
				src.visible_message(SPAN_ALERT("[user] removes \the [disk] from \the [src]!"))
				return
		if (DISK_SECURITY_SECURED)
			if (user)
				boutput(user, SPAN_ALERT("You can't remove \the [disk] while it's still secured!"))
		if (DISK_SECURITY_PERMANENT)
			if (user)
				boutput(user, SPAN_ALERT("You can't remove \the [disk] as it's permanently locked into \the [src]!"))
		if (DISK_SECURITY_IN_USE)
			if (user)
				boutput(user, SPAN_ALERT("You can't remove \the [disk] while it's still being used!"))

/obj/machinery/sim/cabinet/proc/secure_disk(slot_num)
	src.secured_disks[slot_num] = DISK_SECURITY_SECURED

/obj/machinery/sim/cabinet/proc/unsecure_disk

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
	spawn_contents = list(
		/obj/item/disk/data/floppy/vspace/chess,
		/obj/item/disk/data/floppy/vspace/gauntlet,
		/obj/item/disk/data/floppy/vspace/racetrack,
	)

#undef DISK_SECURITY_UNSECURED
#undef DISK_SECURITY_SECURED
#undef DISK_SECURITY_PERMANENT
#undef DISK_SECURITY_IN_USE
