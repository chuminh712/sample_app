class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      activate user
    else
      flash.now[:danger] = t ".log_in_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t ".log_out_success"
    redirect_to login_path
  end

  private

  def activate user
    if user.activated?
      log_in user
      check_remember_me user
      flash[:success] = t ".log_in_success"
      redirect_back_or user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_url
    end
  end
end
