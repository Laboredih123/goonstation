/obj/machinery/power/nuke/nuke_turbine
	name = "Large Turbine"
	desc = "A large assembly of fan blades rotated by steam pressure to generate electricity."
	icon = 'icons/obj/machines/fusion.dmi'
	icon_state = "cab3"
	anchored = 1
	density = 1
	layer = FLOOR_EQUIP_LAYER1

	var/debug = 1
	var/displayHtml = ""
	var/genlast = 0

	New()
		nturbine = src
		SPAWN(5 DECI SECONDS)
			make_fluid_networks()
			var/obj/fluid_pipe/source/temp_i = locate(/obj/fluid_pipe/source) in get_step(src,SOUTH)
			var/obj/fluid_pipe/sink/temp_o = locate(/obj/fluid_pipe/sink) in get_step(src,NORTH)
			//n_input = temp_i.network
			//n_output = temp_o.network
			n_input = temp_i
			n_output = temp_o
			..()

	attack_hand(mob/user)
		displayHtml = buildHtml()
		src.add_dialog(user)
		user.Browse(displayHtml, "window=fturbine;size=550x700;can_resize=1;can_minimize=1;allow-html=1;show-url=1;statusbar=1;enable-http-images=1;can-scroll=1")
		onclose(user, "fturbine")

	proc/gen_tick()
		if(!active)
			return

		if(src.n_input.network.last == TURBINE)
			return /* XXX make this sync */

		var/heat_inc = n_input.network.reagents.total_temperature

		if(heat_inc > src.core_heat)
			var/delta = heat_inc - src.core_heat
			src.genlast = delta * nuke_knobs.joules_per_heat
			add_avail(genlast WATTS)
			src.core_heat += delta/10
			n_output.network.reagents.temperature_reagents(heat_inc - delta, n_output.used_capacity, 2, 300) /* XXX fix this */


		var/before = core_heat
		n_input.network.reagents.trans_to(src.n_output.network, src.n_input.network.reagents.total_volume)
		transfer_heat_reagents()
		if(before > core_heat)
			n_output.network.last = TURBINE
			return

		genlast = heat_transfer * nuke_knobs.joules_per_heat
		add_avail(genlast WATTS)
		n_output.network.last = TURBINE

		updateUsrDialog()

	process()
		gen_tick()


	proc/buildHtml()
		var/html = ""

		html += "<html><head>"

		html += K_STYLE
		html += "</head><body>"
		html += "<div class=\"ib\">"
		html += "<h1>core heat: [core_heat] C</h1>"
		html += "<h1>coolant flow: [n_input.used_capacity] mols/tick</h1>"
		html += "<h1>in  coolant temp: [n_input.network.reagents.total_temperature] C</h1>"
		html += "<h1>out coolant temp: [n_output.network.reagents.total_temperature] C</h1>"
		html += "<h1>heat delta: [heat_transfer] K</h1>"
		html += "<h1>power generated: [nturbine.genlast] \"E\"?</h1>"
		html += "</div>"

		html += "</body></html>"
		return html
