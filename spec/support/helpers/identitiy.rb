module Helpers
  module Identity
    module FeatureTests
      def sign_in_as(user)
        origin_path = current_path
        visit sign_in_path

        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_on "Sign in"

        assert_text "Signed in successfully"

        visit origin_path
      end
    end

    module ControllerTests
      def sign_in_as(user)
        session = user.sessions.create!
        cookies.signed.permanent[:session_token] = { value: session.id, httponly: true }
        user
      end
    end

    module RequestTests
      def sign_in_as(user)
        post(sign_in_path, params: { email: user.email, password: user.password })
        user
      end
    end
  end
end