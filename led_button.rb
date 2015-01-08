# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
button = Dino::Components::Button.new(pin: 'A0', board: board)
led = Dino::Components::Led.new(pin: 1, board: board)

# Initially set the led off.
led.send(:off)

# Specifies what message is to be sent on a particular user's event. (Here, pressing up and down the button).
# ------------
button.down do
  puts "button not pressed"
  led.send(:off)
end

button.up do
  puts "button pressed"
  led.send(:on)
end

sleep
