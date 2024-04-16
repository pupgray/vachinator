# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :authenticate

  private

  def authenticate
    return if Current.session.present?

    redirect_to sign_in_path
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip

    return unless (session_record = Session.find_by(id: cookies.signed[:session_token]))

    Current.session = session_record
  end
end
