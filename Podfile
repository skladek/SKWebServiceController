platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

target 'SKWebServiceController' do
	project 'SKWebServiceController.xcodeproj'
	pod 'SwiftLint', '= 0.27.0'
end

target 'SKWebServiceControllerTests' do
	workspace 'SKWebServiceController.xcworkspace'
	project 'SKWebServiceController.xcodeproj'
	pod 'Nimble', '= 7.3.0'
	pod 'Quick', '= 1.3.1'
end

target 'SampleProject' do
	project 'SampleProject/SampleProject.xcodeproj'
	pod 'SKTableViewDataSource', '= 2.0.0'
end