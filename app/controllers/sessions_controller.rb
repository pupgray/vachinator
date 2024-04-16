# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  before_action :set_session, only: :destroy
  before_action :set_user, only: :create

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new; end

  def create
    if @user
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: I18n.t('signed_in_successfully')
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: I18n.t('that_email_or_password_is_incorrect')
    end
  end

  def destroy
    @session.destroy
    cookies.signed.permanent[:session_token] = nil
    redirect_to(sessions_path, notice: I18n.t('that_session_has_been_logged_out'))
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end

  def set_user
    @user = User.authenticate_by(email: params[:email], password: params[:password])
  end
end
