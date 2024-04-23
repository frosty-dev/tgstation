/datum/surgery/advanced/bioware/vein_threading
	name = "Модифицирование: Переплетение вен"
	desc = "Хирургическая процедура, которая значительно снижает количество теряемой крови при ранениях."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/thread_veins,
		/datum/surgery_step/close,
	)

	bioware_target = BIOWARE_CIRCULATION

/datum/surgery_step/thread_veins
	name = "переплетение вен (рука)"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/thread_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Начинаю переплетать кровеносную систему [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал[user.ru_a()] переплетать кровеносную систему [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал[user.ru_a()] работать над кровеносной системой [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/thread_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Сплел[user.ru_a()] кровеносную систему [skloname(target.name, RODITELNI, target.gender)] в прочную сеть!") ,
		span_notice("[user] сплел[user.ru_a()] кровеносную систему [skloname(target.name, RODITELNI, target.gender)] в прочную сеть!") ,
		span_notice("[user] закончил[user.ru_a()] работать над кровеносной системой [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/threaded_veins(target)
	return ..()

/datum/bioware/threaded_veins
	name = "Переплетенные вены"
	desc = "Система кровообращения сплетена в сеть, значительно снижающую количество теряемой при ранениях крови."
	mod_type = BIOWARE_CIRCULATION

/datum/bioware/threaded_veins/on_gain()
	..()
	owner.physiology.bleed_mod *= 0.25

/datum/bioware/threaded_veins/on_lose()
	..()
	owner.physiology.bleed_mod *= 4
