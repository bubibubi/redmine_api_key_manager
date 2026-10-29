# frozen_string_literal: true
class RedmineApiKeysController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :find_user, only: %i[revoke rotate]

  def index
    @filter = params[:filter].to_s
    @filter = 'all' unless %w[all with_key without_key].include?(@filter)
    users = User.where(type: 'User').includes(:api_token).order(:login, :id)
    # Pagination avoids loading all accounts on large installations.
    if @filter == 'with_key'
      users = users.where(id: Token.where(action: 'api').select(:user_id))
    elsif @filter == 'without_key'
      users = users.where.not(id: Token.where(action: 'api').select(:user_id))
    end
    @user_count = users.count
    @user_pages = Paginator.new @user_count, 50, params[:page]
    @users = users.limit(@user_pages.per_page).offset(@user_pages.offset).to_a
  end

  def revoke
    token = Token.find_by(user_id: @user.id, action: 'api')
    if token
      token.destroy!
      Rails.logger.info("Redmine API key revoked by admin_id=#{User.current.id} user_id=#{@user.id} token_id=#{token.id}")
      flash[:notice] = l(:notice_api_key_revoked)
    else
      flash[:warning] = l(:notice_api_key_absent)
    end
    redirect_to redmine_api_keys_path
  end

  def rotate
    # Creating an 'api' token automatically removes the previous one (Redmine 5.0.1 Token callback).
    token = Token.create!(user: @user, action: 'api')
    Rails.logger.info("Redmine API key rotated by admin_id=#{User.current.id} user_id=#{@user.id} token_id=#{token.id}")
    flash[:notice] = l(:notice_api_key_rotated)
    redirect_to redmine_api_keys_path
  end

  private

  def find_user
    @user = User.where(type: 'User').find(params[:id])
  end
end
