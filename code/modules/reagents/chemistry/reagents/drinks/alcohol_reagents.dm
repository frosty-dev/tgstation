#define ALCOHOL_THRESHOLD_MODIFIER 1 //Greater numbers mean that less alcohol has greater intoxication potential
#define ALCOHOL_EXPONENT 1.6 //The exponent applied to boozepwr to make higher volume alcohol at least a little bit damaging to the liver

/datum/reagent/consumable/ethanol
	name = "Этанол"
	enname = "Ehtanol"
	description = "Известный алкоголь с множеством применений."
	color = "#404030" // rgb: 64, 64, 48
	nutriment_factor = 0
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW
	taste_description = "alcohol"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = 1 // impure base reagents are a big no-no
	ph = 7.33
	burning_temperature = 2193//ethanol burns at 1970C (at it's peak)
	burning_volume = 0.1
	default_container = /obj/item/reagent_containers/cup/glass/bottle/beer
	fallback_icon = 'icons/obj/drinks/bottles.dmi'
	fallback_icon_state = "beer"
	/**
	 * Boozepwr Chart
	 *
	 * Higher numbers equal higher hardness, higher hardness equals more intense alcohol poisoning
	 *
	 * Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts
	 * (i.e. light poisoning inherts from slight poisoning)
	 * In addition, severe effects won't always trigger unless the drink is poisonously strong
	 * All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance
	 * (see [/datum/status_effect/inebriated])
	 *
	 * * 0: Non-alcoholic
	 * * 1-10: Barely classifiable as alcohol - occassional slurring
	 * * 11-20: Slight alcohol content - slurring
	 * * 21-30: Below average - imbiber begins to look slightly drunk
	 * * 31-40: Just below average - no unique effects
	 * * 41-50: Average - mild disorientation, imbiber begins to look drunk
	 * * 51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
	 * * 61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
	 * * 71-80: High alcohol content - blurry vision, imbiber completely shitfaced
	 * * 81-90: Extremely high alcohol content - heavy toxin damage, passing out
	 * * 91-100: Dangerously toxic - swift death
	 */
	var/boozepwr = 65

/datum/reagent/consumable/ethanol/New(list/data)
	if(LAZYLEN(data))
		if(!isnull(data["quality"]))
			quality = data["quality"]
			name = "Natural " + name
		if(data["boozepwr"])
			boozepwr = data["boozepwr"]
	addiction_types = list(/datum/addiction/alcohol = 0.05 * boozepwr)
	return ..()

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.get_drunk_amount() < volume * boozepwr * ALCOHOL_THRESHOLD_MODIFIER || boozepwr < 0)
		var/booze_power = boozepwr
		if(HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE)) // we're an accomplished drinker
			booze_power *= 0.7
		if(HAS_TRAIT(drinker, TRAIT_LIGHT_DRINKER))
			booze_power *= 2

		// water will dilute alcohol effects
		var/total_water_volume = 0
		var/total_alcohol_volume = 0
		for(var/datum/reagent/water/sobriety in drinker.reagents.reagent_list)
			total_water_volume += sobriety.volume

		for(var/datum/reagent/consumable/ethanol/alcohol in drinker.reagents.reagent_list)
			total_alcohol_volume += alcohol.volume

		var/combined_dilute_volume = total_alcohol_volume + total_water_volume
		if(combined_dilute_volume) // safety check to prevent division by zero
			booze_power *= (total_alcohol_volume / combined_dilute_volume)

		// Volume, power, and server alcohol rate effect how quickly one gets drunk
		drinker.adjust_drunk_effect(sqrt(volume) * booze_power * ALCOHOL_RATE * REM * seconds_per_tick)
		if(boozepwr > 0)
			var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
			var/heavy_drinker_multiplier = (HAS_TRAIT(drinker, TRAIT_HEAVY_DRINKER) ? 0.5 : 1)
			if (istype(liver))
				if(liver.apply_organ_damage(((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * liver.alcohol_tolerance * heavy_drinker_multiplier * seconds_per_tick, 0))/150)))
					return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/expose_obj(obj/exposed_obj, reac_volume)
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clear_paper()
		to_chat(usr, span_notice("чернила на [paperaffected] смываются."))
	if(istype(exposed_obj, /obj/item/book))
		if(reac_volume >= 5)
			var/obj/item/book/affectedbook = exposed_obj
			affectedbook.book_data.set_content("")
			exposed_obj.visible_message(span_notice("Надписи на [exposed_obj] смыты [name]!"))
		else
			exposed_obj.visible_message(span_warning("[name] размазал чернила по [exposed_obj], но они не смылись!"))
	return ..()

/datum/reagent/consumable/ethanol/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	exposed_mob.adjust_fire_stacks(reac_volume / 15)

	if(!iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/power_multiplier = boozepwr / 65 // Weak alcohol has less sterilizing power

	for(var/datum/surgery/surgery as anything in exposed_carbon.surgeries)
		surgery.speed_modifier = max(0.1 * power_multiplier, surgery.speed_modifier)

/datum/reagent/consumable/ethanol/beer
	name = "Пиво"
	enname = "Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Всё еще популярен."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1
	boozepwr = 25
	taste_description = "моча"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

// Beer is a chemical composition of alcohol and various other things. It's a garbage nutrient but hey, it's still one. Also alcohol is bad, mmmkay?
/datum/reagent/consumable/ethanol/beer/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 0.05))
	mytray.adjust_waterlevel(round(volume * 0.7))

/datum/reagent/consumable/ethanol/beer/light
	name = "Светлое Пиво"
	enname = "Light Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Этот сорт отличается меньшим количеством калорий и алкоголя."
	boozepwr = 5 //Space Europeans hate it
	taste_description = "стекломойка"
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beer/maltliquor
	name = "Malt Liquor"
	description = "An alcoholic beverage brewed since ancient times on Old Earth. This variety is stronger than usual, super cheap, and super terrible."
	boozepwr = 35
	taste_description = "sweet corn beer and the hood life"
	ph = 4.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beer/green
	name = "Зеленое Пиво"
	enname = "Green Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Этот сорт окрашен в зеленый цвет."
	color = COLOR_CRAYON_GREEN
	taste_description = "зелёная моча"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beer/green/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.color != color)
		drinker.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)

/datum/reagent/consumable/ethanol/beer/green/on_mob_end_metabolize(mob/living/drinker)
	drinker.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/kahlua
	name = "Кофейный ликер"
	enname = "Kahlua"
	description = "Широко известный мексиканский ликер со вкусом кофе. Выпускается с 1936-го года!"
	color = "#8e8368" // rgb: 142,131,104
	boozepwr = 45
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_dizzy_if_lower(10 SECONDS * REM * seconds_per_tick)
	drinker.adjust_drowsiness(-6 SECONDS * REM * seconds_per_tick)
	drinker.AdjustSleeping(-40 * REM * seconds_per_tick)
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.set_jitter_if_lower(10 SECONDS)

/datum/reagent/consumable/ethanol/whiskey
	name = "Виски"
	enname = "Whiskey"
	description = "Превосходный и хорошо выдержанный односолодовый виски."
	color = "#b4a287" // rgb: 180,162,135
	boozepwr = 75
	taste_description = "меласса"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Конг"
	enname = "Kong"
	description = "Заставляет вас сойти с ума!&#174;"
	color = "#332100" // rgb: 51, 33, 0
	taste_description = "хватка гигантской обезьяны"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "конфетно-кукурузный ликер"
	enname = "Candy Corn Liquor"
	description = "Такой же, как во времена сухого закона."
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "блинный сироп"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		drinker.adjust_hallucinations(4 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Локо Тринадцать"
	description = "Мощная смесь кофе и алкоголя."
	enname = "Thirteen Loko"
	color = "#102000" // rgb: 16, 32, 0
	nutriment_factor = 1
	boozepwr = 80
	quality = DRINK_GOOD
	overdose_threshold = 60
	taste_description = "jitters and death"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_drowsiness(-14 SECONDS * REM * seconds_per_tick)
	drinker.AdjustSleeping(-40 * REM * seconds_per_tick)
	drinker.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, drinker.get_body_temp_normal())
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.set_jitter_if_lower(10 SECONDS)

/datum/reagent/consumable/ethanol/thirteenloko/overdose_start(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_userdanger("Всё моё тело сильно дрожит с приходом тошноты. Наверное, не стоило пить так много [name]!"))
	drinker.set_jitter_if_lower(40 SECONDS)
	drinker.Stun(1.5 SECONDS)

/datum/reagent/consumable/ethanol/thirteenloko/overdose_process(mob/living/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(3.5, seconds_per_tick) && iscarbon(drinker))
		var/obj/item/held_item = drinker.get_active_held_item()
		if(held_item)
			drinker.dropItemToGround(held_item)
			to_chat(drinker, span_notice("Руки дрожат, роняю то, что в них было!"))
			drinker.set_jitter_if_lower(20 SECONDS)

	if(SPT_PROB(3.5, seconds_per_tick))
		to_chat(drinker, span_notice("[pick("У меня очень сильно болит голова.", "Глазам больно.", "Мне сложно ровно стоять.", "По ощущениям мое сердце буквально вырывается из груди.")]"))

	if(SPT_PROB(2.5, seconds_per_tick) && iscarbon(drinker))
		var/obj/item/organ/internal/eyes/eyes = drinker.get_organ_slot(ORGAN_SLOT_EYES)
		if(eyes && IS_ORGANIC_ORGAN(eyes)) // doesn't affect robotic eyes
			if(drinker.is_blind())
				eyes.Remove(drinker)
				eyes.forceMove(get_turf(drinker))
				to_chat(drinker, span_userdanger("Сгибаюсь от боли, кажется, мои глазные яблоки разжижаются в голове!"))
				drinker.emote("scream")
				if(drinker.adjustBruteLoss(15 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
					. = UPDATE_MOB_HEALTH
			else
				to_chat(drinker, span_userdanger("Кричу от ужаса, я ничего не вижу!"))
				if(eyes.apply_organ_damage(eyes.maxHealth))
					. = UPDATE_MOB_HEALTH
				drinker.emote("scream")

	if(SPT_PROB(1.5, seconds_per_tick) && iscarbon(drinker))
		drinker.visible_message(span_danger("[drinker] бьется в припадке!") , span_userdanger("У меня припадок!"))
		if(drinker.Unconscious(10 SECONDS))
			. = UPDATE_MOB_HEALTH
		drinker.set_jitter_if_lower(700 SECONDS)

	if(SPT_PROB(0.5, seconds_per_tick) && iscarbon(drinker))
		var/datum/disease/heart_attack = new /datum/disease/heart_failure
		drinker.ForceContractDisease(heart_attack)
		to_chat(drinker, span_userdanger("Уверен[drinker.ru_a()], что ощутил[drinker.ru_a()] как мое сердце пропустило удар.."))
		drinker.playsound_local(drinker, 'sound/effects/singlebeat.ogg', 100, 0)

/datum/reagent/consumable/ethanol/vodka
	name = "Водка"
	enname = "Vodka"
	description = "Напиток и топливо номер один для русских по всему миру."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 65
	taste_description = "зерновой спирт"
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS //Very high proof
	default_container = /obj/item/reagent_containers/cup/glass/bottle/vodka

/datum/reagent/consumable/ethanol/bilk
	name = "Билк"
	description = "Похоже, это пиво, смешанное с молоком. Отвратительно."
	enname = "Bilk"
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2
	boozepwr = 15
	taste_description = "отчаяние и лактат"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.getBruteLoss() && SPT_PROB(5, seconds_per_tick))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/threemileisland
	name = "Три мили от берега"
	description = "Made for a woman, strong enough for a man."
	enname = "Three Mile Island Iced Tea"
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "сухость"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_drugginess(100 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/gin
	name = "Джин"
	enname = "Gin"
	description = "It's gin. In space. I say, good sir."
	color = "#d8e8f0" // rgb: 216,232,240
	boozepwr = 45
	taste_description = "an alcoholic christmas tree"
	ph = 6.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/rum
	name = "Ром"
	enname = "Rum"
	description = "Йо-хо-хо, так сказать."
	color = "#c9c07e" // rgb: 201,192,126
	boozepwr = 60
	taste_description = "колючие ириски"
	ph = 6.5
	default_container = /obj/item/reagent_containers/cup/glass/bottle/rum

/datum/reagent/consumable/ethanol/tequila
	name = "Текила"
	enname = "Tequila"
	description = "Крепкий и мягкий по вкусу спиртной напиток мексиканского производства. Хочешь выпить, приятель?"
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 70
	taste_description = "paint stripper"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/vermouth
	enname = "Vermouth"
	name = "Вермут"
	description = "Вдруг испытываю желание выпить мартини..."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 45
	taste_description = "сухой спирт"
	ph = 3.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wine
	name = "Вино"
	enname = "Wine"
	description = "Вам вдруг захотелось выпить мартини..."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 35
	taste_description = "bitter sweetness"
	ph = 3.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK
	default_container = /obj/item/reagent_containers/cup/glass/bottle/wine

/datum/reagent/consumable/ethanol/wine/on_merge(data)
	. = ..()
	if(src.data && data && data["vintage"] != src.data["vintage"])
		src.data["vintage"] = "mixed wine"

/datum/reagent/consumable/ethanol/wine/get_taste_description(mob/living/taster)
	if(HAS_TRAIT(taster,TRAIT_WINE_TASTER))
		if(data && data["vintage"])
			return list("[data["vintage"]]" = 1)
		else
			return list("synthetic wine"=1)
	return ..()

/datum/reagent/consumable/ethanol/lizardwine
	name = "Вино из ящериц"
	enname = "Lizard Wine"
	description = "Алкогольный напиток из космического Китая, изготовленный путем настаивания хвостов ящериц в этаноле."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "масштабная сладость"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/grappa
	name = "Граппа"
	enname = "Grappa"
	description = "Прекрасный итальянский бренди, когда обычное вино недостаточно крепкое для вас."
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "классная горькая сладость"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/amaretto
	name = "Амаретто"
	enname = "Amaretto"
	description = "Нежный напиток со сладким ароматом."
	color = "#E17600"
	boozepwr = 25
	taste_description = "фруктово-ореховая сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/cognac
	name = "Коньяк"
	enname = "Cognac"
	description = "Сладкий и сильноалкогольный напиток, изготовленный после многочисленных дистилляций и многолетней выдержки."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "ирландская злость"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/absinthe
	name = "Абсент"
	enname = "Absinthe"
	description = "Крепкий алкогольный напиток. По слухам, вызывает галлюцинации, но это не так."
	color = rgb(10, 206, 0)
	boozepwr = 80 //Very strong even by default
	taste_description = "смерть и солодка"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick) && !HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.adjust_hallucinations(8 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/hooch
	enname = "Hooch"
	name = "Хуч"
	description = "Либо чья-то неудача в приготовлении коктейля, либо попытка производства алкоголя. В любом случае, вы действительно хотите это выпить?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100
	taste_description = "чистая отставка"
	addiction_types = list(/datum/addiction/alcohol = 5, /datum/addiction/maintenance_drugs = 2)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/ale
	enname = "Ale"
	name = "Эль"
	description = "Темный алкогольный напиток, приготовленный из ячменного солода и дрожжей."
	color = "#976063" // rgb: 151,96,99
	boozepwr = 65
	taste_description = "ячменный эль"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/goldschlager
	enname = "Goldschlager"
	name = "Гольдшпигер"
	description = "Шнапс с корицей 100% пробы, созданный для алкоголиков-подростков на весенних каникулах."
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "горящая корица"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	// This drink is really popular with a certain demographic.
	var/teenage_girl_quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/goldschlager/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	// Reset quality each time, since the bottle can be shared
	quality = initial(quality)

	if(ishuman(exposed_mob))
		var/mob/living/carbon/human/human = exposed_mob
		// tgstation13 does not endorse underage drinking. laws may vary by your jurisdiction.
		if(human.age >= 13 && human.age <= 19 && human.gender == FEMALE)
			quality = teenage_girl_quality

	return ..()

/datum/reagent/consumable/ethanol/goldschlager/on_transfer(atom/atom, methods = TOUCH, trans_volume)
	if(!(methods & INGEST))
		return ..()

	var/convert_amount = trans_volume * min(GOLDSCHLAGER_GOLD_RATIO, 1)
	atom.reagents.remove_reagent(/datum/reagent/consumable/ethanol/goldschlager, convert_amount)
	atom.reagents.add_reagent(/datum/reagent/gold, convert_amount)
	return ..()

/datum/reagent/consumable/ethanol/patron
	enname = "Patron"
	name = "Текила «Патрон»"
	description = "Текила с серебром, обожаемая девушками с низкой социальной ответственностью."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "дорогой металл"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gintonic
	enname = "Gin and Tonic"
	name = "Джин-тоник"
	description = "Классический коктейль на все времена."
	color = "#cae7ec" // rgb: 202,231,236
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "мягкий и терпкий напиток"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/rum_coke
	enname = "Rum and Coke"
	name = "Ром с колой"
	description = "Ром, смешанный с колой."
	taste_description = "кола"
	boozepwr = 40
	quality = DRINK_NICE
	color = "#3E1B00"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cuba_libre
	enname = "Cuba Libre"
	name = "Куба Либре"
	special_sound = 'white/valtos/sound/drink/cuba.ogg'
	description = "Да здравствует революция! Да здравствует свободная Куба!"
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "освежающий брак цитрусовых и рома"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cuba_libre/on_mob_life(mob/living/carbon/cubano, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	if(cubano.mind && cubano.mind.has_antag_datum(/datum/antagonist/rev)) //Cuba Libre, the traditional drink of revolutions! Heals revolutionaries.
		need_mob_update = cubano.adjustBruteLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += cubano.adjustFireLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += cubano.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += cubano.adjustOxyLoss(-5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/whiskey_cola
	enname = "Whiskey Cola"
	name = "Виски кола"
	description = "Виски, смешанное с колой. Удивительно освежает."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "кола"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/martini
	enname = "Classic Martini"
	name = "Классический Мартини"
	description = "Вермут с джином. Не совсем то, что любил агент 007, но все равно вкусно."
	color = "#cddbac" // rgb: 205,219,172
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "классический сухой мартини"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/vodkamartini
	enname = "Vodka Martini"
	name = "Мартини с водкой"
	description = "Водка с джином. Не совсем то, что любил агент 007, но все равно вкусно."
	color = "#cddcad" // rgb: 205,220,173
	boozepwr = 65
	quality = DRINK_NICE
	taste_description = "взболтанный, но не размешанный"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/white_russian
	enname = "White Russian"
	name = "Белый Русский"
	description = "Это всего лишь твое мнение..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горькие сливки"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail
	enname = "Screwdriver"
	name = "Отвертка"
	description = "Водка, смешанная с обычным апельсиновым соком. Результат удивительно хорош."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "детство"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_transfer(atom/atom, methods = TOUCH, trans_volume)
	if(!(methods & INGEST))
		return ..()

	if(src == atom.reagents.get_master_reagent() && istype(atom, /obj/item/reagent_containers/cup/glass/drinkingglass))
		var/obj/item/reagent_containers/cup/glass/drinkingglass/drink = atom
		drink.tool_behaviour = TOOL_SCREWDRIVER
		var/list/reagent_change_signals = list(
			COMSIG_REAGENTS_ADD_REAGENT,
			COMSIG_REAGENTS_NEW_REAGENT,
			COMSIG_REAGENTS_REM_REAGENT,
			COMSIG_REAGENTS_DEL_REAGENT,
			COMSIG_REAGENTS_CLEAR_REAGENTS,
			COMSIG_REAGENTS_REACTED,
		)
		RegisterSignals(drink.reagents, reagent_change_signals, PROC_REF(on_reagent_change))

	return ..()

/datum/reagent/consumable/ethanol/screwdrivercocktail/proc/on_reagent_change(datum/reagents/reagents)
	SIGNAL_HANDLER
	if(src != reagents.get_master_reagent())
		var/obj/item/reagent_containers/cup/glass/drinkingglass/drink = reagents.my_atom
		drink.tool_behaviour = initial(drink.tool_behaviour)
		UnregisterSignal(reagents, list(
			COMSIG_REAGENTS_ADD_REAGENT,
			COMSIG_REAGENTS_NEW_REAGENT,
			COMSIG_REAGENTS_REM_REAGENT,
			COMSIG_REAGENTS_DEL_REAGENT,
			COMSIG_REAGENTS_CLEAR_REAGENTS,
			COMSIG_REAGENTS_REACTED,
		))

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_ENGINEER_METABOLISM))
		ADD_TRAIT(drinker, TRAIT_HALT_RADIATION_EFFECTS, "[type]")
		if (HAS_TRAIT(drinker, TRAIT_IRRADIATED))
			if(drinker.adjustToxLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	REMOVE_TRAIT(drinker, TRAIT_HALT_RADIATION_EFFECTS, "[type]")

/datum/reagent/consumable/ethanol/booger
	enname = "Booger"
	name = "Бугер"
	description = "Фууу..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 45
	taste_description = "сливки с ноткой сладости"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary
	enname = "Bloody Mary"
	name = "Кровавая Мэри"
	description = "Странная, но приятная смесь из водки, томата и сока лайма. По крайней мере, вам КАЖЕТСЯ что красное вещество - это томатный сок."
	color = "#bf707c" // rgb: 191,112,124
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "помидоры с ноткой лайма"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	if(drinker.blood_volume < BLOOD_VOLUME_NORMAL)
		drinker.blood_volume = min(drinker.blood_volume + (3 * REM * seconds_per_tick), BLOOD_VOLUME_NORMAL) //Bloody Mary quickly restores blood loss.
	..()

/datum/reagent/consumable/ethanol/brave_bull
	enname = "Brave Bull"
	name = "Храбрый Бык"
	special_sound = 'white/valtos/sound/drink/bull.ogg'
	description = "Один глоток даёт заряд бравады на целую смену."
	color = "#a79f98" // rgb: 167,159,152
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "алкогольная храбрость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	var/tough_text

/datum/reagent/consumable/ethanol/brave_bull/on_mob_metabolize(mob/living/drinker)
	. = ..()
	tough_text = pick("сильнее", "выносливее", "крепче") //Tuff stuff
	to_chat(drinker, span_notice("Чувствую, что становлюсь [tough_text]!"))
	drinker.maxHealth += 10 //Brave Bull makes you sturdier, and thus capable of withstanding a tiny bit more punishment.
	drinker.health += 10
	ADD_TRAIT(drinker, TRAIT_FEARLESS, type)

/datum/reagent/consumable/ethanol/brave_bull/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("Снова чувствую себя нормально."))
	drinker.maxHealth -= 10
	drinker.health = min(drinker.health - 10, drinker.maxHealth) //This can indeed crit you if you're alive solely based on alchol ingestion
	REMOVE_TRAIT(drinker, TRAIT_FEARLESS, type)

/datum/reagent/consumable/ethanol/tequila_sunrise
	enname = "Tequila Sunrise"
	name = "Текила Санрайз"
	special_sound = 'white/valtos/sound/drink/tequila_sunrise.ogg'
	description = "Текила, гренадин и апельсиновый сок."
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "апельсины с оттенком граната"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("Чувствую как по моему телу расползается приятное тепло!"))
	light_holder = new(drinker)
	light_holder.set_light(3, 0.7, "#FFCC00") //Tequila Sunrise makes you radiate dim light, like a sunrise!

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	if(QDELETED(light_holder))
		holder.del_reagent(type) //If we lost our light object somehow, remove the reagent
	else if(light_holder.loc != drinker)
		light_holder.forceMove(drinker)
	return ..()

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("Тепло, окутававшее мое тело, исчезло."))
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/toxins_special
	enname = "Toxins Special"
	name = "Бомбление"
	description = "ПОЖАР! ВЗРЫВОТЕХНИКИ СНОВА ГОРЯТ!! ВЫЗОВИТЕ СРАНЫЙ ШАТЛ!!!"
	color = "#8880a8" // rgb: 136,128,168
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "пряные токсины"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_bodytemperature(15 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, drinker.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/beepsky_smash
	enname = "Beepsky Smash"
	name = "Удар Бипски"
	special_sound = 'white/valtos/sound/drink/criminal.ogg'
	description = "Выпейте это и приготовьтесь к ПРАВОСУДИЮ."
	color = "#808000" // rgb: 128,128,0
	boozepwr = 60 //THE FIST OF THE LAW IS STRONG AND HARD
	quality = DRINK_GOOD
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "ЗАКОН И ПОРЯДОК"
	overdose_threshold = 40
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/datum/brain_trauma/special/beepsky/beepsky_hallucination

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		metabolization_rate = 0.8
	// if you don't have a liver, or your liver isn't an officer's liver
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		beepsky_hallucination = new()
		drinker.gain_trauma(beepsky_hallucination, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_jitter_if_lower(4 SECONDS)
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you have a liver and that liver is an officer's liver
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		if(drinker.adjustStaminaLoss(-10 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
		if(SPT_PROB(10, seconds_per_tick))
			drinker.cause_hallucination(get_random_valid_hallucination_subtype(/datum/hallucination/nearby_fake_item), name)
		if(SPT_PROB(5, seconds_per_tick))
			drinker.cause_hallucination(/datum/hallucination/stray_bullet, name)

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(beepsky_hallucination)
		QDEL_NULL(beepsky_hallucination)

/datum/reagent/consumable/ethanol/beepsky_smash/overdose_start(mob/living/carbon/drinker)
	. = ..()
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you don't have a liver, or your liver isn't an officer's liver
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		drinker.gain_trauma(/datum/brain_trauma/mild/phobia/security, TRAUMA_RESILIENCE_BASIC)

/datum/reagent/consumable/ethanol/irish_cream
	enname = "Irish Cream"
	name = "Айриш Крим"
	special_sound = 'white/valtos/sound/drink/irish_coffee.ogg'
	description = "Сливки с виски - что еще можно ожидать от ирландцев?"
	color = "#e3d0b2" // rgb: 227,208,178
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "creamy alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manly_dorf
	enname = "The Manly Dorf"
	name = "Мужицкий Дорф"
	special_sound = 'white/valtos/sound/drink/df.ogg'
	description = "Пиво и эль, собранные вместе в восхитительный микс. Только для настоящих мужчин."
	color = "#815336" // rgb: 129,83,54
	boozepwr = 100 //For the manly only
	quality = DRINK_NICE
	taste_description = "волосы на груди и подбородке"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/dorf_mode = FALSE

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/potential_dwarf = drinker
		if(HAS_TRAIT(potential_dwarf, TRAIT_DWARF))
			to_chat(potential_dwarf, span_notice("Вот ЭТО и есть МУЖЕСТВО!"))
			boozepwr = 50 // will still smash but not as much.
			dorf_mode = TRUE

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_life(mob/living/carbon/dwarf, seconds_per_tick, times_fired)
	. = ..()
	if(dorf_mode)
		var/need_mob_update
		need_mob_update = dwarf.adjustBruteLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += dwarf.adjustFireLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/longislandicedtea
	enname = "Long Island Iced Tea"
	name = "Лонг-Айленд айс ти"
	special_sound = 'white/valtos/sound/drink/long_island.ogg'
	description = "Восхитительная смесь водки, джина, текилы и куба либре. Предназначен только для женщин-алкоголиков бальзаковского возраста."
	color = "#ff6633" // rgb: 255,102,51
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "смесь алкоголя"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/moonshine
	enname = "Moonshine"
	name = "Лунный свет"
	description = "Вы действительно достигли дна... Ваша печень собрала свои вещи и ушла вчера вечером."
	special_sound = 'white/valtos/sound/drink/moonshine.ogg'
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha) (like water)
	boozepwr = 95
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/b52
	enname = "B-52"
	name = "Б-52"
	description = "Кофе, айриш крим и коньяк. Тебя просто разорвёт."
	color = "#8f1733" // rgb: 143,23,51
	boozepwr = 85
	quality = DRINK_GOOD
	taste_description = "ирландская злость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/b52/on_mob_metabolize(mob/living/drinker)
	. = ..()
	playsound(drinker, 'white/valtos/sound/nuclearexplosion.ogg', 100, FALSE)

/datum/reagent/consumable/ethanol/irishcoffee
	enname = "Irish Coffee"
	name = "Ирландский кофе"
	description = "Кофе и алкоголь. Веселее, чем пить \"Мимозу\" по утрам."
	special_sound = 'white/valtos/sound/drink/irish_coffee.ogg'
	color = "#874010" // rgb: 135,64,16
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "giving up on the day"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/margarita
	enname = "Margarita"
	name = "Маргарита"
	description = "На камнях с солью по краю. Арриба~!"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "сухость и соль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/black_russian
	enname = "Black Russian"
	name = "Черный русский"
	description = "Для людей с непереносимостью лактозы. По-прежнему стильный, как белый русский."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manhattan
	enname = "Manhattan"
	name = "Манхэттен"
	description = "Любимый напиток детектива под прикрытием. Он никогда не мог переварить джин..."
	color = "#ff3300" // rgb: 255,51,0
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "легкая сухость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/manhattan_proj
	enname = "Manhattan Project"
	name = "Проект Манхэттен"
	description = "Любимый напиток ученых, мечтающих как взорвать станцию."
	color = COLOR_MOSTLY_PURE_RED
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "смерть, разрушитель миров"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manhattan_proj/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_drugginess(1 MINUTES * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/whiskeysoda
	enname = "Whiskey Soda"
	name = "Виски с содовой"
	description = "Идеально освежает."
	color = "#ffcc33" // rgb: 255,204,51
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "содовая"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze
	enname = "Anti-freeze"
	name = "Антифриз"
	description = "Идеально освежает. Внешний вид может обмануть."
	color = "#30f0f8" // rgb: 48,240,248
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "моча Джека Фроста"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, drinker.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/barefoot
	enname = "Barefoot"
	name = "Босоножка"
	description = "Босая и беременная."
	color = "#fc5acc" // rgb: 252,90,204
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "сливочные ягоды"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/barefoot/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker)) //Barefoot causes the imbiber to quickly regenerate brute trauma if they're not wearing shoes.
		var/mob/living/carbon/human/unshoed = drinker
		if(!unshoed.shoes)
			if(unshoed.adjustBruteLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/snowwhite
	enname = "Snow White"
	name = "Белоснежка"
	description = "Холодная свежесть."
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "освежающий холод"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/demonsblood
	enname = "Demon's Blood"
	name = "Кровь демона"
	description = "ААААА!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "сладкое железо"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/demonsblood/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	RegisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_PRE_CONSUMED, PROC_REF(pre_bloodcrawl_consumed))

/datum/reagent/consumable/ethanol/demonsblood/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	UnregisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_PRE_CONSUMED)

/// Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
/datum/reagent/consumable/ethanol/demonsblood/proc/pre_bloodcrawl_consumed(
	mob/living/source,
	datum/action/cooldown/spell/jaunt/bloodcrawl/crawl,
	mob/living/jaunter,
	obj/effect/decal/cleanable/blood,
)

	SIGNAL_HANDLER

	var/turf/jaunt_turf = get_turf(jaunter)
	jaunt_turf.visible_message(
		span_warning("Something prevents [source] from entering [blood]!"),
		blind_message = span_notice("You hear a splash and a thud.")
	)
	to_chat(jaunter, span_warning("A strange force is blocking [source] from entering!"))

	return COMPONENT_STOP_CONSUMPTION

/datum/reagent/consumable/ethanol/devilskiss
	enname = "Devil's Kiss"
	name = "Поцелуй дьявола"
	description = "Жуть!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "горькое железо"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/devilskiss/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	RegisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_CONSUMED, PROC_REF(on_bloodcrawl_consumed))

/datum/reagent/consumable/ethanol/devilskiss/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	UnregisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_CONSUMED)

/// If eaten by a slaughter demon, the demon will regret it.
/datum/reagent/consumable/ethanol/devilskiss/proc/on_bloodcrawl_consumed(
	mob/living/source,
	datum/action/cooldown/spell/jaunt/bloodcrawl/crawl,
	mob/living/jaunter,
)

	SIGNAL_HANDLER

	. = COMPONENT_STOP_CONSUMPTION

	to_chat(jaunter, span_boldwarning("AAH! THEIR FLESH! IT BURNS!"))
	jaunter.apply_damage(25, BRUTE, wound_bonus = CANT_WOUND)

	for(var/obj/effect/decal/cleanable/nearby_blood in range(1, get_turf(source)))
		if(!nearby_blood.can_bloodcrawl_in())
			continue
		source.forceMove(get_turf(nearby_blood))
		source.visible_message(span_warning("[nearby_blood] violently expels [source]!"))
		crawl.exit_blood_effect(source)
		return

	// Fuck it, just eject them, thanks to some split second cleaning
	source.forceMove(get_turf(source))
	source.visible_message(span_warning("[source] appears from nowhere, covered in blood!"))
	crawl.exit_blood_effect(source)

/datum/reagent/consumable/ethanol/vodkatonic
	enname = "Vodka and Tonic"
	name = "Водка с тоником"
	description = "Для тех случаев, когда джин с тоником не достаточно по-русски."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "терпкая горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/ginfizz
	enname = "Gin Fizz"
	name = "Джин физ"
	description = "Освежающе лимонный, восхитительно сухой."
	color = "#ffffcc" // rgb: 255,255,204
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "сухой, терпкий лимон"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bahama_mama
	enname = "Bahama Mama"
	name = "Багама мама"
	description = "Тропический коктейль со сложным сочетанием вкусов."
	special_sound = 'white/valtos/sound/drink/bahama_mama.ogg'
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "ананас, кокос и кофе"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/singulo
	enname = "Singulo"
	name = "Сингуло"
	description = "Блюспейс коктейль!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "концентрированное вещество"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/static/list/ray_filter = list(type = "rays", size = 40, density = 15, color = SUPERMATTER_SINGULARITY_RAYS_COLOUR, factor = 15)

/datum/reagent/consumable/ethanol/singulo/on_mob_metabolize(mob/living/drinker)
	. = ..()
	ADD_TRAIT(drinker, TRAIT_MADNESS_IMMUNE, type)

/datum/reagent/consumable/ethanol/singulo/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	REMOVE_TRAIT(drinker, TRAIT_MADNESS_IMMUNE, type)
	drinker.remove_filter("singulo_rays")

/datum/reagent/consumable/ethanol/singulo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		// 20u = 1x1, 45u = 2x2, 80u = 3x3
		var/volume_to_radius = FLOOR(sqrt(volume/5), 1) - 1
		var/suck_range = clamp(volume_to_radius, 0, 3)

		if(!suck_range)
			return ..()

		var/turf/gravity_well_turf = get_turf(drinker)
		goonchem_vortex(gravity_well_turf, 0, suck_range)
		playsound(get_turf(drinker), 'sound/effects/supermatter.ogg', 150, TRUE)
		drinker.add_filter("singulo_rays", 1, ray_filter)
		animate(drinker.get_filter("singulo_rays"), offset = 10, time = 1.5 SECONDS, loop = -1)
		addtimer(CALLBACK(drinker, TYPE_PROC_REF(/datum, remove_filter), "singulo_rays"), 1.5 SECONDS)
		drinker.emote("burp")

/datum/reagent/consumable/ethanol/sbiten
	enname = "Sbiten"
	name = "Сбитень"
	description = "Водка с перцом! Не обожгись!"
	color = "#d8d5ae" // rgb: 216,213,174
	boozepwr = 70
	quality = DRINK_GOOD
	taste_description = "горячая пряность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_bodytemperature(50 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, BODYTEMP_HEAT_DAMAGE_LIMIT) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/red_mead
	enname = "Red Mead"
	name = "Красная медовуха"
	description = "Настоящий напиток викингов! Несмотря его странный цвет."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 31 //Red drinks are stronger
	quality = DRINK_GOOD
	taste_description = "сладкий и соленый алкоголь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mead
	enname = "Mead"
	name = "Медовуха"
	description = "Напиток викингов, хоть и дешевый, но любимый."
	color = "#e0c058" // rgb: 224,192,88
	nutriment_factor = 1
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "сладкий, сладкий алкоголь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer
	enname = "Iced Beer"
	name = "Ледяное пиво"
	description = "Настолько холодное пиво, что воздух вокруг замерзает."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "освежающая прохлада"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_bodytemperature(-20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, T0C) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/grog
	enname = "Grog"
	name = "Грог"
	description = "Разбавленный водой ром, Нанотрейзен одобряет!"
	color = "#e0e058" // rgb: 224,224,88
	boozepwr = 1 //Basically nothing
	taste_description = "плохое оправдание для алкоголя"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/aloe
	enname = "Aloe"
	name = "Алоэ"
	description = "Очень, очень, очень хорош."
	color = "#f8f800" // rgb: 248,248,0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "сладкие сливки"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	//somewhat annoying mix
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/andalusia
	enname = "Andalusia"
	name = "Андалузия"
	description = "Приятный напиток со странным названием."
	color = "#c8f860" // rgb: 200,248,96
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "лимоны"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/alliescocktail
	enname = "Allies Cocktail"
	name = "Коктейль союзников"
	description = "Напиток, приготовленный вашими союзниками. Не так сладок, как напиток, приготовленный из ваших врагов."
	color = "#60f8f8" // rgb: 96,248,248
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "горечь свободы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/acid_spit
	enname = "Acid Spit"
	name = "Кислотный плевок"
	description = "Напиток для смелых. При неправильном приготовлении может оказаться смертельно опасным!"
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "желудочная кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amasec
	enname = "Amasec"
	name = "Амасек"
	description = "Официальный напиток оружейного клуба \"НаноТрейзен\"!"
	color = "#e0e058" // rgb: 224,224,88
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "тьма и металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting
	enname = "Changeling Sting"
	name = "Жало генокрада"
	description = "Вы делаете маленький глоток и чувствуете жжение...."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "мой мозг выходит из носа"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting/on_mob_life(mob/living/carbon/target, seconds_per_tick, times_fired)
	. = ..()
	var/datum/antagonist/changeling/changeling = target.mind?.has_antag_datum(/datum/antagonist/changeling)
	changeling?.adjust_chemicals(metabolization_rate * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/irishcarbomb
	enname = "Irish Car Bomb"
	name = "Ирландская Автомобильная бомба"
	description = "Ммм, на вкус как свободное ирландское государство."
	special_sound = 'white/valtos/sound/drink/irish_coffee.ogg'
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "дух Ирландии"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb
	enname = "Syndicate Bomb"
	name = "Бомба Синдиката"
	description = "На вкус как терроризм!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 90
	quality = DRINK_GOOD
	taste_description = "очищенный антагонизм"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		playsound(get_turf(drinker), 'sound/effects/explosionfar.ogg', 100, TRUE)

/datum/reagent/consumable/ethanol/hiveminderaser
	enname = "Hivemind Eraser"
	name = "Стиратель улья"
	description = "Сосуд чистого вкуса."
	color = "#FF80FC" // rgb: 255, 128, 252
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "экстрасенсорные связи"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/erikasurprise
	enname = "Erika Surprise"
	name = "Сюрприз Эрики"
	description = "Это сюрпиз! И он зеленый!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "терпкость и бананы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/driestmartini
	enname = "Driest Martini"
	name = "Сухой Мартини"
	description = "Только для бывалых. Вам кажется, что вы видите песок, плавающий в бокале."
	nutriment_factor = 1
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 65
	quality = DRINK_GOOD
	taste_description = "пляж"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk
	enname = "Banana Honk"
	name = "Банановый Хонк"
	description = "Напиток из клоунского рая."
	special_sound = 'white/valtos/sound/drink/bikehorn.ogg'
	nutriment_factor = 1
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "плохая шутка"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || is_simian(drinker))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/silencer
	enname = "Silencer"
	name = "Глушитель"
	description = "Напиток из Рая для Мимов."
	nutriment_factor = 2
	color = "#a8a8a8" // rgb: 168,168,168
	boozepwr = 59 //Proof that clowns are better than mimes right here
	quality = DRINK_GOOD
	taste_description = "ластик"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/drunkenblumpkin
	enname = "Drunken Blumpkin"
	name = "Пьяный тупица"
	description = "Странная смесь виски и сока бюспейс тыквы."
	color = "#1EA0FF" // rgb: 30,160,255
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "патока и глоток воды из бассейна"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey_sour //Requested since we had whiskey cola and soda but not sour.
	enname = "Whiskey Sour"
	name = "Виски Сауэр"
	description = "Lemon juice/whiskey/sugar mixture. Moderate alcohol content."
	color = rgb(255, 201, 49)
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "кислые лимоны"

/datum/reagent/consumable/ethanol/hcider
	enname = "Hard Cider"
	name = "Крепкий Сидр"
	description = "Яблочный сок для взрослых."
	special_sound = 'white/nocringe/sound/drink/hcider.ogg'
	color = "#CD6839"
	nutriment_factor = 1
	boozepwr = 25
	taste_description = "осень"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/fetching_fizz //A reference to one of my favorite games of all time. Pulls nearby ores to the imbiber!
	enname = "Fetching Fizz"
	name = "Приход"
	description = "Смесь кислого виски с железом и ураном, в результате чего образуется высокомагнитная суспензия." //Requires no alcohol to make but has alcohol anyway because ~magic~
	color = rgb(255, 91, 15)
	boozepwr = 10
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	taste_description = "заряженный металл" // the same as teslium, honk honk.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fetching_fizz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	for(var/obj/item/stack/ore/O in orange(3, drinker))
		step_towards(O, get_turf(drinker))

//Another reference. Heals those in critical condition extremely quickly.
/datum/reagent/consumable/ethanol/hearty_punch
	enname = "Hearty Punch"
	name = "Сердечный Пунш"
	description = "Смесь Храброго Быка, Бомбы Синдиката и абсента, в результате чего получается возбуждающий напиток."
	color = rgb(140, 0, 0)
	boozepwr = 90
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	taste_description = "бравада перед лицом катастрофы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hearty_punch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.health <= 0)
		var/need_mob_update
		need_mob_update = drinker.adjustBruteLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjustFireLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjustCloneLoss(-5 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustOxyLoss(-4 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjustToxLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/bacchus_blessing //An EXTREMELY powerful drink. Smashed in seconds, dead in minutes.
	enname = "Bacchus' Blessing"
	name = "Бахус"
	description = "Неидентифицируемая смесь. Неизмеримо высокое содержание алкоголя."
	color = rgb(51, 19, 3) //Sickly brown
	boozepwr = 300 //I warned you
	taste_description = "кирпичная стена"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/atomicbomb
	enname = "Atomic Bomb"
	name = "Атомная Бомба"
	description = "Ядерное оружие никогда не было таким вкусным."
	color = "#666300" // rgb: 102, 99, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	taste_description = "бомба"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/atomicbomb/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_drugginess(100 SECONDS * REM * seconds_per_tick)
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.adjust_confusion(2 SECONDS * REM * seconds_per_tick)
	drinker.set_dizzy_if_lower(20 SECONDS * REM * seconds_per_tick)
	drinker.adjust_slurring(6 SECONDS * REM * seconds_per_tick)
	switch(current_cycle)
		if(52 to 201)
			drinker.Sleeping(100 * REM * seconds_per_tick)
		if(202 to INFINITY)
			drinker.AdjustSleeping(40 * REM * seconds_per_tick)
			if(drinker.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/gargle_blaster
	enname = "Pan-Galactic Gargle Blaster"
	name = "Пангалактический ополаскиватель"
	description = "Вау, эта штука выглядит нестабильной."
	color = "#9cc8b4" // rgb: 156,200,180
	boozepwr = 0 //custom drunk effect
	quality = DRINK_GOOD
	taste_description = "мои мозги разбиты лимоном, обернутым вокруг золотого кирпича"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/gargle_blaster/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_dizzy(3 SECONDS * REM * seconds_per_tick)
	switch(current_cycle)
		if(16 to 46)
			drinker.adjust_slurring(3 SECONDS * REM * seconds_per_tick)
		if(46 to 56)
			if(SPT_PROB(30, seconds_per_tick))
				drinker.adjust_confusion(3 SECONDS * REM * seconds_per_tick)
		if(56 to 201)
			drinker.set_drugginess(110 SECONDS * REM * seconds_per_tick)
		if(201 to INFINITY)
			if(drinker.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/neurotoxin
	enname = "Neurotoxin"
	name = "Нейротоксин"
	description = "Сильный нейротоксин, который вводит субъекта в состояние, подобное смерти."
	color = "#2E2E61" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "онемение"
	metabolization_rate = 1 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/neurotoxin/proc/pick_paralyzed_limb()
	return (pick(TRAIT_PARALYSIS_L_ARM,TRAIT_PARALYSIS_R_ARM,TRAIT_PARALYSIS_R_LEG,TRAIT_PARALYSIS_L_LEG))

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_drugginess(100 SECONDS * REM * seconds_per_tick)
	drinker.adjust_dizzy(4 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	need_mob_update = drinker.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * seconds_per_tick, 150, required_organ_flag = affected_organ_flags)
	if(SPT_PROB(10, seconds_per_tick))
		need_mob_update += drinker.adjustStaminaLoss(10 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		drinker.drop_all_held_items()
		to_chat(drinker, span_notice("Не чувствую руки!"))
	if(current_cycle > 6)
		if(SPT_PROB(10, seconds_per_tick))
			var/paralyzed_limb = pick_paralyzed_limb()
			ADD_TRAIT(drinker, paralyzed_limb, type)
			need_mob_update += drinker.adjustStaminaLoss(10 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(current_cycle > 31)
			need_mob_update += drinker.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
			if(current_cycle > 51 && SPT_PROB(7.5, seconds_per_tick))
				if(!drinker.undergoing_cardiac_arrest() && drinker.can_heartattack())
					drinker.set_heartattack(TRUE)
					if(drinker.stat == CONSCIOUS)
						drinker.visible_message(span_userdanger("[drinker]хватается за [drinker.ru_ego()] грудь, будто [drinker.ru_ego()] сердце остановилось!"))
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_L_ARM, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_R_ARM, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_R_LEG, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_L_LEG, type)
	drinker.adjustStaminaLoss(10, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/hippies_delight
	enname = "Hippie's Delight"
	name = "Услада Хиппи"
	description = "Ты просто не догоняешь, чуваааак."
	color = "#b16e8b" // rgb: 177,110,139
	nutriment_factor = 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "дать миру шанс"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hippies_delight/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.set_slurring_if_lower(1 SECONDS * REM * seconds_per_tick)

	switch(current_cycle)
		if(2 to 6)
			drinker.set_dizzy_if_lower(20 SECONDS * REM * seconds_per_tick)
			drinker.set_drugginess(1 MINUTES * REM * seconds_per_tick)
			if(SPT_PROB(5, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if(6 to 11)
			drinker.set_jitter_if_lower(40 SECONDS * REM * seconds_per_tick)
			drinker.set_dizzy_if_lower(40 SECONDS * REM * seconds_per_tick)
			drinker.set_drugginess(1.5 MINUTES * REM * seconds_per_tick)
			if(SPT_PROB(10, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if (11 to 201)
			drinker.set_jitter_if_lower(80 SECONDS * REM * seconds_per_tick)
			drinker.set_dizzy_if_lower(80 SECONDS * REM * seconds_per_tick)
			drinker.set_drugginess(2 MINUTES * REM * seconds_per_tick)
			if(SPT_PROB(16, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if(201 to INFINITY)
			drinker.set_jitter_if_lower(120 SECONDS * REM * seconds_per_tick)
			drinker.set_dizzy_if_lower(120 SECONDS * REM * seconds_per_tick)
			drinker.set_drugginess(2.5 MINUTES * REM * seconds_per_tick)
			if(SPT_PROB(23, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
			if(SPT_PROB(16, seconds_per_tick))
				if(drinker.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
					return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/eggnog
	enname = "Eggnog"
	name = "Гоголь-Моголь"
	description = "Для наслаждения самым замечательным временем года."
	color = "#fcfdc6" // rgb: 252, 253, 198
	nutriment_factor = 2
	boozepwr = 1
	quality = DRINK_VERYGOOD
	taste_description = "заварной крем и алкоголь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/dreadnog
	enname = "Dreadnog"
	name = "Страх-Моголь"
	description = "Для страдания во время радости."
	color = "#abb862" // rgb: 252, 253, 198
	nutriment_factor = 3 * REAGENTS_METABOLISM
	boozepwr = 1
	quality = DRINK_REVOLTING
	taste_description = "custard and alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/narsour
	enname = "Nar'Sour"
	name = "Нар'Кис"
	description = "Побочные эффекты включают самобичевание и накопительство пластали."
	color = RUNE_COLOR_DARKRED
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "кровь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/narsour/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_timed_status_effect(6 SECONDS * REM * seconds_per_tick, /datum/status_effect/speech/slurring/cult, max_duration = 6 SECONDS)
	drinker.adjust_stutter_up_to(6 SECONDS * REM * seconds_per_tick, 6 SECONDS)

/datum/reagent/consumable/ethanol/triple_sec
	enname = "Triple Sec"
	name = "Трипл Сек"
	description = "Сладкий и яркий на вкус апельсиновый ликер."
	color = "#ffcc66"
	boozepwr = 30
	taste_description = "теплый цветочный апельсиновый вкус, напоминающий воздушный океан и летний карибский ветер"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_menthe
	enname = "Creme de Menthe"
	name = "Мятный ликер"
	description = "Мятный ликер отлично подходит для освежающих, прохладных напитков."
	color = "#00cc00"
	boozepwr = 20
	taste_description = "мятный, прохладный и бодрящий всплеск холодной воды"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_cacao
	enname = "Creme de Cacao"
	name = "Шоколадный ликер"
	description = "Шоколадный ликер отлично подходит для придания десертных нот напиткам и подкупа женских обществ."
	color = "#996633"
	boozepwr = 20
	taste_description = "гладкий и ароматный намек конфет, кружащихся в укусе алкоголя"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_coconut
	enname = "Creme de Coconut"
	name = "Кокосовый ликер"
	description = "Кокосовый ликер для мягких, сливочных, тропических напитков."
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "a sweet milky flavor with notes of toasted sugar"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec
	enname = "Quadruple Sec"
	name = "Квадрипл Сек"
	description = "Прекрасен, как облизывание батарейки станбатона."
	color = "#cc0000"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "бодрящая горькая свежесть, которая наполняет ваше существо; ни один враг станции не останется незамеченным в этот день"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/quintuple_sec
	enname = "Quintuple Sec"
	name = "Квантипл Сек"
	description = "Закон, порядок, алкоголь и полицейское "
	color = "#ff3300"
	boozepwr = 55
	quality = DRINK_FANTASTIC
	taste_description = "ЗАКОН"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quintuple_sec/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes but STRONG..
	var/obj/item/organ/internal/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		var/need_mob_update
		need_mob_update = drinker.heal_bodypart_damage(2 * REM * seconds_per_tick, 2 * REM *  seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjustStaminaLoss(-2 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/grasshopper
	enname = "Grasshopper"
	name = "Кузнечик"
	description = "Свежий и сладкий десертный шутер. Трудно выглядеть мужественным, когда пьешь это."
	color = "#00ff00"
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "шоколад и мята"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/stinger
	enname = "Stinger"
	name = "Стингер"
	description = "Отличный способ закончить день."
	color = "#ccff99"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "пощечина в лучшем виде"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bastion_bourbon
	enname = "Bastion Bourbon"
	name = "Бурбон «Бастион»"
	description = "Успокаивающий горячий травяной напиток с восстанавливающими свойствами."
	color = "#00FFFF"
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "горячий травяной напиток с фруктовым оттенком"
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_metabolize(mob/living/drinker)
	. = ..()
	var/heal_points = 10
	if(drinker.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = drinker.adjustBruteLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjustFireLoss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjustToxLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += drinker.adjustOxyLoss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += drinker.adjustStaminaLoss(-heal_amt, updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		drinker.updatehealth()
	drinker.visible_message(span_warning("[drinker] дрожит с новой силой!") , span_notice("Вкус [lowertext(name)] наполняет меня энергией!"))
	if(!drinker.stat && heal_points == 20) //brought us out of softcrit
		drinker.visible_message(span_danger("[drinker] накренилась в сторону [drinker.ru_ego()] ноги!") , span_boldnotice("Проснись и пой, малыш."))

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_life(mob/living/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.health > 0)
		var/need_mob_update
		need_mob_update = drinker.adjustBruteLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjustFireLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjustToxLoss(-0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjustOxyLoss(-3 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjustStaminaLoss(-5 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/squirt_cider
	enname = "Squirt Cider"
	name = "Сидровый сквирт"
	description = "Забродивший экстракт сквирта с ароматом черствого хлеба и океанской воды. Что бы это ни было."
	color = "#FF0000"
	boozepwr = 40
	taste_description = "черствый хлеб с послевкусием послевкусия"
	nutriment_factor = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/squirt_cider/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.satiety += 5 * REM * seconds_per_tick //for context, vitamins give 15 satiety per second

/datum/reagent/consumable/ethanol/fringe_weaver
	enname = "Fringe Weaver"
	name = "Бон Развязон"
	description = "Пузырчатый, стильный и, несомненно, сильный - классика Глитч Сити."
	special_sound = 'white/valtos/sound/drink/va-lchalla.ogg'
	color = "#FFEAC4"
	boozepwr = 90 //classy hooch, essentially, but lower pwr to make up for slightly easier access
	quality = DRINK_GOOD
	taste_description = "этиловый спирт с оттенком сахара"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush
	enname = "Sugar Rush"
	name = "Сладкий форсаж"
	description = "Сладкий, легкий и фруктовый - девчачий."
	special_sound = 'white/valtos/sound/drink/va-lchalla.ogg'
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "ваши артерии засоряются сахаром"
	nutriment_factor = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.satiety -= 10 * REM * seconds_per_tick //junky as hell! a whole glass will keep you from being able to eat junk food

/datum/reagent/consumable/ethanol/crevice_spike
	enname = "Crevice Spike"
	name = "Спазм Кишок"
	description = "Кислый, горький и отлично отрезвляющий."
	special_sound = 'white/valtos/sound/drink/va-lchalla.ogg'
	color = "#5BD231"
	boozepwr = -10 //sobers you up - ideally, one would drink to get hit with brute damage now to avoid alcohol problems later
	quality = DRINK_VERYGOOD
	taste_description = "горький спайк с кислым послевкусием"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/crevice_spike/on_mob_metabolize(mob/living/drinker) //damage only applies when drink first enters system and won't again until drink metabolizes out
	. = ..()
	drinker.adjustBruteLoss(3 * min(5,volume), required_bodytype = affected_bodytype) //minimum 3 brute damage on ingestion to limit non-drink means of injury - a full 5 unit gulp of the drink trucks you for the full 15

/datum/reagent/consumable/ethanol/sake
	enname = "Sake"
	name = "Сакэ"
	description = "Сладкое рисовое вино сомнительной легальности и чрезвычайно сильного действия."
	color = "#DDDDDD"
	boozepwr = 70
	taste_description = "сладкое рисовое вино"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/peppermint_patty
	enname = "Peppermint Patty"
	name = "Мятная Пэтти"
	description = "Этот слабоалкогольный напиток сочетает в себе полезные свойства ментола и какао."
	color = "#45ca7a"
	taste_description = "мята и шоколад"
	boozepwr = 25
	quality = DRINK_GOOD
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/peppermint_patty/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/throat_soothed)
	drinker.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, drinker.get_body_temp_normal())

/datum/reagent/consumable/ethanol/alexander
	enname = "Alexander"
	name = "Александр"
	description = "Названная в честь греческого героя, эта смесь, как говорят, укрепляет щит пользователя, как будто он находится в фаланге."
	special_sound = 'white/valtos/sound/drink/alexander.ogg'
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горький, сливочный какао"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/obj/item/shield/mighty_shield

/datum/reagent/consumable/ethanol/alexander/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/the_human = drinker
		for(var/obj/item/shield/the_shield in the_human.contents)
			mighty_shield = the_shield
			mighty_shield.block_chance += 10
			to_chat(the_human, span_notice("[the_shield] выглядит отполированным, хотя, я, кажется, его не полировал."))

/datum/reagent/consumable/ethanol/alexander/on_mob_life(mob/living/drinker, seconds_per_tick, times_fired)
	if(mighty_shield && !(mighty_shield in drinker.contents)) //If you had a shield and lose it, you lose the reagent as well. Otherwise this is just a normal drink.
		holder.remove_reagent(type, volume)
	return ..()

/datum/reagent/consumable/ethanol/alexander/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	if(mighty_shield)
		mighty_shield.block_chance -= 10
		to_chat(drinker ,span_notice("Заметчаю, что [mighty_shield] снова выглядит потрепанным. Странно."))

/datum/reagent/consumable/ethanol/amaretto_alexander
	enname = "Amaretto Alexander"
	name = "Александр Амаретто"
	description = "Более слабая версия Александра, но то, чего ей не хватает в силе, она восполняет во вкусе."
	color = "#DBD5AE"
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "сладкое, сливочное какао"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sidecar
	enname = "Sidecar"
	name = "Сайдкар"
	description = "Единственная поездка, ради которой вы с радостью отдадите руль."
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "свобода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets
	enname = "Between the Sheets"
	name = "Между Простынями"
	description = "Классика с провокационным названием. Забавно, но врачи рекомендуют пить его перед сном."
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "обольщение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets/on_mob_life(mob/living/drinker, seconds_per_tick, times_fired)
	. = ..()
	var/is_between_the_sheets = FALSE
	for(var/obj/item/bedsheet/bedsheet in range(drinker.loc, 0))
		if(bedsheet.loc != drinker.loc) // bedsheets in your backpack/neck don't count
			continue
		is_between_the_sheets = TRUE
		break

	if(!drinker.IsSleeping() || !is_between_the_sheets)
		return

	var/need_mob_update
	if(drinker.getBruteLoss() && drinker.getFireLoss()) //If you are damaged by both types, slightly increased healing but it only heals one. The more the merrier wink wink.
		if(prob(50))
			need_mob_update = drinker.adjustBruteLoss(-0.25 * REM * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
		else
			need_mob_update = drinker.adjustFireLoss(-0.25 * REM * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
	else if(drinker.getBruteLoss()) //If you have only one, it still heals but not as well.
		need_mob_update = drinker.adjustBruteLoss(-0.2 * REM * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
	else if(drinker.getFireLoss())
		need_mob_update = drinker.adjustFireLoss(-0.2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/kamikaze
	enname = "Kamikaze"
	name = "Камикадзе"
	description = "Божественный ветер."
	color = "#EEF191"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "божественная ветренность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mojito
	enname = "Mojito"
	name = "Мохито"
	description = "Один только вид этого напитка освежает вас."
	color = "#DFFAD9"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "освежающая мята"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/moscow_mule
	enname = "Moscow Mule"
	name = "Московский Мул"
	description = "Прохладительный напиток, напоминающий вам о Дереликте."
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing spiciness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet
	enname = "Fernet"
	name = "Фернет"
	description = "Невероятно горький травяной ликер, используемый в качестве дижестива."
	color = "#1B2E24" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "полная горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.nutrition <= NUTRITION_LEVEL_STARVING)
		if(drinker.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	drinker.adjust_nutrition(-5 * REM * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fernet_cola
	enname = "Fernet Cola"
	name = "Фернет с Колой"
	description = "Очень популярный и горько-сладкий дижестив. Идеально подавать после плотного обеда."
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "сладкое облегчение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.nutrition <= NUTRITION_LEVEL_STARVING)
		if(drinker.adjustToxLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	drinker.adjust_nutrition(-3 * REM * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fanciulli
	enname = "Fanciulli"
	name = "Фанциулли"
	description = "Что если бы в коктейле \"Манхэттен\" ДЕЙСТВИТЕЛЬНО использовался ликер из горьких трав? Помогает протрезветь." //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "сладкая отрезвляющая смесь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/fanciulli/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_nutrition(-5 * REM * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fanciulli/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(drinker.health > 0)
		drinker.adjustStaminaLoss(20, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/branca_menta
	enname = "Branca Menta"
	name = "Бранка Мента"
	description = "Освежающая смесь горького Фернета с мятным кремовым ликером."
	color = "#4B5746" // rgb: 75, 87, 70
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "горькая свежесть"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/branca_menta/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_bodytemperature(-20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, T0C)

/datum/reagent/consumable/ethanol/branca_menta/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(drinker.health > 0)
		drinker.adjustStaminaLoss(35, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/blank_paper
	enname = "Blank Paper"
	name = "Чистый Лист"
	description = "Бокал пузырящейся белой жидкости. При одном взгляде на него вы почувствуете свежесть."
	nutriment_factor = 1
	color = "#DCDCDC" // rgb: 220, 220, 220
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "возможность пузырения"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/blank_paper/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/fruit_wine
	enname = "Fruit Wine"
	name = "Фруктовое Вино"
	description = "A wine made from grown plants."
	color = "#FFFFFF"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "плохой код"
	var/list/names = list("null fruit" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("bad coding" = 1) //List of tastes. See above.
	ph = 4

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	if(!data)
		return

	src.data = data
	names = data["names"]
	tastes = data["tastes"]
	boozepwr = data["boozepwr"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/data, amount)
	..()
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	boozepwr *= oldvolume
	var/newzepwr = data["boozepwr"] * amount
	boozepwr += newzepwr
	boozepwr /= volume //Blending boozepwr to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	// BYOND's compiler fails to catch non-consts in a ranged switch case, and it causes incorrect behavior. So this needs to explicitly be a constant.
	var/const/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	for(var/taste in tastes)
		switch(tastes[taste])
			if(minimum_percent*2 to INFINITY)
				primary_tastes += taste
			if(minimum_percent to minimum_percent*2)
				secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "вино"
	else
		name = "вино, смешанное из [names_in_order[1]]"

	var/alcohol_description
	switch(boozepwr)
		if(120 to INFINITY)
			alcohol_description = "убийственно крепкий"
		if(90 to 120)
			alcohol_description = "очень крепкий"
		if(70 to 90)
			alcohol_description = "крепкий"
		if(40 to 70)
			alcohol_description = "дорогой"
		if(20 to 40)
			alcohol_description = "заплесневелый"
		if(0 to 20)
			alcohol_description = "сладкий"
		else
			alcohol_description = "водянистый" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "другие фрукты"
	var/fruit_list = english_list(fruits)
	description = "[alcohol_description] алкоголь из [fruit_list]."

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] алкоголь")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ",с ноткой "
		flavor += english_list(secondary_tastes)
	taste_description = flavor

/datum/reagent/consumable/ethanol/champagne //How the hell did we not have champagne already!?
	enname = "Champagne"
	name = "Шампанское"
	description = "Игристое вино, известное своей способностью наносить быстрые и сильные удары по вашей печени."
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "благоприятные случаи и плохие решения"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/wizz_fizz
	enname = "Wizz Fizz"
	name = "Виз Физ"
	description = "Волшебное зелье, шипучее и дикое! Однако вкус, как вы заметите, довольно мягкий."
	color = "#4235d0" //Just pretend that the triple-sec was blue curacao.
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "дружба! Ведь это магия"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wizz_fizz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	//A healing drink similar to Quadruple Sec, Ling Stings, and Screwdrivers for the Wizznerds; the check is consistent with the changeling sting
	if(drinker?.mind?.has_antag_datum(/datum/antagonist/wizard))
		var/need_mob_update
		need_mob_update = drinker.heal_bodypart_damage(1 * REM * seconds_per_tick, 1 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustOxyLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjustStaminaLoss(-1  * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/bug_spray
	enname = "Bug Spray"
	name = "Спрей от Насекомых"
	description = "Резкий, едкий, горький напиток, для тех, кому нужно что-то для укрепления сил."
	color = "#33ff33"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "боль десяти тысяч убитых комаров"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	affected_biotype = MOB_BUG

/datum/reagent/consumable/ethanol/bug_spray/on_new(data)
	. = ..()
	AddElement(/datum/element/bugkiller_reagent)

/datum/reagent/consumable/ethanol/bug_spray/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	// Does some damage to bug biotypes
	if(drinker.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		. = UPDATE_MOB_HEALTH
		// Random chance of causing a screm if we did some damage
		if(SPT_PROB(2, seconds_per_tick))
			drinker.emote("scream")

/datum/reagent/consumable/ethanol/applejack
	enname = "Applejack"
	name = "Эплджек"
	description = "Идеальный напиток для тех случаев, когда вы хотите побузить."
	color = "#ff6633"
	boozepwr = 20
	taste_description = "честный день работы в саду"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/jack_rose
	enname = "Jack Rose"
	name = "Джек Роуз"
	description = "Легкий коктейль, который идеально подходит для потягивания с кусочком пирога."
	color = "#ff6633"
	boozepwr = 15
	quality = DRINK_NICE
	taste_description = "кисло-сладкий кусочек яблока"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo
	enname = "Turbo"
	name = "Турбо"
	description = "Бурный коктейль, связянный с незаконными гонками на ховербайках. Не для слабонервных."
	color = "#e94c3a"
	boozepwr = 85
	quality = DRINK_VERYGOOD
	taste_description = "дух вне закона"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(2, seconds_per_tick))
		to_chat(drinker, span_notice("[pick("You feel disregard for the rule of law.", "You feel pumped!", "Your head is pounding.", "Your thoughts are racing..")]"))
	if(drinker.adjustStaminaLoss(-0.25 * drinker.get_drunk_amount() * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/old_timer
	enname = "Old Timer"
	name = "Старый таймер"
	description = "Архаичный напиток, которым наслаждаются старики всех возрастов."
	color = "#996835"
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "более простые времена"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/old_timer/on_mob_life(mob/living/carbon/human/metabolizer, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick) && istype(metabolizer))
		metabolizer.age += 1
		if(metabolizer.age > 70)
			metabolizer.set_facial_haircolor("#cccccc", update = FALSE)
			metabolizer.set_haircolor("#cccccc", update = TRUE)
			if(metabolizer.age > 100)
				metabolizer.become_nearsighted(type)
				if(metabolizer.gender == MALE)
					metabolizer.set_facial_hairstyle("Beard (Very Long)", update = TRUE)

				if(metabolizer.age > 969) //Best not let people get older than this or i might incur G-ds wrath
					metabolizer.visible_message(span_notice("[metabolizer] становится старше чем кто либо.. и рассыпается прахом!"))
					metabolizer.dust(just_ash = FALSE, drop_items = TRUE, force = FALSE)

/datum/reagent/consumable/ethanol/rubberneck
	enname = "Rubberneck"
	name = "Зевака"
	description = "Качественный коктейль \"Зевака\" не должен содержать натуральных ингредиентов."
	color = "#ffe65b"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "искусственная фруктовость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rubberneck/on_mob_metabolize(mob/living/drinker)
	. = ..()
	ADD_TRAIT(drinker, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/ethanol/rubberneck/on_mob_end_metabolize(mob/living/drinker)
	REMOVE_TRAIT(drinker, TRAIT_SHOCKIMMUNE, type)
	return ..()

/datum/reagent/consumable/ethanol/duplex
	enname = "Duplex"
	name = "Дуплекс"
	description = "Неразрывное сочетание двух фруктовых напитков."
	color = "#50e5cf"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "зелёные яблоки и голубая малина"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist
	enname = "Trappist Beer"
	name = "Траппистское пиво"
	description = "Крепкий темный эль, предпочитаемый космическими монахами."
	color = "#390c00"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "сушеные сливы и солод"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.mind?.holy_role)
		if(drinker.adjustFireLoss(-2.5 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
			. = UPDATE_MOB_HEALTH
		drinker.adjust_jitter(-2 SECONDS * REM * seconds_per_tick)
		drinker.adjust_stutter(-2 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/blazaam
	enname = "Blazaam"
	name = "Блазаам"
	description = "Странный напиток, о существовании которого мало кто помнит."
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "альтернативные реалии"
	var/stored_teleports = 0

/datum/reagent/consumable/ethanol/blazaam/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.get_drunk_amount() > 40)
		if(stored_teleports)
			do_teleport(drinker, get_turf(drinker), rand(1,3), channel = TELEPORT_CHANNEL_WORMHOLE)
			stored_teleports--

		if(SPT_PROB(5, seconds_per_tick))
			stored_teleports += rand(2, 6)
			if(prob(70))
				drinker.vomit(vomit_flags = VOMIT_CATEGORY_DEFAULT, vomit_type = /obj/effect/decal/cleanable/vomit/purple)

/datum/reagent/consumable/ethanol/planet_cracker
	enname = "Planet Cracker"
	name = "Планетарный потрошитель"
	description = "Этот ликующий напиток празднует победу человечества над инопланетной угрозой. Может быть оскорбительным для нечеловеческих членов экипажа."
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "торжество с оттенком горечи"

/datum/reagent/consumable/ethanol/mauna_loa
	enname = "Mauna Loa"
	name = "Мауна-Лоа"
	description = "Чрезвычайно горячий. Не для слабонервных!"
	boozepwr = 40
	color = "#fe8308" // 254, 131, 8
	quality = DRINK_FANTASTIC
	taste_description = "огонь. Послевкусие сгоревшей плоти"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mauna_loa/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	// Heats the user up while the reagent is in the body. Occasionally makes you burst into flames.
	drinker.adjust_bodytemperature(25 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick)
	if (SPT_PROB(2.5, seconds_per_tick))
		drinker.adjust_fire_stacks(1 * REM * seconds_per_tick)
		drinker.ignite_mob()

/datum/reagent/consumable/ethanol/painkiller
	enname = "Painkiller"
	name = "Обезбол"
	description = "Притупляет вашу боль. Вашу эмоциональную боль, то есть."
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "сладкая терпкость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pina_colada
	enname = "Pina Colada"
	name = "Пина Колада"
	description = "Напиток из свежего ананаса с кокосовым ромом. Очень вкусно."
	special_sound = 'white/valtos/sound/drink/pina_colada.ogg'
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "ананас, кокос и океан"

/datum/reagent/consumable/ethanol/pina_olivada
	enname = "Piña Olivada"
	name = "Пинья Оливада"
	description = "Странное сочетание ананаса и оливкового масла."
	special_sound = 'white/valtos/sound/drink/pina_colada.ogg'
	boozepwr = 20 // the oil coats your gastrointestinal tract, meaning you can't absorb as much alcohol. horrifying
	color = "#493c00"
	quality = DRINK_NICE
	taste_description = "a horrible emulsion of pineapple and olive oil"

/datum/reagent/consumable/ethanol/pina_olivada/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(8, seconds_per_tick))
		drinker.manual_emote(pick("coughs up some oil", "swallows the lump in [drinker.p_their()] throat", "gags", "chokes up a bit"))
	if(SPT_PROB(3, seconds_per_tick))
		var/static/list/messages = list(
			"A horrible aftertaste coats your mouth.",
			"You feel like you're going to choke on the oil in your throat.",
			"You start to feel some heartburn coming on.",
			"You want to throw up, but you know that nothing can come out due to the clog in your esophagus.",
			"Your throat feels horrible.",
		)
		to_chat(drinker, span_notice(pick(messages)))

/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	enname = "Pruno"
	name = "Пруно"
	color = "#E78108"
	description = "Перебродившее тюремное вино, сделанное из фруктов, сахара и отчаяния. Служба безопасности любит его конфисковывать, и это единственное доброе дело, которое она когда-либо делала."
	boozepwr = 85
	taste_description = "будто мои вкусовые были рецепторы отшлифованы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.adjust_disgust(5 * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/ginger_amaretto
	enname = "Ginger Amaretto"
	name = "Джинджер Амаретто"
	description = "Восхитительно простой коктейль, вкус которого вас порадует."
	boozepwr = 30
	color = "#EFB42A"
	quality = DRINK_GOOD
	taste_description = "сладость, за которой следует мягкая кислинка и теплота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/godfather
	enname = "Godfather"
	name = "Крестный Отец"
	description = "Коктейль, который вам не стоит пить, если вы не хотите, чтобы вас нашли."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "восхитительный пунш"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/godmother
	enname = "Godmother"
	name = "Крестная Мать"
	description = "Твист на классике, который больше нравится зрелым женщинам."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "сладость и пикантность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kortara
	enname = "Kortara"
	name = "Кортара"
	description = "A sweet, milky nut-based drink enjoyed on Tizira. Frequently mixed with fruit juices and cocoa for extra refreshment."
	boozepwr = 25
	color = "#EEC39A"
	quality = DRINK_GOOD
	taste_description = "сладкий нектар"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kortara/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(drinker.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/sea_breeze
	enname = "Sea Breeze"
	name = "Морзкой бриз"
	description = "Light and refreshing with a mint and cocoa hit- like mint choc chip ice cream you can drink!"
	boozepwr = 15
	color = "#CFFFE5"
	quality = DRINK_VERYGOOD
	taste_description = "мятный шоколад"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sea_breeze/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/throat_soothed)

/datum/reagent/consumable/ethanol/white_tiziran
	enname = "White Tiziran"
	name = "Белый Тизиран"
	description = "Смесь водка и картары. Ящеры любят этот напиток."
	boozepwr = 65
	color = "#A68340"
	quality = DRINK_GOOD
	taste_description = "strikes and gutters"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/drunken_espatier
	enname = "Drunken Espatier"
	name = "Пьяный Эспатьер"
	description = "Look, if you had to get into a shootout in the cold vacuum of space, you'd want to be drunk too."
	boozepwr = 65
	color = "#A68340"
	quality = DRINK_GOOD
	taste_description = "солод"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.add_mood_event("numb", /datum/mood_event/narcotic_medium, name) //comfortably numb

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_metabolize(mob/living/drinker)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	drinker.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/consumable/ethanol/protein_blend
	enname = "Protein Blend"
	name = "Протеиновый коктейль"
	description = "A vile blend of protein, pure grain alcohol, korta flour, and blood. Useful for bulking up, if you can keep it down."
	boozepwr = 65
	color = "#FF5B69"
	quality = DRINK_NICE
	taste_description = "сожаления"
	nutriment_factor = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/protein_blend/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. =	..()
	drinker.adjust_nutrition(2 * REM * seconds_per_tick)
	if(!islizard(drinker))
		drinker.adjust_disgust(5 * REM * seconds_per_tick)
	else
		drinker.adjust_disgust(2 * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/mushi_kombucha
	enname = "Mushi Kombucha"
	name = "Муши Комбуча"
	description = "A popular summer beverage on Tizira, made from sweetened mushroom tea."
	boozepwr = 10
	color = "#C46400"
	quality = DRINK_VERYGOOD
	taste_description = "сладкие грибы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/triumphal_arch
	enname = "Triumphal Arch"
	name = "Триумфальная Арка"
	description = "A drink celebrating the Lizard Empire and its military victories. It's popular at bars on Unification Day."
	boozepwr = 60
	color = "#FFD700"
	quality = DRINK_FANTASTIC
	taste_description = "победа"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/triumphal_arch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(islizard(drinker))
		drinker.add_mood_event("triumph", /datum/mood_event/memories_of_home, name)

/datum/reagent/consumable/ethanol/the_juice
	enname = "The Juice"
	name = "Сок"
	description = "Woah man, this like, feels familiar to you dude."
	color = "#4c14be"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "как будущее"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/datum/brain_trauma/special/bluespace_prophet/prophet_trauma

/datum/reagent/consumable/ethanol/the_juice/on_mob_metabolize(mob/living/carbon/drinker)
	. = ..()
	prophet_trauma = new()
	drinker.gain_trauma(prophet_trauma, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/consumable/ethanol/the_juice/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(prophet_trauma)
		QDEL_NULL(prophet_trauma)

//a jacked up absinthe that causes hallucinations to the game master controller basically, used in smuggling objectives
/datum/reagent/consumable/ethanol/ritual_wine
	enname = "Ritual Wine"
	name = "Ритуальное вино"
	description = "The dangerous, potent, alcoholic component of ritual wine."
	color = rgb(35, 231, 25)
	boozepwr = 90 //enjoy near death intoxication
	taste_mult = 6
	taste_description = "концентрированные травы"

/datum/reagent/consumable/ethanol/ritual_wine/on_mob_metabolize(mob/living/psychonaut)
	. = ..()
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.add_filter("ritual_wine", 1, list("type" = "wave", "size" = 1, "x" = 5, "y" = 0, "flags" = WAVE_SIDEWAYS))

/datum/reagent/consumable/ethanol/ritual_wine/on_mob_end_metabolize(mob/living/psychonaut)
	. = ..()
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("ritual_wine")

//Moth Drinks
/datum/reagent/consumable/ethanol/curacao
	enname = "Curaçao"
	name = "Кюрасао"
	description = "Изготовлен с добавлением апельсинов сорта лараха для придания аромата."
	special_sound = 'white/nocringe/sound/drink/curacao.ogg'
	boozepwr = 30
	color = "#1a5fa1"
	quality = DRINK_NICE
	taste_description = "синие апельсины"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/navy_rum //IN THE NAVY
	enname = "Navy Rum"
	name = "Ром ВМФ"
	description = "Ром - лучший напиток моряков."
	boozepwr = 90 //the finest sailors are often drunk
	color = "#d8e8f0"
	quality = DRINK_NICE
	taste_description = "жизнь на волнах"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bitters //why do they call them bitters, anyway? they're more spicy than anything else
	enname = "Andromeda Bitters"
	name = "Андромеда Биттерс"
	description = "Лучший друг бармена, часто используется для придания деликатной остроты любому напитку. Производится в Новом Тринидаде, отныне и навсегда."
	boozepwr = 70
	color = "#1c0000"
	quality = DRINK_NICE
	taste_description = "пряный алкоголь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/admiralty //navy rum, vermouth, fernet
	enname = "Admiralty"
	name = "Адмиралтейство"
	description = "Изысканный, горький напиток, приготовленный из флотского рома, вермута и фернета."
	boozepwr = 100
	color = "#1F0001"
	quality = DRINK_VERYGOOD
	taste_description = "надменное высокомерие"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_haul //Rum, Curacao, Sugar, dash of bitters, lengthened with soda water
	enname = "Long Haul"
	name = "Длинный путь"
	description = "Любимец пилотов грузовых кораблей и недобросовестных контрабандистов."
	boozepwr = 35
	color = "#003153"
	quality = DRINK_VERYGOOD
	taste_description = "дружба"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_john_silver //navy rum, bitters, lemonade
	enname = "Long John Silver"
	name = "Лонг Джон Сильвер"
	description = "Лонг дринк из флотского рома, горького и лимонада. Особенно популярен на борту мольского флота, так как не требует больших затрат на рационы и обладает богатым вкусом."
	boozepwr = 50
	color = "#c4b35c"
	quality = DRINK_VERYGOOD
	taste_description = "ром и специи"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tropical_storm //dark rum, pineapple juice, triple citrus, curacao
	enname = "Tropical Storm"
	name = "Тропический шторм"
	description = "Вкус Карибского моря в одном бокале."
	boozepwr = 40
	color = "#00bfa3"
	quality = DRINK_VERYGOOD
	taste_description = "тропики"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/dark_and_stormy //rum and ginger beer- simple and classic
	enname = "Dark and Stormy"
	name = "Дарк энд Сторми"
	description = "Классический напиток, прибывающий под гром аплодисментов." //thank you, thank you, I'll be here forever
	boozepwr = 50
	color = "#8c5046"
	quality = DRINK_GOOD
	taste_description = "имбирь и ром"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/salt_and_swell //navy rum, tochtause syrup, egg whites, dash of saline-glucose solution
	enname = "Salt and Swell"
	name = "Солт энд Свелл"
	description = "Бодрящая кислинка с интересным соленым вкусом."
	boozepwr = 60
	color = "#b4abd0"
	quality = DRINK_FANTASTIC
	taste_description = "соль и специи"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tiltaellen //yoghurt, salt, vinegar
	enname = "Tiltällen"
	name = "Тильталлен"
	description = "Слегка ферментированный йогуртовый напиток с добавлением соли и небольшого количества уксуса. Имеет выраженный кисловато-сырный вкус."
	boozepwr = 10
	color = "#F4EFE2"
	quality = DRINK_NICE
	taste_description = "Кислый сырный йогурт"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tich_toch
	enname = "Tich Toch"
	name = "Тич Точ"
	description = "Смесь тильталлена, сиропа \"Тохтаузе\" и водки. Не всем по вкусу."
	boozepwr = 75
	color = "#b4abd0"
	quality = DRINK_VERYGOOD
	taste_description = "острый кислый сырный йогурт"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/helianthus
	enname = "Helianthus"
	name = "Гелиантус"
	description = "A dark yet radiant mixture of absinthe and hallucinogens. The choice of all true artists."
	boozepwr = 75
	color = "#fba914"
	quality = DRINK_VERYGOOD
	taste_description = "golden memories"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/hal_amt = 4
	var/hal_cap = 24

/datum/reagent/consumable/ethanol/helianthus/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		drinker.adjust_hallucinations_up_to(4 SECONDS * REM * seconds_per_tick, 48 SECONDS)

/datum/reagent/consumable/ethanol/plumwine
	enname = "Plum wine"
	name = "Сливовое вино"
	description = "Plums turned into wine."
	color = "#8a0421"
	nutriment_factor = 1
	boozepwr = 20
	taste_description = "a poet's love and undoing"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/the_hat
	enname = "The Hat"
	name = "Шляпа"
	description = "A fancy drink, usually served in a man's hat."
	color = "#b90a5c"
	boozepwr = 80
	quality = DRINK_NICE
	taste_description = "something perfumy"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/gin_garden
	enname = "Gin Garden"
	name = "Джин Гарден"
	description = "Excellent cooling alcoholic drink with not so ordinary taste."
	boozepwr = 20
	color = "#6cd87a"
	quality = DRINK_VERYGOOD
	taste_description = "light gin with sweet ginger and cucumber"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/gin_garden/on_mob_life(mob/living/carbon/doll, seconds_per_tick, times_fired)
	. = ..()
	doll.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, doll.get_body_temp_normal())

/datum/reagent/consumable/ethanol/wine_voltaic
	enname = "Voltaic Yellow Wine"
	name = "Вольтайческое жёлтое вино"
	description = "Electrically charged wine. Recharges ethereals, but also nontoxic."
	boozepwr = 30
	color = "#FFAA00"
	taste_description = "static with a hint of sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wine_voltaic/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/internal/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 3)

/datum/reagent/consumable/ethanol/telepole
	enname = "Telepole"
	name = "Телепол"
	description = "A grounding rod in the form of a drink.  Recharges ethereals, and gives temporary shock resistance."
	boozepwr = 50
	color = "#b300ff"
	quality = DRINK_NICE
	taste_description = "the howling storm"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/telepole/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	ADD_TRAIT(affected_mob, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/ethanol/telepole/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/ethanol/telepole/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/internal/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 2)

/datum/reagent/consumable/ethanol/pod_tesla
	enname = "Pod Tesla"
	name = "Под Тесла"
	description = "Ride the lightning!  Recharges ethereals, suppresses phobias, and gives strong temporary shock resistance."
	boozepwr = 80
	color = "#00fbff"
	quality = DRINK_FANTASTIC
	taste_description = "victory, with a hint of insanity"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pod_tesla/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_traits(list(TRAIT_SHOCKIMMUNE,TRAIT_TESLA_SHOCKIMMUNE,TRAIT_FEARLESS), type)

/datum/reagent/consumable/ethanol/pod_tesla/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_traits(list(TRAIT_SHOCKIMMUNE,TRAIT_TESLA_SHOCKIMMUNE,TRAIT_FEARLESS), type)

/datum/reagent/consumable/ethanol/pod_tesla/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/internal/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 5)

// Welcome to the Blue Room Bar and Grill, home to Mars' finest cocktails
/datum/reagent/consumable/ethanol/rice_beer
	enname = "Rice Beer"
	name = "Рисовое пиво"
	description = "A light, rice-based lagered beer popular on Mars. Considered a hate crime against Bavarians under the Reinheitsgebot Act of 1516."
	boozepwr = 5
	color = "#664300"
	quality = DRINK_NICE
	taste_description = "mild carbonated malt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/shochu
	enname = "Shochu"
	name = "Сою"
	description = "Also known as soju or baijiu, this drink is made from fermented rice, much like sake, but at a generally higher proof making it more similar to a true spirit."
	boozepwr = 45
	color = "#DDDDDD"
	quality = DRINK_NICE
	taste_description = "stiff rice wine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/yuyake
	enname = "Yūyake"
	name = "Юяке"
	description = "A sweet melon liqueur from Japan. Considered a relic of the 1980s by most, it has some niche use in cocktail making, in part due to its bright red colour."
	boozepwr = 40
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "sweet melon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/coconut_rum
	enname = "Coconut Rum"
	name = "Кокосовый ром"
	description = "The distilled essence of the beach. Tastes like bleach-blonde hair and suncream."
	boozepwr = 21
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "coconut rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Mixed Martian Drinks
/datum/reagent/consumable/ethanol/yuyakita
	enname = "Yūyakita"
	name = "Юякита"
	description = "A hell unleashed upon the world by an unnamed patron."
	boozepwr = 40
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "death"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/saibasan
	enname = "Saibāsan"
	name = "Сайбасан"
	description = "A drink glorifying Cybersun's enduring business."
	boozepwr = 20
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "betrayal"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/banzai_ti
	enname = "Banzai-Tī"
	name = "Банзай-Ти"
	description = "A variation on the Long Island Iced Tea, made with yuyake for an alternative flavour that's hard to place."
	boozepwr = 40
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "an asian twist on the liquor cabinet"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sanraizusoda
	enname = "Sanraizusōda"
	name = "Санрайзусода"
	description = "It's a melon cream soda, except with alcohol- what's not to love? Well... possibly the hangovers."
	boozepwr = 6
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "creamy melon soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kumicho
	enname = "Kumichō"
	name = "Кумичо"
	description = "A new take on a classic cocktail, the Kumicho takes the Godfather formula and adds shochu for an Asian twist."
	boozepwr = 62
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "rice and rye"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/red_planet
	enname = "Red Planet"
	name = "Красная планета"
	description = "Made in celebration of the Martian Concession, the Red Planet is based on the classic El Presidente, and is as patriotic as it is bright crimson."
	boozepwr = 45
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "the spirit of freedom"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amaterasu
	enname = "Amaterasu"
	name = "Аматерасу"
	description = "Named for Amaterasu, the Shinto Goddess of the Sun, this cocktail embodies radiance- or something like that, anyway."
	boozepwr = 54 //1 part bitters is a lot
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "sweet nectar of the gods"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/nekomimosa
	enname = "Nekomimosa"
	name = "Некомимоза"
	description = "An overly sweet cocktail, made with melon liqueur, melon juice, and champagne (which contains no melon, unfortunately)."
	boozepwr = 17
	color = "#FF0C8D"
	quality = DRINK_NICE
	taste_description = "MELON"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sentai_quencha //melon soda, triple citrus, shochu, blue curacao
	enname = "Sentai Quencha"
	name = "Сентай Куенча"
	description = "Based on the galaxy-famous \"Kyūkyoku no Ninja Pawā Sentai\", the Sentai Quencha is a favourite at anime conventions and weeb bars."
	boozepwr = 28
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "ultimate ninja power"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bosozoku
	enname = "Bōsōzoku"
	name = "Боусозоку"
	description = "A simple summer drink from Mars, made from a 1:1 mix of rice beer and lemonade."
	boozepwr = 6
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "bittersweet lemon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/ersatzche
	enname = "Ersatzche"
	name = "Эрзацче"
	description = "Sweet, bitter, spicy- that's a great combination."
	boozepwr = 6
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "spicy pineapple beer"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/red_city_am
	enname = "Red City AM"
	name = "Ред Сити АМ"
	description = "A breakfast drink from New Osaka, for when you really need to get drunk at 9:30 in the morning in more socially acceptable manner than drinking bagwine on the bullet train. Not that you should drink this on the bullet train either."
	boozepwr = 5 //this thing is fucking disgusting and both less tasty and less alcoholic than a bloody mary. it is against god and nature
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "breakfast in a glass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kings_ransom
	enname = "King's Ransom"
	name = "Королевский Рэнсом"
	description = "A stiff, bitter drink with an odd name and odder recipe."
	boozepwr = 26
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "bitter raspberry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/four_bit
	enname = "Four Bit"
	name = "4 бита"
	description = "Половина байта."
	boozepwr = 26
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "cyberspace"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/white_hawaiian //coconut milk, coconut rum, coffee liqueur
	enname = "White Hawaiian"
	name = "Белый гаваец"
	description = "A take on the classic White Russian, subbing out the classics for some tropical flavours."
	boozepwr = 16
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "COCONUT"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/maui_sunrise //coconut rum, pineapple juice, yuyake, triple citrus, lemon-lime soda
	enname = "Maui Sunrise"
	name = "Мауи Санрайз"
	description = "Behind this drink's red facade lurks a sharp, complex flavour."
	boozepwr = 15
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "sunrise over the pacific"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/imperial_mai_tai //navy rum, rum, lime, triple sec, korta nectar
	enname = "Imperial Mai Tai"
	name = "Имперский Май Тай"
	description = "For when orgeat is in short supply, do as the spacers do- make do and mend."
	boozepwr = 52
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "spicy nutty rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/konococo_rumtini //todo: add espresso | coffee, coffee liqueur, coconut rum, sugar
	enname = "Konococo Rumtini"
	name = "Конококо Румтини"
	description = "Coconut rum, coffee liqueur, and espresso- an odd combination, to be sure, but a welcomed one."
	boozepwr = 20
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "coconut coffee"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/blue_hawaiian //pineapple juice, lemon juice, coconut rum, blue curacao
	enname = "Blue Hawaiian"
	name = "Синий гаваец"
	description = "Sweet, sharp and coconutty."
	boozepwr = 30
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "the aloha state"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

#undef ALCOHOL_EXPONENT
#undef ALCOHOL_THRESHOLD_MODIFIER
