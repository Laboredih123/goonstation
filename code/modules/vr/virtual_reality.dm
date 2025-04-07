/obj/death_button/VR_logout_button
	name = "Leave VR"
	desc = "Press this button to log out of virtual reality."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "party"

	attack_hand(mob/user)
		if (!ismob(user) || !user.client || !istype(user, /mob/living/carbon/human/virtual/))
			return
		src.add_fingerprint(user)

		// Won't delete the VR character otherwise, which can be confusing (detective's goggles sending you to the existing body in the bomb VR etc).
		setdead(user)
		user.death(FALSE)

		Station_VNet.Leave_Vspace(user)
		return

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


/turf/unsimulated/wall/generic/vr
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingMain"
