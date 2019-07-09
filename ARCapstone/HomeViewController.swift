import UIKit
import ARKit

// GLOBAL VARIABLES
var imageDictionary : [String: UIImage] = [:]

struct Hunt: Decodable {
    let name:String
    let description:String
    let paintings:[Paintings]
}

struct Paintings: Decodable {
    let name:String
    let artist:String
    let imageUrl:String
    let description:String
}

var arrOfArt: [Paintings] = []
var clues: [Paintings] = []

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API CALL TO DATABASE TO LOAD ARTWORK
        // Resets hunt to empty when navigated home & holds iterated art (below)
        clues = []
        arrOfArt = []
        
        let jsonUrlString = "http://scavengart.herokuapp.com/api/hunt/\(museum)"

        guard let url = URL(string: jsonUrlString) else {
            return }
        let imageFetchingGroup = DispatchGroup()
        
        // Fetches images from the API
        imageFetchingGroup.enter()
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else { return }
            do {
                // Appends data to array storage
                let hunt = try JSONDecoder().decode(Hunt.self, from: data)
                for i in hunt.paintings {
                    arrOfArt.append(i)
                    clues.append(i)
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            imageFetchingGroup.leave()
        }.resume()
    }
    
}
