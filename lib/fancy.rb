require_relative "card"
require_relative "hand"
require_relative "round"
require_relative "bank"
require_relative "chatter"

#Expands on the basics of "round"

class Fancy < Round
	attr_reader :round_results, :cards_in_play, :matching_cards, :ins_result
	
	def initialize(bank, chatter, number_of_decks)
		super(bank, chatter, number_of_decks)
		@split_counter = 0
		@ins_result = ""
	end
	
	def yes?
		response = ""
		until response == "Y" || response == "N"
			puts "Y/N?"
			response = gets.chomp.upcase
		end
		if response == "Y"
			return true
		elsif response == "N"
			return false
		end
	end
	
	#split pair functions. you can split 3 times, for a total of four hands
	
	def matching_cards?(hand)
		return true if hand.cards_in_hand[0].card_value == hand.cards_in_hand[1].card_value
	end
	
	def split_pair?(hand, hands_array)
		if matching_cards?(hand) && @split_counter < 3
			if enough_money_split_dbl?(hands_array)
				puts "\nAbout Hand ##{hands_array.index(hand) + 1}...\n"
				@chatter.spl_pair
				if yes? then return true else return false end
			else
				@chatter.you_cant("split that pair")
				return false
			end
		else
			return false
		end
	end
	
	def make_new_hand(hands_array)
		hands_array << Hand.new
	end
	
	def make_new_bet
		wager = @bank.init_wager
		@bank.wagers << wager
	end
	
	def divide_matching_cards(hand1, hand2)
		hand2.cards_in_hand[0] = hand1.cards_in_hand.pop
		[hand1, hand2].each do |hand|
			hand.hand_value = 0
			hand.ace_counter = 0
			hand.dealt_card_value_function
			new_card_manager(hand)
		end
		@split_counter +=1
	end
	
	def split_aces?(hand)
		return true if hand.cards_in_hand[0].rank == "Ace" && hand.cards_in_hand[1].rank == "Ace"
	end
	
	def split_ace_play(hands_array)
		hands_array.each do |hand|
			new_card_manager(hand)
		end
	end
	
	def split_pair_play(hands_array)
		hand_num = 1
		hands_array.each do |hand|
			puts "\n\nHand ##{hand_num}\n\n"
			hand.show_hand
			play_a_hand(hand, hands_array) unless hand.hand_value == 21
			hand.show_hand
			hand_num += 1
		end
	end
	
	def all_hands_over?(hands_array)
		hands_array.any? { |hand| hand.hand_value >= 21 }
	end
	
  def split_procedure(hands_array, max_split)
		hands_array.each do |hand|
			while matching_cards?(hand) && @split_counter < max_split
				if split_pair?(hand, hands_array)
					make_new_hand(hands_array)
					make_new_bet
					divide_matching_cards(hand, hands_array.last)
					show_player_cards(hands_array)
				else
					break
				end
			end				
		end
  end
	
	#double down functions. worked into regular play here as well as split pairs
	
	def can_dbl_down?(hand)
		return true if hand.hand_value == 9 || hand.hand_value == 10 || hand.hand_value == 11
	end	
	
	def double_down_play(hand, hands_array)
		init = @bank.init_wager
		i = hands_array.index(hand)
		@bank.wagers[i] += init
		new_card_manager(hand)
	end
	
	def double_down?(hand, hands_array)
		if can_dbl_down?(hand)
			if enough_money_split_dbl?(hands_array)
				@chatter.dbl_dn
			  if yes? then return true else return false end
			else
				@chatter.you_cant("double down")
				return false
			end
		else
			return false
		end
	end
	
	def play_a_hand(hand, hands_array)
		double_down?(hand, hands_array) ?	double_down_play(hand, hands_array) : deal_a_card?(hand)
	end
	
	#money checks
	
	def get_current_total_wager
		total = 0
		@bank.wagers.each { |wager| total += wager}
		@current_total_wager = total
	end
	
	def enough_money_split_dbl?(hands_array)
		get_current_total_wager
		return true if @bank.moneypool >= @current_total_wager + @bank.init_wager
  end
	
	def enough_money_ins?
		get_current_total_wager
		return true if @bank.moneypool >= @current_total_wager + (@bank.init_wager / 2)
	end
	
#insurance functions
	
	def dealer_has_ace?(dealer)
		return true if dealer.cards_in_hand.last.rank == "Ace"
	end
	
	def insurance?(dealer)
		if dealer_has_ace?(dealer)
			if enough_money_ins?
				@chatter.insurance
				if yes? then return true else return false end
			else
				@chatter.you_cant("have insurance")
				return false
			end
		else
			return false
		end
	end
	
	def ins_procedure(dealer)
		dealer.hand_value == 21 ? @ins_result = "win" : @ins_result = "lose"
	end
	
	#the only overriden "run" function here. everything else is inherited
	
	def play_round(hands_array, dealer)
		ins_procedure(dealer) if insurance?(dealer)
		hand1 = hands_array[0]
		unless hand1.hand_value == 21
			if matching_cards?(hand1) && split_aces?(hand1)
				split_procedure(hands_array, 1)
				hands_array.size == 2 ? split_ace_play(hands_array) : play_a_hand(hand1, hands_array)
			elsif matching_cards?(hand1)
				split_procedure(hands_array, 3)
				split_pair_play(hands_array)
			else
				play_a_hand(hand1, hands_array)
			end
			dealer_cards(dealer) unless all_hands_over?(hands_array)
		end
	end
		
end
