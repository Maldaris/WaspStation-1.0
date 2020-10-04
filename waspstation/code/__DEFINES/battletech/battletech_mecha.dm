#define BT_MECHA_UNPOWERED (1<<0)
#define BT_MECHA_SHUTDOWN (1<<1)
#define BT_MECHA_EMP (1<<2)
#define BT_MECHA_POWERPLANT_HACKED (1<<3)

#define BT_MECH_LIGHT 1
#define BT_MECH_MEDIUM 2
#define BT_MECH_HEAVY 3
#define BT_MECH_ASSAULT 4

#define BT_CHASSIS_HEAD "head"
#define BT_CHASSIS_CTORSO "c_torso"
#define BT_CHASSIS_LTORSO "l_torso"
#define BT_CHASSIS_RTORSO "r_torso"
#define BT_CHASSIS_LARM "l_arm"
#define BT_CHASSIS_RARM "r_arm"
#define BT_CHASSIS_LLEG "l_leg"
#define BT_CHASSIS_RLEG "r_leg"

#define BT_CHASSIS_DESTROYED -1
#define BT_CHASSIS_DAMAGED 0
#define BT_CHASSIS_PRISTINE 1


#define BT_RUN_THRESHOLD 50

#define BT_EQUIPMENT_BASE "equip_type_base"
#define BT_EQUIPMENT_SLOT_OMNI "equip_slot_omni"

#define isbtmech(A) (istype(A, /obj/battletech/mecha))
#define isbtchassis(A) (istype(A, /obj/battletech/chassis))
#define isbtequipment(A) (istype(A, /obj/battletech/equipment))
