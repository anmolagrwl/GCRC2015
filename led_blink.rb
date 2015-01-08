# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
led = Dino::Components::Led.new(pin: 1, board: board)

# Cycling between 'on' and 'off' event for LED to create blinking effect.
[:on, :off].cycle do |switch|
  led.send(switch)
  sleep 0.5 #Stays on or off for 0.5 seconds only.
end


