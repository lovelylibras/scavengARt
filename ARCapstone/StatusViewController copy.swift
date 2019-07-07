import UIKit

class StatusViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100.00
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return visitedNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitedPaintingCell", for: indexPath) as! VisitedPaintingCell
        let row = indexPath.row
        cell.PaintingLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell.PaintingLabel.text = visitedNames[row]
        cell.PaintingView.image = visitedImages[row]
        return cell
    }



    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

   



}
