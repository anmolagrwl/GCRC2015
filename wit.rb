# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'
require 'wit'
require 'json'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
led = Dino::Components::Led.new(pin: 1, board: board)

# Wit.ai API's access token.
access_token = 'PYTUKJACUMZQHNSRJ33LFJYYQXZKSHB4'

# Set led initially off.
led.send(:off)

# Initialize Wit.ai API.
Wit.init

loop { 
	# The response we get from Wit.ai API after when we speak something. 
	response = Wit.voice_query_auto(access_token)

	if JSON.load(response)['outcomes'][0]['intent'] == 'lights_on'
		led.send(:on)
	elsif JSON.load(response)['outcomes'][0]['intent'] == 'lights_off'
		led.send(:off)
	end
}

Wit.close