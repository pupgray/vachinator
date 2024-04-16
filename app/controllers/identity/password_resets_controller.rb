# frozen_string_literal: true

module Identity
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate

    before_action :set_user, only: %i[edit update]

    def new; end

    def edit; end

    def create
      if (@user = User.find_by(email: params[:email], verified: true))
        send_password_reset_email
        redirect_to sign_in_path, notice: I18n.t('check_your_email_for_reset_instructions')
      else
        redirect_to new_identity_password_reset_path,
                    alert: I18n.t('you_can_t_reset_your_password_until_you_verify_you')
      end
    end

    def update
      if @user.update(user_params)
        redirect_to sign_in_path, notice: I18n.t('your_password_was_reset_successfully_please_sign_i')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find_by_token_for!(:password_reset, params[:sid])
    rescue StandardError
      redirect_to new_identity_password_reset_path, alert: I18n.t('that_password_reset_link_is_invalid')
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end
  end
end
