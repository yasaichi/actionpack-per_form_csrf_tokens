# frozen_string_literal: true

require "active_support"
require "active_support/security_utils"
require "openssl"
require "uri"

module ActionPack
  module PerFormCsrfTokens
    module RequestForgeryProtection
      GLOBAL_CSRF_TOKEN_IDENTIFIER = "!real_csrf_token"
      private_constant :GLOBAL_CSRF_TOKEN_IDENTIFIER

      private

      def compare_with_global_token(token, session)
        ::ActiveSupport::SecurityUtils.secure_compare(token, global_csrf_token(session))
      end

      def csrf_token_hmac(session, identifier)
        ::OpenSSL::HMAC.digest(
          ::OpenSSL::Digest.new("SHA256"),
          real_csrf_token(session),
          identifier
        )
      end

      def decode_csrf_token(encoded_csrf_token)
        ::Base64.strict_decode64(encoded_csrf_token)
      rescue ::ArgumentError
        ::Base64.urlsafe_decode64(encoded_csrf_token)
      end

      def global_csrf_token(session)
        csrf_token_hmac(session, GLOBAL_CSRF_TOKEN_IDENTIFIER)
      end

      def per_form_csrf_token(session, action_path, method)
        csrf_token_hmac(session, [action_path, method.downcase].join("#"))
      end

      # Override
      def real_csrf_token(session)
        session[:_csrf_token] ||= ::SecureRandom.base64(self.class::AUTHENTICITY_TOKEN_LENGTH)
        decode_csrf_token(session[:_csrf_token])
      end

      def unmask_token(masked_token)
        # Split the token into the one-time pad and the encrypted
        # value and decrypt it.
        one_time_pad = masked_token[0...self.class::AUTHENTICITY_TOKEN_LENGTH]
        encrypted_csrf_token = masked_token[self.class::AUTHENTICITY_TOKEN_LENGTH..-1]
        xor_byte_strings(one_time_pad, encrypted_csrf_token)
      end

      # Override
      def valid_authenticity_token?(session, encoded_masked_token)
        return false if encoded_masked_token.nil? || encoded_masked_token.empty? || !encoded_masked_token.is_a?(String)

        begin
          masked_token = decode_csrf_token(encoded_masked_token)
        rescue ::ArgumentError # encoded_masked_token is invalid Base64
          return false
        end

        # See if it's actually a masked token or not. In order to
        # deploy this code, we should be able to handle any unmasked
        # tokens that we've issued without error.

        case masked_token.length
        when self.class::AUTHENTICITY_TOKEN_LENGTH
          # This is actually an unmasked token. This is expected if
          # you have just upgraded to masked tokens, but should stop
          # happening shortly after installing this gem.
          compare_with_real_token(masked_token, session)

        when self.class::AUTHENTICITY_TOKEN_LENGTH * 2
          csrf_token = unmask_token(masked_token)

          compare_with_global_token(csrf_token, session) ||
            compare_with_real_token(csrf_token, session) ||
            valid_per_form_csrf_token?(csrf_token, session)
        else
          false # Token is malformed.
        end
      end

      def valid_per_form_csrf_token?(token, session)
        correct_token = per_form_csrf_token(
          session,
          request.path.chomp("/"),
          request.request_method
        )

        ::ActiveSupport::SecurityUtils.secure_compare(token, correct_token)
      end
    end
  end
end
