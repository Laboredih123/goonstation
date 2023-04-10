#define SIPHONING 0
#define RELEASING 1

// Do not pass external_pressure_bound
#define BOUND_EXTERNAL 1
// Do not pass internal_pressure_bound
#define BOUND_INTERNAL 2
// Do not pass either
#define BOUND_BOTH 3

//node2 is output port
//node1 is input port
/obj/machinery/atmospherics/binary/dp_vent_pump
	icon = 'icons/obj/atmospherics/dp_vent_pump.dmi'
	icon_state = "off"
	name = "Dual Port Air Vent"
	desc = "Has a valve and pump attached to it. There are two ports."

	level = 1
	var/on = FALSE
	var/pump_direction = RELEASING

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/input_pressure_min = 0
	var/output_pressure_max = 0

	var/pressure_checks = BOUND_INTERNAL

	var/frequency = 0
	var/id = null

/obj/machinery/atmospherics/binary/dp_vent_pump/New()
	..()
	MAKE_DEFAULT_RADIO_PACKET_COMPONENT(null, frequency)

/obj/machinery/atmospherics/binary/dp_vent_pump/update_icon()
	var/turf/T = get_turf(src)
	src.hide(T.intact)

/obj/machinery/atmospherics/binary/dp_vent_pump/hide(var/intact) //to make the little pipe section invisible, the icon changes.
	if(on)
		if(pump_direction)
			icon_state = "[intact && istype(loc, /turf/simulated) && level == 1 ? "h" : "" ]out"
		else
			icon_state = "[intact && istype(loc, /turf/simulated) && level == 1 ? "h" : "" ]in"
	else
		icon_state = "[intact && istype(loc, /turf/simulated) && level == 1 ? "h" : "" ]off"
		on = FALSE

/obj/machinery/atmospherics/binary/dp_vent_pump/process()
	..()

	if(!on)
		return FALSE

	var/datum/gas_mixture/environment = loc.return_air()
	var/environment_pressure = MIXTURE_PRESSURE(environment)

	if(pump_direction) //input -> external
		var/pressure_delta = 10000

		if(pressure_checks&BOUND_EXTERNAL)
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
		if(pressure_checks&BOUND_INTERNAL)
			pressure_delta = min(pressure_delta, (MIXTURE_PRESSURE(air1) - input_pressure_min))

		if(pressure_delta > 0)
			if(air1.temperature > 0)
				var/transfer_moles = pressure_delta*environment.volume/(air1.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = air1.remove(transfer_moles)

				loc.assume_air(removed)

				if(network1)
					network1.update = TRUE

	else //external -> output
		var/pressure_delta = 10000

		if(pressure_checks&1)
			pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
		if(pressure_checks&4)
			pressure_delta = min(pressure_delta, (output_pressure_max - MIXTURE_PRESSURE(air2)))

		if(pressure_delta > 0)
			if(environment.temperature > 0)
				var/transfer_moles = pressure_delta*air2.volume/(environment.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)

				air2.merge(removed)

				if(network2)
					network2.update = TRUE

	return TRUE

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/broadcast_status()
	var/datum/signal/signal = get_free_signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data["tag"] = id
	signal.data["device"] = "ADVP"
	signal.data["power"] = on?("on"):("off")
	signal.data["direction"] = pump_direction?("release"):("siphon")
	signal.data["checks"] = pressure_checks
	signal.data["input"] = input_pressure_min
	signal.data["output"] = output_pressure_max
	signal.data["external"] = external_pressure_bound

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_RADIO_PACKET, signal)

	return TRUE

/obj/machinery/atmospherics/binary/dp_vent_pump/receive_signal(datum/signal/signal)
	if(signal.data["tag"] && (signal.data["tag"] != id))
		return FALSE

	switch(signal.data["command"])
		if("power_on")
			on = TRUE

		if("power_off")
			on = FALSE

		if("power_toggle")
			on = !on

		if("set_direction")
			var/number = text2num_safe(signal.data["parameter"])
			if(number > 0.5)
				pump_direction = RELEASING
			else
				pump_direction = SIPHONING

		if("set_checks")
			var/number = round(text2num_safe(signal.data["parameter"]),1)
			pressure_checks = number

		if("purge")
			pressure_checks &= ~BOUND_EXTERNAL
			pump_direction = SIPHONING

		if("stabalize")
			pressure_checks |= BOUND_EXTERNAL
			pump_direction = RELEASING

		if("set_input_pressure")
			var/number = text2num_safe(signal.data["parameter"])
			number = clamp(number, 0, ONE_ATMOSPHERE*50)

			input_pressure_min = number

		if("set_output_pressure")
			var/number = text2num_safe(signal.data["parameter"])
			number = clamp(number, 0, ONE_ATMOSPHERE*50)

			output_pressure_max = number

		if("set_external_pressure")
			var/number = text2num_safe(signal.data["parameter"])
			number = clamp(number, 0, ONE_ATMOSPHERE*50)

			external_pressure_bound = number

	if(signal.data["tag"])
		SPAWN(0.5 SECONDS) broadcast_status()
	UpdateIcon()

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume
	name = "Large Dual Port Air Vent"

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume/New()
	..()
	air1.volume = 1000
	air2.volume = 1000

#undef SIPHONING
#undef RELEASING
#undef BOUND_EXTERNAL
#undef BOUND_INTERNAL
#undef BOUND_BOTH
