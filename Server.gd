# CALLED AUTOMATICALLY WHEN THE GAME IS FIRST OPENED.
extends Node
var socket = WebSocketPeer.new()
@export var ip_address = "127.0.0.1"
@export var port = "8080"
func _ready(): 
	print("ws://{ip}:{port}/ws".format({"ip":ip_address, "port":port}))
	socket.connect_to_url("ws://{ip}:{port}/ws".format({"ip":ip_address, "port":port})) # Connect to WS server.

func _process(_delta):
	socket.poll() # Poll the socket.
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN: # If connection is open...
		#print("web socket opened")
		while socket.get_available_packet_count(): # For each remaining incoming packet...
			EventLib.handle_response(socket.get_packet().get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
