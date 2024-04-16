# frozen_string_literal: true

module Helpers
  module Mailer
    include ActionMailer::TestHelper

    class EmailFuckedUpOrGoneError < StandardError; end

    ParsedEmail = Struct.new(:mail, :html) do
      def find_link_url(text)
        if blank?
          raise EmailFuckedUpOrGoneError,
                'Cant find link because email was unparseable or does not exist'
        end

        link = html.at("a:contains('#{text}')")

        raise EmailFuckedUpOrGoneError, "A link containing '#{text}' does not exist" unless link

        link['href'] || nil
      end

      delegate :subject, to: :mail

      def present?
        mail.present? && html.present?
      end
    end

    def find_mail_to(email)
      expect(ActionMailer::Base.deliveries.count).to be >= 1

      mail = ActionMailer::Base.deliveries.find { |delivery| delivery.to.include?(email) }
      html = mail.present? ? Nokogiri::HTML(mail.body.to_s) : nil

      ParsedEmail.new mail, html
    end

    def await_mailing(&)
      assert_emails(ActionMailer::Base.deliveries.count + 1, &)
    end
  end
end
