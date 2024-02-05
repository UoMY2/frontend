# CALLED AUTOMATICALLY WHEN THE GAME IS FIRST OPENED.
extends Node

var socket = WebSocketPeer.new()

func _ready(): 
	socket.connect_to_url("ws://localhost:8080/ws") # Connect to WS server.

func _process(delta):
	socket.poll() # Poll the socket.
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN: # If connection is open...
		while socket.get_available_packet_count(): # For each remaining incoming packet...
			EventLib.handle_response(socket.get_packet().get_string_from_utf8())
			# Use EventLib to handle the server response.
		#EventLib.create_lobby()
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
