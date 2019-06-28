//
//  ViewController.swift
//  ARCapstone
//
//  Created by Audra Kenney on 6/27/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!
    
//    var ShipNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
//        ShipNode = shipScene.rootNode
        
        // Set the scene to the view
        sceneView.scene = shipScene
        
//        prepareCamera()
    }
    
//    func prepareCamera() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//
//        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices {
//            captureDevice = availableDevices.first
//            beginSession()
//        }
//    }
//
//    func beginSession() {
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(captureDeviceInput)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)?
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        
        configuration.detectionImages = arImages
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    

    // MARK: - ARSCNViewDelegate
    
    func view(_ view: ARSCNView, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
            let scannedImage = self.images[referenceImageName] {
            self.selectedImage = scannedImage
            
            self.performSegue(withIdentifier: "showImageInfo", sender: self)
            
            return imageSeenMarker()
        }
        return nil
    }
    
    private func imageSeenMarker() -> SCN {
        let labelNode = SCNNode(text: "✅")
        labelNode.horizontalAlignmentMode
    }
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        // Container
        guard let ship = sceneView.scene.rootNode.childNode(withName: "ship", recursively: false) else { return }
        ship.removeFromParentNode()
        node.addChildNode(ship)
        ship.isHidden = false
        
    }

    
//    @IBAction func imageCapture(_ sender: Any, forEvent event: UIEvent) {
//
//    }
}
