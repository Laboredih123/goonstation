
/obj/fluid_pipe/sink/inlet_pump
	name = "Inlet Pump"
	//icon = 'icons/obj/atmospherics/valve.dmi'
	//icon_state = "valve0"
	color = rgb(255,0,0)

	var/open = 0

	attack_hand(mob/user as mob)
		if(src.open)
			src.open = 0
			src.color = rgb(255,0,0)
			boutput(user, "You close the fluid pipe valve.")
		else
			src.open = 1
			src.color = rgb(0,255,0)
			boutput(user, "You open the fluid pipe valve.")

	New()
		START_TRACKING_CAT(TR_CAT_ATMOS_MACHINES)
		initialize_directions = dir
		..()

	disposing()
		STOP_TRACKING_CAT(TR_CAT_ATMOS_MACHINES)
		..()

	proc/process()
		if(!open)
			return
		var/turf/simulated/T = get_turf(src)
		if(T.active_liquid == null)
			return
		var/datum/reagents/Removed = T.active_liquid.group.suck(T.active_liquid, used_capacity)

		DEBUG_MESSAGE_VARDBG("sucked up", Removed)

		for(var/reagent_id in Removed.reagent_list)
			var/datum/reagent/current = Removed.reagent_list[reagent_id]
			src.network.reagents.add_reagent(reagent_id, current.volume, current.data, Removed.total_temperature)


/obj/fluid_pipe/source/outlet_pump
	name = "Outlet Pump"
	//icon = 'icons/obj/atmospherics/valve.dmi'
	//icon_state = "valve0"
	color = rgb(255,0,0)

	var/open = 0

	attack_hand(mob/user as mob)
		if(open)
			src.open = 0
			src.color = rgb(255,0,0)
			boutput(user, "You close the fluid pipe valve.")
		else
			src.open = 1
			src.color = rgb(0,255,0)
			boutput(user, "You open the fluid pipe valve.")

	New()
		START_TRACKING_CAT(TR_CAT_ATMOS_MACHINES)
		initialize_directions = dir
		..()

	disposing()
		STOP_TRACKING_CAT(TR_CAT_ATMOS_MACHINES)
		..()

	proc/process()
		if(!open)
			return

		var/turf/simulated/T = get_turf(src)
		src.network.reagents.trans_to(T, src.network.reagents.total_volume)
