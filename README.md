# PGMappingKit

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/PGMappingKit.svg?style=flat)](http://cocoapods.org/pods/PGMappingKit)
[![License](https://img.shields.io/cocoapods/l/PGMappingKit.svg?style=flat)](http://cocoapods.org/pods/PGMappingKit)
[![Platform](https://img.shields.io/cocoapods/p/PGMappingKit.svg?style=flat)](http://cocoapods.org/pods/PGMappingKit)

**PGMappingKit** helps you parsing a JSON response and getting it into Core Data. It is built on top of [AFNetworking 3](https://github.com/AFNetworking/AFNetworking).

## Requirements

- iOS 8.0+
- Xcode 7.2+

## Installation

### Carthage

Source is available throught [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```ogdl
github "PlotGuru/PGMappingKit"  ~> 1.0
```

### CocoaPods

Source is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'PGMappingKit', '~> 1.0'
```

## Example

Assuming you have the Core Data model shown in the image below.

![](https://cloud.githubusercontent.com/assets/3337361/12500157/6a3871ca-c065-11e5-9469-4fa5c62b6925.png)

Assuming you have the following JSON that can be retrieved from `www.example.com/user`.

```json
[
  {
    "id": 6,
    "name": "Justin Jia",
    "posts": [
      {
        "id": 0,
        "text": "Hello, PGMappingKit!"
      }
    ]
  }
]
```

You can retreive, parse the JSON response and get it into Core Data by using the following code:

```objc
// Initialize Network Handler

PGNetworkHandler *networkHandler = [PGNetworkHandler alloc] initWithBaseURL:[NSURL URLWithString:@"www.example.com"]];

// Describe Relationship

PGMappingDescription *postMapping = [PGMappingDescription name:@{@"posts": PGEntity(Post)}
                                                            ID:@{@"id": PGAttribute(Post, uniqueID)}
                                                       mapping:@{@"text": PGAttribute(Post, text)}];
PGMappingDescription *userMapping = [PGMappingDescription name:@{@"": PGEntity(User)}
                                                            ID:@{@"id": PGAttribute(User, uniqueID)}
                                                       mapping:@{@"name": PGAttribute(User, username),
                                                                 @"posts": postMapping}];

// Perform GET Request

[self.networkHandler GET:@"user"
                     from:nil
                     to:context
                     mapping:userMapping
                     option:PGSaveOptionUpdate
                     progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nonnull results) {
        // Finish Login
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Show Error
    } finish:^(NSURLSessionDataTask * _Nullable task) {
        // Refresh UI
}];
```

## Credits

PGMappingKit is owned by [Plot Guru](http://www.plotguru.com).

PGMappingKit is maintained by [Justin Jia](https://github.com/justinjiadev/) and [Hooman Mohammadi](https://github.com/hooman96).

PGMappingKit was originally created by [Justin Jia](https://github.com/justinjiadev/) in the development of [Plot Guru for iOS](https://itunes.apple.com/app/id964629606).

## Licensing

PGMappingKit is released under the MIT license. See LICENSE for details.
