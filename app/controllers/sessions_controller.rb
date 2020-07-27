class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t ".log_in_success"
      redirect_to user
    else
      flash.now[:danger] = t ".log_in_fail"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "logout success"
    redirect_to login_path
  end
end
