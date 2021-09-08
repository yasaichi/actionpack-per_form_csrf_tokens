require "test_helper"

module ActionPack
  module PerFormCsrfTokens
    class Test < ActionController::TestCase
      tests(::Class.new(::ActionController::Base) do
        # NOTE: Borrowed from https://github.com/rails/rails/blob/6-1-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb
        def mask_token(raw_token, urlsafe_encode)
          one_time_pad = ::SecureRandom.random_bytes(self.class::AUTHENTICITY_TOKEN_LENGTH)
          encrypted_csrf_token = xor_byte_strings(one_time_pad, raw_token)
          masked_token = one_time_pad + encrypted_csrf_token

          if urlsafe_encode
            ::Base64.urlsafe_encode64(masked_token, padding: false)
          else
            ::Base64.strict_encode64(masked_token)
          end
        end
      end)

      def setup
        @controller.send(:real_csrf_token, session)
      end

      def test_global_csrf_token_authenticity
        global_csrf_token = @controller.send(:global_csrf_token, session)

        [true, false].each do |urlsafe_encode|
          encoded_masked_token = @controller.mask_token(global_csrf_token, urlsafe_encode)
          assert @controller.send(:valid_authenticity_token?, session, encoded_masked_token)
        end
      end

      def test_perform_csrf_token_authenticity
        # NOTE: In test, `request.path` returns "/", so we need to pass "" into `action`.
        # See https://github.com/rails/rails/blob/6-1-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L389
        per_form_csrf_token = @controller.send(:per_form_csrf_token, session, action = "", "GET")

        [true, false].each do |urlsafe_encode|
          encoded_masked_token = @controller.mask_token(per_form_csrf_token, urlsafe_encode)
          assert @controller.send(:valid_authenticity_token?, session, encoded_masked_token)
        end
      end
    end
  end
end
