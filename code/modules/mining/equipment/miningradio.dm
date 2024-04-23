/// Portable mining radio purchasable by miners
/obj/item/radio/weather_monitor
	icon = 'icons/obj/miningradio.dmi'
	name = "шахтёрское погодное радио"
	desc = "Погодное радио, разработанное для использования в негостеприимных условиях. Издает звуковые предупреждения, когда приближаются бури. Имеет доступ к каналу карго."
	icon_state = "miningradio"
	freqlock = RADIO_FREQENCY_LOCKED
	luminosity = 1
	light_power = 1
	light_range = 1.6

/obj/item/radio/weather_monitor/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "small_emissive", src, alpha = src.alpha)

/obj/item/radio/weather_monitor/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/weather_announcer, \
		state_normal = "weatherwarning", \
		state_warning = "urgentwarning", \
		state_danger = "direwarning", \
	)
	set_frequency(FREQ_SUPPLY)
