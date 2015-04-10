# WhoseTurn: Simple Payment Tracking for Group Lunches

### What is It?

An app to keep track of whose turn it is to pay, in a way that's moderately fair and moderably durable.

It's an evolution of a system the authors have been using on a whiteboard for years, and since it's useful for us, we hope it's useful for you.

### Credits

Geoffrey and Paul both spent some time on design and implementation as well as discussing ideas. It's not an even split, but we don't need to split hairs.

- Geoffrey Wiseman of [Codiform](http://www.codiform.com/)
- Paul Fangchen Huang

### Technology

This application is built on the following technology:

- UIKit
- Swift 1.2
- Parse SDK
- CocoaPods
- XCTest

### Build
1. Open `WhoseTurn.xcworkspace` in Xcode

2. Create Settings.plist file and add to the project

        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>ParseClientKey</key>
            <string>[PARSE_CLIENT_KEY]</string>
            <key>ParseAppId</key>
            <string>[PARSE_APP_ID]</string>
          </dict>
        </plist>

3. Run `$pod install`

4. Build with Xcode
