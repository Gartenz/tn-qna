class UsersController < ApplicationController
  def finish_signup
    @user = User.find(params[:id])
  end
end
