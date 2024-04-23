/obj/item/retractor
	name = "расширитель"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "retractor"
	inhand_icon_state = "retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	tool_behaviour = TOOL_RETRACTOR
	toolspeed = 1
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "retractor_normal"

/obj/item/retractor/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/retractor/augment
	name = "кибернетический расширитель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "retractor"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	toolspeed = 0.5


/obj/item/hemostat
	name = "зажим"
	desc = "Используется для манипуляций в рабочей области и остановки внутренних кровотечений."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "hemostat"
	inhand_icon_state = "hemostat"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("атакует", "прокусывает")
	attack_verb_simple = list("атакует", "прокусывает")
	tool_behaviour = TOOL_HEMOSTAT
	toolspeed = 1
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "hemostat_normal"

/obj/item/hemostat/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/hemostat/augment
	name = "кибернетический зажим"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "hemostat"
	desc = "Крошечные сервоприводы приводят пару зажимов в действие, чтобы остановить кровотечение."
	toolspeed = 0.5


/obj/item/cautery
	name = "прижигатель"
	desc = "Останавливает кровотечения и дезинфецирует рабочую зону после завершения операции."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "cautery"
	inhand_icon_state = "cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass = SMALL_MATERIAL_AMOUNT*7.5)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("прожигает")
	attack_verb_simple = list("прожигает")
	tool_behaviour = TOOL_CAUTERY
	toolspeed = 1
	heat = 500
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "cautery_normal"

/obj/item/cautery/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/cautery/ignition_effect(atom/ignitable_atom, mob/user)
	. = span_notice("[user] притрагивается раскалённым концом [src.name] к [ignitable_atom.name].")

/obj/item/cautery/augment
	name = "кибернетический прижигатель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "cautery"
	desc = "Нагревательный элемент, который прижигает раны."
	toolspeed = 0.5

/obj/item/cautery/advanced
	name = "лазерный прижигатель"
	desc = "Устройство, используемое для дезинфекции и прижигания раны за счёт излучения низкочастотного лазерного луча. Так же можно сфокусирувать луч до мощности небольшого зубного сверла."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "e_cautery"
	inhand_icon_state = "e_cautery"
	surgical_tray_overlay = "cautery_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/uranium = SHEET_MATERIAL_AMOUNT*1.5, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*1.5)
	hitsound = 'sound/items/welder.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = COLOR_SOFT_RED

/obj/item/cautery/advanced/get_all_tool_behaviours()
	return list(TOOL_CAUTERY, TOOL_DRILL)

/obj/item/cautery/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between drill and cautery and gives feedback to the user.
 */
/obj/item/cautery/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_DRILL : TOOL_CAUTERY)
	balloon_alert(user, "Линза [active ? "сфокусирована" : "расфокусирована"]")
	playsound(user ? user : src, 'sound/weapons/tap.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/cautery/advanced/examine()
	. = ..()
	. += span_notice("Переключатель установлен на режиме [tool_behaviour == TOOL_CAUTERY ? "прижигателя" : "сверла"].")

/obj/item/surgicaldrill
	name = "хирургическая дрель"
	desc = "Можно просверлить с помощью этого что-то. Или пробурить?"
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "drill"
	inhand_icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*3)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	demolition_mod = 0.5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("дырявит")
	attack_verb_simple = list("дырявит")
	tool_behaviour = TOOL_DRILL
	toolspeed = 1
	sharpness = SHARP_POINTY
	wound_bonus = 10
	bare_wound_bonus = 10
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "drill_normal"

/obj/item/surgicaldrill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/surgicaldrill/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/surgicaldrill/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] rams [src] into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, gib), null, null, TRUE, TRUE), 25)
	user.SpinAnimation(3, 10)
	playsound(user, 'sound/machines/juicer.ogg', 20, TRUE)
	return MANUAL_SUICIDE

/obj/item/surgicaldrill/augment
	name = "кибернетическая дрель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "surgicaldrill"
	desc = "По сути, небольшая электрическая дрель, содержащаяся в руке, края притуплены, чтобы предотвратить повреждение тканей. Может или не может пронзить небеса."
	hitsound = 'sound/weapons/circsawhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

/obj/item/scalpel
	name = "скальпель"
	desc = "Очень острое лезвие с микронной заточкой."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "scalpel"
	inhand_icon_state = "scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 10
	demolition_mod = 0.25
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SCALPEL
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "scalpel_normal"

/obj/item/scalpel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 0, \
	)
	AddElement(/datum/element/eyestab)

/obj/item/scalpel/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/scalpel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] [pick("wrists", "throat", "stomach")] with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/scalpel/augment
	name = "кибернетический скальпель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "scalpel"
	desc = "Ультра-острое лезвие прикреплено непосредственно к кости для дополнительной точности."
	toolspeed = 0.5

/obj/item/circular_saw
	name = "циркулярная пила"
	desc = "Для работы с костью при полостных операциях."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "saw"
	inhand_icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	mob_throw_hit_sound = 'sound/weapons/pierce.ogg'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*3)
	attack_verb_continuous = list("атакует", "рубит", "пилит", "режет")
	attack_verb_simple = list("атакует", "рубит", "пилит", "режет")
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 1
	wound_bonus = 15
	bare_wound_bonus = 10
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "saw_normal"

/obj/item/circular_saw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 4 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 5, \
	butcher_sound = 'sound/weapons/circsawhit.ogg', \
	)
	//saws are very accurate and fast at butchering
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/chainsaw)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/circular_saw/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/circular_saw/augment
	name = "кибернетическая пила"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "circular_saw"
	desc = "Маленькая, но очень быстро вращающаяся пила."
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5


/obj/item/surgical_drapes
	name = "хирургическая простыня"
	desc = "Хирургические простыни марки NanoTrasen обеспечивают оптимальную безопасность и защиту от инфекций."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "surgical_drapes"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "drapes"
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("шлёпает")
	attack_verb_simple = list("шлёпает")

/obj/item/surgical_drapes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_processor //allows medical cyborgs to scan and initiate advanced surgeries
	name = "хирургический процессор"
	desc = "Устройство для сканирования и запуска операций с диска или операционного компьютера."
	icon = 'icons/obj/device.dmi'
	icon_state = "surgical_processor"
	item_flags = NOBLUDGEON
	// List of surgeries downloaded into the device.
	var/list/loaded_surgeries = list()
	// If a surgery has been downloaded in. Will cause the display to have a noticeable effect - helps to realize you forgot to load anything in.
	var/downloaded = TRUE

/obj/item/surgical_processor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_processor/examine(mob/user)
	. = ..()
	. += span_notice("Equip the processor in one of your active modules to access downloaded advanced surgeries.")
	. += span_boldnotice("Advanced surgeries available:")
	//list of downloaded surgeries' names
	var/list/surgeries_names = list()
	for(var/datum/surgery/downloaded_surgery as anything in loaded_surgeries)
		if(initial(downloaded_surgery.replaced_by) in loaded_surgeries) //if a surgery has a better version replacing it, we don't include it in the list
			continue
		surgeries_names += "[initial(downloaded_surgery.name)]"
	. += span_notice("[english_list(surgeries_names)]")

/obj/item/surgical_processor/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		UnregisterSignal(user, COMSIG_SURGERY_STARTING)
		return
	RegisterSignal(user, COMSIG_SURGERY_STARTING, PROC_REF(check_surgery))

/obj/item/surgical_processor/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/cyborg_unequip(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/afterattack(atom/design_holder, mob/user, proximity)
	if(!proximity)
		return ..()
	if(!istype(design_holder, /obj/item/disk/surgery) && !istype(design_holder, /obj/machinery/computer/operating))
		return ..()
	balloon_alert(user, "копирую хирургические протоколы...")
	playsound(src, 'sound/machines/terminal_processing.ogg', 25, TRUE)
	if(do_after(user, 1 SECONDS, target = design_holder))
		if(istype(design_holder, /obj/item/disk/surgery))
			var/obj/item/disk/surgery/surgery_disk = design_holder
			loaded_surgeries |= surgery_disk.surgeries
		else
			var/obj/machinery/computer/operating/surgery_computer = design_holder
			loaded_surgeries |= surgery_computer.advanced_surgeries
		playsound(src, 'sound/machines/terminal_success.ogg', 25, TRUE)
		downloaded = TRUE
		update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/surgical_processor/update_overlays()
	. = ..()
	if(downloaded)
		. += mutable_appearance(src.icon, "+downloaded")

/obj/item/surgical_processor/proc/check_surgery(mob/user, datum/surgery/surgery, mob/patient)
	SIGNAL_HANDLER

	if(surgery.replaced_by in loaded_surgeries)
		return COMPONENT_CANCEL_SURGERY
	if(surgery.type in loaded_surgeries)
		return COMPONENT_FORCE_SURGERY

/obj/item/scalpel/advanced
	name = "лазерный скальпель"
	desc = "Усовершенствованный скальпель, который использует лазерную технологию для резки. Переключателем можно увеличить мощность излучателя для работы с костью."
	icon_state = "e_scalpel"
	inhand_icon_state = "e_scalpel"
	surgical_tray_overlay = "scalpel_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 2, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*2)
	hitsound = 'sound/weapons/blade1.ogg'
	force = 16
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = LIGHT_COLOR_BLUE
	sharpness = SHARP_EDGED

/obj/item/scalpel/advanced/get_all_tool_behaviours()
	return list(TOOL_SAW, TOOL_SCALPEL)

/obj/item/scalpel/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force + 1, \
		throwforce_on = throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between saw and scalpel and updates the light / gives feedback to the user.
 */
/obj/item/scalpel/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_SAW
		set_light_range(2)
	else
		tool_behaviour = TOOL_SCALPEL
		set_light_range(1)

	balloon_alert(user, "[active ? "увеличиваю" : "уменьшаю"] мощность")
	playsound(user ? user : src, 'sound/machines/click.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/scalpel/advanced/examine()
	. = ..()
	. += span_notice("Переключатель мощности установлен на режиме [tool_behaviour == TOOL_SCALPEL ? "скальпеля" : "пилы"].")

/obj/item/retractor/advanced
	name = "механический зажим"
	desc = "Сложный инструмент состоящий из шестеренок и манипуляторов."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6, /datum/material/glass = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5)
	icon_state = "adv_retractor"
	inhand_icon_state = "adv_retractor"
	surgical_tray_overlay = "retractor_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7

/obj/item/retractor/advanced/get_all_tool_behaviours()
	return list(TOOL_HEMOSTAT, TOOL_RETRACTOR)

/obj/item/retractor/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between retractor and hemostat and gives feedback to the user.
 */
/obj/item/retractor/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_HEMOSTAT : TOOL_RETRACTOR)
	balloon_alert(user, "шестерни установлены в положении [active ? "зажима" : "расширителя"]")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/retractor/advanced/examine()
	. = ..()
	. += span_notice("Шестерни установлены в положении  [tool_behaviour == TOOL_RETRACTOR ? "расширителя" : "зажима"].")

/obj/item/shears
	name = "ножницы для ампутации"
	desc = "Тип тяжелых хирургических ножниц, используемых для достижения чистого разделения между конечностью и пациентом. Держать пациента по-прежнему необходимо, чтобы иметь возможность закрепить и выровнять ножницы."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "shears"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	toolspeed = 1
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 6
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*4, /datum/material/titanium=SHEET_MATERIAL_AMOUNT*3)
	attack_verb_continuous = list("стрижёт", "режет")
	attack_verb_simple = list("стрижёт", "режет")
	sharpness = SHARP_EDGED
	custom_premium_price = PAYCHECK_CREW * 14

/obj/item/shears/attack(mob/living/amputee, mob/living/user)
	if(!iscarbon(amputee) || user.combat_mode)
		return ..()

	if(user.zone_selected == BODY_ZONE_CHEST)
		return ..()

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("Конечности пациента выглядят слишком крепкими для ампутации."))
		return

	var/candidate_name
	var/obj/item/organ/external/tail_snip_candidate
	var/obj/item/bodypart/limb_snip_candidate

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		tail_snip_candidate = patient.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(!tail_snip_candidate)
			to_chat(user, span_warning("[patient] не имеет хвоста."))
			return
		candidate_name = tail_snip_candidate.name

	else
		limb_snip_candidate = patient.get_bodypart(check_zone(user.zone_selected))
		if(!limb_snip_candidate)
			to_chat(user, span_warning("[patient] не имеет здесь конечности."))
			return
		candidate_name = limb_snip_candidate.name

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user] начинает устанавливать [src] вокруг [candidate_name] [patient].") , span_userdanger("[user] начинает закреплять [src] вокруг моей [candidate_name]!"))
	playsound(get_turf(patient), 'sound/items/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || HAS_TRAIT(patient, TRAIT_INCAPACITATED)) //if you're incapacitated (due to paralysis, a stun, being in staminacrit, etc.), critted, unconscious, or dead, it's much easier to properly line up a snip
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && patient.has_status_effect(/datum/status_effect/jitter)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25, so staminacritting someone who's jittering (from, say, a stun baton) won't give you enough time to snip their head off, but staminacritting someone who isn't jittering will

	if(do_after(user,  toolspeed * 15 SECONDS * amputation_speed_mod, target = patient))
		playsound(get_turf(patient), 'sound/weapons/bladeslice.ogg', 250, TRUE)
		if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) //OwO
			tail_snip_candidate.Remove(patient)
			tail_snip_candidate.forceMove(get_turf(patient))
		else
			limb_snip_candidate.dismember()
		user.visible_message(span_danger("[capitalize(src.name)] яростно захлопывается, ампутируя [candidate_name] [patient].") , span_notice("Ампутирую [candidate_name] [patient] используя [src]."))

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID)) //Freak
		user.add_mood_event("morbid_dismemberment", /datum/mood_event/morbid_dismemberment)

/obj/item/shears/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is pinching [user.p_them()]self with  [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	var/timer = 1 SECONDS
	for(var/obj/item/bodypart/thing in user.bodyparts)
		if(thing.body_part == CHEST)
			continue
		addtimer(CALLBACK(thing, TYPE_PROC_REF(/obj/item/bodypart/, dismember)), timer)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/weapons/bladeslice.ogg', 70), timer)
		timer += 1 SECONDS
	sleep(timer)
	return BRUTELOSS

/obj/item/bonesetter
	name = "костоправ"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bonesetter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5,  /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("корректирует", "правильно устанавливает")
	attack_verb_simple = list("корректирует", "правильно устанавливает")
	tool_behaviour = TOOL_BONESET
	toolspeed = 1

/obj/item/bonesetter/get_surgery_tool_overlay(tray_extended)
	return "bonesetter" + (tray_extended ? "" : "_out")

/obj/item/bonesetter/augment
	name = "кибернетический костоправ"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "bone_setter"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	toolspeed = 0.5

/obj/item/blood_filter
	name = "фильтр крови"
	desc = "Для фильтрации крови и лимфы."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bloodfilter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/glass=HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("pumps", "siphons")
	attack_verb_simple = list("pump", "siphon")
	tool_behaviour = TOOL_BLOODFILTER
	toolspeed = 1
	/// Assoc list of chem ids to names, used for deciding which chems to filter when used for surgery
	var/list/whitelist = list()

/obj/item/blood_filter/get_surgery_tool_overlay(tray_extended)
	return "filter"

/obj/item/blood_filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BloodFilter", name)
		ui.open()

/obj/item/blood_filter/ui_data(mob/user)
	var/list/data = list()
	var/list/chem_names = list()
	for(var/key in whitelist)
		chem_names += whitelist[key]
	data["whitelist"] = chem_names
	return data

/obj/item/blood_filter/ui_act(action, params)
	. = ..()
	if(.)
		return
	. = TRUE
	switch(action)
		if("add")
			var/selected_reagent = tgui_input_list(usr, "Выбор реагента для фильтрации", "Белый список реагентов", GLOB.chemical_name_list)
			if(!selected_reagent)
				return TRUE

			var/chem_id = get_chem_id(selected_reagent)
			if(!chem_id)
				return TRUE

			if(!(chem_id in whitelist))
				whitelist[chem_id] = selected_reagent



		if("remove")
			var/chem_name = params["reagent"]
			var/chem_id = get_chem_id(chem_name)
			whitelist -= chem_id

/*
 * Cruel Surgery Tools
 *
 * This variety of tool has the CRUEL_IMPLEMENT flag.
 *
 * Bonuses if the surgery is being done by a morbid user and it is of their interest.
 *
 * Morbid users are interested in; autospies, revival surgery, plastic surgery, organ/feature manipulations, amputations
 *
 * Otherwise, normal tool.
 */

/obj/item/retractor/cruel
	name = "расширитель"
	desc = "Помогает раскрыть секреты, которые лучше бы остались скрытыми."
	icon_state = "cruelretractor"
	surgical_tray_overlay = "retractor_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/hemostat/cruel
	name = "зажим"
	desc = "Зажимает, но не очень хорошо останавливает внутренние кровотечения."
	icon_state = "cruelhemostat"
	surgical_tray_overlay = "hemostat_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/cautery/cruel
	name = "прижигатель"
	desc = "Запишем как еще одну успешную вивисекцию."
	icon_state = "cruelcautery"
	surgical_tray_overlay = "cautery_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/scalpel/cruel
	name = "скальпель"
	desc = "Я помню каждый раз, как брал тебя в руки, мой дорогой друг..."
	icon_state = "cruelscalpel"
	surgical_tray_overlay = "scalpel_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/scalpel/cruel/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bane, mob_biotypes = MOB_UNDEAD, damage_multiplier = 1) //Just in case one of the tennants get uppity
