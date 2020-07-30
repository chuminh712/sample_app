class FollowersController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "users.followers"
    @users = @user.followers.page(params[:page]).per Settings.kaminari.page
    render "users/show_follow"
  end
end
