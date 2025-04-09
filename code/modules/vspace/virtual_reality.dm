ABSTRACT_TYPE(/area/sim)
/area/sim
	name = "Sim"
	icon_state = "purple"
	luminosity = 1
	force_fullbright = 1
	requires_power = 0
	teleport_blocked = 1
	virtual = 1
	skip_sims = 1
	sims_score = 100
	sound_group = "vr"
	dont_log_combat = TRUE

/area/sim/area1
	name = "Vspace area 1"
	icon_state = "simA1"

/area/sim/area2
	name = "Vspace area 2"
	icon_state = "simA2"

/turf/unsimulated/floor/vr
	name = "virtual floor"

/turf/unsimulated/floor/vr/reinforced
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntfloorPod"

/turf/unsimulated/floor/vr/checker
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntfloorDefault"

/turf/simulated/floor/Vspace
	name = "Vspace"
	icon_state = "flashyblue"
	var/network = "none"
	var/network_ID = "none"
	fullbright = 1

/turf/simulated/floor/Vspace/brig
	name = "Brig"
	icon_state = "floor"
	network = "prison"

/turf/unsimulated/floor/vr
	icon_state = "vrfloor"

/turf/unsimulated/floor/vr/plating
	icon_state = "vrplating"

/turf/unsimulated/floor/vr/space
	icon_state = "vrspace"

/turf/unsimulated/floor/vr/white
	icon_state = "vrwhitehall"

/turf/unsimulated/wall/blackwall
	name = "V-Space Edge"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingMain"

TYPEINFO(/turf/unsimulated/wall/auto/virtual)
TYPEINFO_NEW(/turf/unsimulated/wall/auto/virtual)
	. = ..()
	connects_to = typecacheof(/turf/unsimulated/wall/auto/virtual)

/turf/unsimulated/wall/auto/virtual
	icon = 'icons/turf/walls/destiny.dmi'
	icon_state = "mapwall"
	name = "virtual wall"
	desc = "that sure is a wall, yep."

/turf/unsimulated/floor/setpieces/gauntlet
	name = "Gauntlet Floor"
	desc = "Artist needs effort badly."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntfloorDefault"

/turf/unsimulated/wall/setpieces/gauntlet
	name = "Gauntlet Wall"
	desc = "Is this retro? Thank god it's not team ninja."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntwall"

