Pod::Spec.new do |spec|
  spec.name         = 'libCurlPods'
  spec.version      = '7.60'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/LorienMan/libCurl_CocoaPods'
  spec.authors      = { 'LorienMan' => 'https://github.com/LorienMan' }
  spec.summary      = 'Compiled libCurl to be used via CocoaPods'
  spec.source       = { :git => 'https://github.com/LorienMan/libCurl_CocoaPods.git', :tag => '7.60' }
  spec.platform     = :ios, '9.0'

  spec.source_files = ['libCurlPods.h', 'libCurlPods.m', 'curl/*.h']
  spec.public_header_files = 'curl/*.h'
  spec.vendored_libraries = 'libcurl.a'
  spec.frameworks = 'Foundation'

  spec.module_map = 'libCurlPods.modulemap'

  spec.static_framework = true
end