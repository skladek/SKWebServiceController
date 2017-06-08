Pod::Spec.new do |spec|
  spec.name = 'WebServiceController'
  spec.version = '0.0.1'
  spec.license = 'MIT'
  spec.summary = 'A barebones network controller.'
  spec.homepage = 'https://github.com/skladek/WebServiceController'
  spec.authors = { 'Sean Kladek' => 'skladek@gmail.com' }
  spec.source = { :git => 'https://github.com/skladek/WebServiceController.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Source/*.swift'
end
