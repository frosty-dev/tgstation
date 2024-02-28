// Microwaving doesn't use recipes, instead it calls the microwave_act of the objects.
// For food, this creates something based on the food's cooked_type

/// Values based on microwave success
#define MICROWAVE_NORMAL 0
#define MICROWAVE_MUCK 1
#define MICROWAVE_PRE 2

/// Values for how broken the microwave is
#define NOT_BROKEN 0
#define KINDA_BROKEN 1
#define REALLY_BROKEN 2

/// The max amount of dirtiness a microwave can be
#define MAX_MICROWAVE_DIRTINESS 100

/// For the wireless version, and display fluff
#define TIER_1_CELL_CHARGE_RATE 250

/obj/machinery/microwave
	name = "микроволновка"
	desc = "Варит и греет вещи."
	icon = 'icons/obj/machines/microwave.dmi'
	base_icon_state = ""
	icon_state = "mw_complete"
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE
	layer = BELOW_OBJ_LAYER
	density = TRUE
	circuit = /obj/item/circuitboard/machine/microwave
	pass_flags = PASSTABLE
	light_color = LIGHT_COLOR_DIM_YELLOW
	light_power = 3
	anchored_tabletop_offset = 6
	/// Is its function wire cut?
	var/wire_disabled = FALSE
	/// Wire cut to run mode backwards
	var/wire_mode_swap = FALSE
	/// Fail due to inserted PDA
	var/pda_failure = FALSE
	var/operating = FALSE
	/// How dirty is it?
	var/dirty = 0
	var/dirty_anim_playing = FALSE
	/// How broken is it? NOT_BROKEN, KINDA_BROKEN, REALLY_BROKEN
	var/broken = NOT_BROKEN
	/// Microwave door position
	var/open = FALSE
	/// Microwave max capacity
	var/max_n_of_items = 10
	/// Microwave efficiency (power) based on the stock components
	var/efficiency = 0
	/// If we use a cell instead of powernet
	var/cell_powered = FALSE
	/// The cell we charge with
	var/obj/item/stock_parts/cell/cell
	/// The cell we're charging
	var/obj/item/stock_parts/cell/vampire_cell
	/// Capable of vampire charging PDAs
	var/vampire_charging_capable = FALSE
	/// Charge contents of microwave instead of cook
	var/vampire_charging_enabled = FALSE
	var/datum/looping_sound/microwave/soundloop
	/// May only contain /atom/movables
	var/list/ingredients = list()
	/// When this is the nth ingredient, whats its pixel_x?
	var/list/ingredient_shifts_x = list(
		-2,
		1,
		-5,
		2,
		-6,
		0,
		-4,
	)
	/// When this is the nth ingredient, whats its pixel_y?
	var/list/ingredient_shifts_y = list(
		-4,
		-2,
		-3,
	)
	var/static/radial_examine = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_examine")
	var/static/radial_eject = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_eject")
	var/static/radial_cook = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_cook")
	var/static/radial_charge = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_charge")

	// we show the button even if the proc will not work
	var/static/list/radial_options = list("eject" = radial_eject, "cook" = radial_cook, "charge" = radial_charge)
	var/static/list/ai_radial_options = list("eject" = radial_eject, "cook" = radial_cook, "charge" = radial_charge, "examine" = radial_examine)

/obj/machinery/microwave/Initialize(mapload)
	. = ..()
	register_context()
	set_wires(new /datum/wires/microwave(src))
	create_reagents(100)
	soundloop = new(src, FALSE)
	update_appearance(UPDATE_ICON)

/obj/machinery/microwave/Exited(atom/movable/gone, direction)
	if(gone in ingredients)
		ingredients -= gone
		if(!QDELING(gone) && ingredients.len && isitem(gone))
			var/obj/item/itemized_ingredient = gone
			if(!(itemized_ingredient.item_flags & NO_PIXEL_RANDOM_DROP))
				itemized_ingredient.pixel_x = itemized_ingredient.base_pixel_x + rand(-6, 6)
				itemized_ingredient.pixel_y = itemized_ingredient.base_pixel_y + rand(-5, 6)
	return ..()

/obj/machinery/microwave/on_deconstruction()
	eject()
	return ..()

/obj/machinery/microwave/Destroy()
	QDEL_LIST(ingredients)
	QDEL_NULL(wires)
	QDEL_NULL(soundloop)
	if(!isnull(cell))
		QDEL_NULL(cell)
	return ..()

/obj/machinery/microwave/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(cell_powered)
		if(!isnull(cell))
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Вытащить батарейку"
		else if(held_item && istype(held_item, /obj/item/stock_parts/cell))
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Вставить батарейку"

	if(held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Открепить" : "Закрепить"]"
		return CONTEXTUAL_SCREENTIP_SET

	if(broken > NOT_BROKEN)
		if(broken == REALLY_BROKEN && held_item?.tool_behaviour == TOOL_WIRECUTTER)
			context[SCREENTIP_CONTEXT_LMB] = "Починить"
			return CONTEXTUAL_SCREENTIP_SET

		else if(broken == KINDA_BROKEN && held_item?.tool_behaviour == TOOL_WELDER)
			context[SCREENTIP_CONTEXT_LMB] = "Починить"
			return CONTEXTUAL_SCREENTIP_SET

	context[SCREENTIP_CONTEXT_LMB] = "Меню"

	if(vampire_charging_capable)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Переключить на [vampire_charging_enabled ? "готовку" : "зарядку"]"

	if(length(ingredients) != 0)
		context[SCREENTIP_CONTEXT_RMB] = "Начать [vampire_charging_enabled ? "зарядку" : "готовку"]"

	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/microwave/RefreshParts()
	. = ..()
	efficiency = 0
	vampire_charging_capable = FALSE
	for(var/datum/stock_part/micro_laser/micro_laser in component_parts)
		efficiency += micro_laser.tier
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		max_n_of_items = 10 * matter_bin.tier
		break
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		if(capacitor.tier >= 2)
			vampire_charging_capable = TRUE
			visible_message(span_notice("Индикатор на лампочке [EXAMINE_HINT("Возможность зарядки")] зажглись на [src]."))
			break

/obj/machinery/microwave/examine(mob/user)
	. = ..()
	if(vampire_charging_capable)
		. += span_info("Эта модель имеет на борту технологию 'Волна'™:, эксклюзив НаноТрэйзен. Наша последняя и прекрасная технология позволяет вашим ПДА заряжаться без проводов, посредством микроволновых волн! Вы можете зарядить свои устройства посредством смены режимы работы на зарядку.")
		. += span_info("Только возможность заряжять ваши ПДА, пока вы сжигаете свои обьедки, действительно заставит поверить в то, что будущее настало. Волна™ НаноТрэйзен - Пересмотри свои возможности в мультизадачности.")

	if(cell_powered)
		. += span_notice("Эта запитана батарейками и может работаеть без доступа к сети. [isnull(cell) ? "Батарейный отсек пуст." : "[EXAMINE_HINT("Ctrl-клик")] для удаление батарейки."]")

	if(!operating)
		if(!operating && vampire_charging_capable)
			. += span_notice("[EXAMINE_HINT("Alt-клик")] для смены в обычный режим.")

		. += span_notice("[EXAMINE_HINT("ПКМ")] для [vampire_charging_enabled ? "зарядки" : "готовки"].")

	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("Слишком далеко для взаимодействия с содержимым и дисплеем [src]!")
		return
	if(operating)
		. += span_notice(" [src] работает.")
		return

	if(length(ingredients))
		if(issilicon(user))
			. += span_notice(" [src] камера показываеть:")
		else
			. += span_notice(" [src] содержит:")
		var/list/items_counts = new
		for(var/i in ingredients)
			if(isstack(i))
				var/obj/item/stack/item_stack = i
				items_counts[item_stack.name] += item_stack.amount
			else
				var/atom/movable/single_item = i
				items_counts[single_item.name]++
		for(var/item in items_counts)
			. += span_notice("- [items_counts[item]]x [item].")
	else
		. += span_notice(" [src] пустая.")

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "[span_notice("Дисплей:")]\n"+\
		"[span_notice("- Режим: <b>[vampire_charging_enabled ? "Зарядка" : "Готовка"]</b>.")]\n"+\
		"[span_notice("- Вместителность: <b>[max_n_of_items]</b> предметов.")]\n"+\
		span_notice("- Power: <b>[efficiency * TIER_1_CELL_CHARGE_RATE]W</b>.")

		if(cell_powered)
			. += span_notice("- Заряд: <b>[isnull(cell) ? "ВСТАВЬТЕ ЭЛЕМЕНТ ПИТАНИЯ" : "[round(cell.percent())]%"]</b>.")

#define MICROWAVE_INGREDIENT_OVERLAY_SIZE 24

/obj/machinery/microwave/update_overlays()
	. = ..()

	// All of these will use a full icon state instead
	if(panel_open || dirty >= MAX_MICROWAVE_DIRTINESS || broken || dirty_anim_playing)
		return .

	var/ingredient_count = 0

	for(var/atom/movable/ingredient as anything in ingredients)
		var/image/ingredient_overlay = image(ingredient, src)

		var/list/icon_dimensions = get_icon_dimensions(ingredient.icon)
		ingredient_overlay.transform = ingredient_overlay.transform.Scale(
			MICROWAVE_INGREDIENT_OVERLAY_SIZE / icon_dimensions["width"],
			MICROWAVE_INGREDIENT_OVERLAY_SIZE / icon_dimensions["height"],
		)

		ingredient_overlay.pixel_x = ingredient_shifts_x[(ingredient_count % ingredient_shifts_x.len) + 1]
		ingredient_overlay.pixel_y = ingredient_shifts_y[(ingredient_count % ingredient_shifts_y.len) + 1]
		ingredient_overlay.layer = FLOAT_LAYER
		ingredient_overlay.plane = FLOAT_PLANE
		ingredient_overlay.blend_mode = BLEND_INSET_OVERLAY

		ingredient_count += 1

		. += ingredient_overlay

	var/border_icon_state
	var/door_icon_state

	if(open)
		door_icon_state = "[base_icon_state]door_open"
		border_icon_state = "[base_icon_state]mwo"
	else if(operating)
		if(vampire_charging_enabled)
			door_icon_state = "[base_icon_state]door_charge"
		else
			door_icon_state = "[base_icon_state]door_on"
		border_icon_state = "[base_icon_state]mw1"
	else
		door_icon_state = "[base_icon_state]door_off"
		border_icon_state = "[base_icon_state]mw"


	. += mutable_appearance(
		icon,
		door_icon_state,
	)

	. += border_icon_state

	if(!open)
		. += "[base_icon_state]door_handle"

	if(!(machine_stat & NOPOWER) || cell_powered)
		. += emissive_appearance(icon, "emissive_[border_icon_state]", src, alpha = src.alpha)

	if(cell_powered && !isnull(cell))
		switch(cell.percent())
			if(75 to 100)
				. += mutable_appearance(icon, "[base_icon_state]cell_100")
				. += emissive_appearance(icon, "[base_icon_state]cell_100", src, alpha = src.alpha)
			if(50 to 75)
				. += mutable_appearance(icon, "[base_icon_state]cell_75")
				. += emissive_appearance(icon, "[base_icon_state]cell_75", src, alpha = src.alpha)
			if(25 to 50)
				. += mutable_appearance(icon, "[base_icon_state]cell_25")
				. += emissive_appearance(icon, "[base_icon_state]cell_25", src, alpha = src.alpha)
			else
				. += mutable_appearance(icon, "[base_icon_state]cell_0")
				. += emissive_appearance(icon, "[base_icon_state]cell_0", src, alpha = src.alpha)

	return .

#undef MICROWAVE_INGREDIENT_OVERLAY_SIZE

/obj/machinery/microwave/update_icon_state()
	if(broken)
		icon_state = "[base_icon_state]mwb"
	else if(dirty_anim_playing)
		icon_state = "[base_icon_state]mwbloody1"
	else if(dirty >= MAX_MICROWAVE_DIRTINESS)
		icon_state = open ? "[base_icon_state]mwbloodyo" : "[base_icon_state]mwbloody"
	else if(operating)
		icon_state = "[base_icon_state]back_on"
	else if(open)
		icon_state = "[base_icon_state]back_open"
	else if(panel_open)
		icon_state = "[base_icon_state]mw-o"
	else
		icon_state = "[base_icon_state]back_off"

	return ..()

/obj/machinery/microwave/wrench_act(mob/living/user, obj/item/tool)
	if(default_unfasten_wrench(user, tool))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/microwave/crowbar_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/microwave/screwdriver_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/microwave/wirecutter_act(mob/living/user, obj/item/tool)
	if(broken != REALLY_BROKEN)
		return

	user.visible_message(
		span_notice("[user] начинает частично чинить [src]."),
		span_notice("Начинаю частично чинить [src]..."),
	)

	if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
		return TOOL_ACT_SIGNAL_BLOCKING

	user.visible_message(
		span_notice("[user] чинит частично [src]."),
		span_notice("Починил частично [src]."),
	)
	broken = KINDA_BROKEN // Fix it a bit
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/microwave/welder_act(mob/living/user, obj/item/tool)
	if(broken != KINDA_BROKEN)
		return

	user.visible_message(
		span_notice("[user] начинает частично чинить [src]."),
		span_notice("Начинаю частично чинить [src]..."),
	)

	if(!tool.use_tool(src, user, 2 SECONDS, amount = 1, volume = 50))
		return TOOL_ACT_SIGNAL_BLOCKING

	user.visible_message(
		span_notice("[user] починил [src]."),
		span_notice("Починил [src]."),
	)
	broken = NOT_BROKEN
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/microwave/tool_act(mob/living/user, obj/item/tool, tool_type, is_right_clicking)
	if(operating)
		return
	if(dirty >= MAX_MICROWAVE_DIRTINESS)
		return

	. = ..()
	if(. & TOOL_ACT_MELEE_CHAIN_BLOCKING)
		return

	if(panel_open && is_wire_tool(tool))
		wires.interact(user)
		return TOOL_ACT_SIGNAL_BLOCKING

/obj/machinery/microwave/attackby(obj/item/item, mob/living/user, params)
	if(operating)
		return

	if(broken > NOT_BROKEN)
		if(IS_EDIBLE(item))
			balloon_alert(user, "Оно сломано!")
			return TRUE
		return ..()

	if(istype(item, /obj/item/stock_parts/cell) && cell_powered)
		var/swapped = FALSE
		if(!isnull(cell))
			cell.forceMove(drop_location())
			if(!issilicon(user) && Adjacent(user))
				user.put_in_hands(cell)
			cell = null
			swapped = TRUE
		if(!user.transferItemToLoc(item, src))
			update_appearance()
			return TRUE
		cell = item
		balloon_alert(user, "[swapped ? "Заменил" : "Вставил"] батарейку")
		update_appearance()
		return TRUE

	if(!anchored)
		if(IS_EDIBLE(item))
			balloon_alert(user, "Не зафиксировано!")
			return TRUE
		return ..()

	if(dirty >= MAX_MICROWAVE_DIRTINESS) // The microwave is all dirty so can't be used!
		if(IS_EDIBLE(item))
			balloon_alert(user, "Слишком грязная!")
			return TRUE
		return ..()

	if(vampire_charging_capable && istype(item, /obj/item/modular_computer/pda) && ingredients.len > 0)
		balloon_alert(user, "Только один ПДА!")
		return FALSE

	if(istype(item, /obj/item/storage))
		var/obj/item/storage/tray = item
		var/loaded = 0

		if(!istype(item, /obj/item/storage/bag/tray))
			// Non-tray dumping requires a do_after
			to_chat(user, span_notice("Вытрахиваю содержимое [item] в [src]..."))
			if(!do_after(user, 2 SECONDS, target = tray))
				return

		for(var/obj/tray_item in tray.contents)
			if(!IS_EDIBLE(tray_item))
				continue
			if(ingredients.len >= max_n_of_items)
				balloon_alert(user, "Оно заполнено!")
				return TRUE
			if(tray.atom_storage.attempt_remove(tray_item, src))
				loaded++
				ingredients += tray_item
		if(loaded)
			open(autoclose = 0.6 SECONDS)
			to_chat(user, span_notice("Вставляю [loaded] предметов в [src]."))
			update_appearance()
		return

	if(item.w_class <= WEIGHT_CLASS_NORMAL && !istype(item, /obj/item/storage) && !user.combat_mode)
		if(ingredients.len >= max_n_of_items)
			balloon_alert(user, "Оно заполнено!")
			return TRUE
		if(!user.transferItemToLoc(item, src))
			balloon_alert(user, "Прилипло к руке!")
			return FALSE

		ingredients += item
		open(autoclose = 0.6 SECONDS)
		user.visible_message(span_notice("[user] добавляет [item] в [src]."), span_notice("Добавляю [item] в [src]."))
		update_appearance()
		return

	return ..()

/obj/machinery/microwave/attack_hand_secondary(mob/user, list/modifiers)
	if(user.can_perform_action(src, ALLOW_SILICON_REACH))
		if(!length(ingredients))
			balloon_alert(user, "Оно пустое!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		start_cycle(user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/microwave/AltClick(mob/user, list/modifiers)
	if(user.can_perform_action(src, ALLOW_SILICON_REACH))
		if(!vampire_charging_capable)
			return

		vampire_charging_enabled = !vampire_charging_enabled
		balloon_alert(user, "Установил на [vampire_charging_enabled ? "зарядку" : "готовку"]")
		playsound(src, 'sound/machines/twobeep_high.ogg', 50, FALSE)
		if(issilicon(user))
			visible_message(span_notice("[user] переключил [src] на [vampire_charging_enabled ? "зарядку" : "готовку"]."), blind_message = span_notice("Слышу сигнал нажатия на [src]!"))

/obj/machinery/microwave/CtrlClick(mob/user)
	. = ..()
	if(cell_powered && !isnull(cell) && anchored)
		user.put_in_hands(cell)
		balloon_alert(user, "Вытащил батарейку")
		cell = null
		update_appearance()

/obj/machinery/microwave/ui_interact(mob/user)
	. = ..()

	if(!anchored)
		balloon_alert(user, "Не зафиксирован!")
		return
	if(operating || panel_open || !user.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(isAI(user) && (machine_stat & NOPOWER))
		return

	if(!length(ingredients))
		if(isAI(user))
			examine(user)
		else
			balloon_alert(user, "Оно пустое!")
		return

	var/choice = show_radial_menu(user, src, isAI(user) ? ai_radial_options : radial_options, require_near = !issilicon(user))

	// post choice verification
	if(operating || panel_open || (!vampire_charging_capable && !anchored) || !user.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(isAI(user) && (machine_stat & NOPOWER))
		return

	user.set_machine(src)
	switch(choice)
		if("Вытащить")
			eject()
		if("Готовить")
			vampire_charging_enabled = FALSE
			start_cycle(user)
		if("Зарядить")
			vampire_charging_enabled = TRUE
			start_cycle(user)
		if("Осмотреть")
			examine(user)

/obj/machinery/microwave/wash(clean_types)
	. = ..()
	if(operating || !(clean_types & CLEAN_SCRUB))
		return .

	dirty = 0
	update_appearance()
	return . || TRUE

/obj/machinery/microwave/proc/eject()
	var/atom/drop_loc = drop_location()
	for(var/atom/movable/movable_ingredient as anything in ingredients)
		movable_ingredient.forceMove(drop_loc)
	open(autoclose = 1.4 SECONDS)

/obj/machinery/microwave/proc/start_cycle(mob/user)
	if(wire_mode_swap)
		spark()
		if(vampire_charging_enabled)
			cook(user)
		else
			charge(user)

	else if(vampire_charging_enabled)
		charge(user)
	else
		cook(user)

/**
 * Begins the process of cooking the included ingredients.
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/cook(mob/cooker)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(operating || broken > 0 || panel_open || !anchored || dirty >= MAX_MICROWAVE_DIRTINESS)
		return

	if(wire_disabled)
		audible_message("[src] гудит.")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return

	if(cell_powered && cell?.charge < TIER_1_CELL_CHARGE_RATE * efficiency)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		balloon_alert(cooker, "Нужно заменить батарейку!")
		return

	if(cooker && HAS_TRAIT(cooker, TRAIT_CURSED) && prob(7))
		muck()
		return

	if(prob(max((5 / efficiency) - 5, dirty * 5))) //a clean unupgraded microwave has no risk of failure
		muck()
		return

	// How many items are we cooking that aren't already food items
	var/non_food_ingedients = length(ingredients)
	for(var/atom/movable/potential_fooditem as anything in ingredients)
		if(IS_EDIBLE(potential_fooditem))
			non_food_ingedients--
		if(istype(potential_fooditem, /obj/item/modular_computer/pda) && prob(75))
			pda_failure = TRUE
			notify_ghosts("[cooker] перегрел свой ПДА!", source = src, action = NOTIFY_JUMP, flashwindow = FALSE, header = "Голодные Игры: Перекидывание огня")

	// If we're cooking non-food items we can fail randomly
	if(length(non_food_ingedients) && prob(min(dirty * 5, 100)))
		start_can_fail(cooker)
		return

	start(cooker)

/obj/machinery/microwave/proc/wzhzhzh()
	visible_message(span_notice(" [src] включается."), null, span_hear("Слышу гудение микроволновки."))
	operating = TRUE
	if(cell_powered && !isnull(cell))
		cell.use(TIER_1_CELL_CHARGE_RATE * efficiency)

	set_light(l_range = 1.5, l_power = 1.2, l_on = TRUE)
	soundloop.start()
	update_appearance()

/obj/machinery/microwave/proc/spark()
	visible_message(span_warning("Искры разлетаются вокруг [src]!"))
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(2, 1, src)
	sparks.start()

/**
 * The start of the cook loop
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/start(mob/cooker)
	wzhzhzh()
	cook_loop(type = MICROWAVE_NORMAL, cycles = 10, cooker = cooker)

/**
 * The start of the cook loop, but can fail (result in a splat / dirty microwave)
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/start_can_fail(mob/cooker)
	wzhzhzh()
	cook_loop(type = MICROWAVE_PRE, cycles = 4, cooker = cooker)

/obj/machinery/microwave/proc/muck()
	wzhzhzh()
	playsound(loc, 'sound/effects/splat.ogg', 50, TRUE)
	dirty_anim_playing = TRUE
	update_appearance()
	cook_loop(type = MICROWAVE_MUCK, cycles = 4)

/**
 * The actual cook loop started via [proc/start] or [proc/start_can_fail]
 *
 * * type - the type of cooking, determined via how this iteration of cook_loop is called, and determines the result
 * * time - how many loops are left, base case for recursion
 * * wait - deciseconds between loops
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/cook_loop(type, cycles, wait = max(12 - 2 * efficiency, 2), mob/cooker) // standard wait is 10
	if((machine_stat & BROKEN) && type == MICROWAVE_PRE)
		pre_fail()
		return

	if(cycles <= 0 || !length(ingredients))
		switch(type)
			if(MICROWAVE_NORMAL)
				loop_finish(cooker)
			if(MICROWAVE_MUCK)
				muck_finish()
			if(MICROWAVE_PRE)
				pre_success(cooker)
		return
	cycles--
	use_power(active_power_usage)
	addtimer(CALLBACK(src, PROC_REF(cook_loop), type, cycles, wait, cooker), wait)

/obj/machinery/microwave/power_change()
	. = ..()
	if(cell_powered)
		return

	if((machine_stat & NOPOWER) && operating)
		pre_fail()
		eject()

/**
 * Called when the cook_loop is done successfully, no dirty mess or whatever
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/loop_finish(mob/cooker)
	operating = FALSE
	if(pda_failure)
		spark()
		pda_failure = FALSE // in case they repair it after this, reset
		broken = REALLY_BROKEN
		explosion(src, heavy_impact_range = 1, light_impact_range = 2, flame_range = 1)

	var/cursed_chef = cooker && HAS_TRAIT(cooker, TRAIT_CURSED)
	var/metal_amount = 0
	for(var/obj/item/cooked_item in ingredients)
		var/sigreturn = cooked_item.microwave_act(src, cooker, randomize_pixel_offset = ingredients.len)
		if(sigreturn & COMPONENT_MICROWAVE_SUCCESS)
			if(isstack(cooked_item))
				var/obj/item/stack/cooked_stack = cooked_item
				dirty += cooked_stack.amount
			else
				dirty++

		metal_amount += (cooked_item.custom_materials?[GET_MATERIAL_REF(/datum/material/iron)] || 0)

	if(cursed_chef && (metal_amount || prob(5)))  // If we're unlucky and have metal, we're guaranteed to explode
		spark()
		broken = REALLY_BROKEN
		explosion(src, light_impact_range = 2, flame_range = 1)

	if(metal_amount)
		spark()
		broken = REALLY_BROKEN
		if(prob(max(metal_amount / 2, 33)))
			explosion(src, heavy_impact_range = 1, light_impact_range = 2)

	after_finish_loop()

/obj/machinery/microwave/proc/pre_fail()
	broken = REALLY_BROKEN
	operating = FALSE
	spark()
	after_finish_loop()

/obj/machinery/microwave/proc/pre_success(mob/cooker)
	cook_loop(type = MICROWAVE_NORMAL, cycles = 10, cooker = cooker)

/obj/machinery/microwave/proc/muck_finish()
	visible_message(span_warning(" [src] покрывается в грязи!"))

	dirty = MAX_MICROWAVE_DIRTINESS
	dirty_anim_playing = FALSE
	operating = FALSE

	after_finish_loop()

/obj/machinery/microwave/proc/after_finish_loop()
	set_light(l_on = FALSE)
	soundloop.stop()
	eject()
	open(autoclose = 2 SECONDS)

/obj/machinery/microwave/proc/open(autoclose = 2 SECONDS)
	open = TRUE
	playsound(loc, 'sound/machines/click.ogg', 15, TRUE, -3)
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(close)), autoclose)

/obj/machinery/microwave/proc/close()
	open = FALSE
	update_appearance()

/**
 * The start of the charge loop
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/vampire(mob/cooker)
	var/obj/item/modular_computer/pda/vampire_pda = LAZYACCESS(ingredients, 1)
	if(isnull(vampire_pda))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		after_finish_loop()
		return

	vampire_cell = vampire_pda.internal_cell
	if(isnull(vampire_cell))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		after_finish_loop()
		return

	wzhzhzh()
	var/vampire_charge_amount = vampire_cell.maxcharge - vampire_cell.charge
	charge_loop(vampire_charge_amount, cooker = cooker)

/obj/machinery/microwave/proc/charge(mob/cooker)
	if(!vampire_charging_capable)
		balloon_alert(cooker, "Требуется улучшение!")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return

	if(operating || broken > 0 || panel_open || dirty >= MAX_MICROWAVE_DIRTINESS)
		return

	if(wire_disabled)
		audible_message("[src] гудит.")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return

	// We should only be charging PDAs
	for(var/atom/movable/potential_item as anything in ingredients)
		if(!istype(potential_item, /obj/item/modular_computer/pda))
			balloon_alert(cooker, "только ПДА!")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
			eject()
			return

	vampire(cooker)

/**
 * The actual cook loop started via [proc/start] or [proc/start_can_fail]
 *
 * * type - the type of charging, determined via how this iteration of cook_loop is called, and determines the result
 * * time - how many loops are left, base case for recursion
 * * wait - deciseconds between loops
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/charge_loop(vampire_charge_amount, wait = max(12 - 2 * efficiency, 2), mob/cooker) // standard wait is 10
	if(machine_stat & BROKEN)
		pre_fail()
		return

	if(!vampire_charge_amount || !length(ingredients) || (!isnull(cell) && !cell.charge) || vampire_charge_amount < 25)
		vampire_cell = null
		charge_loop_finish(cooker)
		return

	var/charge_rate = vampire_cell.chargerate * (1 + ((efficiency - 1) * 0.25))
	if(charge_rate > vampire_charge_amount)
		charge_rate = vampire_charge_amount

	if(cell_powered && !cell.use(charge_rate))
		charge_loop_finish(cooker)

	vampire_cell.give(charge_rate * (0.85 + (efficiency * 0.5))) // we lose a tiny bit of power in the transfer as heat
	use_power(charge_rate)

	vampire_charge_amount = vampire_cell.maxcharge - vampire_cell.charge

	addtimer(CALLBACK(src, PROC_REF(charge_loop), vampire_charge_amount, wait, cooker), wait)

/obj/machinery/microwave/power_change()
	. = ..()
	if((machine_stat & NOPOWER) && operating)
		pre_fail()
		eject()

/**
 * Called when the charge_loop is done successfully, no dirty mess or whatever
 *
 * * cooker - The mob that initiated the cook cycle, can be null if no apparent mob triggered it (such as via emp)
 */
/obj/machinery/microwave/proc/charge_loop_finish(mob/cooker)
	operating = FALSE
	var/cursed_chef = cooker && HAS_TRAIT(cooker, TRAIT_CURSED)
	if(cursed_chef && prob(5))
		spark()
		broken = REALLY_BROKEN
		explosion(src, light_impact_range = 2, flame_range = 1)

	// playsound(src, 'sound/machines/chime.ogg', 50, FALSE)
	after_finish_loop()

/// Type of microwave that automatically turns it self on erratically. Probably don't use this outside of the holodeck program "Microwave Paradise".
/// You could also live your life with a microwave that will continously run in the background of everything while also not having any power draw. I think the former makes more sense.
/obj/machinery/microwave/hell
	desc = "Варит и греет вещи. Этот, кажется, немного... отличается."
	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/microwave/hell/Initialize(mapload)
	. = ..()
	//We want there to be some chance of them getting a working microwave (eventually).
	if(prob(95))
		//The microwave should turn off asynchronously from any other microwaves that initialize at the same time. Keep in mind this will not turn off, since there is nothing to call the proc that ends this microwave's looping
		addtimer(CALLBACK(src, PROC_REF(wzhzhzh)), rand(0.5 SECONDS, 3 SECONDS))

/obj/machinery/microwave/engineering
	name = "беспроводная микроволновка"
	desc = "Создана для какого-то трудолюбивого торговца, который находится в какой-то глуши и просто хочет разогреть свою выпечку из дорогого торгового автомата."
	base_icon_state = "engi_"
	icon_state = "engi_mw_complete"
	circuit = /obj/item/circuitboard/machine/microwave/engineering
	light_color = LIGHT_COLOR_BABY_BLUE
	// We don't use area power, we always use the cell
	use_power = NO_POWER_USE
	cell_powered = TRUE
	vampire_charging_capable = TRUE
	ingredient_shifts_x = list(
		0,
		5,
		-5,
		3,
		-3,
	)
	ingredient_shifts_y = list(
		0,
		2,
		-2,
	)

/obj/machinery/microwave/engineering/Initialize(mapload)
	. = ..()
	if(mapload)
		cell = new /obj/item/stock_parts/cell/upgraded/plus
	update_appearance()

/obj/machinery/microwave/engineering/cell_included/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/cell/upgraded/plus
	update_appearance()

#undef MICROWAVE_NORMAL
#undef MICROWAVE_MUCK
#undef MICROWAVE_PRE

#undef NOT_BROKEN
#undef KINDA_BROKEN
#undef REALLY_BROKEN

#undef MAX_MICROWAVE_DIRTINESS
#undef TIER_1_CELL_CHARGE_RATE
