/image/foreground_parallax_occlusion_overlay
	icon = 'icons/misc/foreground_parallax_occlusion_overlay.dmi'
	icon_state = "overlay-0"
	plane = PLANE_FOREGROUND_PARALLAX_OCCLUSION

/turf/New()
	. = ..()
	var/area/A = get_area(src)
	if (A.occlude_foreground_parallax_layers)
		src.update_parallax_occlusion_overlay()

/turf/proc/update_parallax_occlusion_overlay(update_neighbors = TRUE, turf/called_from_turf=null)
	var/connected_directions = 0
	// Cardinal
	for (var/dir in cardinal)
		var/turf/CT = get_step(src, dir)
		if (CT == called_from_turf || !isnull(CT.GetOverlayImage("foreground_parallax_occlusion_overlay")))
			connected_directions |= dir
			if (update_neighbors)
				CT.update_parallax_occlusion_overlay(FALSE, src)

	// Ordinal
	if (!((NORTHEAST & connected_directions) != NORTHEAST))
		var/turf/OT = get_step(src, NORTHEAST)
		if (OT == called_from_turf || !isnull(OT.GetOverlayImage("foreground_parallax_occlusion_overlay")))
			connected_directions |= 8 << 1
			if (update_neighbors)
				OT.update_parallax_occlusion_overlay(FALSE, src)

	if (!((SOUTHEAST & connected_directions) != SOUTHEAST))
		var/turf/OT = get_step(src, SOUTHEAST)
		if (OT == called_from_turf || !isnull(OT.GetOverlayImage("foreground_parallax_occlusion_overlay")))
			connected_directions |= 8 << 2
			if (update_neighbors)
				OT.update_parallax_occlusion_overlay(FALSE, src)

	if (!((SOUTHWEST & connected_directions) != SOUTHWEST))
		var/turf/OT = get_step(src, SOUTHWEST)
		if (OT == called_from_turf || !isnull(OT.GetOverlayImage("foreground_parallax_occlusion_overlay")))
			connected_directions |= 8 << 3
			if (update_neighbors)
				OT.update_parallax_occlusion_overlay(FALSE, src)

	if (!((NORTHWEST & connected_directions) != NORTHWEST))
		var/turf/OT = get_step(src, NORTHWEST)
		if (OT == called_from_turf || !isnull(OT.GetOverlayImage("foreground_parallax_occlusion_overlay")))
			connected_directions |= 8 << 4
			if (update_neighbors)
				OT.update_parallax_occlusion_overlay(FALSE, src)

	var/image/our_overlay = src.GetOverlayImage("foreground_parallax_occlusion_overlay") || new /image/foreground_parallax_occlusion_overlay
	our_overlay.icon_state = "overlay-[connected_directions]"
	src.AddOverlaysAllOff(our_overlay, "foreground_parallax_occlusion_overlay")
