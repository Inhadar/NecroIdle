extends Node

var tap_perm = true
var coin = 0
var base_damage =1
var upgrade_level_datas = {
	"tap_level":1
	}


#NEW Datas
#var necro_resources:Array = [0,0] 
var bones = 0
var digged_graves = 0
var graves_level = 1

var slaves = {
	"slave1":[5,10,1,CapsuleMesh.new(),true,"slave2"],#0:count 1:damage 2:attack_cooldown 3:modelmesh 4:aviability 5:can turn to
	"slave2":[3,10,1,PrismMesh.new(),false,"slave3"],#0:count 1:damage 2:attack_cooldown
	"slave3":[2,10,1,SphereMesh.new(),false,"slave4"],#0:count 1:damage 2:attack_cooldown
	"slave4":[1,10,1,BoxMesh.new(),false,"n/a"],#0:count 1:damage 2:attack_cooldown
	}

var grave_update_data = {
	"update_1": ["incrase dig power",1, 10.0, "n/a"], #<- price calculate from level(index=1)
	"update_2": ["digger slave",1 , 20.0, 1.0, "deactive"],
	"update_3": ["digger machine",1 , 30.0, 2.0, "deactive"],
	"update_4": ["diginator",1 , 40.0, 3.0, "deactive"]
	}

var attack_updater = {}

var unlocked_maps= {
	"Graves":["grave1"],
	"Forges":["forge1"],
	"Habitats":[],
	"Targets":[],
}

func calculate_grave_level():
	graves_level = floor(digged_graves/2)
	return graves_level
