//
//  CompletedHuntsViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/11/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class CompletedHuntsViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        print("user", userGlobal)
        super.viewDidLoad()
        
  
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00
    }
    
    // Sets the number of sections for the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Sets the number of cells to how many images have been visited
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedGames.isEmpty ? 0 : completedGames.count
    }
    
    // Sets the information within the cell – name and image
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedHuntCell", for: indexPath) as! CompletedHuntCell
       
            print("I am in here")
          
                    let row = indexPath.row
                    print("each game", completedGames[row])
            cell.HuntLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
            cell.HuntLabel.text = completedGames[row].hunt.name
            var date = completedGames[row].updatedAt
            date.removeLast(14)
            print(date)
            cell.HuntDateLabel.text = date
        
        if completedGames[row].hunt.name == "The Metropolitan Museum of Art" { cell.HuntView.image = #imageLiteral(resourceName: "Met") }
          else if completedGames[row].hunt.name == "The Museum of Modern Art" { cell.HuntView.image = #imageLiteral(resourceName: "MoMA") }
          else if completedGames[row].hunt.name == "The Whitney Museum of American Art" { cell.HuntView.image = #imageLiteral(resourceName: "Whitney") }
        
           return cell
       
    }
    
    // HANDLES CLOSE
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
