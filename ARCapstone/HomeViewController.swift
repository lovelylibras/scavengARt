//
//  HomeViewController.swift
//  scavengARt
//
//  Created by Audra Kenney on 6/28/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

struct Hunt: Decodable {
    let name:String
    let description:String
    let paintings:[Paintings]
}

struct Paintings: Decodable {
    let name:String
    let artist:String
    let imageUrl:String
}

var arrOfArt: [Paintings] = []

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
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            print(arrOfArt)

        }.resume()
        // Do any additional setup after loading the view.
        
    }
}
