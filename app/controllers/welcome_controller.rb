class WelcomeController < ApplicationController

  def index
  end

  def determine_route(user)
    {
      "admin" => "/admin",
      "merchant" => "/merchant",
      "default" => "/profile"
    }[user.role]
  end

end
