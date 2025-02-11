/obj/machinery/devtesttestregionselector
	name = "Prefab Request Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "teleport"
	desc = "A computer that lets you pick what thing to load."
	density = TRUE
	anchored = ANCHORED

	attack_hand(mob/user)
		. = ..()
		var/list/choices = recursive_flist("assets/maps/loadabledevtest/", list_folders=FALSE)
		var/choice = tgui_input_list(user, "Choose an engine type!", "Engine Selector", choices)
		if(!choice)
			return
		var/dmm_suite/D = new/dmm_suite()
		D.read_map(file2text(choice), src.x+1, src.y, src.z, choice, DMM_OVERWRITE_MOBS | DMM_OVERWRITE_OBJS)
		for(var/turf/T as anything in block(locate(src.x+1, src.y, src.z), locate(src.x+17, src.y+16, src.z)))
			for(var/obj/O in T)
				O.initialize(FALSE)
				O.UpdateIcon()
