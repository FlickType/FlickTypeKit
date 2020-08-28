# FlickTypeKit Technical Notes


## Unable to deploy to device via Xcode

Make sure `RemoveHeadersOnCopy` is enabled for FlickTypeKit.xcframework (you might have to manually edit your project file). See [this commit](https://github.com/FlickType/FlickTypeKit/commit/b1e84d46d4f3d13e35a1941b65ab48f634bc24e3) for more information.

## Objective-C

If your project is in Objective-C, make sure [Always Embed Swift Standard Libraries](https://indiestack.com/2017/03/implicit-swift-dependencies/) is set to YES for the watch extension target. You can also watch this [integration tutorial](https://www.youtube.com/watch?v=f7TkCE7gaDc)._


