/datum/surgery/advanced/bioware/ligament_reinforcement
	name = "Модифицирование: Укрепление связок"
	desc = "Хирургическая процедура, добавляющая защитную ткань и костяную клетку вокруг соединений туловища и конечностей, предотвращая расчленение. \
	Однако, в результате нервные соединения легче оборвать, что ведет к большему шансу вывести из строя конечности при получении урона."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/reinforce_ligaments,
		/datum/surgery_step/close,
	)

	bioware_target = BIOWARE_LIGAMENTS

/datum/surgery_step/reinforce_ligaments
	name = "укрепление связок (рука)"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/reinforce_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Начинаю укреплять связки [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал[user.ru_a()] укреплять связки [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал[user.ru_a()] работу со связками [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/reinforce_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Укрепил[user.ru_a()] связки [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] укрепил[user.ru_a()] связки [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] закончил[user.ru_a()] работу со связками [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/reinforced_ligaments(target)
	return ..()

/datum/bioware/reinforced_ligaments
	name = "Укрепленные связки"
	desc = "Связки и нервные окончания, соединяющие туловище с конечностями, защищены смесью костей и тканей, и их куда сложнее отделить от туловища, но куда проще поранить."
	mod_type = BIOWARE_LIGAMENTS

/datum/bioware/reinforced_ligaments/on_gain()
	..()
	owner.add_traits(list(TRAIT_NODISMEMBER, TRAIT_EASILY_WOUNDED), EXPERIMENTAL_SURGERY_TRAIT)

/datum/bioware/reinforced_ligaments/on_lose()
	..()
	owner.remove_traits(list(TRAIT_NODISMEMBER, TRAIT_EASILY_WOUNDED), EXPERIMENTAL_SURGERY_TRAIT)
