require_relative "card"
# The Hand is a structure to generate cards, hold cards, and determine their value
# The Player can have multiple hands, the Dealer is one hand.

class Hand
	attr_accessor :hand_value, :cards_in_hand, :ace_counter
	
	def initialize
	  @ace_counter = 0
	  @cards_in_hand = []
		@hand_value = 0
	end
	
	def iterator
		@cards_in_hand.each do |card|
			yield card
		end
	end
	
	def set_hand_value
	  iterator do |card|
	    @hand_value += card.card_value  
			ace_count_increase(card)
		end
		ace_handler
	end

	def show_hand
		iterator { |card| puts card.name }
		puts @hand_value
	end
	
	def one_face_down
		puts @cards_in_hand.last.name
		puts "???"
	end
	
	def deal_card
	 @cards_in_hand << Card.new
	end
	
	def dealt_card_value_function
	  @hand_value += @cards_in_hand.last.card_value
		ace_count_increase(@cards_in_hand.last)
	  ace_handler
	end

# Aces automatically flip bewteen a value of 11 and 1 when the Hand's value exceeds 21

	def ace_count_increase(card)
		@ace_counter += 1 if card.rank == "Ace"
	end
	
	def ace_handler
		if @hand_value > 21 && @ace_counter > 0
	    @ace_counter -= 1
		  @hand_value -= 10
	  end
	end
end
