begin
  PubnubLed::Application.config.board = Dino::Board.new(Dino::TxRx.new)
  

rescue Dino::BoardNotFound
  puts 'The board is not connected'
  
end
