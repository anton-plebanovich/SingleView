//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import AppUtils
import UIKit

final class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Utils.value2)
    }
}

//    .../DerivedData-Release/Build/Intermediates.noindex/ArchiveIntermediates/App/BuildProductsPath/Release-iphoneos/AppUtils-Extension/AppUtils.framework/Headers/AppUtils-App-umbrella.h:17:1: error: umbrella header for module 'AppUtils' does not include header 'AppUtils-Extension-umbrella.h'
//
//                                                                                                                                                                                                                            <unknown>:0: error: could not build Objective-C module 'AppUtils'
//
//                                                                                                                                                                                                                            * [x] I've read and understood the [*CONTRIBUTING* guidelines and have done my best effort to follow](https://github.com/CocoaPods/CocoaPods/blob/master/CONTRIBUTING.md).
//
//                                                                                                                                                                                                                            # Report
//
//                                                                                                                                                                                                                            ## What did you do?
//                                                                                                                                                                                                                            I have a local podspec, let's call it `Utils`, which contains two subspecs: `Utils/Main` and `Utils/Extension` for the main app and an app extension. The app builds and runs fine, frameworks are placed in `AppUtils-Main` and `AppUtils-Extension` directories and can be imported with `import AppUtils`. However, during an archive, both frameworks are copied to one folder and so get mixed, the module file and the binary file get overridden and the archive fails.
//
//                                                                                                                                                                                                                            As a workaround I created and addition podspec but now I need to use complex imports which is cumbersome.
//                                                                                                                                                                                                                            ```
//                                                                                                                                                                                                                            #if EXTENSION
//                                                                                                                                                                                                                            import AppUtilsExtension
//                                                                                                                                                                                                                            #else
//                                                                                                                                                                                                                            import AppUtils
//                                                                                                                                                                                                                            #endif
//                                                                                                                                                                                                                            ```
//
//                                                                                                                                                                                                                            ## What did you expect to happen?
//                                                                                                                                                                                                                            To archive success.
//
//                                                                                                                                                                                                                            ## What happened instead?
//                                                                                                                                                                                                                            Archive failed.
//
//                                                                                                                                                                                                                            ## CocoaPods Environment
//
//                                                                                                                                                                                                                            ### Stack
//
//                                                                                                                                                                                                                            ```
//                                                                                                                                                                                                                            CocoaPods : 1.11.2
//                                                                                                                                                                                                                            Ruby : ruby 2.6.3p62 (2019-04-16 revision 67580) [universal.x86_64-darwin20]
//                                                                                                                                                                                                                            RubyGems : 3.1.3
//                                                                                                                                                                                                                            Host : macOS 11.6 (20G165)
//                                                                                                                                                                                                                            Xcode : 13.1 (13A1030d)
//                                                                                                                                                                                                                            Git : git version 2.30.1 (Apple Git-130)
//                                                                                                                                                                                                                            Ruby lib dir : /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib
//                                                                                                                                                                                                                            Repositories : artsy - git - https://github.com/Artsy/Specs.git @ c416b392ce39204d47ad48f34c02cfb94dc98982
//
//                                                                                                                                                                                                                            cocoapods - git - https://github.com/CocoaPods/Specs.git @ 5486b33bb6582fbfce1a86fbd026296b8620d664
//
//                                                                                                                                                                                                                            trunk - CDN - https://cdn.cocoapods.org/
//                                                                                                                                                                                                                            ```
//
//                                                                                                                                                                                                                            ### Installation Source
//
//                                                                                                                                                                                                                            ```
//                                                                                                                                                                                                                            Executable Path: /usr/local/bin/pod
//                                                                                                                                                                                                                            ```
//
//                                                                                                                                                                                                                            ### Plugins
//
//                                                                                                                                                                                                                            ```
//                                                                                                                                                                                                                            cocoapods-binary                      : 0.5.0
//                                                                                                                                                                                                                            cocoapods-deintegrate                 : 1.0.5
//                                                                                                                                                                                                                            cocoapods-disable-podfile-validations : 0.1.1
//                                                                                                                                                                                                                            cocoapods-generate                    : 2.2.2
//                                                                                                                                                                                                                            cocoapods-plugins                     : 1.0.0
//                                                                                                                                                                                                                            cocoapods-search                      : 1.0.1
//                                                                                                                                                                                                                            cocoapods-stats                       : 1.1.0
//                                                                                                                                                                                                                            cocoapods-trunk                       : 1.6.0
//                                                                                                                                                                                                                            cocoapods-try                         : 1.2.0
//                                                                                                                                                                                                                            ```
//
//                                                                                                                                                                                                                            ## Project that demonstrates the issue
//
//                                                                                                                                                                                                                            ℹ Please link to a project we can download that reproduces the issue.
//                                                                                                                                                                                                                            You can delete this section if your issue is unrelated to build problems,
//                                                                                                                                                                                                                           i.e. it's only an issue with CocoaPods the tool.
