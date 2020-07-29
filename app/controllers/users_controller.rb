class UsersController < ApplicationController
  before_action :load_user, :correct_user, only: %i(show edit update)
  before_action :logged_in_user, except: %i(show new create)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.kaminari.page
  end

  def show
    @microposts = @user.microposts.page(params[:page])
      .per Settings.kaminari.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "account_activation.flash_activate"
      redirect_to root_path
    else
      flash[:danger] = t ".new.sign_up_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
      redirect_to users_url
    else
      flash[:danger] = t ".delete_failed"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.get_error"
    redirect_to root_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
