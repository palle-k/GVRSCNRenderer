# GVRSCNRenderer

[![license](https://img.shields.io/github/license/palle-k/GVRSCNRenderer.svg)](https://github.com/palle-k/GVRSCNRenderer/blob/master/LICENSE)

Combines Google Cardboard with SceneKit Rendering and ARKit 6DOF World Tracking.

![Cardboard+ARKit](https://raw.githubusercontent.com/palle-k/GVRSCNRenderer/master/img/cardboard-arkit.gif)

## Installation

Installation using CocoaPods is currently unavailable, as static libraries are required, which are incompatible with Swift Pods.
The pod will be available when CocoaPods 1.4 is released, which adds support for static swift libraries.

To use this library using CocoaPods, update to 1.4 using `gem install cocoapods --pre` and use this library as a development pod:

1. Clone this repository

2. Add this library as a development pod:

```ruby
target 'Your-App-Name' do
  use_frameworks!
  pod 'GVRSCNRenderer', :path => '/path/to/GVRSCNRenderer/'
end
```

## Usage

Builds on top of `GVRRenderer` from `GVRKit`, which is part of the Google VR SDK for iOS.

### Basic Setup

```swift
import GVRKit
import GVRSCNRenderer

// Create scene:
let scene: SCNScene = ...

// For SceneKit Rendering without world tracking:
let renderer = GVRSCNRenderer(scene: scene)

// For 6DOF Tracking:
let renderer = GVRSCNARTrackingRenderer(scene: scene)

// Create Cardboard view and pass renderer
let view = GVRRendererView(renderer: renderer)
```

### Event Handling

Cardboard trigger events can be handled by the interaction delegate:

```swift
renderer.interactionDelegate = yourEventHandler

extension YourEventHandler: GVRSCNInteractionDelegate {
	func didTrigger(_ renderer: GVRSCNRenderer, headTransform: SCNMatrix4) {
		// Handle trigger event
	}
}
```

### Render Loop Customization

The render loop can be customized using a `SCNSceneRendererDelegate`:

```swift
renderer.rendererDelegate = yourRendererDelegate

extension YourRendererDelegate: SCNSceneRendererDelegate {
	// ...
}
```

### Showing Tracking Features

Tracking features can be shown to signal nearby objects in the real world to the user to avoid collisions (`GVRSCNARTrackingRenderer` only):

```swift
renderer.showsTrackingFeatures = true
```

Customizing feature indicators:

```swift
// Set tracking feature size in meters (e.g. 0.001 == 1mm)
renderer.trackingFeatureSize = ...

// Set tracking feature material
renderer.trackingFeatureMaterial = ...
```

---

3D Model in demo GIF: [Rempart Walls scenery 1 - Fougères castle](https://sketchfab.com/models/ac1367f3ec3d48c4b6a56e0117f20761) by [noxfcna](https://sketchfab.com/noxfcna) is licensed under [CC Attribution](http://creativecommons.org/licenses/by/4.0/)
