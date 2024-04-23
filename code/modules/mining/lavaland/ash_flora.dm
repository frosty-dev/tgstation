//*******************Contains everything related to the flora on lavaland.*******************************
//This includes: The structures, their produce, their seeds and the crafting recipe for the mushroom bowl

/obj/structure/flora/ash
	name = "огромные грибы"
	desc = "Несколько огромных грибов, покрытых слоем пепла и спор."
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	icon_state = "l_mushroom1"
	base_icon_state = "l_mushroom"
	resistance_flags = LAVA_PROOF
	gender = PLURAL
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER //sporangiums up don't shoot
	product_types = list(/obj/item/food/grown/ash_flora/shavings = 1)
	harvest_with_hands = TRUE
	harvested_name = "грибы"
	harvested_desc = "Несколько грибов, покрытых пеплом. Вы можете видеть, как они медленно растут."
	harvest_message_low = "Срываю гриб."
	harvest_message_med = "Срываю несколько грибов."
	harvest_message_high = "Срываю пару грибов."
	harvest_message_true_thresholds = TRUE
	harvest_verb = "срывать"
	flora_flags = FLORA_HERBAL //not really accurate but what sound do hit mushrooms make anyway

	var/number_of_variants = 4

/obj/structure/flora/ash/Initialize(mapload)
	. = ..()
	base_icon_state = "[base_icon_state][rand(1, number_of_variants)]"
	icon_state = base_icon_state

/obj/structure/flora/ash/harvest(user, product_amount_multiplier)
	if(!..())
		return FALSE
	icon_state = "[base_icon_state]p"
	return TRUE

/obj/structure/flora/ash/regrow()
	..()
	icon_state = base_icon_state

/obj/structure/flora/ash/tall_shroom //exists only so that the spawning check doesn't allow these spawning near other things
	regrowth_time_low = 4200

/obj/structure/flora/ash/leaf_shroom
	name = "листовые грибы"
	desc = "Несколько грибов, каждый из которых окружен зеленоватым спорангием с несколькими листоподобными структурами."
	icon_state = "s_mushroom1"
	base_icon_state = "s_mushroom"
	product_types = list(/obj/item/food/grown/ash_flora/mushroom_leaf = 1)
	harvested_name = "листовые грибы"
	harvested_desc = "Несколько грибов, каждый из которых окружен зеленоватым спорангием с несколькими листоподобными структурами."
	harvest_amount_high = 4
	harvest_message_low = "Срываю лист."
	harvest_message_med = "Срываю несколько листьев."
	harvest_message_high = "Срываю четыре листа."
	harvest_time = 20
	regrowth_time_low = 2400
	regrowth_time_high = 6000

/obj/structure/flora/ash/cap_shroom
	name = "высокие грибы"
	desc = "Несколько грибов, у больших из которых есть кольцо на середине ножек."
	icon_state = "r_mushroom1"
	base_icon_state = "r_mushroom"
	product_types = list(/obj/item/food/grown/ash_flora/mushroom_cap = 1)
	harvested_name = "маленькие грибы"
	harvested_desc = "Несколько маленьких грибов возле пеньков, которые, вероятно, были когда-то большими грибами."
	harvest_amount_high = 4
	harvest_message_low = "Срываю шляпку гриба."
	harvest_message_med = "Срываю несколько шляпок грибов."
	harvest_message_high = "Срываю четыре шляпки."
	harvest_time = 50
	regrowth_time_low = 3000
	regrowth_time_high = 5400

/obj/structure/flora/ash/stem_shroom
	name = "скопление грибов"
	desc = "Большое количество грибов, некоторые из которых имеют длинные мясистые ножки. Они светятся!"
	icon_state = "t_mushroom1"
	base_icon_state = "t_mushroom"
	light_range = 1.5
	light_power = 2.1
	product_types = list(/obj/item/food/grown/ash_flora/mushroom_stem = 1)
	harvested_name = "крошечные грибы"
	harvested_desc = "Несколько маленьких грибов. Уже видно, как они начинают расти."
	harvest_amount_high = 4
	harvest_message_low = "Собираю ножку гриба."
	harvest_message_med = "Срываю несколько ножек грибов."
	harvest_message_high = "Срываю четыре ножки."
	harvest_time = 40
	regrowth_time_low = 3000
	regrowth_time_high = 6000

/obj/structure/flora/ash/cacti
	name = "плодоносящие кактусы"
	desc = "Несколько колючих кактусов, полных спелых плодов и покрытых тонким слоем пепла."
	icon_state = "cactus1"
	base_icon_state = "cactus"
	product_types = list(/obj/item/food/grown/ash_flora/cactus_fruit = 20, /obj/item/seeds/lavaland/cactus = 1)
	harvested_name = "кактус"
	harvested_desc = "Несколько колючих кактусов. Видно, как плоды начинают расти под слоем пепла."
	harvest_amount_high = 2
	harvest_message_low = "Собираю плод кактуса."
	harvest_message_med = "Собираю несколько плодов кактуса." //shouldn't show up, because you can't get more than two
	harvest_message_high = "Собираю пару плодов кактуса."
	harvest_time = 10
	regrowth_time_low = 4800
	regrowth_time_high = 7200
	can_uproot = FALSE //Don't want 50 in one tile to decimate whoever dare step on the mass of cacti

/obj/structure/flora/ash/cacti/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 3, max_damage = 6, probability = 70)

/obj/structure/flora/ash/seraka
	name = "грибы серака"
	desc = "Несколько маленьких грибов серака. Должно быть, их принесли с собой пепельные ящеры."
	icon_state = "seraka_mushroom1"
	base_icon_state = "seraka_mushroom"
	product_types = list(/obj/item/food/grown/ash_flora/seraka = 1)
	harvested_name = "грибы серака"
	harvested_desc = "Несколько маленьких грибов серака. Больший из них, видимо, недавно сорван. Они снова вырастут... когда-нибудь."
	harvest_amount_high = 6
	harvest_message_low = "Срываю несколько вкусных грибов."
	harvest_message_med = "Срываю пригоршню грибов"
	harvest_message_high = "Срываю целую кучу вкусных грибов."
	harvest_time = 25
	regrowth_time_low = 3000
	regrowth_time_high = 5400
	number_of_variants = 2
	harvest_message_true_thresholds = FALSE

/obj/structure/flora/ash/fireblossom
	name = "огнецвет"
	desc = "Странный цветок, который часто растет рядом с лавой."
	icon_state = "fireblossom1"
	base_icon_state = "fireblossom"
	light_range = LIGHT_FIRE_BLOSSOM
	light_power = LIGHT_FIRE_BLOSSOM
	light_color = COLOR_BIOLUMINESCENCE_YELLOW
	product_types = list(/obj/item/food/grown/ash_flora/fireblossom = 1)
	harvested_name = "стебли огнецвета"
	harvested_desc = "Несколько стеблей огнецвета без цветков."
	harvest_amount_high = 3
	harvest_message_low = "Срываю один-единственный цветок."
	harvest_message_med = "Срываю несколько цветов."
	harvest_message_high = "Срываю целую кучу цветов."
	regrowth_time_low = 2500
	regrowth_time_high = 4000
	number_of_variants = 2

/obj/structure/flora/ash/fireblossom/after_harvest()
	set_light_power(LIGHT_RANGE_FIRE_BLOSSOM_HARVESTED)
	set_light_range(LIGHT_POWER_FIRE_BLOSSOM_HARVESTED)
	update_light()
	return ..()

/obj/structure/flora/ash/fireblossom/regrow()
	set_light_power(initial(light_power))
	set_light_range(initial(light_range))
	update_light()
	return ..()

///Snow flora to exist on icebox.
// only on icebox, so no translation (kinda didn't bother with the other flora either)
/obj/structure/flora/ash/chilly
	name = "springy grassy fruit"
	desc = "A number of bright, springy blue fruiting plants. They seem to be unconcerned with the hardy, cold environment."
	icon_state = "chilly_pepper1"
	base_icon_state = "chilly_pepper"
	product_types = list(/obj/item/food/grown/icepepper = 1)
	harvested_name = "springy grass"
	harvested_desc = "A bunch of springy, bouncy fruiting grass, all picked. Or maybe they were never fruiting at all?"
	harvest_amount_high = 3
	harvest_message_low = "You pluck a single, curved fruit."
	harvest_message_med = "You pluck a number of curved fruit."
	harvest_message_high = "You pluck quite a lot of curved fruit."
	harvest_time = 15
	regrowth_time_low = 2400
	regrowth_time_high = 5500
	number_of_variants = 2

//SNACKS

/obj/item/food/grown/ash_flora
	name = "грибная стружка"
	desc = "Немного стружек, оставшийся от грибных ножек. Можно перемолоть в муку."
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	icon_state = "mushroom_shavings"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 100
	seed = /obj/item/seeds/lavaland/polypore
	wine_power = 20

/obj/item/food/grown/ash_flora/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-4, 4)
	pixel_y = base_pixel_y + rand(-4, 4)

/obj/item/food/grown/ash_flora/shavings //So we can't craft bowls from everything.
	grind_results = list(/datum/reagent/toxin/mushroom_powder = 5)

/obj/item/food/grown/ash_flora/mushroom_leaf
	name = "грибной лист"
	desc = "Лист, сорванный с гриба."
	icon_state = "mushroom_leaf"
	seed = /obj/item/seeds/lavaland/porcini
	wine_power = 40

/obj/item/food/grown/ash_flora/mushroom_cap
	name = "грибная шляпка"
	desc = "Шляпка огромного гриба."
	icon_state = "mushroom_cap"
	seed = /obj/item/seeds/lavaland/inocybe
	wine_power = 70

/obj/item/food/grown/ash_flora/mushroom_stem
	name = "грибная ножка"
	desc = "Длинная грибная ножка. Слегка светится."
	icon_state = "mushroom_stem"
	seed = /obj/item/seeds/lavaland/ember
	wine_power = 60

/obj/item/food/grown/ash_flora/cactus_fruit
	name = "плод кактуса"
	desc = "Плод кактуса, покрытый толстой красной кожурой и пеплом."
	icon_state = "cactus_fruit"
	seed = /obj/item/seeds/lavaland/cactus
	wine_power = 50

/obj/item/food/grown/ash_flora/seraka
	name = "шляпка гриба серака"
	desc = "Маленький, глубоко ароматный гриб, изначально происходящий из Тизиры."
	icon_state = "seraka_cap"
	seed = /obj/item/seeds/lavaland/seraka
	wine_power = 40

/obj/item/food/grown/ash_flora/fireblossom
	name = "огнецвет"
	desc = "Цветок огнецвета."
	icon_state = "fireblossom"
	slot_flags = ITEM_SLOT_HEAD
	seed = /obj/item/seeds/lavaland/fireblossom
	wine_power = 40

//SEEDS

/obj/item/seeds/lavaland
	name = "lavaland seeds"
	desc = "You should never see this."
	lifespan = 50
	endurance = 25
	maturation = 7
	production = 4
	yield = 4
	potency = 15
	growthstages = 3
	rarity = 20
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)
	species = "polypore" // silence unit test
	genes = list(/datum/plant_gene/trait/fire_resistance)
	graft_gene = /datum/plant_gene/trait/fire_resistance

/obj/item/seeds/lavaland/cactus
	name = "упаковка семян плодоносящего кактуса"
	desc = "Эти семяна вырастут в плодоносящие кактусы."
	icon_state = "seed-cactus"
	species = "cactus"
	plantname = "Плодоносящий кактус"
	product = /obj/item/food/grown/ash_flora/cactus_fruit
	mutatelist = list(/obj/item/seeds/star_cactus)
	genes = list(/datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	growthstages = 2
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.04, /datum/reagent/consumable/vitfro = 0.08)

///Star Cactus seeds, mutation of lavaland cactus.
/obj/item/seeds/star_cactus
	// name = "pack of star cacti seeds"
	name = "упаковка семян звёздчатого кактуса"
	desc = "Из этих семян вырастет астрофитум звёздчатый."
	icon_state = "seed-starcactus"
	species = "starcactus"
	plantname = "Астрофитум звёздчатый"
	product = /obj/item/food/grown/star_cactus
	lifespan = 60
	endurance = 30
	maturation = 7
	production = 6
	yield = 3
	growthstages = 4
	genes = list(/datum/plant_gene/trait/sticky, /datum/plant_gene/trait/stinging)
	graft_gene = /datum/plant_gene/trait/sticky
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/water = 0.08, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/c2/helbital = 0.05)

///Star Cactus Plants.
/obj/item/food/grown/star_cactus
	seed = /obj/item/seeds/star_cactus
	name = "звёздчатый кактус"
	desc = "Скопление колючик звёздчатых кактусов. Нет, он называется так не из-за того, что мы находимся в космосе."
	icon_state = "starcactus"
	filling_color = "#1c801c"
	foodtypes = VEGETABLES
	distill_reagent = /datum/reagent/consumable/ethanol/tequila

/obj/item/seeds/lavaland/polypore
	name = "упаковка семян пористого мицелия"
	desc = "Из этого мицелия вырастают трутовики. Твердые древесные грибы, шахтёры часто используют их для различных поделок."
	icon_state = "mycelium-polypore"
	species = "polypore"
	plantname = "Трутовик"
	product = /obj/item/food/grown/ash_flora/shavings
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/sugar = 0.06, /datum/reagent/consumable/ethanol = 0.04, /datum/reagent/stabilizing_agent = 0.06, /datum/reagent/consumable/mintextract = 0.02)

/obj/item/seeds/lavaland/porcini
	name = "упаковка семян мицелия белого гриба"
	desc = "Из этого мицелия вырастает Boletus edulis, также известный как белый гриб. Произрастал на Земле, но был обнаружен на Лаваланде. Применяется в кулинарии, медицине и как средство для расслабления."
	icon_state = "mycelium-porcini"
	species = "porcini"
	plantname = "Белый гриб"
	product = /obj/item/food/grown/ash_flora/mushroom_leaf
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.06, /datum/reagent/consumable/vitfro = 0.04, /datum/reagent/drug/nicotine = 0.04)

/obj/item/seeds/lavaland/inocybe
	name = "упаковка семян мицелия волоконницы"
	desc = "Из этого мицелия вырастает гриб волоконница, вид грибов, происходящий с Лаваланда. Может использоваться в качестве галлюциногена и яда."
	icon_state = "mycelium-inocybe"
	species = "inocybe"
	plantname = "Inocybe Mushrooms"
	product = /obj/item/food/grown/ash_flora/mushroom_cap
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/toxin/mindbreaker = 0.04, /datum/reagent/consumable/entpoly = 0.08, /datum/reagent/drug/mushroomhallucinogen = 0.04)

/obj/item/seeds/lavaland/ember
	name = "упаковка семян мицелия пепельного гриба"
	desc = "Из этого мицелия вырастают пепельниые грибы, вид светящихся грибов, происходящий с Лаваланда."
	icon_state = "mycelium-ember"
	species = "ember"
	plantname = "Пепельные грибы"
	product = /obj/item/food/grown/ash_flora/mushroom_stem
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/glow, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/tinlux = 0.04, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/drug/space_drugs = 0.02)

/obj/item/seeds/lavaland/seraka
	name = "упаковка семян мицеля грибов серака"
	desc = "Из этого мицелия вырастают грибы серака, вид кисловатых грибов, изначально произраставших на Тизаре. Используется в кулинарии и традиционной медицине."
	icon_state = "mycelium-seraka"
	species = "seraka"
	plantname = "Грибы серака"
	product = /obj/item/food/grown/ash_flora/seraka
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/toxin/mushroom_powder = 0.1, /datum/reagent/medicine/coagulant/seraka_extract = 0.02)

/obj/item/seeds/lavaland/fireblossom
	name = "упаковка семян огнецвета"
	desc = "Из этих семян вырастает огнецвет"
	plantname = "Огнецвет"
	icon_state = "seed-fireblossom"
	species = "fireblossom"
	growthstages = 3
	product = /obj/item/food/grown/ash_flora/fireblossom
	genes = list(/datum/plant_gene/trait/fire_resistance, /datum/plant_gene/trait/glow/yellow)
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/tinlux = 0.04, /datum/reagent/consumable/nutriment = 0.03, /datum/reagent/carbon = 0.05)

//CRAFTING

/datum/crafting_recipe/mushroom_bowl
	name = "Грибная миска"
	result = /obj/item/reagent_containers/cup/bowl/mushroom_bowl
	reqs = list(/obj/item/food/grown/ash_flora/shavings = 5)
	time = 30
	category = CAT_CONTAINERS

/obj/item/reagent_containers/cup/bowl/mushroom_bowl
	name = "Грибная миска"
	desc = "Миска, сделанная из грибов. Не еда, хотя в какой-то момент она могла в ней быть."
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	icon_state = "mushroom_bowl"
	fill_icon_state = "fullbowl"
	fill_icon = 'icons/obj/mining_zones/ash_flora.dmi'

/obj/item/reagent_containers/cup/bowl/mushroom_bowl/update_icon_state()
	if(!reagents.total_volume)
		icon_state = "mushroom_bowl"
	return ..()
