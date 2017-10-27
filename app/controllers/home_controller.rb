class HomeController < ApplicationController
  def hello
    @time = Time.now
    # @users = User.all
  end
end
