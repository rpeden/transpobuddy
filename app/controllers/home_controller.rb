
class HomeController < ApplicationController
	before_filter :check_mobile
	def index
		
	end

private
	
	def check_mobile
		if user_is_mobile? then redirect_to '/mobile' end
	end

	def user_is_mobile?
		request.user_agent =~ /iPhone|iPad|iPod|Android/i
	end

end
