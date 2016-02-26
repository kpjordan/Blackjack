require_relative "bank"

# Almost all of the dialog is here. 

class Chatter
	
	def initialize(bank)
		@bank = bank
	end
	
#game intro and explanation of rules
	
	def greeting
		puts "--- Welcome to K's MINIMALIST BLACKJACK!!!1! ---\n\n\n"
		puts "(Because if I call the whole text thing \"minimalist\","
		puts "then it's \"stylish\". And not \"slightly disappointing\")"
	end
	
	def hear_rules
		puts "Would you like an explanation of the rules? Y/N"
	end
	
	def no_rules
		puts "Okay then! Have it your way."
	end
	
	def rules1
		space
		puts "Default is simple rules, but you can be fancy."
		puts "Right now available fancy rules are:\n"
		puts "splitting pairs, doubling down, and insurance."
		space
	end
	
	def rules2
		space
		puts "Splitting pairs means you can split two cards of equal value into new hands."
		puts "You can currently split three times. THREE!!"
		puts "This means you can play with up to four hands."
		puts "The new hand gets a bet equal to your original."
		puts "If you split aces you can only draw one card on each. No more splits."
		space
	end
	
	def rules3
		space
		puts "Doubling down means you can double your initial bet if" 
		puts "your hand equals 9, 10, or 11"
		puts "You can only draw one additional card."
		puts "It also means you're an overconfident hot-dog, but I'm not judging."
		space
	end
	
	def rules4
		space
		puts "Insurance means you make a side bet equal to half your original bet"
		puts "if the dealer has an ace showing. Because you think they have a blackjack."
		puts "It's a way to offset what you think may be a loss."
		puts "Also everything you read says you probably shouldn't do this."
		puts "I say live by your own rules. Be a lone wolf. A loose cannon."
		space
	end
	
	def rules5
		space
		puts "If you opt out of fanciness then things are very basic."
		puts "You draw two cards, dealer draws two cards, one card is face down."
		puts "The objctive is to hit 21, or have the highest hand value without"
		puts "going over 21. If you are dealt 21 at the start that's a blackjack!"
		puts "You draw until you go over, hit 21 or stop."
		puts "The dealer will keep drawing until they are over a value of 16."
		space
	end
	
	def enter
	  puts "Press enter to continue!"
		response = gets.chomp
	end
	
	def rules_explainer
		rules1
		enter
		rules2
		enter
		rules3
		enter
		rules4
		enter
		rules5
	end
	
	def fancy?
		puts "So? Fancy rules?? Y/N?"
	end
	
# betting dialog
	
	def initial_bet
		puts "Minimum wager is 10 Monies, maximum is 100 Monies."
		puts "All wagers must be made in increments of 10."
		puts "You currently have #{@bank.moneypool} Monies."
		puts "What is your wager?"
	end
	
	def invalid_wager
		puts "\nThat's an invalid wager and you know it. You should be ashamed. Try again."
	end
	
	def your_wager
		puts "\nYou wagered #{@bank.init_wager} Monies."
	end
	
# basic gameplay dialog
	
	def space
		puts "\n\n----------***-----***-----***----------\n\n"
	end
		
	def player_has
		puts "\n\nHere's what you got:\n\n"
	end	
		
	def dealer_has
		puts "\n\nThe Dealer has:\n\n"
	end
	
	def another_card
		puts "\nDraw another card? Y/N"
	end
	
# "fancy" rules dialog
	
	def you_cant(rule)
		puts "You can't #{rule} because you don't have enough to cover the bet!"
	end
	
	def dbl_dn
		puts "Hey! You can double down on this hand. You wanna double down?\n\n"
	end
	
	def spl_pair
		puts "That's a pair! You wanna split that pair?\n\n"
	end
	
	def insurance
		puts "The dealer is showing an ace!! That could be a blackjack."
		puts "Feeling unlucky? Want insurance?\n\n"
	end
	
# round result(s) dialog
	
	def you_win
		puts "You win! You now have #{@bank.moneypool} Monies! Woooo!!"
	end
	
	def you_win_b
		puts "Oh you got that blackjack business! That's the good business!!"
		puts "You now have #{@bank.moneypool} Monies."
		puts "You are legally obligated to send me some."
	end
	
	def you_lose
		puts "You lose. You now have #{@bank.moneypool} Monies. Please don't cry on your keyboard."
  end

	def a_draw
		puts "A draw. You now have #{@bank.moneypool} Monies. That was a waste of time."
	end	
	
	def ins_winner
		puts "You won on that insurance bet though. That's something."
		puts "You now have #{@bank.moneypool} Monies."
	end
	
	def ins_loser
		puts "You lost your insurance bet. Womp womp."
		puts "You have #{@bank.moneypool} Monies."
	end

# round wrap-up dialog
		
	def another_round
		puts "So you want to play more MINIMALIST BLACKJACK?"
		puts "(Come on, say yes. Please?)"
		end
	
	def get_out
		puts "Hey! You don't have enough Monies to make the minimum wager."
		puts "Get out, deadbeat!"
	end		
	
end
