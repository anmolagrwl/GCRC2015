
$pubnub = Pubnub.new(
          :publish_key => 'pub-c-67b64f52-9ac9-42df-9803-55fc0a646b22',
          :subscribe_key => 'sub-c-49d69172-3e94-11e4-8c81-02ee2ddab7fe',
          :error_callback   => lambda { |msg|
            puts "Error callback says: #{msg.inspect}"
          },
          :connect_callback => lambda { |msg|
            puts "CONNECTED: #{msg.inspect}"
          }
        )

begin
  PubnubLed::Application.config.board = Dino::Board.new(Dino::TxRx.new)
  
rescue Dino::BoardNotFound
  puts 'The board is not connected'
end
