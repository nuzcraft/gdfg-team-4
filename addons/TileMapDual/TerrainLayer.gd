## A set of _rules usable by a single DisplayLayer.
class_name TerrainLayer
extends Resource


## A list of which CellNeighbors to care about during terrain checking.
var terrain_neighborhood: Array = []

##[br] When a cell in a DisplayLayer needs to be recomputed,
##     the TerrainLayer needs to know which tiles surround it.
##[br] This Array stores the paths from the affected cell to the neighboring world cells.
var display_to_world_neighborhood: Array

# TODO: change Mapping to support https://github.com/pablogila/TileMapDual/issues/13
##[br] The rules that dictate which tile matches a given set of neighbors.
##[br] Used by register_rule() and apply_rule()
##[codeblock]
##  _rules: TrieNode = # The actual type of _rules
##
##  TrieNode: Dictionary{
##    key: int = # The terrain value of this neighbor
##    value: TrieNode | TrieLeaf = # The next branch of this trie
##  }
## 
##  TrieLeaf: Dictionary{
##    'mapping': Mapping = # The tile that this should now become
##  }
##
##  Mapping: Dictionary{
##    'sid': int = # The source_id of this tile
##    'tile': Vector2i = # The Atlas Coordinates of this tile
##  }
##[/codeblock]
##[br] Internally a decision "trie":
##[br] - each node branch represents a terrain neighbor
##[br] - each leaf node represents the terrain that a tile
##       with the given terrain neighborhood should become
##[br] 
##[br] How the trie is searched:
##[br] - check the next neighbor in terrain_neighbors
##[br] - check if there is a branch corresponding to the terrain of that neighbor
##[br]   - if there is a branch, search again under that branch
##[br]   - else pretend that neighbor is empty and try again
##[br]   - if there really isn't a branch, no rules exist so just return empty
##[br] - once at a leaf node, its mapping should tell us what terrain to become
##[br]
##[br] See apply_rule() for more details.
var _rules: Dictionary = {}


func _init(fields: Dictionary) -> void:
	self.terrain_neighborhood = fields.terrain_neighborhood
	self.display_to_world_neighborhood = fields.display_to_world_neighborhood


## Register a new rule for a specific tile in an atlas.
func _register_tile(data: TileData, mapping: Dictionary) -> void:
	if data.terrain_set != 0:
		# This was already handled as an error in the parent TerrainDual
		return
	var terrain_neighbors := terrain_neighborhood.map(data.get_terrain_peering_bit)
	# Skip tiles with no peering bits in this filter
	# They might be used for a different layer,
	# or may have no peering bits at all, which will just be ignored by all layers
	if terrain_neighbors.any(func(neighbor): return neighbor == -1):
		if terrain_neighbors.any(func(neighbor): return neighbor != -1):
			push_warning(
				"Invalid Tile Neighborhood at %s.\n" % [mapping] +
				"Expected neighborhood: %s" % [terrain_neighborhood.map(Util.neighbor_name)]
			)
		return
	_register_rule(terrain_neighbors, mapping)


## Register a new rule for a set of surrounding terrain neighbors
func _register_rule(terrain_neighbors: Array, mapping: Dictionary) -> void:
	var node := _rules
	for terrain in terrain_neighbors:
		if terrain not in node:
			node[terrain] = {}
		node = node[terrain]
	if 'mapping' in node:
		var prev_mapping = node.mapping
		push_warning(
			"2 different tiles in this TileSet have the same Terrain neighbors:\n" +
			"Neighbor Configuration: %s\n" % [_neighbors_to_dict(terrain_neighbors)] +
			"1st: %s\n" % [prev_mapping] +
			"2nd: %s" % [mapping]
		)
	node.mapping = mapping


const TILE_EMPTY: Dictionary = {'sid': - 1, 'tile': Vector2i(-1, -1)}
## Returns the tile that should be used based on the surrounding terrain neighbors
func apply_rule(terrain_neighbors: Array) -> Dictionary:
	var is_empty := terrain_neighbors.all(func(terrain): return terrain == -1)
	if is_empty:
		return TILE_EMPTY
	var normalized_neighbors = terrain_neighbors.map(normalize_terrain)

	var node := _rules
	for terrain in normalized_neighbors:
		if terrain not in node:
			terrain = 0
		if terrain not in node:
			return TILE_EMPTY
		node = node[terrain]
	if 'mapping' not in node:
		return TILE_EMPTY
	return node.mapping


## Coerces all empty tiles to have a terrain of 0.
static func normalize_terrain(terrain):
	return terrain if terrain != -1 else 0


## Utility function for easier printing
func _neighbors_to_dict(terrain_neighbors: Array) -> Dictionary:
	return Util.arrays_to_dict(terrain_neighborhood.map(Util.neighbor_name), terrain_neighbors)
