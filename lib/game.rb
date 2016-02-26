require_relative "card"
require_relative "round"
require_relative "hand"
require_relative "fancy"
require_relative "bank"
require_relative "chatter"

#Controls start-up, round type selection, and payoff.

class Game
	
	def initialize
		@round_counter = 0
		@round_type = ""
		@bank = Bank.new
		@chatter = Chatter.new(@bank)
	end
	
#Chatter stuff

	def welcome
	 @chatter.greeting
	end
	
	def round_count
	  @round_counter += 1
		puts "\nRound #{@round_counter}"
	end	
	
	def space
	 @chatter.space
	end
	
	def another_round
		@chatter.another_round
	end	
	
	def get_out
		@chatter.get_out
	end
	
	def show_rules
		@chatter.hear_rules
		response = gets.chomp.upcase
		until response == "Y" || response == "N"
			puts "\nY/N?"
			response = gets.chomp.upcase
		end
		response == "Y" ?	@chatter.rules_explainer : @chatter.no_rules
		@chatter.fancy?
	end

#Bet handling

	def initial_bet_handler
		@bank.wagers = []
		@chatter.initial_bet
		wager_input = gets.chomp.to_i
		until wager_input > 9 && wager_input < 101 && (wager_input % 10) == 0 && wager_input <= @bank.moneypool
			@chatter.invalid_wager
			wager_input = gets.chomp.to_i
		end
		@bank.init_wager = wager_input
		@bank.wagers << @bank.init_wager
		@chatter.your_wager
	end
	
	def payout_handler(results)
		wager_index = 0
		results.each do |result|
			wager = @bank.wagers[wager_index]
			case(result)
			when "win"		then @bank.moneypool += wager
												 @chatter.you_win
			when "win_b"  then @bank.moneypool += (wager + wager / 2)
												 @chatter.you_win_b	
			when "lose" 	then @bank.moneypool -= wager
												 @chatter.you_lose	
			when "draw"		then @chatter.a_draw	
			end
			wager_index += 1
		end
		if @round.class == Fancy
			if @round.ins_result == "win"
			  @bank.moneypool += @bank.init_wager / 2
			  @chatter.ins_winner
		  elsif @round.ins_result == "lose"
		  	@bank.moneypool -= @bank.init_wager / 2
		  	@chatter.ins_loser
			end
		end
	end
	
	def enough_money?
		return true if @bank.moneypool >= 10
	end
	
#Main functions

	def startup
		space
		welcome
		space
		show_rules
		response = gets.chomp.upcase
		until response == "Y" || response == "N"
			puts "\nY/N?"
			response = gets.chomp.upcase
		end
		response == "Y" ?	@round_type = "fancy" : @round_type = "normal"
	end
		
	def play
		play_again = ""
		until play_again == "N"
			@round_type == "fancy" ? @round = Fancy.new(@bank, @chatter, 6) : @round = Round.new(@bank, @chatter, 6)
			space
			round_count
			space
			initial_bet_handler
			space
			@round.run
			space
			payout_handler(@round.round_results)
			space			
			if enough_money?
				play_again = ""
				another_round
				until play_again == "Y" || play_again == "N"
					puts "\nY/N?"
					play_again = gets.chomp.upcase
				end
			else
			get_out
			break
			end
		end
	end
	
end
