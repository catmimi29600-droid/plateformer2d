extends CharacterBody2D

# Constantes de mouvement
const SPEED = 200.0
const JUMP_FORCE = -400.0
const GRAVITY = 800.0

# Variables
var is_jumping = false
var tile_map: TileMapLayer

func _ready():
	# Récupérer le tilemap
	tile_map = get_parent().get_node("TileMapLayer")

func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Gestion du saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	
	# Gestion du mouvement horizontal
	var input_vector = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_vector * SPEED
	
	# Animer selon le mouvement
	if input_vector != 0:
		$AnimatedSprite2D.animation = "default"
		if input_vector > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	
	# Appliquer le mouvement
	move_and_slide()
	
	# Vérifier les collisions avec tuiles dangereuses
	check_death_tiles()

func check_death_tiles():
	if not tile_map:
		return
	
	# Convertir la position globale du joueur en position de tuile
	var local_pos = tile_map.to_local(global_position)
	var tile_pos = tile_map.local_to_map(local_pos)
	var source_id = tile_map.get_cell_source_id(tile_pos)
	var atlas_coords = tile_map.get_cell_atlas_coords(tile_pos)
	
	# Si source ID 7 = tuile de mort
	if source_id == 7:
		die()

func die():
	global_position = Vector2(0, 0)
	velocity = Vector2.ZERO
