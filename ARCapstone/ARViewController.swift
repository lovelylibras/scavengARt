import UIKit
import SceneKit
import ARKit
import AVFoundation

//global variables
var images : [String: UIImage] = [:]
var visitedNames : [String] = []
var visitedImages : [UIImage] = []


extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node:SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async{
        guard let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.name else { return }
        if(imageName == clues[0].name){
        let scannedImage = arrOfArt.filter({$0.name == imageName})
        self.selectedImage = scannedImage
            
            let physicalWidth = imageAnchor.referenceImage.physicalSize.width
            let physicalHeight = imageAnchor.referenceImage.physicalSize.height
            
            let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
            mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
            
            let mainNode = SCNNode(geometry: mainPlane)
            mainNode.eulerAngles.x = -.pi/2
            mainNode.opacity = 0
            
            node.addChildNode(mainNode)
            
            self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight, completionHandler: {
                self.performSegue(withIdentifier: "showImageInfo", sender: self)

                let thumbNode = SuccessNode(withReferenceImage: imageAnchor.referenceImage)
                thumbNode.renderingOrder = -1
                node.addChildNode(thumbNode)
                
                let shapeSpin = SCNAction.rotateBy(x: 0, y: 0, z: 2 * .pi, duration: 10)
                let repeatSpin = SCNAction.repeatForever(shapeSpin)
                thumbNode.runAction(repeatSpin)
                
            })

        if (!visitedNames.contains(imageName) && clues[0].name == imageName) {
            visitedNames.append(imageName)
            visitedImages.append(images[imageName]!)
            clues.remove(at: 0)
        }
        }
        }

        
    }
    
    
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        planeNode.position.z += 0.1
        planeNode.opacity = 0
        
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}

class ViewController: UIViewController  {
    
    var augmentedRealityConfiguration = ARWorldTrackingConfiguration()
    var augmentedRealitySession = ARSession()
    
    @IBOutlet weak var clueDisplayLabel: UILabel!
    @IBOutlet weak var augmentedRealityView: ARSCNView!
    @IBOutlet weak var homeButton: UIButton!
    
//    @IBAction func takePhoto(_ sender: Any) {
//        getSnapshotImage()
//    }
    
    var selectedImage : [Paintings]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startARSession()
        generateImagesFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if clues.isEmpty {
            homeButton.isHidden = false
            clueDisplayLabel.text = "You found all the paintings!!!!!! "
        }else {
            homeButton.isHidden = true
             clueDisplayLabel.text = "Find \(clues[0].name)"
        }
    }

    func startARSession(){
        augmentedRealityView.session = augmentedRealitySession
        augmentedRealityView.delegate = self
        
        augmentedRealitySession.run(augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    func generateImagesFromServer(){
        ImageDownloader.downloadImagesFromPaths { (result) in
            switch result{
                
            case .success(let dynamicContent):
                
                self.augmentedRealityConfiguration.maximumNumberOfTrackedImages = arrOfArt.count
                self.augmentedRealityConfiguration.detectionImages = dynamicContent
                self.augmentedRealitySession.run(self.augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
                print("It was a success!!!!!")
            case .failure(let error):
                
                print("An Error Occured Generating The Dynamic Reference Images \(error)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInfo" {
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage{
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }
}

extension UIView {
    func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}

    
    
    
    
    

