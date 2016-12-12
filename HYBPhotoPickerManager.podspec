Pod::Spec.new do |s|
  s.name                  = "HYBPhotoPickerManager"
  s.version               = "1.0.2"
  s.summary               = "HYBPhotoPickerManager 是来自于 http://blog.csdn.net/woaifen3344/article/details/41980837 的代码, 这里是有 pod 管理, thx 标哥"
  s.homepage              = "https://github.com/tpctt/HYBPhotoPickerManager"
  s.social_media_url      = "https://github.com/tpctt/HYBPhotoPickerManager"
  s.platform     = :ios,'6.0'
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { " tim" => "491590253@qq.com" }
  s.source                = { :git => "https://github.com/tpctt/HYBPhotoPickerManager.git",:tag => s.version.to_s 
    #:commit => "cebd0fe6d6a0e087cf7d5ed86a572d31f9e8af14" 
    }
  s.source_files = 'Classes/**/*.{h,m,mm}'
  #s.resources   = "YMCitySelect/*.{png,bundle}"

  s.ios.deployment_target = "6.0"
  s.requires_arc          = true
  s.framework             = "CoreFoundation","Foundation","CoreGraphics","UIKit"
  # s.library		= "z.1.1.3","stdc++","sqlite3"
 
  #s.subspec 'HYBPhotoPickerManager' do |sp|
  #sp.source_files = 'YMCitySelect/*.{h,m,mm}'
  #  sp.resources   = "Extend/**/*.{png}"
    # sp.requires_arc = true
    # sp.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libz, $(SDKROOT)/usr/include/libxml2', 'CLANG_CXX_LANGUAGE_STANDARD' =>  #'gnu++0x', 'CLANG_CXX_LIBRARY' => 'libstdc++', 'CLANG_WARN_DIRECT_OBJC_ISA_USAGE' => 'YES'}
   
  #  sp.dependency 'FontIcon'
   # sp.prefix_header_contents = '#import "EasyIOS.h"'
#  end
end
