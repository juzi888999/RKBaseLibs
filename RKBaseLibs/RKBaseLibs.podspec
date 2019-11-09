#
#  Be sure to run `pod spec lint RKBaseLibs.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "RKBaseLibs"
  spec.version      = "1.0.31"
  spec.summary      = "app的Object-C基础框架"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "no desc"

  spec.homepage     = "https://github.com/juzi888999/RKBaseLibs"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "juzi888999" => "juzi888999@gmail.com" }
  # Or just: spec.author    = "juzi888999"
  # spec.authors            = { "juzi888999" => "email@address.com" }
  # spec.social_media_url   = "https://twitter.com/juzi888999"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #




  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

#远程仓库使用这个
  spec.source       = { :git => "https://github.com/juzi888999/RKBaseLibs.git", :tag => spec.version.to_s}
  spec.source_files  = "RKBaseLibs/RKBaseLibs/Classes/*.{h,m}", "RKBaseLibs/RKBaseLibs/Classes/**/*.{h,m}","RKBaseLibs/RKBaseLibs/Classes/**/**/*.{h,m}","RKBaseLibs/RKBaseLibs/Classes/**/**/**/*.{h,m}","RKBaseLibs/RKBaseLibs/Classes/**/**/**/**/*.{h,m}"
  spec.exclude_files = "RKBaseLibs/Exclude"
  spec.prefix_header_file = "RKBaseLibs/RKBaseLibs/Classes/Configration/RKPrefixHeader.pch"

#本地仓库使用这个
  # spec.source       = { :git => "", :tag => spec.version.to_s}
  # spec.source_files  = "RKBaseLibs/Classes/*.{h,m}", "RKBaseLibs/Classes/**/*.{h,m}","RKBaseLibs/Classes/**/**/*.{h,m}","RKBaseLibs/Classes/**/**/**/*.{h,m}","RKBaseLibs/Classes/**/**/**/**/*.{h,m}"
  # spec.exclude_files = "RKBaseLibs/Exclude"
  # spec.prefix_header_file = "RKBaseLibs/Classes/Configration/RKPrefixHeader.pch"

  # spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  spec.resources = "RKBaseLibs/RKBaseLibs/RKBaseLibs/Classes/ThirdPart/**/*.bundle","RKBaseLibs/RKBaseLibs/Classes/ThirdPart/**/**/*.bundle","RKBaseLibs/RKBaseLibs/Classes/ThirdPart/**/**/**/*.bundle","RKBaseLibs/RKBaseLibs/Classes/ThirdPart/NumberCalculate/resource/*.png","RKBaseLibs/RKBaseLibs/Classes/ThirdPart/MWPhotoBrowser/Assets/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  spec.compiler_flags = '-fno-modules'
  spec.frameworks  = "UIKit","Foundation"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  spec.dependency 'DACircularProgress', '~> 2.3.1'
  spec.dependency 'AFNetworking', '~> 2.6'
  spec.dependency 'MBProgressHUD','1.1.0'
  spec.dependency 'Nimbus','1.3.0'
  # spec.dependency 'SSKeychain','1.2.3'
  spec.dependency 'SAMKeychain', '~> 1.5.3'
  spec.dependency 'Masonry','1.1.0'
  spec.dependency 'Mantle', '1.5.4'
  spec.dependency 'XMLDictionary','1.4'
  spec.dependency 'FlatUIKit','1.6'
  spec.dependency 'MJRefresh', '~> 3.2.0'
  spec.dependency '320Categories', '~> 0.2.2'
  spec.dependency 'JHChainableAnimations', '~> 2.0.2'
  spec.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.4'
  spec.dependency 'YYKit', '~> 1.0.9'
  spec.dependency 'FMDB', '~> 2.6.2'
  spec.dependency 'DLAlertView','~>1.2.5'
  spec.dependency 'SDWebImage'
  spec.dependency 'FLAnimatedImage', '~> 1.0.12'
  spec.dependency 'AXBadgeView'
  spec.dependency 'IQKeyboardManager'
  spec.dependency 'GTMBase64', '~> 1.0.0'
  spec.dependency 'GCDTimer'
  spec.dependency 'UIButton-LXLayout', '~> 0.2'
  spec.dependency 'TZImagePickerController', '~> 3.2.1'
  spec.dependency 'BackButtonHandler', '~> 1.0.0'
  spec.dependency 'WQConsole', '~> 1.0.0'
  spec.dependency 'XHInputView'
  # spec.dependency 'YCDownloadSession', '~> 2.0.3', :subspecs => ['Core', 'Mgr']

end
