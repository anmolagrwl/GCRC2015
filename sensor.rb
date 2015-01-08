# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
sensor = Dino::Components::Sensor.new(pin: 'A0', board: board)

# Puts the recieved data in terminal.
sensor.when_data_received do |data|
  puts data
end

sleep
