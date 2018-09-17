Pod::Spec.new do |spec|
  spec.name = 'SKWebServiceController'
  spec.version = '2.1.0'
  spec.license = 'MIT'
  spec.summary = 'A barebones network controller.'
  spec.homepage = 'https://github.com/skladek/SKWebServiceController'
  spec.authors = { 'Sean Kladek' => 'skladek@gmail.com' }
  spec.source = { :git => 'https://github.com/skladek/SKWebServiceController.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Source/*.swift'
end
