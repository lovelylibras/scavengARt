import UIKit
import SceneKit
import ARKit

//global variables
var visitedNames : [String] = []
var visitedImages : [UIImage] = []


extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node:SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.name else { return }

        // IMAGE RECOGNITION & 3D RENDER:
        DispatchQueue.main.async{
            
            // Verifies that it is the target image
            if(imageName == clues[0].name){
            let scannedImage = arrOfArt.filter({$0.name == imageName})
            self.selectedImage = scannedImage
                
                // Gets the size
                let physicalWidth = imageAnchor.referenceImage.physicalSize.width
                let physicalHeight = imageAnchor.referenceImage.physicalSize.height
                
                // Renders the plane for the main node and adds to the scene node
                let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
                let mainNode = SCNNode(geometry: mainPlane)
                mainNode.eulerAngles.x = -.pi/2
                mainNode.opacity = 1
                node.addChildNode(mainNode)
                
                // Renders the trophy object node on the node
                let successNode = SuccessNode(withReferenceImage: imageAnchor.referenceImage)
                node.addChildNode(successNode)
                successNode.isHidden = true
                
                // Animation action for rotating trophy
                let shapeSpin = SCNAction.rotateBy(x: 0, y: 0, z: 2 * .pi, duration: 10)
                let repeatSpin = SCNAction.repeatForever(shapeSpin)
                successNode.runAction(repeatSpin)
                
                // Checks to make sure that the picture hasn't been visited AND is the target artwork
                if (!visitedNames.contains(imageName) && clues[0].name == imageName) {
                    // Adds the name to the visitedNames list (used for Visited Paintings)
                    visitedNames.append(imageName)
                    // Adds the name to the visitedImages list (used for Visited Paintings)
                    visitedImages.append(imageDictionary[imageName]!)
                    // Advances to the next clue
                    clues.remove(at: 0)
                }
                
                if clues.isEmpty {
                    let particle = SCNParticleSystem(named: "firetest.scnp", inDirectory: nil)!
                    let particleNode = SCNNode()
                    node.addChildNode(particleNode)
                    particleNode.addParticleSystem(particle)
                }
                
                // Calls the function that makes the flashing recognition plane and triggers the image information segue
                self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight, completionHandler: {
                    DispatchQueue.main.async{
                        print("I am in the completionHandler", Thread.current)
                        self.performSegue(withIdentifier: "showImageInfo", sender: self)
                        mainNode.opacity = 0
                        successNode.isHidden = false
                    }
                })
            } else {
                self.augmentedRealityView.session.remove(anchor: imageAnchor)
            }
        }
    }
    
    // Creates the plane and function for the blinking recognition plane
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
    
    // The action for the blinking recognition plane
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
    
    // VARIABLES FOR AR SCENE/SESSION
    var augmentedRealityConfiguration = ARWorldTrackingConfiguration()
    var augmentedRealitySession = ARSession()

    let homeAlert = HomeAlert()

    // OUTLETS FOR UI ELEMENTS
    @IBOutlet weak var clueDisplayLabel: UILabel!
    @IBOutlet weak var augmentedRealityView: ARSCNView!
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var downloadSpinner: UIActivityIndicatorView! {
        didSet {
            downloadSpinner.alpha = 0
        }
    }
    
    // STATE FOR SELECTED IMAGE
    var selectedImage : [Paintings]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startARSession()
        generateImagesFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display for current clue or success message
        if clues.isEmpty {
            clueDisplayLabel.text = "You found all the paintings!!!!!!"
        } else {
            clueDisplayLabel.text = "Find \(clues[0].name)"
        }
    }

    // INITIALIZES AR SESSION
    func startARSession(){
        augmentedRealityView.session = augmentedRealitySession
        augmentedRealityView.delegate = self
        augmentedRealitySession.run(augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // SPEAKS TO IMAGEDOWNLOADER TO SET REFERENCE IMAGES
    func generateImagesFromServer(){
        
        self.downloadSpinner.alpha = 1
        self.downloadSpinner.startAnimating()
        
        ImageDownloader.downloadImagesFromPaths { (result) in
            switch result{
                
            case .success(let dynamicContent):
                self.augmentedRealityConfiguration.maximumNumberOfTrackedImages = 10
                self.augmentedRealityConfiguration.detectionImages = dynamicContent
                self.augmentedRealitySession.run(self.augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
                
                DispatchQueue.main.async {
                    self.downloadSpinner.alpha = 0
                    self.downloadSpinner.stopAnimating()
                }
                
                print("It was a success!!!!!")
            case .failure(let error):
                print("An Error Occured Generating The Dynamic Reference Images \(error)")
            }
        }
    }
    
    // ALERT FOR LEAVING GAME
    @IBAction func homeAction(_ sender: Any) {
        alert(title: "Are you sure you want to leave?", message: "Your progress will not be saved", completion: { result in
            if result {
                self.performSegue(withIdentifier: "museumSegue", sender: self)
            }
        })
    }
  
    func alert (title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Leave game", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(true) // true signals "YES"
        }))
        
        alertController.addAction(UIAlertAction(title: "Keep playing", style: UIAlertAction.Style.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(false) // false singals "NO"
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // PREPARE FOR SEGUE AND PASSES SELECTED IMAGE TO IMAGEINFORMATIONVIEWCONTROLLER FOR RENDER

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInfo" {
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage{
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
//        if segue.identifier == "tableViewIdentifier" {
//            if let statusVC = segue.destination as? StatusViewController {
//                print("VISITED NAMES: ", visitedNames.count, "ARROFART: ", arrOfArt.count)
//            }
//        }
    }
}

    
    
    
    
    

