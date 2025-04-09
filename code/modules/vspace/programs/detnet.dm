/obj/item/disk/data/floppy/vspace/detnet
	name = "V-Space Program - DetNet"
	icon_state = "arcade-disk0"

/area/sim/detnet
	name = "V-Space DetNet Zone"

// DetNet Intercoms
/obj/item/device/radio/intercom/detnet
	name = "DetNet Intercom (General)"
	locked_frequency = TRUE
	device_color = RADIOC_STANDARD
	layer = 3.2

	initialize()
		set_frequency(frequency)

/obj/item/device/radio/intercom/detnet/security
	name = "DetNet Intercom (Security)"
	frequency = R_FREQ_SECURITY
	secure_frequencies = list("g" = R_FREQ_SECURITY)
	secure_classes = list("g" = R_FREQ_SECURITY)
	device_color = RADIOC_SECURITY
	layer = 3.1

	initialize()
		set_frequency(frequency)
		set_secure_frequencies(src)

/obj/item/device/radio/intercom/detnet/detective
	name = "DetNet Intercom (???)"
	frequency = R_FREQ_DETECTIVE
	secure_frequencies = list("d" = R_FREQ_DETECTIVE)
	secure_classes = list("d" = R_FREQ_DETECTIVE)
	device_color = RADIOC_DETECTIVE
	layer = 3

	initialize()
		set_frequency(frequency)
		set_secure_frequencies(src)
