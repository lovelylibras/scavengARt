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

struct ImageInformation {
    let name: String
    let description: String
    let image: UIImage
}


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var selectedImage : ImageInformation?
    
    let images = ["mdmX" : ImageInformation(name: "Madame X", description: "Portrait of Madame X is the title of a portrait painting by John Singer Sargent of a young socialite, Virginie Amélie Avegno Gautreau, wife of the French banker Pierre Gautreau. Madame X was painted not as a commission, but at the request of Sargent. It is a study in opposition. Sargent shows a woman posing in a black satin dress with jeweled straps, a dress that reveals and hides at the same time. The portrait is characterized by the pale flesh tone of the subject contrasted against a dark colored dress and background. The scandal resulting from the painting's controversial reception at the Paris Salon of 1884 amounted to a temporary set-back to Sargent while in France, though it may have helped him later establish a successful career in Britain and America.", image: UIImage(named: "ColormdmX")!)]
    
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
        
//         Create a new scene
        let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
//         Set the scene to the view
        sceneView.scene = shipScene
        let configuration = ARWorldTrackingConfiguration()
        
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        
        configuration.detectionImages = arImages
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
    }
    

    // MARK: - ARSCNViewDelegate
    
//    func view(_ view: ARSCNView, nodeFor anchor: ARAnchor) -> SKNode? {
//        if let imageAnchor = anchor as? ARImageAnchor,
//            let referenceImageName = imageAnchor.referenceImage.name,
//            let scannedImage = self.images[referenceImageName] {
//            self.selectedImage = scannedImage
//
//            self.performSegue(withIdentifier: "showImageInfo", sender: self)
//
//            return imageSeenMarker()
//        }
//        return nil
//    }
    
//    private func imageSeenMarker() -> SKLabelNode {
//        let labelNode = SKLabelNode(text: "✅")
//        labelNode.horizontalAlignmentMode = .center
//        labelNode.verticalAlignmentMode = .center
//
//        return labelNode
//    }
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
        let scannedImage = self.images[referenceImageName] {
            self.selectedImage = scannedImage
            self.performSegue(withIdentifier: "showImageInfo", sender: self)
            guard let ship = sceneView.scene.rootNode.childNode(withName: "ship", recursively: false) else { return }
            ship.removeFromParentNode()
            node.addChildNode(ship)
            ship.isHidden = false
        
        }
 
        
        


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInfo" {
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage {
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }

    
//    @IBAction func imageCapture(_ sender: Any, forEvent event: UIEvent) {
//
//    }
}
