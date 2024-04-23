/datum/surgery/advanced/wing_reconstruction
	name = "Восстановление крыльев"
	desc = "Экспериментальная хирургическая процедура, которая восстанавливает поврежденные крылья мотыльков. Требует Синтплоть."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/wing_reconstruction,
	)

/datum/surgery/advanced/wing_reconstruction/can_start(mob/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	var/obj/item/organ/external/wings/moth/wings = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(!istype(wings, /obj/item/organ/external/wings/moth))
		return FALSE
	return ..() && wings?.burnt

/datum/surgery_step/wing_reconstruction
	name = "начать восстановление крыльев (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	time = 200
	chems_needed = list(/datum/reagent/medicine/c2/synthflesh)
	require_all_chems = FALSE

/datum/surgery_step/wing_reconstruction/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Начинаю восстанавливать обугленные мембраны крыльев [skloname(target.name, VINITELNI, target.gender)]...") ,
		span_notice("[user] начал восстанавливать обугленные мембраны крыльев [skloname(target.name, VINITELNI, target.gender)].") ,
		span_notice("[user] начал проведение операции на обугленных мембранах крыльев [skloname(target.name, VINITELNI, target.gender)]."))

/datum/surgery_step/wing_reconstruction/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(
			user,
			target,
			span_notice("Успешно восстановил[user.ru_a()] крылья [skloname(target.name, VINITELNI, target.gender)].") ,
			span_notice("[user] успешно восстановил[user.ru_a()] крылья [skloname(target.name, VINITELNI, target.gender)]!") ,
			span_notice("[user] завершил[user.ru_a()] операцию на крыльях [skloname(target.name, VINITELNI, target.gender)]."))

		var/obj/item/organ/external/wings/moth/wings = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
		if(istype(wings, /obj/item/organ/external/wings/moth)) //make sure we only heal moth wings.
			wings.heal_wings(user, ALL)

		var/obj/item/organ/external/antennae/antennae = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_ANTENNAE) //i mean we might aswell heal their antennae too
		antennae?.heal_antennae()

		human_target.update_body_parts()
	return ..()
