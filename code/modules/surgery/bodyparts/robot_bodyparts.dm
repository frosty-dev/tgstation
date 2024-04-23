
#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

//For ye whom may venture here, split up arm / hand sprites are formatted as "l_hand" & "l_arm".
//The complete sprite (displayed when the limb is on the ground) should be named "borg_l_arm".
//Failure to follow this pattern will cause the hand's icons to be missing due to the way get_limb_icon() works to generate the mob's icons using the aux_zone var.

/obj/item/bodypart/arm/left/robot
	name = "левая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	limb_id = BODYPART_ID_ROBOTIC
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	icon_static = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_arm"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/arm/right/robot
	name = "правая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	flags_1 = CONDUCT_1
	icon_state = "borg_r_arm"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/left/robot
	name = "левая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	flags_1 = CONDUCT_1
	icon_state = "borg_l_leg"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/left/robot/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [plaintext_zone] unexpectedly malfunctions, it causes you to fall to the ground!"))

/obj/item/bodypart/leg/right/robot
	name = "правая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon_static =  'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	flags_1 = CONDUCT_1
	icon_state = "borg_r_leg"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/right/robot/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [plaintext_zone] unexpectedly malfunctions, it causes you to fall to the ground!"))

/obj/item/bodypart/chest/robot
	name = "туловище киборга"
	desc = "Тяжело укрепленный корпус, содержащий логические платы киборга, с отверстием под стандартную ячейку питания."
	inhand_icon_state = "buildpipe"
	icon_static =  'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	flags_1 = CONDUCT_1
	icon_state = "borg_chest"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

	var/wired = FALSE
	var/obj/item/stock_parts/cell/cell = null

	robotic_emp_paralyze_damage_percent_threshold = 0.6

	wing_types = list(/obj/item/organ/external/wings/functional/robotic)

/obj/item/bodypart/chest/robot/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	var/stun_time = 0
	var/shift_x = 3
	var/shift_y = 0
	var/shake_duration = AUGGED_CHEST_EMP_SHAKE_TIME

	if(severity == EMP_HEAVY)
		stun_time = AUGGED_CHEST_EMP_STUN_TIME

		shift_x = 5
		shift_y = 2

	var/damage_percent_to_max = (get_damage() / max_damage)
	if (stun_time && (damage_percent_to_max >= robotic_emp_paralyze_damage_percent_threshold))
		to_chat(owner, span_danger("Your [plaintext_zone]'s logic boards temporarily become unresponsive!"))
		owner.Stun(stun_time)
	owner.Shake(pixelshiftx = shift_x, pixelshifty = shift_y, duration = shake_duration)

/obj/item/bodypart/chest/robot/get_cell()
	return cell

/obj/item/bodypart/chest/robot/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == cell)
		cell = null

/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	UnregisterSignal(src, COMSIG_BODYPART_ATTACHED)
	return ..()

/obj/item/bodypart/chest/robot/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_BODYPART_ATTACHED, PROC_REF(on_attached))
	RegisterSignal(src, COMSIG_BODYPART_REMOVED, PROC_REF(on_detached))

/obj/item/bodypart/chest/robot/proc/on_attached(obj/item/bodypart/chest/robot/this_bodypart, mob/living/carbon/human/new_owner)
	SIGNAL_HANDLER

	RegisterSignals(new_owner, list(COMSIG_CARBON_POST_ATTACH_LIMB, COMSIG_CARBON_POST_REMOVE_LIMB), PROC_REF(check_limbs))

/obj/item/bodypart/chest/robot/proc/on_detached(obj/item/bodypart/chest/robot/this_bodypart, mob/living/carbon/human/old_owner)
	SIGNAL_HANDLER

	UnregisterSignal(old_owner, list(COMSIG_CARBON_POST_ATTACH_LIMB, COMSIG_CARBON_POST_REMOVE_LIMB))

/obj/item/bodypart/chest/robot/proc/check_limbs()
	SIGNAL_HANDLER

	var/all_robotic = TRUE
	for(var/obj/item/bodypart/part in owner.bodyparts)
		all_robotic = all_robotic && IS_ROBOTIC_LIMB(part)

	if(all_robotic)
		owner.add_traits(list(
			TRAIT_RESISTCOLD,
			TRAIT_RESISTHEAT,
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
			), AUGMENTATION_TRAIT)
	else
		owner.remove_traits(list(
			TRAIT_RESISTCOLD,
			TRAIT_RESISTHEAT,
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
			), AUGMENTATION_TRAIT)

/obj/item/bodypart/chest/robot/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, span_warning("Уже вставил[user.ru_a()] ячейку питания!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			cell = weapon
			to_chat(user, span_notice("Вставил[user.ru_a()] ячейку питания."))
	else if(istype(weapon, /obj/item/stack/cable_coil))
		if(wired)
			to_chat(user, span_warning("Уже вставил[user.ru_a()] провод!"))
			return
		var/obj/item/stack/cable_coil/coil = weapon
		if (coil.use(1))
			wired = TRUE
			to_chat(user, span_notice("Вставил[user.ru_a()] провод."))
		else
			to_chat(user, span_warning("Мне нужен 1 кусок провода, чтобы присоединить его сюда!"))
	else
		return ..()

/obj/item/bodypart/chest/robot/wirecutter_act(mob/living/user, obj/item/cutter)
	. = ..()
	if(!wired)
		return
	. = TRUE
	cutter.play_tool_sound(src)
	to_chat(user, span_notice("Отрезаю провода в [src]."))
	new /obj/item/stack/cable_coil(drop_location(), 1)
	wired = FALSE

/obj/item/bodypart/chest/robot/screwdriver_act(mob/living/user, obj/item/screwtool)
	..()
	. = TRUE
	if(!cell)
		to_chat(user, span_warning("В [src] не установлен источник питания!"))
		return
	screwtool.play_tool_sound(src)
	to_chat(user, span_notice("Извлекаю [cell] из [src]."))
	cell.forceMove(drop_location())

/obj/item/bodypart/chest/robot/examine(mob/user)
	. = ..()
	if(cell)
		. += {"Имеет вставленную [cell].\n
		[span_info("Можно использовать <b>отвертку</b>, чтобы извлечь [cell].")]"}
	else
		. += span_info("Имеет пустой слот для <b>ячейки питания</b>.")
	if(wired)
		. += "Всё подключено [cell ? " и готово для использования" : ""].\n"+\
		span_info("Можно использовать <b>кусачки</b>, чтобы извлечь проводку.")
	else
		. += span_info("Имеет пару гнезд, которые необходимо <b>подключить</b>.")

/obj/item/bodypart/chest/robot/drop_organs(mob/user, violent_removal)
	var/atom/drop_loc = drop_location()
	if(wired)
		new /obj/item/stack/cable_coil(drop_loc, 1)
		wired = FALSE
	cell?.forceMove(drop_loc)
	return ..()

/obj/item/bodypart/head/robot
	name = "голова киборга"
	desc = "Стандартная укрепленная черепная коробка, с подключаемой к позвоночнику нейронным сокетом и сенсорными стыковочными узлами."
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	flags_1 = CONDUCT_1
	icon_state = "borg_head"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

	head_flags = HEAD_EYESPRITES

	var/obj/item/assembly/flash/handheld/flash1 = null
	var/obj/item/assembly/flash/handheld/flash2 = null

#define EMP_GLITCH "EMP_GLITCH"

/obj/item/bodypart/head/robot/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	to_chat(owner, span_danger("Your [plaintext_zone]'s optical transponders glitch out and malfunction!"))

	var/glitch_duration = AUGGED_HEAD_EMP_GLITCH_DURATION
	if (severity == EMP_HEAVY)
		glitch_duration *= 2

	owner.add_client_colour(/datum/client_colour/malfunction)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, remove_client_colour), /datum/client_colour/malfunction), glitch_duration)

#undef EMP_GLITCH

/obj/item/bodypart/head/robot/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == flash1)
		flash1 = null
	if(gone == flash2)
		flash2 = null

/obj/item/bodypart/head/robot/Destroy()
	QDEL_NULL(flash1)
	QDEL_NULL(flash2)
	return ..()

/obj/item/bodypart/head/robot/examine(mob/user)
	. = ..()
	if(!flash1 && !flash2)
		. += span_info("Имеет два свободных слота для <b>вспышек</b>.")
	else
		var/single_flash = FALSE
		if(!flash1 || !flash2)
			single_flash = TRUE
			. += {"Один из слотов на данный момент занят вспышкой.\n
			[span_info("В ней есть еще один свободный слот под <b>вспышку</b>.")]"}
		else
			. += "Оба слота заняты вспышками."
		. += span_notice("Можно извлечь [single_flash ? "установленную вспышку":"установленные вспышки"] при помощи <b>ломика</b>.")

/obj/item/bodypart/head/robot/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/assembly/flash/handheld))
		var/obj/item/assembly/flash/handheld/flash = weapon
		if(flash1 && flash2)
			to_chat(user, span_warning("Уже вставил[user.ru_a()] глаза!"))
			return
		else if(flash.burnt_out)
			to_chat(user, span_warning("Не могу использовать сломанную вспышку!"))
			return
		else
			if(!user.transferItemToLoc(flash, src))
				return
			if(flash1)
				flash2 = flash
			else
				flash1 = flash
			to_chat(user, span_notice("Вставил[user.ru_a()] вспышку в соответствующий слот."))
			return
	return ..()

/obj/item/bodypart/head/robot/crowbar_act(mob/living/user, obj/item/prytool)
	..()
	if(flash1 || flash2)
		prytool.play_tool_sound(src)
		to_chat(user, span_notice("Извлекаю вспышку из [src]."))
		flash1?.forceMove(drop_location())
		flash2?.forceMove(drop_location())
	else
		to_chat(user, span_warning("В [src] нет вспышки которую можно извлечь."))
	return TRUE

/obj/item/bodypart/head/robot/drop_organs(mob/user, violent_removal)
	var/atom/drop_loc = drop_location()
	flash1?.forceMove(drop_loc)
	flash2?.forceMove(drop_loc)
	return ..()

// Prosthetics - Cheap, mediocre, and worse than organic limbs
// The fact they dont have a internal biotype means theyre a lot weaker defensively,
// since they skip slash and go right to blunt
// They are VERY easy to delimb as a result
// HP is also reduced just in case this isnt enough

/obj/item/bodypart/arm/left/robot/surplus
	name = "бюджетный протез левой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	burn_modifier = 1
	brute_modifier = 1
	max_damage = PROSTHESIS_MAX_HP

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/surplus
	name = "бюджетный протез правой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	burn_modifier = 1
	brute_modifier = 1
	max_damage = PROSTHESIS_MAX_HP

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/surplus
	name = "бюджетный протез левой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_modifier = 1
	burn_modifier = 1
	max_damage = PROSTHESIS_MAX_HP

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/surplus
	name = "бюджетный протез правой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_modifier = 1
	burn_modifier = 1
	max_damage = PROSTHESIS_MAX_HP

	biological_state = (BIO_METAL|BIO_JOINTED)

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG
