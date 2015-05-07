/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	flags = CONDUCT
	force = 2 * 5.0
	w_class = 2.0
	throwforce = 2 * 5.0
	throw_range = 15
	throw_speed = 3
	var/plintool = 0
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	var/datum/effect/effect/system/spark_spread/spark_system

	matter = list("metal" = 50,"glass" = 20)

	origin_tech = "magnets=1;engineering=1"
	var/obj/machinery/telecomms/buffer // simple machine buffer for device linkage

/obj/item/device/debugger/plin
	icon_state = "plintool"
	plintool = 1


/obj/item/device/debugger/is_used_on(obj/O, mob/user)
	if(istype(O, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = O
		if(A.emagged || A.malfhack)
			user << "\red There is a software error with the device."
		else
			user << "\blue The device's software appears to be fine."
		return 1
	if(istype(O, /obj/machinery/door))
		var/obj/machinery/door/D = O
		if(plintool == 1)
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			if(D.emagged == 0)
				usr << "Door not emagged"
			if(D.emagged == 1)
				usr << "Door emagged"
			if(D.secondsElectrified != 0)
				usr << "Door electrified"
		if(D.operating == -1)
			user << "\red There is a software error with the device."
		else
			user << "\blue The device's software appears to be fine."
		return 1
	else if(istype(O, /obj/machinery))
		var/obj/machinery/A = O
		if(plintool == 1)
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
		if(A.emagged)
			user << "\red There is a software error with the device."
		else
			user << "\blue The device's software appears to be fine."
		return 1
