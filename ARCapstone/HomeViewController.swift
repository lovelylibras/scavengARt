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

struct Museum {
    let museum: String
}

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var arrOfImage: [String] = []
        
        let jsonUrlString = "http://localhost:1337/api/hunt/\(museum)"
        guard let url = URL(string: jsonUrlString) else {
            return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else { return }
            do {
                let hunt = try JSONDecoder().decode(Hunt.self, from: data)
                for i in hunt.paintings {
                    arrOfImage.append(i.imageUrl)
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            print(arrOfImage)
        }.resume()
        // Do any additional setup after loading the view.
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
}
