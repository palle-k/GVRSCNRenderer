# GVRSCNRenderer

[![license](https://img.shields.io/github/license/palle-k/GVRSCNRenderer.svg)](https://github.com/palle-k/GVRSCNRenderer/blob/master/LICENSE)

Combines Google Cardboard with SceneKit Rendering and ARKit World Tracking.  
Combining ARKit with Google Cardboard enables six degrees of freedom (rotation and translation) in VR:

![Cardboard+ARKit](https://raw.githubusercontent.com/palle-k/GVRSCNRenderer/master/img/cardboard-arkit.gif)

## Installation

To import this library using CocoaPods right now, update to 1.4 using `gem install cocoapods --pre` and add it as a development pod:

```ruby
target 'Your-App-Name' do
  use_frameworks!
  pod 'GVRSCNRenderer', :git => 'https://github.com/palle-k/GVRSCNRenderer.git'
end
```

(Installation directly from the pod spec repo is currently unavailable, as it is not possible to create Swift pods with static library dependencies with CocoaPods 1.3 or earlier)

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
