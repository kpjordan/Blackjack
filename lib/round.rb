require_relative "card"
require_relative "hand"
require_relative "chatter"
require_relative "bank"

class Round
	attr_reader :round_results, :cards_in_play

	def initialize(bank, chatter, number_of_decks)
		@player 				 = [Hand.new]
		@dealer 				 = Hand.new
		@number_of_decks = number_of_decks
		@cards_in_play	 = {}
		@bank	    	     = bank
		@chatter				 = chatter
		@round_results	 = []
	end
	
# "deck" functions
	
	def initial_deck_function(hand)
		2.times do hand.deal_card
		end
		hand.cards_in_hand.each do |card|
			card_name = card.name
			card_counter(card_name)
			same_cards = @cards_in_play[card_name]
			if same_cards > @number_of_decks
				@cards_in_play[card_name] -= 1
				card_replacer(hand, card)
				deal_deck_function(hand)
			end
		end
		hand.set_hand_value
	end

	def deal_deck_function(hand)
		last_card = hand.cards_in_hand.last
		last_card_name = last_card.name
		card_counter(last_card_name)
		new_card_total = @cards_in_play[last_card_name]
		until new_card_total <= @number_of_decks
			@cards_in_play[last_card_name] -= 1
			card_replacer(hand, last_card)
			last_card = hand.cards_in_hand.last
			last_card_name = last_card.name
			card_counter(last_card_name)
			new_card_total = @cards_in_play[last_card_name]
		end
	end
	
	def card_replacer(hand, card)
		hand.cards_in_hand.delete(card)
		hand.cards_in_hand << Card.new
	end
			
	def card_counter(card_name)
		if @cards_in_play.has_key?(card_name)
			@cards_in_play[card_name] += 1
		else 
			@cards_in_play[card_name] = 1
		end 
	end
	
	def new_card_manager(hand)
		hand.deal_card
		deal_deck_function(hand)
		hand.dealt_card_value_function
	end
	
# Gameplay functions


  
	def deal_a_card?(hand)
		response = ""
		until response == "Y" || response == "N"
		@chatter.another_card
		response = gets.chomp.upcase
		end
		until response == "N"
			new_card_manager(hand) if response == "Y"
			break if hand.hand_value >= 21
			puts "\n\n"
			hand.show_hand
			@chatter.another_card
			response = gets.chomp.upcase
		end 
	end
	
	def dealer_cards(dealer)	
		until dealer.hand_value > 16	
			new_card_manager(dealer)
		end
	end
	
	def show_player_cards(hands_array)
		hands_array.each do |hand|
			hand.show_hand
			puts "\n\n"
		end
	end
	
	def show_all_cards(hands_array, dealer)
		show_player_cards(hands_array)
		@chatter.dealer_has
		dealer.show_hand
		puts "\n\n"
	end
	
# win/lose params
	
	def win?(hand, dealer)
	  return true if (hand.hand_value < 21 && dealer.hand_value > 21) || 
									 (hand.hand_value > dealer.hand_value && hand.hand_value < 21) || 
									 (hand.hand_value == 21 && hand.cards_in_hand.size != 2 && dealer.hand_value != 21 )
   end  
		
	def lose?(hand, dealer)	
		return true if (hand.hand_value > 21 && dealer.hand_value < 21) || 
									 (hand.hand_value < dealer.hand_value && dealer.hand_value < 21) || 
									 (dealer.hand_value == 21 && hand.hand_value != 21)
	end
		
	def draw?(hand, dealer)
		return true if (hand.hand_value > 21 && dealer.hand_value > 21) ||
										(hand.hand_value == dealer.hand_value)
									
	end

	def is_blackjack?(hand, dealer)
		return true if hand.hand_value == 21 && hand.cards_in_hand.size == 2 && dealer.hand_value != 21
	end
	
# Main functions
	
	def play_round(hands_array, dealer)
		hand1 = hands_array[0]
		unless hand1.hand_value == 21
			deal_a_card?(hand1)
			dealer_cards(dealer) if hand1.hand_value < 21
		end
	end
	
	def start_round(hands_array, dealer)
		hand1 = hands_array[0]
		[hand1, dealer].each { |hand| initial_deck_function(hand)}
		@chatter.player_has
		hand1.show_hand
		@chatter.dealer_has
		dealer.one_face_down
	end	
		
	def end_of_round(hands_array, dealer)
		show_all_cards(hands_array, dealer)
		get_round_results(hands_array, dealer)
	end
	
	def get_round_results(hands_array, dealer)
		hands_array.each do |hand| 
			case
			when win?(hand, dealer) then @round_results << "win"
			when lose?(hand, dealer) then @round_results << "lose"
			when draw?(hand, dealer) then @round_results << "draw"
			when is_blackjack?(hand, dealer) then @round_results << "win_b"  
			end
		end
	end
	
	def run
		start_round(@player, @dealer)
		play_round(@player, @dealer)
		end_of_round(@player, @dealer)
	end

end