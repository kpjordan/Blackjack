class Card
	attr_reader :name, :card_value, :rank
	
	SUITS = ["Hearts","Spades","Diamonds","Clubs"]
	RANKS = [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"]
	
#Card is randomly assigned a suit and rank as it is generated. There is no "deck"
			
	def initialize
	  @suit = SUITS[rand(4)]
	  @rank = RANKS[rand(13)]
	  set_name
	  set_card_value
	end
	
	def set_card_value
	  case(rank)
	  when (2..10) then @card_value = @rank
		when 'Jack', 'Queen', 'King' then @card_value = 10
		when 'Ace' then @card_value = 11
	  end
	end
	
	def set_name
	  @name = "#{@rank} of #{@suit}"
	end
end
