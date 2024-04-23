/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "кирка"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	inhand_icon_state = "pickaxe"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 15
	throwforce = 10
	demolition_mod = 1.15
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb_continuous = list("бьёт", "протыкает", "рубит", "атакует")
	attack_verb_simple = list("бьёт", "протыкает", "рубит", "атакует")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/pickaxe/rusted
	name = "ржавая кирка"
	desc = "Кирка, оставленная ржаветь."
	attack_verb_continuous = list("тыкает")
	attack_verb_simple = list("тыкает")
	force = 1
	throwforce = 1

/obj/item/pickaxe/mini
	name = "компактная кирка"
	desc = "Меньшая, компактная версия стандартной кирки."
	icon_state = "minipick"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/pickaxe/silver
	name = "посеребренная кирка"
	desc = "Посеребренная кирка, которая добывает немного быстрее, чем стандартная."
	icon_state = "spickaxe"
	inhand_icon_state = "spickaxe"
	toolspeed = 0.5 //mines faster than a normal pickaxe, bought from mining vendor
	force = 17

/obj/item/pickaxe/diamond
	name = "кирка с алмазным наконечником"
	desc = "Кирка с алмазной головкой. Чрезвычайно устойчива к растрескиванию каменных стен и выкапыванию грязи."
	icon_state = "dpickaxe"
	inhand_icon_state = "dpickaxe"
	toolspeed = 0.3
	force = 19

/obj/item/pickaxe/drill
	name = "шахтёрский бур"
	desc = "Тяжелая буровая установка для особо крепкой породы."
	icon_state = "handdrill"
	inhand_icon_state = "handdrill"
	slot_flags = ITEM_SLOT_BELT
	toolspeed = 0.6 //available from roundstart, faster than a pickaxe.
	usesound = 'sound/weapons/drill.ogg'
	hitsound = 'sound/weapons/drill.ogg'

/obj/item/pickaxe/drill/cyborg
	name = "шахтёрский бур киборга"
	desc = "Интегрированная электрическая буровая установка."
	flags_1 = NONE

/obj/item/pickaxe/drill/cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/pickaxe/drill/diamonddrill
	name = "бур с алмазным напылением"
	desc = "Мой бур создан, чтобы пронзить небеса!"
	icon_state = "diamonddrill"
	inhand_icon_state = "diamonddrill"
	toolspeed = 0.2

/obj/item/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "бур с алмазным напылением киборга" //To inherit the NODROP_1 flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	inhand_icon_state = "diamonddrill"
	toolspeed = 0.2

/obj/item/pickaxe/drill/jackhammer
	name = "ультразвуковой пневмоперфоратор"
	desc = "Крошит породу в пыль высокочастотными звуковыми импульсами."
	icon_state = "jackhammer"
	inhand_icon_state = "jackhammer"
	toolspeed = 0.1 //the epitome of powertools. extremely fast mining
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/item/pickaxe/improvised
	name = "импровизированная кирка"
	desc = "Кирка, сделанная из ножа и лома, склеенных вместе, как она не ломается?"
	icon_state = "ipickaxe"
	inhand_icon_state = "ipickaxe"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	toolspeed = 3 //3 times slower than a normal pickaxe
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6) //This number used to be insane and I'm just going to save your sanity and not tell you what it was.

/obj/item/shovel
	name = "лопата"
	desc = "Большой инструмент для копания и перемещения грязи."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	inhand_icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 8
	throwforce = 4
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)
	attack_verb_continuous = list("колотит", "ударяет", "колошматит", "вмазывает")
	attack_verb_simple = list("колотит", "ударяет", "колошматит", "вмазывает")
	sharpness = SHARP_EDGED

/obj/item/shovel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 15 SECONDS, \
	effectiveness = 40, \
	)
	//it's sharp, so it works, but barely.

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging their own grave! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/shovel/spade
	name = "лопатка"
	desc = "Маленькая лопатка для вскапывания земли."
	icon_state = "spade"
	inhand_icon_state = "spade"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/serrated
	name = "зубчатая костяная лопата"
	desc = "Коварный инструмент, который пробивает грязь так же легко, как и плоть. Дизайн был выполнен в стиле древних племен Лаваленда."
	icon_state = "shovel_bone"
	worn_icon_state = "shovel_serr"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	force = 10
	throwforce = 12
	w_class = WEIGHT_CLASS_NORMAL
	tool_behaviour = TOOL_SHOVEL // hey, it's serrated.
	toolspeed = 0.3
	attack_verb_continuous = list("колотит", "ударяет", "колошматит", "вмазывает")
	attack_verb_simple = list("колотит", "ударяет", "колошматит", "вмазывает")
	sharpness = SHARP_EDGED
	item_flags = CRUEL_IMPLEMENT

/obj/item/shovel/serrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bane, mob_biotypes = MOB_ORGANIC, damage_multiplier = 1) //You may be horridly cursed now, but at least you kill the living a whole lot more easily!

/obj/item/shovel/serrated/examine(mob/user)
	. = ..()
	if( !(user.mind && HAS_TRAIT(user.mind, TRAIT_MORBID)) )
		return
	. += span_deadsay("Чувствую странное желание пронзить живую плоть этой лопатой. Почему она зубчатая? Мысль завораживает...")

// Coroner mail version
/obj/item/shovel/serrated/dull
	name = "тупая костяная лопата"
	desc = "Древняя тупая костяная лопата с странным дизайном и маркировкой. Визуально она кажется довольно слабой, но вы чувствуете, что в ней есть что-то большее, чем кажется на первый взгляд..."
	force = 8
	throwforce = 10
	toolspeed = 0.8

/obj/item/trench_tool
	name = "инструмент для рытья траншей"
	desc = "Многоцелевой инструмент, который всегда вам нужен."
	icon = 'icons/obj/mining.dmi'
	icon_state = "trench_tool"
	inhand_icon_state = "trench_tool"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 15
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	tool_behaviour = TOOL_WRENCH
	toolspeed = 0.75
	usesound = 'sound/items/ratchet.ogg'
	attack_verb_continuous = list("колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("колотит", "бьёт", "ударяет", "вмазывает")
	wound_bonus = 10

/obj/item/trench_tool/get_all_tool_behaviours()
	return list(TOOL_MINING, TOOL_SHOVEL, TOOL_WRENCH)

/obj/item/trench_tool/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/trench_tool/examine(mob/user)
	. = ..()
	. += span_danger("Используйте в руке, чтобы переключить конфигурацию.")
	. += span_danger("Он функционирует как [uncapitalize(tool_behaviour)].")

/obj/item/trench_tool/update_icon_state()
	. = ..()
	switch(tool_behaviour)
		if(TOOL_WRENCH)
			icon_state = inhand_icon_state = initial(icon_state)
		if(TOOL_SHOVEL)
			icon_state = inhand_icon_state = "[initial(icon_state)]_shovel"
		if(TOOL_MINING)
			icon_state = inhand_icon_state = "[initial(icon_state)]_pick"

/obj/item/trench_tool/attack_self(mob/user, modifiers)
	. = ..()
	if(!user)
		return
	var/list/tool_list = list(
		"Гаечный ключ" = image(icon = icon, icon_state = "trench_tool"),
		"Лопата" = image(icon = icon, icon_state = "trench_tool_shovel"),
		"Кирка" = image(icon = icon, icon_state = "trench_tool_pick"),
		)
	var/tool_result = show_radial_menu(user, src, tool_list, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user) || !tool_result)
		return
	switch(tool_result)
		if("Гаечный ключ")
			tool_behaviour = TOOL_WRENCH
			sharpness = NONE
			toolspeed = 0.75
			w_class = WEIGHT_CLASS_SMALL
			usesound = 'sound/items/ratchet.ogg'
			attack_verb_continuous = list("колотит", "бьёт", "ударяет", "вмазывает")
			attack_verb_simple = list("колотит", "бьёт", "ударяет", "вмазывает")
		if("Лопата")
			tool_behaviour = TOOL_SHOVEL
			sharpness = SHARP_EDGED
			toolspeed = 0.25
			w_class = WEIGHT_CLASS_NORMAL
			usesound = 'sound/effects/shovel_dig.ogg'
			attack_verb_continuous = list("колотит", "ударяет", "колошматит", "вмазывает")
			attack_verb_simple = list("колотит", "ударяет", "колошматит", "вмазывает")
		if("Кирка")
			tool_behaviour = TOOL_MINING
			sharpness = SHARP_POINTY
			toolspeed = 0.5
			w_class = WEIGHT_CLASS_NORMAL
			usesound = 'sound/effects/picaxe1.ogg'
			attack_verb_continuous = list("бьёт", "протыкает", "рубит", "атакует")
			attack_verb_simple = list("бьёт", "протыкает", "рубит", "атакует")
	playsound(src, 'sound/items/ratchet.ogg', 50, vary = TRUE)
	update_appearance(UPDATE_ICON)

/obj/item/trench_tool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/shovel/giant_wrench
	name = "Big Slappy"
	desc = "Гигантский гаечный ключ. Признан незаконным из-за множества инцидентов, связанных с этим инструментом."
	icon_state = "giant_wrench"
	icon = 'icons/obj/weapons/giant_wrench.dmi'
	inhand_icon_state = null
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	toolspeed = 0.1
	force = 30
	throwforce = 20
	block_chance = 30
	throw_range = 2
	demolition_mod = 2
	armor_type = /datum/armor/giant_wrench
	resistance_flags = FIRE_PROOF
	wound_bonus = -10
	attack_verb_continuous = list("бьёт", "протыкает", "рубит", "атакует")
	attack_verb_simple = list("бьёт", "протыкает", "рубит", "атакует")
	drop_sound = 'sound/weapons/sonic_jackhammer.ogg'
	pickup_sound = 'sound/items/handling/crowbar_pickup.ogg'
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	block_sound = 'sound/weapons/sonic_jackhammer.ogg'
	obj_flags = IMMUTABLE_SLOW
	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 3
	attack_speed = 1.2 SECONDS
	/// The factor at which the recoil becomes less.
	var/recoil_factor = 3
	/// Wether we knock down and launch away out enemies when we attack.
	var/do_launch = TRUE

/obj/item/shovel/giant_wrench/get_all_tool_behaviours()
	return list(TOOL_SHOVEL, TOOL_WRENCH)

/datum/armor/giant_wrench
	acid = 30
	bomb = 100
	bullet = 30
	fire = 100
	laser = 30
	melee = 30

/obj/item/shovel/giant_wrench/Initialize(mapload)
	. = ..()
	transform = transform.Translate(-16, -16)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	AddComponent( \
		/datum/component/transforming, \
		force_on = 40, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		sharpness_on = SHARP_POINTY, \
		clumsy_check = TRUE, \
		inhand_icon_change = TRUE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/// Used when the tool is transformed through the transforming component.
/obj/item/shovel/giant_wrench/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	usesound = (active ? 'sound/items/ratchet.ogg' : initial(usesound))
	block_chance = (active ? 0 : initial(block_chance))
	recoil_factor = (active ? 2 : initial(recoil_factor))
	do_launch = (active ? FALSE : initial(do_launch))
	tool_behaviour = (active ? TOOL_WRENCH : initial(tool_behaviour))
	armour_penetration = (active ? 30 : initial(armour_penetration))
	if(user)
		balloon_alert(user, "[active ? "открываю" : "закрываю"] Big Slappy")
	playsound(src, 'sound/items/ratchet.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/shovel/giant_wrench/attack(mob/living/target_mob, mob/living/user)
	..()
	if(QDELETED(target_mob))
		return
	if(do_launch)
		var/atom/throw_target = get_edge_target_turf(target_mob, get_dir(user, get_step_away(target_mob, user)))
		target_mob.throw_at(throw_target, 2, 2, user, gentle = TRUE)
		target_mob.Knockdown(2 SECONDS)
	var/body_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	user.apply_damage(force / recoil_factor, BRUTE, body_zone, user.run_armor_check(body_zone, MELEE))
	log_combat(user, user, "recoiled Big Slappy into")
