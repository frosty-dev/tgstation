/obj/item/stack/sheet/hot_ice
	name = "горячий лёд"
	icon_state = "hot-ice"
	inhand_icon_state = "hot-ice"
	singular_name = "горячий лёд"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/hot_ice=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/hot_ice = 25)
	material_type = /datum/material/hot_ice
	merge_type = /obj/item/stack/sheet/hot_ice

/obj/item/stack/sheet/hot_ice/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins licking  [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return FIRELOSS//dont you kids know that stuff is toxic?
