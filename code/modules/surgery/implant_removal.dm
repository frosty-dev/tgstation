/datum/surgery/implant_removal
	name = "Извлечение микроимпланта"
	target_mobtypes = list(/mob/living)
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/close,
	)

//extract implant
/datum/surgery_step/extract_implant
	name = "извлеките микроимплант (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 65,
		/obj/item/kitchen/fork = 35)
	time = 64
	success_sound = 'sound/surgery/hemostat1.ogg'
	var/obj/item/implant/implant

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/object in target.implants)
		implant = object
		break
	if(implant)
		display_results(user, target, span_notice("Начинаю извлекать [implant] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает извлекать [implant] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает извлекать что-то из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Чувствую сильную боль в [ru_gde_zone(target_zone)]!")
	else
		display_results(user, target, span_notice("Начинаю искать микроимпланты в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает искать микроимпланты в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает искать что-то в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/extract_implant/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(implant)
		display_results(user, target, span_notice("Извлекаю [implant] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно извлекает [implant] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] успешно извлекает что-то из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!"))
		display_pain(target, "Ауч! Кажется из меня что-то вытащили!")
		implant.removed(target)

		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/implant_case in user.held_items)
			case = implant_case
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = implant
			implant.forceMove(case)
			case.update_appearance()
			display_results(user, target, span_notice("Помещаю [implant] в [case].") ,
				span_notice("[user] помещает [implant] в [case]!") ,
				span_notice("[user] помещает что-то в [case]!"))
		else
			qdel(implant)

	else
		to_chat(user, span_warning("Не могу найти ничего в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!"))
	return ..()

/datum/surgery/implant_removal/mechanic
	name = "Извлечение микроимпланта (кибер)"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	target_mobtypes = list(/mob/living/carbon/human) // Simpler mobs don't have bodypart types
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close)
