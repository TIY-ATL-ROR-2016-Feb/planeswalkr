class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      mail = WelcomeMailer.welcome(@user)
      mail.deliver_now
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    render :index
  end

  private
  def user_params
    params.permit(:full_name, :email, :password)
  end
end
