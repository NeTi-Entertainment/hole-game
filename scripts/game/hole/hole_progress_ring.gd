extends MeshInstance3D
class_name HoleProgressRing

@export_range(0.0, 1.0, 0.01) var progress_ratio: float = 0.0
@export var radius: float = 1.25
@export var thickness: float = 0.12
@export var segments: int = 96
@export var y_offset: float = 0.08
@export var start_angle_degrees: float = -90.0


func _ready() -> void:
	rebuild_mesh()


func set_progress_ratio(new_progress_ratio: float) -> void:
	progress_ratio = clampf(new_progress_ratio, 0.0, 1.0)
	rebuild_mesh()


func set_radius(new_radius: float) -> void:
	radius = maxf(new_radius, 0.05)
	rebuild_mesh()


func rebuild_mesh() -> void:
	var clamped_progress := clampf(progress_ratio, 0.0, 1.0)

	if clamped_progress <= 0.0:
		mesh = ArrayMesh.new()
		return

	var outer_radius := radius + thickness * 0.5
	var inner_radius := maxf(0.01, radius - thickness * 0.5)

	var used_segments: int = max(1, int(ceil(float(segments) * clamped_progress)))
	var angle_span := TAU * clamped_progress
	var start_angle := deg_to_rad(start_angle_degrees)

	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()

	for index in range(used_segments + 1):
		var ratio := float(index) / float(used_segments)
		var angle := start_angle + angle_span * ratio
		var direction := Vector3(cos(angle), 0.0, sin(angle))

		vertices.append(Vector3(
			direction.x * outer_radius,
			y_offset,
			direction.z * outer_radius
		))

		vertices.append(Vector3(
			direction.x * inner_radius,
			y_offset,
			direction.z * inner_radius
		))

		normals.append(Vector3.UP)
		normals.append(Vector3.UP)

	for index in range(used_segments):
		var vertex_index := index * 2

		# Face visible côté haut
		indices.append(vertex_index)
		indices.append(vertex_index + 2)
		indices.append(vertex_index + 1)

		indices.append(vertex_index + 2)
		indices.append(vertex_index + 3)
		indices.append(vertex_index + 1)

		# Face inversée pour rendre le ring visible même si le culling pose problème
		indices.append(vertex_index)
		indices.append(vertex_index + 1)
		indices.append(vertex_index + 2)

		indices.append(vertex_index + 2)
		indices.append(vertex_index + 1)
		indices.append(vertex_index + 3)

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var new_mesh := ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	mesh = new_mesh
