/datum/job/bitrunner
	title = JOB_BITRUNNER
	description = "Путешествуйте по виртуальному домену в поисках снаряжения и добычи."
	department_head = list(JOB_QUARTERMASTER)
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_QM
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "BITRUNNER"
	outfit = /datum/outfit/job/bitrunner
	plasmaman_outfit = /datum/outfit/plasmaman/bitrunner
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_BITRUNNER
	bounty_types = CIV_JOB_RANDOM
	departments_list = list(
		/datum/job_department/cargo,
		)

	family_heirlooms = list(/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind)

	mail_goodies = list(
		/obj/item/food/cornchips = 1,
		/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind = 1,
		/obj/item/food/cornchips/green = 1,
		/obj/item/food/cornchips/red = 1,
		/obj/item/food/cornchips/purple = 1,
		/obj/item/food/cornchips/blue = 1,
	)
	rpg_title = "Recluse"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/bitrunner
	name = "Bitrunner"
	jobtype = /datum/job/bitrunner

	id_trim = /datum/id_trim/job/bitrunner
	uniform = /obj/item/clothing/under/rank/cargo/bitrunner
	belt = /obj/item/modular_computer/pda/bitrunner
	ears = /obj/item/radio/headset/headset_cargo
