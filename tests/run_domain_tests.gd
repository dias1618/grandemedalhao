extends SceneTree

## Discovers tests/domain/*_test.gd and calls run() -> bool.
## Exit 0 when every test passes or when no test exists yet.


func _initialize() -> void:
	var failed := _run_all()
	quit(1 if failed > 0 else 0)


func _run_all() -> int:
	var directory := DirAccess.open("res://tests/domain")
	if directory == null:
		print("domain tests: no tests/domain directory, nothing to run")
		return 0

	var failed := 0
	var ran := 0
	for file_name in directory.get_files():
		if not file_name.ends_with("_test.gd"):
			continue
		ran += 1
		if not _run_one(file_name):
			failed += 1

	print("domain tests ran=%d failed=%d" % [ran, failed])
	return failed


func _run_one(file_name: String) -> bool:
	var resource_path := "res://tests/domain/" + file_name
	var script: Script = load(resource_path)
	if script == null:
		push_error("failed to load %s" % resource_path)
		return false

	var test: Object = script.new()
	if test == null or not test.has_method("run"):
		push_error("%s must extend RefCounted and implement run() -> bool" % file_name)
		return false

	var result: Variant = test.call("run")
	if result != true:
		print("FAIL %s" % file_name)
		return false

	print("PASS %s" % file_name)
	return true
