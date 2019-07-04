import UIKit

//global variables
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
//    let clue:String
}
var arrOfArt : [Paintings] = []
var clues : [Paintings] = []

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let jsonUrlString = "http://scavengart.herokuapp.com/api/hunt/\(museum)"

        guard let url = URL(string: jsonUrlString) else {
            return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else { return }
            do {
                let hunt = try JSONDecoder().decode(Hunt.self, from: data)
                for i in hunt.paintings {
                    arrOfArt.append(i)
                    clues.append(i)
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            print(arrOfArt)

        }.resume()
    }
}
