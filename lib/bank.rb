# The Bank functions as a simple holding place for the game's "money"

class Bank
	attr_accessor :moneypool, :wagers, :init_wager

	def initialize
		@moneypool = 100
		@init_wager = 0
		@wagers = []
	end
	
end
