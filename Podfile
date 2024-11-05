

source 'https://github.com/CocoaPods/Specs.git'

target 'ChatFlow' do
  platform :ios, '18.0'

  use_frameworks!
  inhibit_all_warnings!
  
  pod 'RealmSwift', '10.49.0'
  
  target 'ChatFlowTests' do
    inherit! :search_paths
    
    end
  end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
    end
  end
end
