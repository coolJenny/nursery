class WebinarController < ApplicationController
  layout "register"
  
  def show
    @schedule = Schedule.find_by_token(params[:id])
  end

  def authenticate
    user = User.find_by_email(params[:user][:email])
    if user.valid_password?(params[:user][:password])
      sign_in user
      redirect_to "/dashboard"
    else
      flash[:alert] = "wrong password"
      redirect_to :back
    end
  end

end
