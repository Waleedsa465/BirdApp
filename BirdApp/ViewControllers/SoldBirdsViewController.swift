import UIKit

class SoldBirdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var birds: [SoldBirdsDetails]  = [] // core data entity name
    private let manager = DatabaseManagerss() // core data upload method
    var imgViewUUID = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        birds = manager.fetchUsers()
        tableView.reloadData()
        
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SoldTableViewCell

        cell.certificateNo.text = ("Certificate No : \(birds[indexPath.row].certificateNo ?? "NO Data Found" )")
        cell.birdIdLbl.text = ("Bird Id : \(birds[indexPath.row].birdID ?? "NO Data Found" )")
        cell.birdSpecieLbl.text = ("Bird Name : \(birds[indexPath.row].birdSpecie ?? "NO Data Found" )")
        cell.soldDateLbl.text = ("Sold Date : \(birds[indexPath.row].soldDate ?? "NO Data Found" )")
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SoldDetailViewController") as! SoldDetailViewController

        vc.soldData = birds[indexPath.row]
        vc.imgViewUUID = birds[indexPath.row].uploadCurrentImage!
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Search Bar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func isFiltering() -> Bool {
        return searchBar.text?.isEmpty == false
        
    }
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all birds
            birds = manager.fetchUsers()
        } else {
            // Filter the birds based on the search text
            birds = manager.fetchUsers().filter { bird in
                if let certificateNo = bird.certificateNo,
                   let birdId = bird.birdID,
                   let birdSpecie = bird.birdSpecie {
                    
                    return certificateNo.lowercased().contains(searchText.lowercased()) ||
                           birdId.lowercased().contains(searchText.lowercased()) ||
                           birdSpecie.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(soldBirds: self.birds[indexPath.row])
            self.birds.remove(at: indexPath.row) // Array
            self.tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
