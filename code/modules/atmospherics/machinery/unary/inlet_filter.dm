// Filter inlet
// works with filter_control

/obj/machinery/atmospherics/unary/inlet_filter
	name = "inlet"
	icon = 'icons/obj/atmospherics/inlet_filter.dmi'
	machine_registry_idx = MACHINES_INLETS

	var/id = null
	var/frequency = FREQ_AIR_ALARM_CONTROL

	var/on = FALSE
	#define _DEF_SCRUBBER_VAR(GAS, ...) var/scrub_##GAS = 0;
	APPLY_TO_GASES(_DEF_SCRUBBER_VAR)
	#undef _DEF_SCRUBBER_VAR


/obj/machinery/atmospherics/unary/inlet_filter/New()
	..()
	if(frequency)
		MAKE_DEFAULT_RADIO_PACKET_COMPONENT(null, frequency)

/obj/machinery/atmospherics/unary/inlet_filter/initialize()
	..()
	UpdateIcon()

/obj/machinery/atmospherics/unary/inlet_filter/process()
	..()
	if(!on)
		return FALSE

	var/datum/gas_mixture/exterior = src.loc.return_air()
	var/datum/gas_mixture/filtered_out = new()
	filtered_out.temperature = exterior.temperature

	var/flow_rate = ((TOTAL_MOLES(exterior)-TOTAL_MOLES(air_contents))*FLOWFRAC)/exterior
	if(flow_rate <= 0)
		return
	#define _FILTER_OUT_GAS(GAS, ...) \
	if(scrub_##GAS) { \
		filtered_out.GAS = exterior.GAS * flow_rate; \
		exterior.GAS -= filtered_out.GAS; \
	}
	APPLY_TO_GASES(_FILTER_OUT_GAS)
	#undef _FILTER_OUT_GAS
	use_power(5,ENVIRON)
	air_contents.merge(filtered_out)
	UpdateIcon()

/obj/machinery/atmospherics/unary/inlet_filter/update_icon()

	if(!on)
		icon_state = "inlet_filter-0"
		return

	var/datum/gas_mixture/exterior = src.loc.return_air()
	var/flow_rate = ((TOTAL_MOLES(exterior)-TOTAL_MOLES(air_contents))*FLOWFRAC)/exterior

	if(flow_rate < 0.25)
		icon_state = "inlet_filter-4"
	else if(flow_rate < 0.33)
		icon_state = "inlet_filter-3"
	else if(flow_rate < 0.5)
		icon_state = "inlet_filter-2"
	else if(flow_rate >= 0.5)
		icon_state = "inlet_filter-1"
	else
		icon_state = "inlet_filter-0"

/obj/machinery/atmospherics/unary/inlet_filter/receive_signal(datum/signal/signal)
	if(signal.data["tag"] && (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("toggle_inlet")
			if (signal.data["parameter"] == "power_on")
				src.on = 1
			else if (signal.data["parameter"] == "power_off")
				src.on = 0



		UpdateIcon()
