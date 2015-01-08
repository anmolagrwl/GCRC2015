# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'
require 'pubnub'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
sensor = Dino::Components::Sensor.new(pin: 'A0', board: board)
buzzer = Dino::Components::Led.new(pin: 1, board: board)

# Initially set the buzzer off.
buzzer.send(:off)

# Initializing and setting up the pubnub variable.
# ------------
    @pubnub = Pubnub.new(
        :subscribe_key    => 'sub-c-49d69172-3e94-11e4-8c81-02ee2ddab7fe',
        :publish_key      => 'pub-c-67b64f52-9ac9-42df-9803-55fc0a646b22',
        :error_callback   => lambda { |msg|
          puts "Error callback says: #{msg.inspect}"
        },
        :connect_callback => lambda { |msg|
          puts "CONNECTED: #{msg.inspect}"
        }
    )

    # Subscribing the channel to/from which message are to be passed/collected.
    @pubnub.subscribe(
        :channel  => 'earthquake_frequency'
    ){|data|

        # Logic of what to do on client side when message is analysed.
        if data.message['Magnitude'] > 6.50
          puts "EARTHQUAKE ALERT..."
         buzzer.send(:on)
        else
         buzzer.send(:off)
       end
    }
# ------------

# Specifies what message is to be sent to pubnub on a particular user's event. (Here, pressing up and down the button).
# ------------
sensor.when_data_received do |data|
	puts data
    mag = (data.to_f)/100
    @pubnub.publish(:message => {'Magnitude' => mag}, :channel => 'earthquake_frequency', :http_sync => true)
end

sleep
