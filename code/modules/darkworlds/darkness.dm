/datum/darkfountain
	var/obj/effects/darkworldblack/fountain
	var/list/darknessfields

	New(fountain)
		..()
		src.fountain = fountain

	proc/send(atom/movable/AM)
		if (ismob(AM))
			var/mob/M = AM
			

/obj/effects/darkworldblack
	name = "dark fountain"
	plane = PLANE_ABOVE_BLACKNESS
	layer = ABOVE_OBJ_LAYER
	particles = new/particles/darkworldblack
	var/datum/darkfountain/parent

	New()
		..()
		src.parent = new(src)
		var/area = get_area(src)
		src.add_filter("outline", 0, outline_filter(size=2, color="#FFFFFF", flags = 0))
		var/list/L = list()
		for (var/turf/T in range(7, src))
			if (T.loc != area || !IN_EUCLIDEAN_RANGE(T, src, 7.4)) continue
			L += new /obj/overlay/darkness_field{layer = HUD_LAYER}(T, null, radius = 1.5, max_alpha = 255, timetochange = GET_EUCLIDEAN_DIST(src, T) SECONDS + 2)
			L += new /obj/overlay/darkness_field{layer = HUD_LAYER; plane = PLANE_SELFILLUM}(T, null, radius = 1.5, max_alpha = 255, timetochange = GET_EUCLIDEAN_DIST(src, T) SECONDS + 2)
			L += new /obj/pure_darkness(T, GET_EUCLIDEAN_DIST(src, T) SECONDS + 2, src.parent)
		src.parent.darknessfields = L

/obj/pure_darkness
	icon = 'icons/misc/chaplainRitual.dmi'
	icon_state = "black"
	name = "darkness"
	desc = "Despite there being no light, you still make figures out."
	var/datum/darkfountain/fountain = null
	plane = PLANE_ABOVE_BLACKNESS
	var/active = FALSE

	New(loc, timetokickin = 0, datum/darkfountain/fountain)
		..()
		src.set_loc(loc)
		src.fountain = fountain
		alpha = 0
		animate(src, timetokickin, alpha = 255)
		SPAWN(timetokickin)
			src.active = TRUE

	Crossed(atom/movable/AM)
		. = ..()
		if (src.active)
			src.fountain.send(AM)

