
/**********************Ore box**************************/

/obj/structure/ore_box
	name = "ящик для руды"
	desc = "Тяжелый деревянный ящик, который можно наполнить большим количеством руды."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	density = TRUE
	pressure_resistance = 5*ONE_ATMOSPHERE

/obj/structure/ore_box/attackby(obj/item/holder, mob/user, params)
	if (istype(holder, /obj/item/stack/ore))
		user.transferItemToLoc(holder, src)
	else if(holder.atom_storage)
		holder.atom_storage.remove_type(/obj/item/stack/ore, src, INFINITY, TRUE, FALSE, user, null)
		to_chat(user, span_notice("Опустошаю содержимое [holder.name] в [src.name]."))
	else
		return ..()

/obj/structure/ore_box/crowbar_act(mob/living/user, obj/item/I)
	if(I.use_tool(src, user, 50, volume=50))
		user.visible_message(span_notice("[user] разбирает [src.name]."),
			span_notice("Разбираю [src.name]."),
			span_hear("Слышу звук раскалывающегося дерева."))
		deconstruct(TRUE, user)
	return TRUE

/obj/structure/ore_box/examine(mob/living/user)
	if(Adjacent(user) && istype(user))
		ui_interact(user)
	. = ..()

/obj/structure/ore_box/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(Adjacent(user))
		ui_interact(user)

/obj/structure/ore_box/attack_robot(mob/user)
	if(Adjacent(user))
		ui_interact(user)

/obj/structure/ore_box/proc/dump_box_contents()
	var/drop = drop_location()
	var/turf/our_turf = get_turf(src)
	for(var/obj/item/stack/ore/O in src)
		if(QDELETED(O))
			continue
		if(QDELETED(src))
			break
		O.forceMove(drop)
		SET_PLANE(O, PLANE_TO_TRUE(O.plane), our_turf)
		if(TICK_CHECK)
			stoplag()
			our_turf = get_turf(src)
			drop = drop_location()

/obj/structure/ore_box/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreBox", name)
		ui.open()

/obj/structure/ore_box/ui_data()
	var/contents = list()
	for(var/obj/item/stack/ore/O in src)
		contents[O.type] += O.amount

	var/data = list()
	data["materials"] = list()
	for(var/type in contents)
		var/obj/item/stack/ore/O = type
		var/name = initial(O.name)
		data["materials"] += list(list("name" = name, "amount" = contents[type], "id" = type))

	return data

/obj/structure/ore_box/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!Adjacent(usr))
		return
	add_fingerprint(usr)
	usr.set_machine(src)
	switch(action)
		if("removeall")
			dump_box_contents()
			to_chat(usr, span_notice("Открываю дно ящика."))
/obj/structure/ore_box/deconstruct(disassembled = TRUE, mob/user)
	var/obj/item/stack/sheet/mineral/wood/WD = new (loc, 4)
	if(user && !QDELETED(WD))
		WD.add_fingerprint(user)
	dump_box_contents()
	qdel(src)

/// Special override for notify_contents = FALSE.
/obj/structure/ore_box/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = FALSE)
	return ..()
