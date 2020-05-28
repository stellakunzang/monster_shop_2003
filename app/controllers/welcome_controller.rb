class WelcomeController < ApplicationController

  def index
    # if current_user
    #   route = determine_route(current_user)
    #
    #   redirect_to route
    # end
  end

  def determine_route(user)
    {
      "admin" => "/admin",
      "merchant" => "/merchant",
      "default" => "/profile"
    }[user.role]
  end
end
