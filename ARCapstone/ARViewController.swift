import UIKit
import SceneKit
import ARKit
import AVFoundation

//global variables
var images : [String: UIImage] = [:]

class ViewController: UIViewController, ARSCNViewDelegate {
    var configuration = ARWorldTrackingConfiguration()
    @IBOutlet var sceneView: ARSCNView!
    var selectedImage : [Paintings]?
   
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    var captureDevice: AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//         Create a new scene
        let successScene = SCNScene(named: "art.scnassets/success.scn")!
        
        
//         Set the scene to the view
        sceneView.scene = successScene
       
        self.addReferences(media: arrOfArt)
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
    }
    

    func addReferences(media: [Paintings]) {
        var imageSet = Set<ARReferenceImage>()
        let imageFetchingGroup = DispatchGroup()
        for medium in media {
            
            let name = medium.name
            let imageUrl = medium.imageUrl
            let url = URL(string: imageUrl)
            let session = URLSession(configuration: .default)
            
            imageFetchingGroup.enter()
            let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                    imageFetchingGroup.leave()
                }else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            let image = UIImage(data: imageData)!
                            images.updateValue(image, forKey: medium.name)
                            let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(image.cgImage!.width) )
                            arImage.name = name
                            imageSet.insert(arImage)
                            imageFetchingGroup.leave()
                        }else {
                            print("Couldn't get image: Image is nil")
                            imageFetchingGroup.leave()
                        }
                    }else {
                        print("Couldn't get response code")
                        imageFetchingGroup.leave()
                    }
                }
            }
            downloadPicTask.resume()
        }
        self.configuration = ARWorldTrackingConfiguration()
        imageFetchingGroup.notify(queue: .main) {
            self.configuration.detectionImages = imageSet
            self.sceneView.session.run(self.configuration)
        }
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor,
        let referenceImageName = imageAnchor.referenceImage.name {
            let scannedImage = arrOfArt.filter({$0.name == referenceImageName})
            self.selectedImage = scannedImage
            self.performSegue(withIdentifier: "showImageInfo", sender: self)
            guard let thumb = sceneView.scene.rootNode.childNode(withName: "thumb", recursively: false) else { return }
            thumb.removeFromParentNode()
            node.addChildNode(thumb)
            thumb.isHidden = false
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

}
