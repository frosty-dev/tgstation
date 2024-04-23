/datum/surgery/advanced/viral_bonding
	name = "Вирусный симбиоз"
	desc = "Хирургическая процедура которая устанавливает симбиотические отношения между вирусом и носителем. Пациенту должен быть введен Космоцелин, пища для вирусов и формальдегид."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/viral_bond,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/viral_bonding/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	if(!LAZYLEN(target.diseases))
		return FALSE
	return TRUE

/datum/surgery_step/viral_bond
	name = "установите связь (прижигатель)"
	implements = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 50,
		/obj/item = 30) // 30% success with any hot item.
	time = 100
	chems_needed = list(/datum/reagent/medicine/spaceacillin,/datum/reagent/consumable/virus_food,/datum/reagent/toxin/formaldehyde)

/datum/surgery_step/viral_bond/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/viral_bond/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Начинаю нагревать спинной мозг [skloname(target.name, VINITELNI, target.gender)], используя [tool]...") ,
		span_notice("[user] начинает нагревать спинной мозг [skloname(target.name, VINITELNI, target.gender)], используя [tool]...") ,
		span_notice("[user] начинает нагревать что-то в туловище [skloname(target.name, VINITELNI, target.gender)], используя [tool]..."))

/datum/surgery_step/viral_bond/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(
		user,
		target,
		span_notice("Костный мозг [skloname(target.name, VINITELNI, target.gender)] начинает медленно пульсировать. Вирусный симбиоз установлен.") ,
		span_notice("Костный мозг [skloname(target.name, VINITELNI, target.gender)] начинает медленно пульсировать.") ,
		span_notice("[user] завершает операцию."))

	for(var/datum/disease/infected_disease as anything in target.diseases)
		if(infected_disease.severity != DISEASE_SEVERITY_UNCURABLE) //no curing quirks, sweaty
			infected_disease.carrier = TRUE
	return TRUE
