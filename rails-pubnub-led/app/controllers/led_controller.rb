class LedController < ApplicationController
  before_action :subscribe, only: [:index]
  before_action :set_up_led

  def index
    
  end

  def on
    puts "button pressed"
    $pubnub.publish(:message => {"button_status" => "ON"}, :channel => 'button_pubnub', :http_sync => true)
 
    render :nothing => true
  end

  def off
    puts "button not pressed"
    $pubnub.publish(:message => {"button_status" => "OFF"}, :channel => 'button_pubnub', :http_sync => true)

    render :nothing => true
  end

  private

    def set_up_led
      @led = Dino::Components::Led.new(pin: 1, board: PubnubLed::Application.config.board)
    end

    def subscribe

      puts "Subscribing..."

      $pubnub.subscribe(
          :channel  => 'button_pubnub'
      ){|data|
          if data.message['button_status'] == "OFF"
            puts "turning LED OFF"
            @led.send(:off)
          elsif data.message['button_status'] == "ON"
           puts "turning LED ON"
           @led.send(:on)
         end
      }unless $pubnub.subscription_running?
    end
end
