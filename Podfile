platform :ios, '13.0'

# Ignore warnings from pods
inhibit_all_warnings!

target 'SwiftTemplate' do
  use_modular_headers!

  # Pods for SwiftTemplate
  pod 'SnapKit'       # A Swift Autolayout DSL for iOS & OS X
  pod 'SwiftLint'     # A tool to enforce Swift style and conventions.

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
