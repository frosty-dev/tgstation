/datum/surgery/advanced/necrotic_revival
	name = "Некротическое воскрешение"
	desc = "Экспериментальная хирургическая процедура, которая стимулирует рост опухоли Ромерола внутри мозга пациента. Требует порошок зомби или Резадон."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/bionecrosis,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/necrotic_revival/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/internal/zombie_infection/z_infection = target.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(z_infection)
		return FALSE

/datum/surgery_step/bionecrosis
	name = "начать бионекроз (шприц)"
	implements = list(
		/obj/item/reagent_containers/syringe = 100,
		/obj/item/pen = 30)
	time = 50
	chems_needed = list(/datum/reagent/toxin/zombiepowder, /datum/reagent/medicine/rezadone)
	require_all_chems = FALSE

/datum/surgery_step/bionecrosis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Стимулирую рост опухоли Ромерола в мозгу [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает возиться с мозгом [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/bionecrosis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Успешно стимулировал[user.ru_a()] рост опухоли Ромерола в мозгу [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно вырастил[user.ru_a()] опухоль Ромерола в мозгу [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершил[user.ru_a()] операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

	if(!target.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/internal/zombie_infection/z_infection = new()
		z_infection.Insert(target)
	return ..()
