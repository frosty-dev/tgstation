/obj/machinery/computer/shuttle/labor
	name = "консоль лагерного шаттла"
	desc = "Используется для вызова и отправки шаттла в лагерь заключенных."
	circuit = /obj/item/circuitboard/computer/labor_shuttle
	shuttleId = "laborcamp"
	possible_destinations = "laborcamp_home;laborcamp_away"
	req_access = list(ACCESS_BRIG)

/obj/machinery/computer/shuttle/labor/one_way
	name = "консоль шаттла заключенных"
	desc = "Консоль однонаправленного шаттла, используется для отправки шаттла в лагерь заключенных."
	possible_destinations = "laborcamp_away"
	circuit = /obj/item/circuitboard/computer/labor_shuttle/one_way
	req_access = list( )

/obj/machinery/computer/shuttle/labor/one_way/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle("laborcamp")
	if(!M)
		to_chat(user, span_warning("Шаттл не найден!"))
		return FALSE
	var/obj/docking_port/stationary/S = M.get_docked()
	if(S?.name == "laborcamp_away")
		to_chat(user, span_warning("Шаттл уже в лагере!"))
		return FALSE
	return TRUE

/obj/docking_port/stationary/laborcamp_home
	name = "SS13: Labor Shuttle Dock"
	shuttle_id = "laborcamp_home"
	roundstart_template = /datum/map_template/shuttle/labour/delta
	width = 9
	dwidth = 2
	height = 5

/obj/docking_port/stationary/laborcamp_home/kilo
	roundstart_template = /datum/map_template/shuttle/labour/kilo
