platform :ios, '14.5'

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

target 'PiranhaSmartCenter' do
  use_frameworks!

  # Pods for PiranhaSmartCenter
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'RealmSwift'
  pod 'NotificationBannerSwift', '~> 3.0.0'

  target 'PiranhaSmartCenterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PiranhaSmartCenterUITests' do
    # Pods for testing
  end

end
