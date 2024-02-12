extends Node




var playerArray = [[],[],[],[],[],[]]  #the first three elements are blue team and last three are red team
var serverObj

#boolean values to run methods
var update_tables = false
var update_code = false
var remove_ready = false
var add_player  = false
var add_remote_players = false

#player variables
var lobby_code = ""
var current_player_name = ""  #this is the current player's name
var current_player_team = 0  #this is the current player's team
var current_player_ready = false
var current_player_position = Vector2()

