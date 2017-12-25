Pod::Spec.new do |s|
  s.name = 'GVRSCNRenderer'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Enables SceneKit Rendering and ARKit 6DOF Tracking for Google Cardboard.'
  s.homepage = 'https://github.com/palle-k/GVRSCNRenderer'
  s.authors = 'Palle Klewitz'
  s.source = { :git => 'https://github.com/palle-k/GVRSCNRenderer.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'GVRSCNRenderer/*.swift'
  s.dependency 'GVRKit'
end
