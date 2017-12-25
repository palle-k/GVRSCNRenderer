//
//  GVRSCNRenderer.swift
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
import SceneKit


open class GVRSCNRenderer: GVRRenderer {
	public private(set) var renderers: [SCNRenderer] = []
	open var scene: SCNScene {
		didSet {
			renderers.forEach {
				$0.scene = scene
			}
		}
	}
	
	init(scene: SCNScene) {
		self.scene = scene
		
		super.init()
	}
	
	private func makeRenderer() -> SCNRenderer {
		let renderer = SCNRenderer(context: EAGLContext.current(), options: nil)
		let cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		renderer.pointOfView = cameraNode
		renderer.scene = scene
		
		return renderer
	}
	
	open override func initializeGl() {
		super.initializeGl()
		
		renderers = [makeRenderer(), makeRenderer(), makeRenderer()]
	}
	
	open override func clearGl() {
		super.clearGl()
		renderers.removeAll()
	}
	
	open override func refresh() {
		super.refresh()
	}
	
	open override func handleTrigger(_ headPose: GVRHeadPose!) -> Bool {
		return super.handleTrigger(headPose)
	}
	
	open override func resetHeadRotation() {
		super.resetHeadRotation()
	}
	
	open override func update(_ headPose: GVRHeadPose!) {
		super.update(headPose)
		
		glClearColor(0, 0, 0, 1)
		glEnable(GLenum(GL_DEPTH_TEST))
		glEnable(GLenum(GL_SCISSOR_TEST))
	}
	
	open override func draw(_ headPose: GVRHeadPose!) {
		super.draw(headPose)
		
		let eye = headPose.eye
		
		let viewport = headPose.viewport
		glViewport(
			GLint(viewport.origin.x),
			GLint(viewport.origin.y),
			GLsizei(viewport.size.width),
			GLsizei(viewport.size.height)
		)
		glScissor(
			GLint(viewport.origin.x),
			GLint(viewport.origin.y),
			GLsizei(viewport.size.width),
			GLsizei(viewport.size.height)
		)
		
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
		
		let renderer = renderers[eye.rawValue]
		let projectionMatrix = headPose.projectionMatrix(withNear: 0.1, far: 100.0)
		
		renderer.pointOfView?.camera?.projectionTransform = SCNMatrix4FromGLKMatrix4(projectionMatrix)
		
		let arTransform = getTransform(headPose: headPose)
		
		let localEyeTransform = headPose.eyeTransform
		let localEyeLocation = GLKMatrix4GetColumn(localEyeTransform, 3)
		
		let cameraToEyeTranslation = GLKVector4Subtract(GLKVector4Make(0.07, -0.03, 0.07, 1), localEyeLocation)
		
		let pointOfViewTransform = GLKMatrix4TranslateWithVector4(arTransform, cameraToEyeTranslation)
		renderer.pointOfView?.transform = SCNMatrix4FromGLKMatrix4(pointOfViewTransform)
		
		if glGetError() == GLenum(GL_NO_ERROR) {
			renderer.render(atTime: CACurrentMediaTime())
		}
	}
	
	open func getTransform(headPose: GVRHeadPose) -> GLKMatrix4 {
		return GLKMatrix4Transpose(headPose.headTransform)
	}
}
