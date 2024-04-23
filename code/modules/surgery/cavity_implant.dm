/datum/surgery/cavity_implant
	name = "Имплантирование предмета в полость"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/handle_cavity,
		/datum/surgery_step/close)

//handle cavity
/datum/surgery_step/handle_cavity
	name = "поместите или извлеките предмет"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 32
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	var/obj/item/item_for_cavity

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_CAUTERY || istype(tool, /obj/item/gun/energy/laser))
		return FALSE
	return !tool.get_temperature()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	item_for_cavity = target_chest.cavity_item
	if(tool)
		display_results(
			user,
			target,
			span_notice("Начинаю помещать [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает помещать [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает помещать что-то в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(
			target,
			"В мою [ru_parse_zone(parse_zone(target_zone))] что-то поместили! Больно!")
	else
		display_results(
			user,
			target,
			span_notice("Начинаю искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery = FALSE)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(item_for_cavity || tool.w_class > WEIGHT_CLASS_NORMAL || HAS_TRAIT(tool, TRAIT_NODROP) || isorgan(tool))
			to_chat(user, span_warning("Кажется [tool] не поместиться в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] из-за слишком крупных размеров!"))
			return FALSE
		else
			display_results(
				user,
				target,
				span_notice("Успешно поместил[user.ru_a()] [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] поместил[user.ru_a()] [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_notice("[user] поместил[user.ru_a()] что-то в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))
			user.transferItemToLoc(tool, target, TRUE)
			target_chest.cavity_item = tool
			return ..()
	else
		if(item_for_cavity)
			display_results(
				user,
				target,
				span_notice("Извлекаю [item_for_cavity] из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] извлек [item_for_cavity] из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_notice("[user] извлек что-то из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
			display_pain(target, "Из моей [ru_otkuda_zone(parse_zone(target_zone))] что-то вытаскивают! Это весьма неприятно!")
			user.put_in_hands(item_for_cavity)
			target_chest.cavity_item = null
			return ..()
		else
			to_chat(user, span_warning("Не могу найти нечего в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))
			return FALSE
