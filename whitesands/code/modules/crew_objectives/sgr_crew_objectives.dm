/obj/item/paper/fluff/paperwork/sgr

/obj/item/paper/fluff/paperwork/sgr/Initialize()
	. = ..()
	info = replacetext(info, regex("\n\s*"), "")

/obj/item/paper/fluff/paperwork/sgr/proc/completed()
	return form_fields.length == 0 && form_fields.stamped.length > 0

/obj/item/paper/fluff/paperwork/sgr/tax_form/form_1099
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
/obj/item/paper/fluff/paperwork/sgr/tax_form/form_w2
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

/obj/item/paper/fluff/paperwork/sgr/census/basic
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
/obj/item/paper/fluff/paperwork/sgr/census/diversity
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
/obj/item/paper/fluff/paperwork/sgr/census/seniority
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
		\[___] (Yes/No)<br/>
	"}
/obj/item/paper/fluff/paperwork/sgr/census/robustness
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
		\[___] (Yes/No)<br/>
	"}


/datum/sg_referendum_content/New()
	. = ..()
	text = replacetextEx(text, regex("\n\s*"), "")

/datum/sg_referendum_content/taxation
	var/static/departments = list(
		"Security", "Medical","Engineering","Cargo","Service","Science"
	)
	var/static/items = list(
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
	var/static/subsidies = list(
		"burial services",
		"banking services",
		"janitorial services",
		"water purification",
		"security retraining",
		"Ian revival"
	)
	var/static/recipients = list(
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
/datum/sg_referendum_content/taxation/tariffs
	var/static/tax_range = list(10, 200)
	var/items
	var/tax
	var/recipients = list()
	var/subsidy

/datum/sg_referendum_content/taxation/tariffs/New()
	tax = rand(src.tax_range[0], src.tax_range[1])
	item = pick(src.items)
	subsidy = pick(src.subsidies)
	recipients.Insert(pick(valid_recipients))
	recipients.Insert(pick(valid_recipients))
	name = "Tarrif on the Import/Export of [src.item]"
	text = {"
		The [src.name] is a [src.tax]% tax on the import and export of [src.item] and derivative products when crossing inter-system boundaries.
		This tax would be used to create [src.subsidy] for underpriviledged [src.recipients[0]] and [src.recipients[1]].
		This tax would apply to all planets, stations, and colonial outposts, except those who would receive the subsidizations above.
	"}

/datum/sg_referendum_content/taxation/department
	var/static/tax_range = list(2, 30)
	var/department
	var/tax
	var/recipients = list()
	var/subsidy

/datum/sg_referendum_content/taxation/department/New()
	tax = rand(src.tax_range[0], src.tax_range[1])
	department = pick(src.departments)
	recipients.Insert(pick(src.valid_recipients))
	subsidy = pick(src.subsidies)
	name = "Tarrif on the Income of [src.department] Operations"
	text = {"
		The [src.name] is a [src.tax] on the net income of [src.department] operations for stations within SolGov space.
		This tax will be used to augment [src.subsidy] for [src.recipients] within the same jurisdiction.
		This tax would apply to all orbital installations, colonial operations, and long-duration voyage craft.
	"}

GLOBAL_LIST_INIT(valid_sg_referendums, list(
	/datum/sg_referendum_content/taxation/department,
	/datum/sg_referendum_content/taxation/tariffs
))

/obj/item/paper/fluff/paperwork/sgr/referendum
/obj/item/paper/fluff/paperwork/sgr/referendum/Initialize(datum/sg_referendum_content/ref)
	. = ..()
	if (!istype(ref))
		log_runtime("Invalid referendum content passed to Initialize")
		return FALSE
	referendum_type = ref
	name = referendum_type.name
	info = {"
		<h1>SolGov Federal Legislation Referendum</h1><br/>
		<h2>Referendum on [referendum_type.name]</h2><br/>
		[referendum_type.text]
	"}

GLOBAL_LIST_INIT(valid_paperwork_for_objectives, list(
	/obj/item/paper/fluff/paperwork/sgr/tax_form/form_1099,
	/obj/item/paper/fluff/paperwork/sgr/tax_form/form_w2,
	/obj/item/paper/fluff/paperwork/sgr/census/basic,
	/obj/item/paper/fluff/paperwork/sgr/census/diversity,
	/obj/item/paper/fluff/paperwork/sgr/census/seniority,
	/obj/item/paper/fluff/paperwork/sgr/census/robustness,
	/obj/item/paper/fluff/paperwork/sgr/referendum
))

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
	else if player_count > 8
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
	paperwork_type = pick(GLOB.valid_paperwork_for_objectives)
	target_count = src.get_target_player_count()
	if(paperwork_type == /obj/item/paper/fluff/paperwork/sgr/referendum)
		explanation_text = "A referendum is up for a vote in the SG Legislature, have at least [target_count] crew vote."
	else
		explanation_text = "Have at least [target_count] crewmembers fill out [initial(paperwork_type.name)]"

/datum/objective/crew/sgr/departmental
	var/department
/datum/objective/crew/sgr/departmental/security
	department = "Security"

/datum/objective/crew/sgr/station_wide

/proc/generate_solgov_rep_objectives(var/datum/mind/crewMind)
	var/list/availableto = splittext(initial(src.jobs),",")
	if (!("[ckey(crewMind.assigned_role)]" in availableto))
		log_runtime("Attempted to generate SGR objectives for a non-SGR crewmember")
		return

	if (!GLOB.sg_referendum)
		GLOB.sg_referendum = new pick(GLOB.valid_sg_referendums)

	var/datum/objective/crew/sgr/paperwork/paperwork_obj = new /datum/objective/crew/sgr/paperwork
	var/datum/objective/crew/sgr/departmental/departmental_obj = new pick(GLOB.valid_departmental_objectives)
	var/datum/objective/crew/sgr/station_wide/station_wide_obj = new pick(GLOB.valid_station_wide_objectives)

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
