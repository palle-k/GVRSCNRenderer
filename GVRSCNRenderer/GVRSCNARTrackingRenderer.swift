//
//  GVRSCNARTrackingRenderer.swift
//  GVRSCNRenderer
//
//  Created by Palle Klewitz on 25.12.17.
//  Copyright (c) 2017 Palle Klewitz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import GVRKit
import ARKit
import SceneKit

open class GVRSCNARTrackingRenderer: GVRSCNRenderer, ARSessionDelegate {
	public let session: ARSession
	
	open var showsTrackingFeatures: Bool
	private let featureRoot: SCNNode = SCNNode()
	private var features: [UInt64: SCNNode] = [:]
	
	public override init(scene: SCNScene) {
		session = ARSession()
		showsTrackingFeatures = false
		
		super.init(scene: scene)
	}
	
	open override func refresh() {
		super.refresh()
		
		//FIXME: Tracking lost when pairing a new cardboard, this method is not called
	}
	
	open override func pause(_ pause: Bool) {
		super.pause(pause)
		
		print(pause ? "pause" : "unpause")
		if pause {
			session.pause()
		} else {
			let configuration = ARWorldTrackingConfiguration()
			session.run(configuration, options: [])
		}
	}
	
	open override func update(_ headPose: GVRHeadPose!) {
		super.update(headPose)
		
		if showsTrackingFeatures, let features = session.currentFrame?.rawFeaturePoints {
			if featureRoot.parent == nil {
				scene.rootNode.addChildNode(featureRoot)
			}
			
			for (id, point) in zip(features.identifiers, features.points) {
				guard self.features[id] == nil else {
					continue
				}
				let plane = SCNPlane(width: 0.002, height: 0.002)
				let material = SCNMaterial()
				material.diffuse.contents = UIColor.yellow
				material.specular.contents = UIColor.black
				plane.materials = [material]
				
				let node = SCNNode(geometry: plane)
				node.simdPosition = point
				node.constraints = [SCNBillboardConstraint()]
				
				self.features[id] = node
				featureRoot.addChildNode(node)
			}
			
			for removedID in Set(self.features.keys).subtracting(features.identifiers) {
				let node = self.features.removeValue(forKey: removedID)
				node?.removeFromParentNode()
			}
			
		} else {
			if featureRoot.parent != nil {
				featureRoot.removeFromParentNode()
			}
		}
	}
	
	open override func getTransform(headPose: GVRHeadPose) -> GLKMatrix4 {
		return SCNMatrix4ToGLKMatrix4(SCNMatrix4(session.currentFrame?.camera.transform ?? matrix_identity_float4x4))
	}
}
