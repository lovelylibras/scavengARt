import UIKit

class StatusViewController: UITableViewController {
    
    @IBOutlet weak var visitedStatus: UILabel!
    
    // CONTROLS STATUS TABLE VIEW
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.visitedStatus.text = "Visited Paintings  |  \(visitedNames.count) of \(arrOfArt.count)"

    }
    
    // Sets the height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100.00
    }

    // Sets the number of sections for the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Sets the number of cells to how many images have been visited
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedNames.count
    }

    // Sets the information within the cell – name and image
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitedPaintingCell", for: indexPath) as! VisitedPaintingCell
        let row = indexPath.row
        cell.PaintingLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell.PaintingLabel.text = visitedNames[row]
        cell.PaintingView.image = visitedImages[row]
        
        return cell
    }
    
    // HANDLES CLOSE
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

   



}
