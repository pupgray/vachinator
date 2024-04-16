# frozen_string_literal: true

module Identity
  class EmailVerificationsController < ApplicationController
    skip_before_action :authenticate, only: :show

    before_action :set_user, only: :show

    def show
      @user.update! verified: true
      redirect_to root_path, notice: I18n.t('thank_you_for_verifying_your_email_address')
    end

    def create
      send_email_verification
      redirect_to root_path, notice: I18n.t('we_sent_a_verification_email_to_your_email_address')
    end

    private

    def set_user
      @user = User.find_by_token_for!(:email_verification, params[:sid])
    rescue StandardError
      redirect_to edit_identity_email_path, alert: I18n.t('that_email_verification_link_is_invalid')
    end

    def send_email_verification
      UserMailer.with(user: Current.user).email_verification.deliver_later
    end
  end
end
