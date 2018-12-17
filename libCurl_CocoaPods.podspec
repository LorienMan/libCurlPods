Pod::Spec.new do |spec|
  spec.name         = 'libCurl_CocoaPods'
  spec.version      = '7.60'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/LorienMan/libCurl_CocoaPods'
  spec.authors      = { 'LorienMan' => 'https://github.com/LorienMan' }
  spec.summary      = 'Compiled libCurl to be used via CocoaPods'
  spec.source       = { :git => 'https://github.com/LorienMan/libCurl_CocoaPods.git', :tag => '7.60' }
  spec.platforms = {
        'ios': '9.0'
  }

  spec.source_files = 'curl/*.h'
  spec.vendored_libraries = 'libcurl.a'
end