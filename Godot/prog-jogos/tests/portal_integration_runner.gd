extends SceneTree

var failures := 0

func _initialize() -> void:
	_run.call_deferred()

func _expect(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		push_error("FAIL: " + description)

func _wait_physics(amount: int) -> void:
	for _index in amount:
		await physics_frame

func _open_scene(path: String) -> void:
	var scene: PackedScene = load(path)
	var instance := scene.instantiate()
	root.add_child(instance)
	current_scene = instance
	await _wait_physics(3)

func _activate_portal(portal_path: String, expected_scene_name: String) -> bool:
	if current_scene == null:
		_expect(false, portal_path + " possui uma cena atual")
		return false

	var previous_scene := current_scene
	var player := current_scene.get_node_or_null("player") as CharacterBody2D
	var portal := current_scene.get_node_or_null(portal_path) as Area2D
	if player == null or portal == null:
		_expect(false, portal_path + " encontra Player e Area2D")
		return false

	player.global_position = portal.global_position

	for _index in 30:
		await physics_frame
		await process_frame
		if current_scene != null and current_scene != previous_scene:
			break

	var changed := current_scene != null and current_scene != previous_scene
	_expect(changed, portal_path + " troca a cena")
	if not changed:
		return false

	var correct_scene := current_scene.name == expected_scene_name
	_expect(correct_scene, portal_path + " abre " + expected_scene_name)
	return correct_scene

func _run() -> void:
	print("--- Integração real dos portais C# ---")
	await _open_scene("res://scenes/world01.tscn")
	var route_ok := await _activate_portal("house_door", "house_interior")
	if route_ok:
		route_ok = await _activate_portal("exit_to_world01", "world01")
	if route_ok:
		route_ok = await _activate_portal("passage_to_world02", "world02")
	if route_ok:
		route_ok = await _activate_portal("return_to_world01", "world01")
	_expect(route_ok, "rota Área 1 -> casa -> Área 1 -> Área 2 -> Área 1")

	if failures == 0:
		print("PORTAL_INTEGRATION_OK")
		quit(0)
	else:
		push_error("PORTAL_INTEGRATION_FAILED: %d" % failures)
		quit(1)
