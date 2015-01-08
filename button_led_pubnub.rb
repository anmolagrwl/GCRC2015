# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'
require 'pubnub'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
button = Dino::Components::Button.new(pin: 'A0', board: board)
led = Dino::Components::Led.new(pin: 1, board: board)

# Initially set the led off.
led.send(:off)

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
        :channel  => 'button_pubnub'
    ){|data|

      # Logic of what to do on client side when message is analysed.
        if data.message['button_status'] == "NOT PRESSED"
          puts "turning LED OFF"
          led.send(:off)
        elsif data.message['button_status'] == "PRESSED"
         puts "turning LED ON"
         led.send(:on)
       end
    }
# ------------

# Specifies what message is to be sent to pubnub on a particular user's event. (Here, pressing up and down the button).
# ------------
button.down do
  puts "button not pressed"
  @pubnub.publish(:message => {"button_status" => "NOT PRESSED"}, :channel => 'button_pubnub', :http_sync => true)
end

button.up do
  puts "button pressed"
  @pubnub.publish(:message => {"button_status" => "PRESSED"}, :channel => 'button_pubnub', :http_sync => true)
end
# ------------

sleep
