platform :ios, '15.0'

target 'im-quickdemo-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for im-quickdemo-ios
  # RongCloud SDK
    pod 'RongCloudIM', '5.42.0'


  # Other
    pod 'IQKeyboardManager', '6.5.11'
    pod 'SVProgressHUD', '2.2.5'
    pod 'SDWebImage', '5.11.1'
    pod 'Masonry', '1.1.0'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  end
 end
end
