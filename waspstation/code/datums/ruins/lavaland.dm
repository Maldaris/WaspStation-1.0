/datum/map_template/ruin/lavaland/ore_node
	cost = 5
	always_place = TRUE // We want to ensure that there is always ore available
	var/material_type = null // This should be a material datum that contains a sheet_type property that isn't null.

/datum/map_template/ruin/lavaland/ore_node/titanium
	name = "Titanium Node"
	id = "titanium-node"
	description = "A vein of titanium, suitable for setting up a deep core mining operation."
	suffix = "lavaland_ore_node_titanium.dmm"
	cost = 0 // We should have a few of these.

/datum/map_template/ruin/lavaland/ore_node/plasma
	name = "Plasma Node"
	id = "solid-plasma-node"
	description = "A vein of solid plasma, which could be extracted with a proper deep core mining rig."
	cost = 0
	suffix = "lavaland_ore_node_plasma.dmm"
	material_type = /datum/material/plasma

/datum/map_template/ruin/lavaland/ore_node/diamond
	name = "Kimberlite (Diamond) Deposits"
	id = "diamond-node"
	description = "Seismographic analysis points to several deep deposits of kimberlite, the tell tale sign of diamonds. A deep core mining drill could extract them."
	suffix = "lavaland_ore_node_diamond.dmm"
	material_type = /datum/material/diamond

/datum/map_template/ruin/lavaland/ore_node/bluespace_crystal
	name = "Bluespace Crystal Geodes"
	id = "bluespace-crystal-node"
	description = "Ground penetrating radar points to several vaccuous caverns underground, a strong indicator for bluespace crystal geode formations. They could be harvested with a deep core mining operation."
	suffix = "lavaland_ore_node_bluespace_crystal.dmm"
	material_type = /datum/material/bluespace
