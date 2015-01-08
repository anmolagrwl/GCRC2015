# LITTLE BUGGY!!!
# List all gems that are required.
require 'rubygems'
require 'bundler/setup'
require 'dino'
require 'mail'

# Setup the hardware with their pins specified.
board = Dino::Board.new(Dino::TxRx::Serial.new)
sensor = Dino::Components::Sensor.new(pin: 'A0', board: board)
led = Dino::Components::Led.new(pin: 1, board: board)

# Initially set the led off.
led.send(:off)

# Initializing and setting up the mail variable.
# ------------
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => 'gcrcbangalore@gmail.com',
            :password             => 'gardencity',
            :authentication       => 'plain',
            :enable_starttls_auto => true  
        }
Mail.defaults do
  delivery_method :smtp, options
end

mail = Mail.new do
  from    'gcrcbangalore@gmail.com'
  to      'gcrcbangalore@gmail.com'
  subject 'Message from your Package Delivery Detector'
  body    'You got a package!'
end
# ------------

package_status = 0 # Keeps in check the value of whether package has been recived or not. 0: Not recieved/picked up, 1: Package recieved
email_status = 0 # Keeps in check the value of whether email has been sent or not. 0: Not sent, 1: Sent

sensor.when_data_received do |data|
	puts data

	d = data.to_i

	# Logic of what to do on client side when message is analysed.

	# If pressure sensor senses some weight/package on it + initially package was not recieved + email wasn't sent
	if (d > 0) && (package_status == 0) && (email_status == 0)
		led.send(:on) # Turn led on.
		package_status = 1 # Package recieved.
		mail.deliver! # Send the email.
		email_status = 1 # Email sent.
	else
		led.send(:off) # Turn led off.
		package_status = 0 # Package was picked up and reset.
		email_status = 0 # Email was seen and reset.
	end
end

sleep


# (d == 0) && (package_status == 1) && (email_status == 1)
