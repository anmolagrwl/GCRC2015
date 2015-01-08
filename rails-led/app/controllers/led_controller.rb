class LedController < ApplicationController
  before_action :set_up_led, only: [:on, :off]

  def index
  
  end

  def on
    @led.send(:on)
    flash[:notice] = "LED is on"
    redirect_to root_path
  end

  def off
    @led.send(:off)
    flash[:notice] = "LED is off"
    redirect_to root_path
  end

  private

    def set_up_led
      @led = Dino::Components::Led.new(pin: 1, board: PubnubLed::Application.config.board)
    end 
end
