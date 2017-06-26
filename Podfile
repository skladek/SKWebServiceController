platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

target 'SKWebServiceController' do
	project 'SKWebServiceController.xcodeproj'
	pod 'SwiftLint', '= 0.20.0'
end

target 'SKWebServiceControllerTests' do
	workspace 'SKWebServiceController.xcworkspace'
	project 'SKWebServiceController.xcodeproj'
	pod 'Nimble', '= 7.0.0'
	pod 'Quick', '= 1.1.0'
end

target 'SampleProject' do
	project 'SampleProject/SampleProject.xcodeproj'
	pod 'SKTableViewDataSource', '= 1.0.0'
end