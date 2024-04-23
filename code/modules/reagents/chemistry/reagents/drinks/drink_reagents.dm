/datum/reagent/consumable/orangejuice
	enname = "Orange Juice"
	name = "Апельсиновый сок"
	description = "Обладает отличным вкусом и богат витамином C, что еще нужно для счастья?"
	color = "#E78108" // rgb: 231, 129, 8
	taste_description = "апельсины"
	ph = 3.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/orangejuice
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/orangejuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getOxyLoss() && SPT_PROB(16, seconds_per_tick))
		if(affected_mob.adjustOxyLoss(-1 * REM * seconds_per_tick, FALSE, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/tomatojuice
	enname = "Tomato Juice"
	name = "Томатный сок"
	description = "Из томатов делают сок. Какая трата больших, сочных томатов, а?"
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "томаты"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/tomatojuice
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/tomatojuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getFireLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 0, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/limejuice
	enname = "Lime Juice"
	name = "Сок лайма"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "невыносимая кислинка"
	ph = 2.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/limejuice
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/limejuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getToxLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/carrotjuice
	enname = "Carrot Juice"
	name = "Морковный сок"
	description = "Это как морковь, но без привычного хруста."
	color = "#973800" // rgb: 151, 56, 0
	taste_description = "морковки"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/carrotjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_eye_blur(-2 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_temp_blindness(-2 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	switch(current_cycle)
		if(1 to 20)
			//nothing
		if(21 to 110)
			if(SPT_PROB(100 * (1 - (sqrt(110 - current_cycle) / 10)), seconds_per_tick))
				need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_EYES, -2 * REM * seconds_per_tick)
		if(110 to INFINITY)
			need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_EYES, -2 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/berryjuice
	enname = "Berry Juice"
	name = "Ягодный сок"
	description = "Восхитительный микс нескольких сортов ягод."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "ягоды"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/applejuice
	enname = "Apple Juice"
	name = "Яблочный сок"
	description = "Сладкий яблочный сок, подходящий для всех возрастов."
	color = "#ECFF56" // rgb: 236, 255, 86
	taste_description = "яблоки"
	ph = 3.2 // ~ 2.7 -> 3.7
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/poisonberryjuice
	enname = "Poison Berry Juice"
	name = "Ядовитый ягодный сок"
	description = "Вкусный сок, приготовленный из нескольких видов смертоносных и ядовитых ягод."
	color = "#863353" // rgb: 134, 51, 83
	taste_description = "ягоды"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/poisonberryjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/watermelonjuice
	enname = "Watermelon Juice"
	name = "Арбузный сок"
	description = "Восхитительный сок из арбузов."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "сочный арбуз"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/lemonjuice
	enname = "Lemon Juice"
	name = "Лимонный сок"
	description = "Этот сок ОЧЕНЬ кислый."
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "кислота"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/banana
	enname = "Banana Juice"
	name = "Банановый сок"
	description = "Чистейший экстракт банана. ХОНК!"
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "банан"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/banana/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || is_simian(affected_mob))
		if(affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/nothing
	enname = "Nothing"
	name = "Ничего"
	description = "Абсолютное ничто."
	taste_description = "ничего"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/glass_style/shot_glass/nothing
	required_drink_type = /datum/reagent/consumable/nothing
	icon_state = "shotglass"

/datum/reagent/consumable/nothing/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/laughter
	enname = "Laughter"
	name = "Хохотач"
	description = "Некоторые говорят, что это лучшее лекарство, но последние исследования доказали, что это неправда."
	metabolization_rate = INFINITY
	color = "#FF4DD2"
	taste_description = "ржака"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/laughter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.emote("laugh")
	affected_mob.add_mood_event("chemical_laughter", /datum/mood_event/chemical_laughter)

/datum/reagent/consumable/superlaughter
	enname = "Super Laughter"
	name = "Полный хохотач"
	description = "Забавно до тех пор, пока ты не начнешь понимать, что ты не можешь остановиться."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#FF4DD2"
	taste_description = "ржака"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/superlaughter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(16, seconds_per_tick))
		affected_mob.visible_message(span_danger("[affected_mob] bursts out into a fit of uncontrollable laughter!"), span_userdanger("You burst out in a fit of uncontrollable laughter!"))
		affected_mob.Stun(5)
		affected_mob.add_mood_event("chemical_laughter", /datum/mood_event/chemical_superlaughter)

/datum/reagent/consumable/potato_juice
	enname = "Potato Juice"
	name = "Картофельный сок"
	description = "Сок из картофеля. Фу."
	nutriment_factor = 2
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "ирландская грусть"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/pickle
	enname = "Pickle Juice"
	name = "Рассол"
	description = "Если быть точнее, то это то, в чем плавал огурец."
	nutriment_factor = 2
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "божественное чудо"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/pickle/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_CORONER_METABOLISM)))
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/grapejuice
	enname = "Grape Juice"
	name = "Виноградный сок"
	description = "Сок из виноградной грозди. Гарантированно безалкогольный."
	color = "#290029" // dark purple
	taste_description = "виноградная сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/plumjuice
	enname = "Plum Juice"
	name = "Сливовый сок"
	description = "Refreshing and slightly acidic beverage."
	color = "#b6062c"
	taste_description = "сливы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/milk
	enname = "Milk"
	name = "Молоко"
	description = "Непрозрачная белая жидкость, вырабатываемая молочными железами млекопитающих."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "молоко"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/milk
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

// Milk is good for humans, but bad for plants.
// The sugars cannot be used by plants, and the milk fat harms growth. Except shrooms.
/datum/reagent/consumable/milk/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume * 0.3))
	var/obj/item/seeds/myseed = mytray.myseed
	if(isnull(myseed) || myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
		return
	myseed.adjust_potency(-round(volume * 0.5))

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 1 * seconds_per_tick)
	return ..() || .

/datum/reagent/consumable/soymilk
	enname = "Soy Milk"
	name = "Соевое молоко"
	description = "Непрозрачная белая жидкость из соевых бобов."
	color = "#DFDFC7" // rgb: 223, 223, 199
	taste_description = "соевое молоко"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/soymilk
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(1, 0))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cream
	enname = "Cream"
	name = "Сливки"
	description = "Жирные сливки, изготовленные из натурального молока. Почему бы тебе не смешать это со скотчем, а?"
	color = "#DFD7AF" // rgb: 223, 215, 175
	taste_description = "сливочное молоко"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/cream
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/cream/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		affected_mob.heal_bodypart_damage(1, 0)
		. = TRUE
	..()

/datum/reagent/consumable/coffee
	enname = "Coffee"
	name = "Кофе"
	description = "Кофе - это напиток, приготовленный из обжаренных кофейных зерен."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/coffee/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	//310.15 is the normal bodytemp.
	affected_mob.adjust_bodytemperature(25 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5 * REM * seconds_per_tick)
	return ..() || .

/datum/reagent/consumable/tea
	enname = "Tea"
	name = "Чай"
	description = "Вкусный черный чай, в нем есть антиоксиданты, он полезен для здоровья!"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "пирог и черный чай"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK
	default_container = /obj/item/reagent_containers/cup/glass/mug/tea
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-4 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-2 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_jitter(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-20 * REM * seconds_per_tick)
	if(affected_mob.getToxLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

	var/to_chatted = FALSE
	for(var/datum/wound/iter_wound as anything in affected_mob.all_wounds)
		if(SPT_PROB(10, seconds_per_tick))
			var/helped = iter_wound.tea_life_process()
			if(!to_chatted && helped)
				to_chat(affected_mob, span_notice("A calm, relaxed feeling suffuses you. Your wounds feel a little healthier."))
			to_chatted = TRUE

// Different handling, different name.
// Returns FALSE by default so broken bones and 'loss' wounds don't give a false message
/datum/wound/proc/tea_life_process()
	return FALSE

// Slowly increase (gauzed) clot rate
/datum/wound/pierce/bleed/tea_life_process()
	gauzed_clot_rate += 0.1
	return TRUE

// Slowly increase clot rate
/datum/wound/slash/flesh/tea_life_process()
	clot_rate += 0.2
	return TRUE

// There's a designated burn process, but I felt this would be better for consistency with the rest of the reagent's procs
/datum/wound/burn/flesh/tea_life_process()
	// Sanitizes and heals, but with a limit
	flesh_healing = (flesh_healing > 0.1) ? flesh_healing : flesh_healing + 0.02
	infestation_rate = max(infestation_rate - 0.005, 0)
	return TRUE

/datum/reagent/consumable/lemonade
	enname = "Lemonade"
	name = "Лимонад"
	description = "Сладкий, терпкий лимонад."
	color = "#FFE978"
	quality = DRINK_NICE
	taste_description = "солнце и лето"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tea/arnold_palmer
	enname = "Arnold Palmer"
	name = "Арнольд Палмер"
	description = "Поощряет пациента к игре в гольф."
	color = "#FFB766"
	quality = DRINK_NICE
	nutriment_factor = 10
	taste_description = "горький чай"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tea/arnold_palmer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[pick("You remember to square your shoulders.","You remember to keep your head down.","You can't decide between squaring your shoulders and keeping your head down.","You remember to relax.","You think about how someday you'll get two strokes off your golf game.")]"))

/datum/reagent/consumable/icecoffee
	enname = "Iced Coffee"
	name = "Кофе со льдом"
	description = "Кофе со льдом, бодрит и охлаждает."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0
	taste_description = "горечь и холод"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/icecoffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/hot_ice_coffee
	enname = "Hot Ice Coffee"
	name = "Кофе с горячим льдом"
	description = "Кофе с горячими осколками льда."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0
	taste_description = "горечь и намёк на дым"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/hot_ice_coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-60 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-7 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)
	if(affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/icetea
	enname = "Iced Tea"
	name = "Чай со льдом"
	description = "Не имеет отношения к определенному рэп исполнителю."
	color = "#104038" // rgb: 16, 64, 56
	nutriment_factor = 0
	taste_description = "сладкий чай"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-4 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-2 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	if(affected_mob.getToxLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/space_cola
	enname = "Cola"
	name = "Космо-Кола"
	description = "Освежающий напиток."
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "кола"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/space_cola/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/roy_rogers
	enname = "Roy Rogers"
	name = "Рой Роджерс"
	description = "A sweet fizzy drink."
	color = "#53090B"
	quality = DRINK_GOOD
	taste_description = "fruity overlysweet cola"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/roy_rogers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.set_jitter_if_lower(12 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/nuka_cola
	enname = "Nuka Cola"
	name = "Нюка-Кола"
	description = "Кола. Кола никогда не меняется."
	color = "#100800" // rgb: 16, 8, 0
	quality = DRINK_VERYGOOD
	taste_description = "будущее"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(40 SECONDS * REM * seconds_per_tick)
	affected_mob.set_drugginess(1 MINUTES * REM * seconds_per_tick)
	affected_mob.adjust_dizzy(3 SECONDS * REM * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/rootbeer
	enname = "root beer"
	name = "рутбир"
	description = "A delightfully bubbly root beer, filled with so much sugar that it can actually speed up the user's trigger finger."
	color = "#181008" // rgb: 24, 16, 8
	quality = DRINK_VERYGOOD
	nutriment_factor = 10
	metabolization_rate = 2 * REAGENTS_METABOLISM
	taste_description = "a monstrous sugar rush"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// If we activated the effect
	var/effect_enabled = FALSE
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/rootbeer/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_DOUBLE_TAP, type)
	if(current_cycle > 10)
		to_chat(affected_mob, span_warning("You feel kinda tired as your sugar rush wears off..."))
		affected_mob.adjustStaminaLoss(min(80, current_cycle * 3), required_biotype = affected_biotype)
		affected_mob.adjust_drowsiness((current_cycle-1) * 2 SECONDS)

/datum/reagent/consumable/rootbeer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 3 && !effect_enabled) // takes a few seconds for the bonus to kick in to prevent microdosing
		to_chat(affected_mob, span_notice("You feel your trigger finger getting itchy..."))
		ADD_TRAIT(affected_mob, TRAIT_DOUBLE_TAP, type)
		effect_enabled = TRUE

	affected_mob.set_jitter_if_lower(4 SECONDS * REM * seconds_per_tick)
	if(prob(50))
		affected_mob.adjust_dizzy(2 SECONDS * REM * seconds_per_tick)
	if(current_cycle > 10)
		affected_mob.adjust_dizzy(3 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/grey_bull
	enname = "Grey Bull"
	name = "Grey Bull"
	description = "Grey Bull заземляет!"
	color = "#EEFF00" // rgb: 238, 255, 0
	quality = DRINK_VERYGOOD
	taste_description = "carbonated oil"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/grey_bull/on_mob_metabolize(mob/living/carbon/affected_atom)
	. = ..()
	ADD_TRAIT(affected_atom, TRAIT_SHOCKIMMUNE, type)
	var/obj/item/organ/internal/liver/liver = affected_atom.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_MAINTENANCE_METABOLISM))
		affected_atom.add_mood_event("maintenance_fun", /datum/mood_event/maintenance_high)
		metabolization_rate *= 0.8

/datum/reagent/consumable/grey_bull/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/grey_bull/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(40 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_dizzy(2 SECONDS * REM * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/spacemountainwind
	enname = "SM Wind"
	name = "Солнечный Ветер"
	description = "Бодрящий напиток, который вдохновляет на новые открытия."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "сладкая цитрусовая сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/spacemountainwind/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness(-14 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-20 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/dr_gibb
	enname = "Dr. Gibb"
	name = "Dr. Gibb"
	description = "Восхитительная смесь из 42 различных вкусов."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "вишневая сода" // FALSE ADVERTISING
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/dr_gibb/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness(-12 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/space_up
	enname = "Space-Up"
	name = "На Взлёт!"
	description = "Вкус напоминает разгерму, как это?"
	color = "#00FF00" // rgb: 0, 255, 0
	taste_description = "вишневая сода" // FALSE ADVERTISING
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/space_up/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/lemon_lime
	enname = "Lemon Lime"
	name = "Лаймон-Флеш"
	description = "Терпкий напиток, состоящик из 0.5% натурального лайма!"
	color = "#8CFF00" // rgb: 135, 255, 0
	taste_description = "острый лайм и лимонная сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/lemon_lime/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/pwr_game
	enname = "Pwr Game"
	name = "PWR Game"
	description = "Единственный напиток с PWR, которого жаждут настоящие геймеры."
	color = "#9385bf" // rgb: 58, 52, 75
	taste_description = "сладкий и соленый запах"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/pwr_game/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(exposed_mob?.mind?.get_skill_level(/datum/skill/gaming) >= SKILL_LEVEL_LEGENDARY && (methods & INGEST) && !HAS_TRAIT(exposed_mob, TRAIT_GAMERGOD))
		ADD_TRAIT(exposed_mob, TRAIT_GAMERGOD, "pwr_game")
		to_chat(exposed_mob, "<span class='nicegreen'>Выпив PWR Game, я распахнул геймерский третий глаз... \
		Чувствую, будто мне открылась великая загадка вселенной...</span>")

/datum/reagent/consumable/pwr_game/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.mind?.adjust_experience(/datum/skill/gaming, 5)

/datum/reagent/consumable/shamblers
	enname = "Shambler's Juice"
	name = "Сок Тьманника" //Darkest Dungeon
	description = "~Взболтай мне немного сока Тьманника!~"
	color = "#f00060" // rgb: 94, 0, 38
	taste_description = "газированная металлическая сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/shamblers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/sodawater
	enname = "Soda Water"
	name = "Газированная вода"
	description = "Банка содовой, почему бы не смешать ее со скотчем?"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "минералка"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

// A variety of nutrients are dissolved in club soda, without sugar.
// These nutrients include carbon, oxygen, hydrogen, phosphorous, potassium, sulfur and sodium, all of which are needed for healthy plant growth.
/datum/reagent/consumable/sodawater/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume))
	mytray.adjust_plant_health(round(volume * 0.1))

/datum/reagent/consumable/sodawater/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/tonic
	enname = "Tonic Water"
	name = "Тонизирующая вода"
	description = "Вкус странный, но, по крайней мере, хинин держит космическую малярию на расстоянии."
	color = "#0064C8" // rgb: 0, 100, 200
	taste_description = "свежесть и терпкость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tonic/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/wellcheers
	enname = "Wellcheers"
	name = "Wellcheers"
	description = "A strange purple drink, smelling of saltwater. Somewhere in the distance, you hear seagulls."
	color = "#762399" // rgb: 118, 35, 153
	taste_description = "grapes and the fresh open sea"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/wellcheers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness(3 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	switch(affected_mob.mob_mood.sanity_level)
		if (SANITY_INSANE to SANITY_CRAZY)
			need_mob_update = affected_mob.adjustStaminaLoss(3 * REM * seconds_per_tick, updating_stamina = FALSE)
		if (SANITY_UNSTABLE to SANITY_DISTURBED)
			affected_mob.add_mood_event("wellcheers", /datum/mood_event/wellcheers)
		if (SANITY_NEUTRAL to SANITY_GREAT)
			need_mob_update = affected_mob.adjustBruteLoss(-1.5 * REM * seconds_per_tick, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/monkey_energy
	enname = "Monkey Energy"
	name = "Monkey Energy"
	description = "Дайте волю примату внутри вас!"
	color = "#f39b03" // rgb: 243, 155, 3
	overdose_threshold = 60
	taste_description = "барбекю и ностальгия"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/monkey_energy/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(80 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_dizzy(2 SECONDS * REM * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/monkey_energy/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(is_simian(affected_mob))
		affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_mob.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/monkey_energy)

/datum/reagent/consumable/ice
	enname = "Ice"
	name = "Лед"
	description = "Замороженная вода, вашему стоматологу не понравится, если вы будете ее жевать."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "лед"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/ice

/datum/reagent/consumable/ice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, FALSE, affected_mob.get_body_temp_normal()))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/soy_latte
	enname = "Soy Latte"
	name = "Соевое латте"
	description = "Приятный и вкусный напиток, то что нужно, пока вы читаете свои хиппи-книги."
	color = "#cc6404" // rgb: 204,100,4
	quality = DRINK_NICE
	taste_description = "сливочное кофе"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/soy_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cafe_latte
	enname = "Cafe Latte"
	name = "Латте"
	description = "Хороший, крепкий и освежающий напиток, идеален под хорошую книгу."
	color = "#cc6404" // rgb: 204,100,4
	quality = DRINK_NICE
	taste_description = "взбитые сливки"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cafe_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-10 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-12 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/doctor_delight
	enname = "The Doctor's Delight"
	name = "Восторг врача"
	description = "Смесь соков, которая довольно быстро исцеляет большинство типов повреждений."
	color = "#FF8CFF" // rgb: 255, 140, 255
	quality = DRINK_VERYGOOD
	taste_description = "фрукт, выращенные твоей мамой"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/doctor_delight/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustBruteLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustFireLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustToxLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOxyLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(affected_mob.nutrition && (affected_mob.nutrition - 2 > 0))
		var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
		if(!(HAS_TRAIT(liver, TRAIT_MEDICAL_METABOLISM)))
			// Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			affected_mob.adjust_nutrition(-2 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cinderella
	enname = "Cinderella"
	name = "Золушка"
	description = "Most definitely a fruity alcohol cocktail to have while partying with your friends."
	color = "#FF6A50"
	quality = DRINK_VERYGOOD
	taste_description = "sweet tangy fruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/cinderella/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_disgust(-5 * REM * seconds_per_tick)

/datum/reagent/consumable/cherryshake
	enname = "Cherry Shake"
	name = "Вишневый молочный коктейль"
	description = "Молочный коктейль со вкусом вишни."
	color = "#FFB6C1"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сливочная вишня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/bluecherryshake
	enname = "Blue Cherry Shake"
	name = "Молочный коктейль с синей вишней"
	description = "Экзотический молочный коктейль с синей вишней."
	color = "#00F1FF"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сливочно-голубая вишня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/vanillashake
	enname = "Vanilla Shake"
	name = "Ванильный молочный коктейль"
	description = "A vanilla flavored milkshake. The basics are still good."
	color = "#E9D2B2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сладкий ванильный крем"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/caramelshake
	enname = "Caramel Shake"
	name = "Карамельный молочный коктейль"
	description = "A caramel flavored milkshake. Your teeth hurt looking at it."
	color = "#E17C00"
	quality = DRINK_GOOD
	nutriment_factor = 10
	taste_description = "сладкая карамель"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/choccyshake
	enname = "Chocolate Shake"
	name = "Шоколадный молочный коктейль"
	description = "A frosty chocolate milkshake."
	color = "#541B00"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сладкий шоколад"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/strawberryshake
	enname = "Strawberry Shake"
	name = "Клубничный молочный коктейль"
	description = "A strawberry milkshake."
	color = "#ff7b7b"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сладкая клубника"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/bananashake
	enname = "Banana Shake"
	name = "Банановый молочный коктейль"
	description = "A banana milkshake. Stuff that clowns drink at their honkday parties."
	color = "#f2d554"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "сладкий банан"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/pumpkin_latte
	enname = "Pumpkin Latte"
	name = "Тыквенное латте"
	description = "Смесь тыквенного сока и кофе."
	color = "#F4A460"
	quality = DRINK_VERYGOOD
	nutriment_factor = 3
	taste_description = "сливочная тыква"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM
/datum/reagent/consumable/gibbfloats
	enname = "Gibb Floats"
	name = "Хороший Пловец"
	description = "Dr. Gibb со сливочным мороженым."
	color = "#B22222"
	quality = DRINK_NICE
	nutriment_factor = 3
	taste_description = "сливочная вишня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/pumpkinjuice
	enname = "Pumpkin Juice"
	name = "Тыквенный сок"
	description = "Сок из тыквы."
	color = "#FFA500"
	taste_description = "тыква"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/blumpkinjuice
	enname = "Blumpkin Juice"
	name = "Синетыквенный сок"
	description = "Сок из синей тыквы."
	color = "#00BFFF"
	taste_description = "глоток воды из бассейна"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/triple_citrus
	enname = "Triple Citrus"
	name = "Тройной Цитрус"
	description = "Прекрасная смесь цитрусовых."
	color = "#EEFF00"
	quality = DRINK_NICE
	taste_description = "крайняя горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/grape_soda
	enname = "Grape Soda"
	name = "Виноградная газировка"
	description = "Её любят дети и бывшие алкоголики."
	color = "#E6CDFF"
	taste_description = "виноградная сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/grape_soda/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/milk/chocolate_milk
	enname = "Chocolate Milk"
	name = "Шоколадное молоко"
	description = "Молоко для крутых ребят."
	color = "#7D4E29"
	quality = DRINK_NICE
	taste_description = "шоколадное молоко"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/hot_coco
	enname = "Hot Coco"
	name = "Горячий шоколад"
	description = "Сделано с любовью!"
	nutriment_factor = 4
	color = "#403010" // rgb: 64, 48, 16
	taste_description = "сливочный шоколад"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/hot_coco/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 2 * REM * seconds_per_tick)
	return ..() || .

/datum/reagent/consumable/italian_coco
	enname = "Italian Hot Chocolate"
	name = "Итальянский горячий шоколад"
	description = "Made with love! You can just imagine a happy Nonna from the smell."
	nutriment_factor = 8
	color = "#57372A"
	quality = DRINK_VERYGOOD
	taste_description = "сливочный шоколад"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/italian_coco/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/menthol
	enname = "Menthol"
	name = "Ментол"
	description = "Облегчает симптомы кашля."
	color = "#80AF9C"
	taste_description = "мята"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/menthol
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/menthol/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/throat_soothed)

/datum/reagent/consumable/grenadine
	enname = "Grenadine"
	name = "Гренадин"
	description = "Не со вкусом вишни!"
	color = "#EA1D26"
	taste_description = "сладкие гранаты"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/parsnipjuice
	enname = "Parsnip Juice"
	name = "Сок пастернака"
	description = "Зачем..."
	color = "#FFA500"
	taste_description = "пастернак"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/pineapplejuice
	enname = "Pineapple Juice"
	name = "Ананасовый сок"
	description = "Терпкий, тропический и горячо обсуждаемый."
	special_sound = 'white/valtos/sound/drink/pineapple_apple_pen.ogg'
	color = "#F7D435"
	taste_description = "ананас"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/pineapplejuice
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/peachjuice //Intended to be extremely rare due to being the limiting ingredients in the blazaam drink
	enname = "Peach Juice"
	name = "Персиковый сок"
	description = "Просто персиковый сок."
	color = "#E78108"
	taste_description = "персики"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cream_soda
	enname = "Cream Soda"
	name = "Крем-сода"
	description = "Класичесский для космо-Америки напиток с ванильными нотками."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "шипучая ваниль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cream_soda/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/sol_dry
	enname = "Sol Dry"
	name = "Меркурий"	//wiki - Меркурий
	description = "Успокаивающий, мягкий напиток, приготовленный из имбиря."
	color = "#f7d26a"
	quality = DRINK_NICE
	taste_description = "сладкая имбирная специя"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/sol_dry/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_disgust(-5 * REM * seconds_per_tick)

/datum/reagent/consumable/shirley_temple
	enname = "Shirley Temple"
	name = "Ширли-Темпл"
	description = "Here you go little girl, now you can drink like the adults."
	color = "#F43724"
	quality = DRINK_GOOD
	taste_description = "sweet cherry syrup and ginger spice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/shirley_temple/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjust_disgust(-3 * REM * seconds_per_tick)
	return ..()

/datum/reagent/consumable/red_queen
	enname = "Red Queen"
	name = "Красная Королева"
	description = "ВЫПЕЙ МЕНЯ."
	color = "#e6ddc3"
	quality = DRINK_GOOD
	taste_description = "чудо"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/current_size = RESIZE_DEFAULT_SIZE
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/red_queen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(50, seconds_per_tick))
		return

	var/newsize = pick(0.5, 0.75, 1, 1.50, 2)
	newsize *= RESIZE_DEFAULT_SIZE
	affected_mob.update_transform(newsize/current_size)
	current_size = newsize
	if(SPT_PROB(23, seconds_per_tick))
		affected_mob.emote("sneeze")

/datum/reagent/consumable/red_queen/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/consumable/bungojuice
	enname = "Bungo Juice"
	name = "Сок Бунго"
	color = "#F9E43D"
	description = "Экзотично! Вы уже чувствуете себя, как в отпуске."
	taste_description = "сочный бунго"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/prunomix
	enname = "Pruno Mixture"
	name = "Микс Пруно"
	color = "#E78108"
	description = "Фрукты, сахар, дрожжи и вода, измельченные в едкую суспензию."
	taste_description = "мусор"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/aloejuice
	enname = "Aloe Juice"
	name = "Сок алоэ"
	color = "#A3C48B"
	description = "Полезный и освежающий сок."
	taste_description = "овощи"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/aloejuice/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getToxLoss() && SPT_PROB(16, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/agua_fresca
	enname = "Agua Fresca"
	name = "Агуа Фреска"
	description = "A refreshing watermelon agua fresca. Perfect on a day at the holodeck."
	color = "#D25B66"
	quality = DRINK_VERYGOOD
	taste_description = "cool refreshing watermelon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/agua_fresca/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(affected_mob.getToxLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-0.5, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/mushroom_tea
	enname = "Mushroom Tea"
	name = "Грибной чай"
	description = "A savoury glass of tea made from polypore mushroom shavings, originally native to Tizira."
	color = "#674945" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "mushrooms"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/mushroom_tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(islizard(affected_mob))
		if(affected_mob.adjustOxyLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
			return UPDATE_MOB_HEALTH

//Moth Stuff
/datum/reagent/consumable/toechtauese_juice
	enname = "Töchtaüse Juice"
	name = "Сок тёхтаузе"
	description = "Неприятный сок из ягод тёхтаузе. Лучше всего приготовить из него сироп, если вам не нравится боль."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "жгучая зудящая боль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/toechtauese_syrup
	enname = "Töchtaüse Syrup"
	name = "Сироп тёхтаузе"
	description = "Резко пряный и горький сироп, приготовленный из ягод тёхтаузе. Не рекомендуется употреблять в чистом виде."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "sugar, spice, and nothing nice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/strawberry_banana
	enname = "strawberry banana smoothie"
	name = "клубнично-банановый смузи"
	description = "A classic smoothie made from strawberries and bananas."
	color = "#FF9999"
	nutriment_factor = 0
	taste_description = "клубника и банан"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/berry_blast
	enname = "berry blast smoothie"
	name = "ягодный смузи"
	description = "A classic smoothie made from mixed berries."
	color = "#A76DC5"
	nutriment_factor = 0
	taste_description = "смесь ягод"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/funky_monkey
	enname = "funky monkey smoothie"
	name = "шоколадно-банановый смузи"
	description = "A classic smoothie made from chocolate and bananas."
	color = "#663300"
	nutriment_factor = 0
	taste_description = "шоколад и банан"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/green_giant
	enname = "green giant smoothie"
	name = "зелёный гигант"
	description = "A green vegetable smoothie, made without vegetables."
	color = "#003300"
	nutriment_factor = 0
	taste_description = "green, just green"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/melon_baller
	enname = "melon baller smoothie"
	name = "арубзный смузи"
	description = "A classic smoothie made from melons."
	color = "#D22F55"
	nutriment_factor = 0
	taste_description = "свежий арбуз"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/vanilla_dream
	enname = "vanilla dream smoothie"
	name = "ванильный смузи"
	description = "A classic smoothie made from vanilla and fresh cream."
	color = "#FFF3DD"
	nutriment_factor = 0
	taste_description = "сливочная ваниль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cucumberjuice
	enname = "Cucumber Juice"
	name = "Огуречный сок"
	description = "Ordinary cucumber juice, nothing from the fantasy world."
	color = "#6cd87a"
	taste_description = "огурец"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cucumberlemonade
	enname = "Cucumber Lemonade"
	name = "Огуречный лимонад"
	description = "Cucumber juice, sugar, and soda; what else do I need?"
	color = "#6cd87a"
	quality = DRINK_GOOD
	taste_description = "citrus soda with cucumber"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cucumberlemonade/on_mob_life(mob/living/carbon/doll, seconds_per_tick, times_fired)
	. = ..()
	doll.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, doll.get_body_temp_normal())
	if(doll.getToxLoss() && SPT_PROB(10, seconds_per_tick))
		if(doll.adjustToxLoss(-0.5, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/mississippi_queen
	enname = "Mississippi Queen"
	name = "Миссисипи Квин"
	description = "If you think you're so hot, how about a victory drink?"
	color = "#d4422f" // rgb: 212,66,47
	taste_description = "sludge seeping down your throat"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/mississippi_queen/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	switch(current_cycle)
		if(11 to 21)
			drinker.adjust_dizzy(4 SECONDS * REM * seconds_per_tick)
		if(21 to 31)
			if(SPT_PROB(15, seconds_per_tick))
				drinker.adjust_confusion(4 SECONDS * REM * seconds_per_tick)
		if(31 to 201)
			drinker.adjust_hallucinations(60 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/t_letter
	enname = "T"
	name = "T"
	description = "You expected to find this in a soup, but this is fine too."
	color = "#583d09" // rgb: 88, 61, 9
	taste_description = "one of your 26 favorite letters"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/t_letter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_MIND_TRAIT(affected_mob, TRAIT_MIMING))
		return
	affected_mob.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
	affected_mob.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	affected_mob.AdjustSleeping(-40 * REM * seconds_per_tick)
	if(affected_mob.getToxLoss() && SPT_PROB(25, seconds_per_tick))
		if(affected_mob.adjustToxLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/hakka_mate
	enname = "Hakka-Mate"
	name = "Хакка-Мате"
	description = "A Martian-made yerba mate soda, dragged straight out of the pits of a hacking convention."
	color = "#c4b000"
	taste_description = "bubbly yerba mate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/coconut_milk
	enname = "Coconut Milk"
	name = "Кокосовое молоко"
	description = "A versatile milk substitute that's perfect for everything from cooking to making cocktails."
	color = "#DFDFDF"
	taste_description = "milky coconut"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/melon_soda
	enname = "Melon Soda"
	name = "Арбузная газировка"
	description = "A neon green hit of nostalgia."
	color = "#6FEB48"
	taste_description = "fizzy melon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/volt_energy
	enname = "24-Volt Energy"
	name = "24-вольтовая энергия"
	description = "An artificially coloured and flavoured electric energy drink, in lanternfruit flavour. Made for ethereals, by ethereals."
	color = "#99E550"
	taste_description = "sour pear"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/volt_energy/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/internal/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 3)
