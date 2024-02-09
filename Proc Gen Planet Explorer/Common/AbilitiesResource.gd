class_name Abl
extends Resource
export(int) var str_
export(int) var dex
export(int) var wil
export(int) var max_str_
export(int) var max_dex
export(int) var max_wil
const STR_ := "str_"
const DEX := "dex"
const WIL := "wil"
const SKILL_LIST := [STR_, DEX, WIL]

#export(Resource) var sub_resource
#export(Array, String) var strings

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_str_=10, new_dex=10, new_wil=10):
	str_ = new_str_
	dex = new_dex
	wil = new_wil
	max_str_ = new_str_
	max_dex = new_dex
	max_wil = new_wil
	
func scene(source:Scene):
	for s in SKILL_LIST:
		set("max_"+s, source["max_" + s])
		set(s, source["max_" + s])



func heal():
	for a in PE.SKILL_LIST:
		if get(a) < get("max_" + a):
			set(a, get(a) + 1)
			return
