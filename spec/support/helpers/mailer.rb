# frozen_string_literal: true

module Helpers
  module Mailer
    include ActionMailer::TestHelper

    class EmailFuckedUpOrGoneError < StandardError; end

    class ParsedEmail < Struct.new(:mail, :html)
      def find_link_url(text)
        raise EmailFuckedUpOrGoneError, 'Cant find link because email was unparseable or does not exist' unless present?

        link = html.at("a:contains('#{text}')")

        raise EmailFuckedUpOrGoneError, "A link containing '#{text}' does not exist" unless link

        link['href'] || nil
      end

      def subject
        mail.subject
      end

      def present?
        mail.present? && html.present?
      end
    end

    def find_mail_to(email)
      expect(ActionMailer::Base.deliveries.count).to be >= 1

      mail = ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email) }
      html = mail.present? ? Nokogiri::HTML(mail.body.to_s) : nil

      parsed_email = ParsedEmail.new mail, html
      expect(parsed_email).to be_present

      parsed_email
    end

    def await_mailing
      assert_emails ActionMailer::Base.deliveries.count + 1 do
        yield
      end
    end
  end
end