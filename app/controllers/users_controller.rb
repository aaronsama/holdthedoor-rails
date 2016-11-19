class UsersController < ApplicationController

  def profile
    @user = current_user
    render 'show'
  end

end
