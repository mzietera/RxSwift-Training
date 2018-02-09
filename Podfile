# Config
use_frameworks!
platform :ios, '9.0'

target 'RxSwiftTraining' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  # Pods for RxSwiftTraining
  pod 'RxSwift', '~> 4.1.1'
  pod 'RxCocoa', '~> 4.1.1'
end

target 'RxSwiftTrainingTests' do
    inherit! :search_paths
    # Pods for testing
end

# enable tracing resources
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D',
'TRACE_RESOURCES']
        end
      end 
    end
  end 
end
