require "active_support"
require "active_support/lazy_load_hooks"
require "actionpack/per_form_csrf_tokens/request_forgery_protection"
require "actionpack/per_form_csrf_tokens/version"

ActiveSupport.on_load(:action_controller) do
  include(ActionPack::PerFormCsrfTokens::RequestForgeryProtection)
end
