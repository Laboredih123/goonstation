/datum/darkfountain
	var/obj/effects/darkworldblack/outsidefountain
	var/obj/effects/fountainindarkworld/insidefountain
	var/list/darknessfields
	var/datum/allocated_region/region

	New(fountain)
		..()
		src.outsidefountain = fountain
		src.region = global.region_allocator.allocate(7, 15)
		src.region.clean_up()
		var/dmm_suite/D = new
		D.read_map(file2text("assets/maps/allocated/fountain.dmm"), region.bottom_left.x, region.bottom_left.y, region.bottom_left.z, flags = DMM_OVERWRITE_OBJS | DMM_OVERWRITE_MOBS | DMM_BESPOKE_AREAS)
		src.insidefountain = new(src.region.turf_at(4, 6), src)

	proc/send(atom/movable/AM, startfountain)
		if (ismob(AM))
			var/mob/M = AM
			M?.client.perspective = MOB_PERSPECTIVE | EDGE_PERSPECTIVE
			if (startfountain)
				animate(M.client, color = "#000000", time = 1 SECONDS)
				sleep(1 SECOND)
				M.set_loc(pick(block(src.region.turf_at(3, 2),src.region.turf_at(5, 5))))
				animate(M.client, color = "#FFFFFF", time = 1 SECONDS)


/obj/effects/darkworldblack
	name = "dark fountain"
	plane = PLANE_ABOVE_BLACKNESS
	layer = ABOVE_OBJ_LAYER
	particles = new/particles/darkworldblack
	var/instant = FALSE
	var/datum/darkfountain/parent

	New()
		..()
		src.parent = new(src)
		var/area = get_area(src)
		src.add_filter("outline", 0, outline_filter(size=2, color="#FFFFFF", flags = 0))
		var/list/L = list()
		if (instant)
			src.particles.spawning = 0
			for (var/turf/T in range(7, src))
				if (T.loc != area || !IN_EUCLIDEAN_RANGE(T, src, 7.4)) continue
				L += new /obj/overlay/darkness_field{layer = HUD_LAYER}(T, null, radius = 1.5, max_alpha = 255, timetochange = 0)
				L += new /obj/overlay/darkness_field{layer = HUD_LAYER; plane = PLANE_SELFILLUM}(T, null, radius = 1.5, max_alpha = 255, timetochange = 0)
				L += new /obj/pure_darkness(T, 0, src.parent, FALSE)
		else
			for (var/turf/T in range(7, src))
				if (T.loc != area || !IN_EUCLIDEAN_RANGE(T, src, 7.4)) continue
				L += new /obj/overlay/darkness_field{layer = HUD_LAYER}(T, null, radius = 1.5, max_alpha = 255, timetochange = GET_EUCLIDEAN_DIST(src, T) SECONDS + 2 SECONDS)
				L += new /obj/overlay/darkness_field{layer = HUD_LAYER; plane = PLANE_SELFILLUM}(T, null, radius = 1.5, max_alpha = 255, timetochange = GET_EUCLIDEAN_DIST(src, T) SECONDS + 2 SECONDS)
				L += new /obj/pure_darkness(T, GET_EUCLIDEAN_DIST(src, T) SECONDS + 2 SECONDS, src.parent, IN_RANGE(src, T, 2))
		src.parent.darknessfields = L
		SPAWN(10 SECONDS)
			src.particles.spawning = 0


/obj/effects/fountainindarkworld
	name = "dark fountain"
	icon = 'icons/effects/overlays/warp.dmi'
	icon_state = "warp_ew"
	var/datum/darkfountain/parent
	pixel_x = -224
	pixel_y = -104

	New(loc, parent)
		..()
		src.parent = parent
		src.transform = src.transform.Scale(0.25,0.65)
		src.add_filter("blur", 0, motion_blur_filter(20, 5))
		src.add_filter("color", 0, color_matrix_filter(list(2, 0, 0, 0, 1.2, 0, 0, 0, 0.33, 0, -0.2, 0)))
		var/filter = src.get_filter("blur")
		animate(filter, x = 10, time = 2 SECONDS, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
		animate(x = -10, time = 2 SECONDS, loop = -1, easing = SINE_EASING)


/obj/pure_darkness
	icon = 'icons/misc/chaplainRitual.dmi'
	icon_state = "black"
	name = "darkness"
	desc = "Despite there being no light, you still make figures out."
	var/datum/darkfountain/fountain = null
	plane = PLANE_ABOVE_BLACKNESS
	var/active = FALSE

	New(loc, timetokickin = 0, datum/darkfountain/fountain, startfountain)
		..()
		src.set_loc(loc)
		src.fountain = fountain
		alpha = 0
		animate(src, timetokickin, alpha = 255)
		SPAWN(timetokickin + 1 SECOND)
			src.active = TRUE
			for (var/atom/movable/AM as anything in src.loc)
				if (istype(AM, /obj/landmark)) continue
				src.fountain.send(AM, startfountain)

	Crossed(atom/movable/AM)
		. = ..()
		if (src.active)
			src.fountain.send(AM)

