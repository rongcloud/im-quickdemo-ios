# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'im-quickdemo-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for im-quickdemo-ios
  # RongCloud SDK
    pod 'RongCloudOpenSource/IMKit', '5.38.0'
    pod 'RongCloudOpenSource/Sight', '5.38.0'
    pod 'RongCloudOpenSource/LocationKit', '5.38.0'

  # Other
    pod 'IQKeyboardManager', '6.5.11'
    pod 'SVProgressHUD'
    pod 'SDWebImage', '5.11.1'
    pod 'Masonry', '1.1.0'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
