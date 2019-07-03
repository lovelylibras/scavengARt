import UIKit
import SceneKit
import ARKit
import AVFoundation

//global variables
var images : [String: UIImage] = [:]
var visitedNames : [String] = []
var visitedImages : [UIImage] = []

class ViewController: UIViewController, ARSCNViewDelegate  {
    @IBOutlet var sceneView: ARSCNView!
    var thumbNode: SCNNode?
    var selectedImage : [Paintings]?
   
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    var captureDevice: AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let thumbScene = SCNScene(named: "art.scnassets/success.scn")
        thumbNode = thumbScene?.rootNode
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//         Create a new scene
//        let successScene = SCNScene(named: "art.scnassets/success.scn")!
//
////         Set the scene to the view
//        sceneView.scene = successScene
        
        let configuration = ARWorldTrackingConfiguration()
        let detectionImages = loadedImagesFromDirectoryContents()
        configuration.detectionImages = detectionImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
  
        
        
    }
    
    func loadedImagesFromDirectoryContents() -> Set<ARReferenceImage>?{
        var index = 0
        var customReferenceSet = Set<ARReferenceImage>()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            let filteredContents = directoryContents.filter{ $0.pathExtension == "png" }
            filteredContents.forEach { (url) in
                do{
                    //1. Create A Data Object From Our URL
                    let imageData = try Data(contentsOf: url)
                    guard let image = UIImage(data: imageData) else { return }
                    //2. Convert The UIImage To A CGImage
                    guard let cgImage = image.cgImage else { return }
                    //3. Get The Width Of The Image
                    let imageWidth = CGFloat(cgImage.width)
                    //4. Create A Custom AR Reference Image With A Unique Name
                    let customARReferenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: imageWidth)
                    customARReferenceImage.name = "MyCustomARImage\(index)"
                    //4. Insert The Reference Image Into Our Set
                    customReferenceSet.insert(customARReferenceImage)
                    print("ARReference Image == \(customARReferenceImage)")
                    index += 1
                }catch{
                    print("Error Generating Images == \(error)")
                }
            }
        } catch {
            print("Error Reading Directory Contents == \(error)")
        }
        //5. Return The Set
        print("HELLOOOOOO")
        return customReferenceSet
    }
    
//    func addReferences(media: [Paintings]) {
//        var imageSet = Set<ARReferenceImage>()
//        let imageFetchingGroup = DispatchGroup()
//        for medium in media {
//
//            let name = medium.name
//            let imageUrl = medium.imageUrl
//            let url = URL(string: imageUrl)
//            let session = URLSession(configuration: .default)
//
//            imageFetchingGroup.enter()
//            let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
//                if let e = error {
//                    print("Error downloading picture: \(e)")
//                    imageFetchingGroup.leave()
//                }else {
//                    if let res = response as? HTTPURLResponse {
//                        print("Downloaded picture with response code \(res.statusCode)")
//                        if let imageData = data {
//                            let image = UIImage(data: imageData)!
//                            images.updateValue(image, forKey: medium.name)
//                            let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(image.cgImage!.width) )
//                            arImage.name = name
//                            imageSet.insert(arImage)
//                            imageFetchingGroup.leave()
//                        }else {
//                            print("Couldn't get image: Image is nil")
//                            imageFetchingGroup.leave()
//                        }
//                    }else {
//                        print("Couldn't get response code")
//                        imageFetchingGroup.leave()
//                    }
//                }
//            }
//            downloadPicTask.resume()
//        }
//        self.configuration = ARWorldTrackingConfiguration()
//        imageFetchingGroup.notify(queue: .main) {
//            self.configuration.detectionImages = imageSet
//            self.sceneView.session.run(self.configuration)
//        }
//    }

    
    
    
    
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            if let shapeNode = thumbNode {
                node.addChildNode(shapeNode)
            }
              print("I recognize this image")
        }
        
      
        return node
        
        
//        let referenceImageName = imageAnchor.referenceImage.name {
//            let scannedImage = arrOfArt.filter({$0.name == referenceImageName})
//            self.selectedImage = scannedImage
////            self.performSegue(withIdentifier: "showImageInfo", sender: self)
//            guard let thumb = sceneView.scene.rootNode.childNode(withName: "thumb", recursively: false) else { return }
//            thumb.removeFromParentNode()
//            node.addChildNode(thumb)
//            thumb.isHidden = false
//            print(thumb.isHidden)
//
////            if !visitedNames.contains(referenceImageName) {
////                visitedNames.append(referenceImageName)
////                visitedImages.append(images[referenceImageName]!)
////            }
//        }
//        print("recognized the image!")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showImageInfo" {
//            if let imageInformationVC = segue.destination as? ImageInformationViewController,
//                let actualSelectedImage = selectedImage {
//                imageInformationVC.imageInformation = actualSelectedImage
//            }
//        }
//    }

}
