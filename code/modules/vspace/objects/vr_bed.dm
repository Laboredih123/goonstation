/obj/machinery/sim/vr_bed
	name = "VR simulation pod"
	desc = "An advanced pod that lets the user enter V-Space"
	icon = 'icons/misc/simroom.dmi'
	icon_state = "vrbed"//_0"
	anchored = ANCHORED
	density = 1
	deconstruct_flags = DECON_MULTITOOL
	machine_registry_idx = MACHINES_SIM
	var/active = 0
	var/internal_id = 0
	var/network = "none"
	var/mob/living/con_user = null
	var/mob/occupant = null
	var/image/image_lid = null
	var/time = 30
	var/timing = 0
	var/last_tick = 0
	//var/emagged = 0

/obj/machinery/sim/vr_bed/New()
	..()
	src.UpdateIcon()

/obj/machinery/sim/vr_bed/disposing()
	go_out()
	. = ..()


/obj/machinery/sim/vr_bed/update_icon()
	ENSURE_IMAGE(src.image_lid, src.icon, "lid[!isnull(occupant)]")
	src.UpdateOverlays(src.image_lid, "lid")

/obj/machinery/sim/vr_bed/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		if (!ismob(G.affecting))
			return
		if (src.occupant)
			boutput(user, SPAN_NOTICE("<B>The VR pod is already occupied!</B>"))
			return
		if(..())
			return
		var/dat = "<HTML><BODY><TT><B>VR pod timer</B>"
		src.add_dialog(user)
		var/d2
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Timed</A><br>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time</A><br>", src)
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		dat += text("<br><HR><br>Timer System: [d2]<br>Time Left: [(minute ? text("[minute]:") : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-5'>-</A> <A href='?src=\ref[src];tp=5'>+</A> <A href='?src=\ref[src];tp=30'>+</A>")
		dat += text("<BR><BR><A href='?action=mach_close&window=computer'>Close</A></TT></BODY></HTML>")
		user.Browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")

		if (G)
			src.log_in(G.affecting)
			qdel(G)
		src.add_fingerprint(user)
		return

/obj/machinery/sim/vr_bed/proc/log_in(mob/M as mob)
	if (src.occupant && !isobserver(M))
		if(M == src.occupant)
			return src.go_out()
		boutput(M, SPAN_NOTICE("<B>The VR pod is already occupied!</B>"))
		return

	if (!iscarbon(M) && !isobserver(M))
		boutput(M, SPAN_NOTICE("<B>You cannot possibly fit into that!</B>"))
		return

	if (!isobserver(M) || isAIeye(M))
		M.set_loc(src)
		M.network_device = src
		//M.verbs += /mob/proc/jack_in
		src.occupant = M
		src.con_user = M
		src.active = 1
	/*
	if(src.emagged)
		boutput(M, "You feel a terrible pain in your head, and everything goes black...")
		M.paralysis += 5
		sleep(0.5 SECONDS)
		M.set_loc(pick(mazewarp))
		return
	*/
	Station_VNet.Enter_Vspace(M, src, src.network)
	for(var/obj/O in src)
		O.set_loc(src.loc)
	src.UpdateIcon()
	return

/obj/machinery/sim/vr_bed/Click(location,control,params)
	var/lpm = params2list(params)
	if(isobserver(usr) && !lpm["ctrl"] && !lpm["shift"] && !lpm["alt"] && alert("Are you sure you want to enter VR?","Are you sure?","Yes","No") == "Yes")
		src.move_inside()
	else return ..()

/obj/machinery/sim/vr_bed/verb/move_inside()
	set src in oview(1)
	set category = "Local"

	if (!Station_VNet) return

	if (is_incapacitated(usr) && !isobserver(usr))
		return
	src.log_in(usr)
	src.add_fingerprint(usr)
	if (!isobserver(usr))
		playsound(src, 'sound/machines/sleeper_close.ogg', 50, 1)
	return

/obj/machinery/sim/vr_bed/MouseDrop_T(mob/living/target, mob/user)
	if (BOUNDS_DIST(user, src) > 0 || !in_interact_range(src,user)) return
	if (target == user)
		move_inside()

/obj/machinery/sim/vr_bed/verb/move_eject()
	set src in oview(1)
	set category = "Local"
	if (!isalive(usr) || usr.getStatusDuration("stunned") !=0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/sim/vr_bed/relaymove(mob/user as mob, dir)
	if (user == src.occupant && (user.canmove))
		src.go_out()
		add_fingerprint(user)
		return

	return

/obj/machinery/sim/vr_bed/remove_air(amount)
	return src.loc.remove_air(amount)

/obj/machinery/sim/vr_bed/attack_hand(var/mob/user)
	if(..()) // TODO: TGUI
		return
	var/dat = "<HTML><BODY><TT><B>VR pod timer</B>"
	src.add_dialog(user)
	var/d2
	if (src.timing)
		d2 = text("<A href='?src=\ref[];time=0'>Stop Timed</A><br>", src)
	else
		d2 = text("<A href='?src=\ref[];time=1'>Initiate Time</A><br>", src)
	var/second = src.time % 60
	var/minute = (src.time - second) / 60
	dat += text("<br><HR><br>Timer System: [d2]<br>Time Left: [(minute ? text("[minute]:") : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-5'>-</A> <A href='?src=\ref[src];tp=5'>+</A> <A href='?src=\ref[src];tp=30'>+</A>")
	dat += text("<BR><BR><A href='?action=mach_close&window=computer'>Close</A></TT></BODY></HTML>")
	user.Browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	src.add_fingerprint(user)
	return

/obj/machinery/sim/vr_bed/proc/go_out()
	for(var/obj/O in src)
		O.set_loc(get_turf(src.loc))
	src.occupant?.set_loc(get_turf(src.loc))
	src.occupant?.changeStatus("knockdown", 2 SECONDS)
	src.occupant?.network_device = null
	src.occupant = null
	src.active = 0
	src.con_user = null
	src.UpdateIcon()
	playsound(src, 'sound/machines/sleeper_open.ogg', 50, 1)
	return

/obj/machinery/sim/vr_bed/Exited(atom/movable/thing, newloc)
	. = ..()
	if(thing == src.occupant && (!isobserver(thing) || isAIeye(thing)))
		src.go_out()

/obj/machinery/sim/vr_bed/process()
	..()
	if (src.timing)
		if (!last_tick) last_tick = world.time
		var/passed_time = round(max(round(world.time - last_tick),10) / 10)
		if (src.time > 0)
			src.time -= passed_time
		else
			done()
			src.time = 0
			src.timing = 0
			last_tick = 0
		last_tick = world.time
	else
		last_tick = 0
	return

/obj/machinery/sim/vr_bed/proc/done()
	if(status & (NOPOWER|BROKEN))
		return
	for(var/obj/machinery/sim/vr_bed/C in machine_registry[MACHINES_SIM])
		if(!C.active)
			continue
		if(C.con_user)
			C.con_user.network_device = null
			C.active = 0
			src.go_out()

/obj/machinery/sim/vr_bed/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_interact_range(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		src.add_dialog(usr)
		if (href_list["time"])
			if(src.allowed(usr))
				src.timing = text2num_safe(href_list["time"])
		else
			if (href_list["tp"])
				if(src.allowed(usr))
					var/tp = text2num_safe(href_list["tp"])
					src.time += tp
					src.time = clamp(round(src.time), 0, 300)
		src.updateUsrDialog()
	return

/obj/machinery/sim/vr_bed/arcade
	network = "arcadevr"
