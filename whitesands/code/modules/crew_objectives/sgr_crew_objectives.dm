/obj/item/paper/paperwork
/obj/item/paper/paperwork/Initialize()
	. = ..()

/obj/item/paper/paperwork/sgr

/obj/item/paper/paperwork/sgr/Initialize()
	. = ..()
	info = replacetextEx(info, regex(@"\n(\s)*"), "")

/obj/item/paper/paperwork/sgr/proc/completed()
	return src.form_fields.len == 0 && src.stamped.len > 0

/obj/item/paper/paperwork/sgr/tax_form
	name = "SG IRS Form W2"
	info = {"
		<h1>SG IRS Form W-2</h1><br/>
		<h3>Used for resident employees (salaried by NT, citizen of SolGov)</h3><br/>
		<b>Employee Name:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Employee Job Title:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Employee Account Number:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Estimated Annual Income for Fiscal Year</b><br/>
		\[______________________________________________________________]<br/>
		<br/>
		<br/>
		<i>By signing this form I affirm that the following information is correct to the best
		of my knowledge and understand that willfully falsifying information herein constitutes
		a federal offense punishable by up to 10 years in the Federal Orbital Corrections System,
		or a fine of up to ¢10 Million Credits.<br/>
	"}

/obj/item/paper/paperwork/sgr/tax_form/form_1099
	name = "SG IRS Form 1099"
	info = {"
		<h1>SG IRS Form 1099</h1><br/>
		<h3>Used for IPCs or non-resident employees</h3><br/>
		<b>Employee Name:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Employee Job Title:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Employee Account Number:</b><br/>
		\[______________________________________________________________]<br/>
		<b>Itemized Annual Income for Fiscal Year:</b><br/>
		<i>Mark N/A on any fields you do not use</i><br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		\[______________________________________________________________]<br/>
		<br/>
		<br/>
		<i>By signing this form I affirm that the following information is correct to the best
		of my knowledge and understand that willfully falsifying information herein constitutes
		a federal offense punishable by up to 10 years in the Federal Orbital Corrections System,
		or a fine of up to ¢10 Million Credits.<br/>
	"}
/obj/item/paper/paperwork/sgr/census
	name = "SG Personnel Census Form"
	info = {"
		<h1>Personnel Census Form</h1><br/>
		<h2>Basic Information</h2><br/>
		<b>Name:</b><br/>
		\[________________________________________________________]<br/>
		<b>Species:</b><br/>
		\[________________________________________________________]<br/>
		<b>Age:</b><br/>
		\[________________________________________________________]<br/>
		<b>Gender:</b><br/>
		\[________________________________________________________]<br/>
		<b>Job Title:</b><br/>
		\[________________________________________________________]<br/>
		<b>Head of Staff:</b><br/>
		\[________________________________________________________]<br/>
		<b>Estimated Time in Position:</b><br/>
		\[________________________________________________________]<br/>
		<b>Addt'l Notes:</b><br/>
		<i>Fill Unused Fields with N/A</i><br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
	"}
/obj/item/paper/paperwork/sgr/census/diversity
	name = "SG Diversity Census Form"
	info = {"
		<h1>Diversity Census Form</h1><br/>
		<h2>Basic Information</h2><br/>
		<b>Name:</b><br/>
		\[________________________________________________________]<br/>
		<b>Species:</b><br/>
		\[________________________________________________________]<br/>
		<b>Age:</b><br/>
		\[________________________________________________________]<br/>
		<b>Gender:</b><br/>
		\[________________________________________________________]<br/>
		<b>Job Title:</b><br/>
		\[________________________________________________________]<br/>
		<b>Head of Staff:</b><br/>
		\[________________________________________________________]<br/>
		<h2>Diversity Questionnaire</h2>
		<b>Q1:</b> Do you have any concerns about the hiring practices of your department?<br/>
		\[______] (Yes/No)<br/>
		If Yes, list below. If No, mark as N/A<br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
		<b>Q2:</b> Which of the following do you feel best represents your crew's diversity?<br/>
		<i>Pick one of the following:<i/><br/>
		<b>A:</b> Our crews are quite diverse and no one species is over or under represented.<br/>
		<b>B:</b> Our crews are somewhat diverse, but there are a few species that are over/under represented.<br/>
		<b>C:</b> Our crews are not diverse, with one or two species dominating the roster.<br/>
		\[______] (A/B/C)<br/>
		<b>Q3:</b> In your day to day work, do you feel discrimination based on your species from peers or superiors?<br/>
		\[______] (Yes/No)<br/>
		If Yes, list below. If No, mark as N/A<br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
		\[________________________________________________________]<br/>
	"}
/obj/item/paper/paperwork/sgr/census/seniority
	name = "SG Seniority Census Form"
	info = {"
		<h1>Seniority Census Form</h1><br/>
		<h2>Basic Information</h2><br/>
		<b>Name:</b><br/>
		\[________________________________________________________]<br/>
		<b>Species:</b><br/>
		\[________________________________________________________]<br/>
		<b>Age:</b><br/>
		\[________________________________________________________]<br/>
		<b>Gender:</b><br/>
		\[________________________________________________________]<br/>
		<b>Job Title:</b><br/>
		\[________________________________________________________]<br/>
		<b>Head of Staff:</b><br/>
		\[________________________________________________________]<br/>
		<h2>Seniority Questionnaire</h2>
		<b>How long have you been in your current position</b><br/>
		\[________________________________________________________]<br/>
		<b>Would you rank your self as junior, average, or senior compared to your peers?</b><br/>
		\[________________________________________________________]<br/>
		<b>Has your superior discussed promotion requirements with you in the last 30 days?</b><br/>
		\[______] (Yes/No)<br/>
	"}
/obj/item/paper/paperwork/sgr/census/robustness
	name = "SG Robustness Survey"
	info = {"
		<h1>Robustness Census Form</h1><br/>
		<h2>Basic Information</h2><br/>
		<b>Name:</b><br/>
		\[________________________________________________________]<br/>
		<b>Species:</b><br/>
		\[________________________________________________________]<br/>
		<b>Age:</b><br/>
		\[________________________________________________________]<br/>
		<b>Gender:</b><br/>
		\[________________________________________________________]<br/>
		<b>Job Title:</b><br/>
		\[________________________________________________________]<br/>
		<b>Head of Staff:</b><br/>
		\[________________________________________________________]<br/>
		<h2>Robustness Questionnaire</h2>
		<b>One question: Are you Robust?</b><br/>
		\[______] (Yes/No)<br/>
	"}

/datum/sg_referendum_content

/datum/sg_referendum_content/New()
	. = ..()
	text = replacetextEx(text, regex(@"\n(\s)*"), "")

/datum/sg_referendum_content/taxation
	var/tax_range = list(10, 200)
	var/item
	var/tax
	var/list/recipients = list()
	var/subsidy
	var/departments = list(
		"Security", "Medical","Engineering","Cargo","Service","Science"
	)
	var/items = list(
		"Iron",
		"Glass",
		"Plasma",
		"Bluespace Crystals",
		"Uranium",
		"Titanium",
		"Miasma",
		"BZ Gas",
		"Organs",
		"Implants",
		"Bodyparts",
		"Empty Clones",
		"Firearms"
	)
	var/subsidies = list(
		"burial services",
		"banking services",
		"janitorial services",
		"water purification",
		"security retraining",
		"Ian revival"
	)
	var/valid_recipients = list(
		"Clowns",
		"Moth Planets",
		"Arachnid Nests",
		"Catgirl Reassignment Surgery",
		"Plasmaman Reparations",
		"Syndicate Appeasement Disbursements",
		"Donk Co.",
		"Cybersun",
		"Mr. Monstrous"
	)

/datum/sg_referendum_content/taxation/New()
	tax = rand(src.tax_range[0], src.tax_range[1])
	item = pick(src.items)
	subsidy = pick(src.subsidies)
	recipients.Insert(pick(valid_recipients))
	recipients.Insert(pick(valid_recipients))
	name = "Taxation on [src.item]"
	text = {"
		The [src.name] is a [src.tax]% tax on the purchase of [src.item] by private citizens and corporations.
		This tax would be used to create [src.subsidy] for underpriviledged [src.recipients[0]] and [src.recipients[1]].
		This tax would apply to all planets, stations, and colonial outposts, except those who would receive the subsidizations above.
	"}

/datum/sg_referendum_content/taxation/tariffs
	tax_range = list(10, 200)

/datum/sg_referendum_content/taxation/tariffs/New()
	tax = rand(src.tax_range[0], src.tax_range[1])
	item = pick(src.items)
	subsidy = pick(src.subsidies)
	recipients.Insert(pick(valid_recipients))
	recipients.Insert(pick(valid_recipients))
	name = "Tarrif on the Import/Export of [src.item]"
	text = {"
		The [src.name] is a [src.tax]% tax on the import and export of [src.item] and derivative products when crossing inter-system boundaries.<br/>
		This tax would be used to create [src.subsidy] for underpriviledged [src.recipients[0]] and [src.recipients[1]].<br/>
		This tax would apply to all planets, stations, and colonial outposts, except those who would receive the subsidizations above.<br/>
	"}

/datum/sg_referendum_content/taxation/department
	tax_range = list(2, 30)
	var/department

/datum/sg_referendum_content/taxation/department/New()
	tax = rand(src.tax_range[0], src.tax_range[1])
	department = pick(src.departments)
	recipients.Insert(pick(valid_recipients))
	subsidy = pick(src.subsidies)
	name = "Tarrif on the Income of [src.department] Operations"
	text = {"
		The [src.name] is a [src.tax] on the net income of [src.department] operations for stations within SolGov space.<br/>
		This tax will be used to augment [src.subsidy] for [src.recipients] within the same jurisdiction.<br/>
		This tax would apply to all orbital installations, colonial operations, and long-duration voyage craft.<br/>
	"}

/obj/item/paper/paperwork/sgr/referendum
	var/referendum_type

/obj/item/paper/paperwork/sgr/referendum/Initialize(datum/sg_referendum_content/ref)
	. = ..()
	if (!ref)
		ref = GLOB.sg_referendum
	if (!istype(ref))
		log_runtime("Invalid referendum content passed to Initialize")
		return FALSE
	referendum_type = ref.type
	name = ref.name
	info = {"
		<h1>SolGov Federal Legislation Referendum</h1><br/>
		<h2>Referendum on [ref.name]</h2><br/>
		[ref.text]
	"}

/datum/objective/crew/sgr
	jobs = "solgovrepresentative"

/datum/objective/crew/sgr/proc/html_format_explanation_text()
	return {"
		<B>Your objective:</B> [src.explanation_text]
	"}

/datum/objective/crew/sgr/proc/get_target_player_count()
	var/player_count = get_active_player_count()
	if(player_count <= 8)
		return player_count <= 3 ? 3 : player_count // At this point they might not be able to make it work, and that's fine.
	else if (player_count > 8)
		return rand(3, round(player_count / 2) - 1)

/datum/objective/crew/sgr/proc/assign(var/datum/mind/crewMind)
	var/list/availableto = splittext(initial(src.jobs),",")
	if (!("[ckey(crewMind.assigned_role)]" in availableto))
		log_runtime("Attempted to assign SGR objectives to a non-SGR crewmember")
		return

	src.owner = crewMind
	crewMind.crew_objectives += src
	crewMind.memory += src.html_format_explanation_text()

/datum/objective/crew/sgr/paperwork
	var/paperwork_type
	var/target_count

/datum/objective/crew/sgr/paperwork/New()
	. = ..()
	var/list/subtypelist = subtypesof(/obj/item/paper/paperwork/sgr)
	var/obj/item/paper/paperwork/sgr/paper = new (subtypelist[rand(0, subtypelist.len - 1)])
	paperwork_type = paper.type
	target_count = src.get_target_player_count()
	if(istype(paperwork_type, /obj/item/paper/paperwork/sgr/referendum))
		explanation_text = "A referendum is up for a vote in the SG Legislature, have at least [target_count] crew vote."
	else
		explanation_text = "Have at least [target_count] crewmembers fill out [paper.name]"
	qdel(paper)

/datum/objective/crew/sgr/departmental
	var/department
	var/target_name
	var/target_count
/datum/objective/crew/sgr/departmental/security
	name = "Stockpiling"
	department = "Security"
	var/target_weapon
	var/valid_weapons
/datum/objective/crew/sgr/departmental/security/New()
	. = ..()
	valid_weapons = typecacheof(list(
		/obj/item/gun/ballistic/shotgun/riot,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/e_gun,
		/obj/item/gun/ballistic/automatic/wt550,
		/obj/item/gun/ballistic/automatic/pistol/commander
	), FALSE, TRUE) // Only the paths explicitly enumerated here.

	target_weapon = pick(valid_weapons)
	target_count = rand(3, 8)
	var/atom/movable/temp_instance = new target_weapon
	temp_instance.moveToNullspace()
	target_name = initial(temp_instance.name)
	qdel(temp_instance)
	name = "Stockpiling: [target_name]"
	explanation_text = "Have at least [target_count] [target_name] in the armory by the end of the shift."

/datum/objective/crew/sgr/departmental/security/check_completion()
	. = ..()
	var/list/guns_in_armory = list()
	var/list/armory_areas = get_areas(/area/ai_monitored/security/armory)
	for(var/area/A in armory_areas)
		for(var/obj/O in A.contents)
			if(istype(O, target_weapon))
				guns_in_armory += O
	if (guns_in_armory.len >= target_count)
		return TRUE
	return FALSE

/datum/objective/crew/sgr/departmental/security/arrest_records
	name = "Crackdown"
	var/crime_type
	var/valid_crime_types = list(
		"Arson", "Assault", "Battery", "Petty Theft", "Harassment", "Vandalism", "Resisting Arrest", "Insubordination"
	)

/datum/objective/crew/sgr/departmental/security/arrest_records/New()
	crime_type = pick(valid_crime_types)
	target_count = rand(2, 5)
	name = "Crackdown: [crime_type]"
	explanation_text = "Have at least [target_count] [crime_type] offenses registered in security records by the end of the shift."

/datum/objective/crew/sgr/departmental/security/arrest_records/check_completion()
	var/list/crimes = GLOB.data_core.get_crimes_by_offense_name(crime_type)
	if(crimes.len > target_count)
		return TRUE
	return FALSE

/datum/objective/crew/sgr/departmental/security/required_equipment
	name = "Rearmament"
	var/equipment_type
	var/valid_equipment_types // Only the paths explicitly enumerated here.

/datum/objective/crew/sgr/departmental/security/required_equipment/New()
	valid_equipment_types = typecacheof(list(
			/obj/item/flashlight,
			/obj/item/melee/baton,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/restraints/handcuffs
	), FALSE, TRUE)
	equipment_type = pick(valid_equipment_types)
	var/atom/movable/temp_instance = new equipment_type
	temp_instance.moveToNullspace()
	target_name = temp_instance.name
	target_count = rand(1, 3)
	name = "Rearmament: [target_name]"
	explanation_text = "Have at least [target_count] [target_name] on each security member on the shuttle by the end of the shift."

/datum/objective/crew/sgr/departmental/security/required_equipment/check_completion()
	for(var/datum/mind/M in SSticker.mode.get_all_by_department(GLOB.security_positions))
		if (!M.current)
			continue
		if(considered_escaped(M))
			var/count = 0
			for (var/obj/O in M.current.contents)
				if(istype(O, equipment_type))
					count++
			if (count < target_count)
				return FALSE
	return TRUE
/datum/objective/crew/sgr/departmental/engineering
	department = "Engineering"
	var/target_machine
	var/area/target_area
	var/list/valid_machines
	var/list/valid_areas

/datum/objective/crew/sgr/departmental/engineering/New()
	. = ..()
	valid_machines = typecacheof(list(
		/obj/machinery/power/smes,
		/obj/machinery/power/shieldwallgen,
		/obj/machinery/power/port_gen/pacman,
		/obj/machinery/power/port_gen/pacman/super,
		/obj/machinery/power/port_gen/pacman/mrs,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/emitter
	), FALSE, TRUE) // Only the paths explicitly enumerated here.
	valid_areas = GLOB.the_station_areas
	target_machine = pick(valid_machines)
	var/atom/movable/temp_instance = new target_machine
	temp_instance.moveToNullspace()
	target_name = temp_instance.name
	qdel(temp_instance)
	target_count = rand(5, 10)
	target_area = pick(valid_areas)
	explanation_text = "Have at least [target_count] [target_name] in [target_area.name] by the end of shift."

/datum/objective/crew/sgr/departmental/engineering/check_completion()
	var/count = 0
	for(var/obj/machinery/O in GLOB.machines)
		if (istype(O, target_machine) && istype(get_area(O), target_area))
			count++
	if (count >= target_count)
		return TRUE
	return FALSE

/datum/objective/crew/sgr/station_wide
	var/target_count

/datum/objective/crew/sgr/station_wide/preserve_life

/datum/objective/crew/sgr/station_wide/preserve_life/New()
	target_count = pick(10, 50)
	explanation_text = "Help ensure at least [target_count]% of the crew survives"

/datum/objective/crew/sgr/station_wide/preserve_life/check_completion()
	var/living_count = SSticker.mode?.current_players[CURRENT_LIVING_PLAYERS].len
	if (living_count == 0)
		return FALSE
	var/total_players = GLOB.joined_player_list.len
	if (living_count/total_players >= (target_count/100))
		return TRUE
	return FALSE

/datum/controller/subsystem/ticker/proc/generate_solgov_rep_objectives(var/datum/mind/crewMind)
	if (!GLOB.sg_referendum)
		var/list/subtypelist = subtypesof(/datum/sg_referendum_content)
		GLOB.sg_referendum = new (subtypelist[rand(0, subtypelist.len - 1)])

	var/datum/objective/crew/sgr/paperwork/paperwork_obj = new /datum/objective/crew/sgr/paperwork
	var/list/valid_department_obj_types = subtypesof(/datum/objective/crew/sgr/departmental)
	var/datum/objective/crew/sgr/departmental/departmental_obj =  new (valid_department_obj_types[rand(0, valid_department_obj_types.len - 1)])
	var/list/station_wide_obj_types = subtypesof(/datum/objective/crew/sgr/station_wide)
	var/datum/objective/crew/sgr/station_wide/station_wide_obj = new (station_wide_obj_types[rand(0, station_wide_obj_types.len - 1)])

	if (!paperwork_obj || !departmental_obj || !station_wide_obj)
		log_runtime({"Failed to generate SGR objectives:
			Paperwork:[!!paperwork_obj], Departmental:[!!departmental_obj], Station-Wide:[!!station_wide_obj]"})
		return

	paperwork_obj.assign(crewMind)
	departmental_obj.assign(crewMind)
	station_wide_obj.assign(crewMind)
	to_chat(crewMind, {"
		<b>
			SolGov has assigned you a set of objectives to complete as part of your shift on the station.
			<span class='warning'>Performing illegal acts to execute your objectives WILL RESULT in termination of your federal employment.</span>
		</b>
	"})
	to_chat(crewMind, paperwork_obj.html_format_explanation_text())
	to_chat(crewMind, departmental_obj.html_format_explanation_text())
	to_chat(crewMind, station_wide_obj.html_format_explanation_text())
