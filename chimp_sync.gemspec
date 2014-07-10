# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'chimp_sync'
  spec.version       = '0.0.1'
  spec.authors       = ['Pat Allan']
  spec.email         = ['pat@freelancing-gods.com']
  spec.summary       = %q{Keep MailChimp list subscriptions synchronised.}
  spec.description   = %q{Synchronise your MailChimp list subscription details with your own data.}
  spec.homepage      = 'https://github.com/inspire9/chimp_sync'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'gibbon',   '~> 1.1'
  spec.add_runtime_dependency 'panthoot', '>= 0.2.1'

  spec.add_development_dependency 'combustion',  '~> 0.5.1'
  spec.add_development_dependency 'rails',       '~> 4.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0.1'
  spec.add_development_dependency 'sqlite3',     '~> 1.3.9'
  spec.add_development_dependency 'webmock',     '~> 1.18.0'
end
