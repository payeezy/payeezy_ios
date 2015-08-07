Pod::Spec.new do |s|
  s.name             = "PayeezySDK"
  s.version          = '2.0.0'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.homepage         = 'https://developer.payeezy.com/'
  s.authors          = { 'Payeezy' => 'support@payeezy.com' }
  s.summary          = "The Payeezy iOS SDK support secure In-App payments via Apple's Apple Pay technology."
  s.source           = { :git => 'https://github.com/payeezy/payeezy_ios.git', :tag => "#{s.version}" }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files      = 'sdk/**/PayeezySDK.{h,m}', 'sdk/**/SBJson*.*'
end
