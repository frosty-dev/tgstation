/datum/design/breathing_bag
	name = "Дыхательная груша"
	desc = "Она же мешок Амбу — механическое ручное устройство для выполнения искусственной вентиляции лёгких."
	id = "breathing_bag"
	build_path = /obj/item/breathing_bag
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000, /datum/material/plastic = 4000)
	category = list("Медицинское снаряжение")
	category = list(RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
