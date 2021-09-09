lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "actionpack/per_form_csrf_tokens/version"

Gem::Specification.new do |spec|
  spec.name          = "actionpack-per_form_csrf_tokens"
  spec.version       = ActionPack::PerFormCsrfTokens::VERSION
  spec.authors       = ["Yuichi Goto"]
  spec.email         = ["yasaichi@users.noreply.github.com"]

  spec.summary       = "Backport of per-form CSRF tokens"
  spec.description   = "Backport of per-form CSRF tokens into Rails 4.2"
  spec.homepage      = "https://github.com/yasaichi/actionpack-per_form_csrf_tokens"
  spec.license       = "MIT"

  spec.files = Dir["CHANGELOG.md", "lib/**/*", "LICENSE.txt", "Rakefile", "README.md"]

  spec.add_dependency "actionpack", "~> 4.2"
  spec.add_dependency "activesupport", "~> 4.2"

  spec.add_development_dependency "railties"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3", "< 1.4.0"
end
