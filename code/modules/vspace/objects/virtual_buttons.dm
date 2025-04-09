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
