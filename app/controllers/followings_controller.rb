class FollowingsController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "users.following"
    @users = @user.following.page(params[:page]).per Settings.kaminari.page
    render "users/show_follow"
  end
end
