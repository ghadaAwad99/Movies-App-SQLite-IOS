
import UIKit

class TableViewController: UITableViewController {
    var moviesList : [Movie] = []
    
    @IBOutlet var myTable: UITableView!
    
    let database = DBManager.databaseInstance
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let secondVC = self.storyboard?.instantiateViewController(identifier: "second") as! AddViewController
        
        secondVC.firstVC = self
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.createTable()
        
        
        myTable.delegate = self
        myTable.dataSource = self
        
        moviesList = database.queryAllMovies()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let movie: Movie = self.moviesList[indexPath.row]
        
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondVC = self.storyboard?.instantiateViewController(identifier: "details") as! ViewController
        secondVC.movie = moviesList[indexPath.row]
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            database.deleteMovie(movie: moviesList[indexPath.row])
            moviesList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension TableViewController : MyProtocol{
    func addNewMovie(movie: Movie) {
        print("inside add new movie")
        database.insertMovie(movie: movie)
        moviesList.append(movie)
        
        myTable.reloadData()
    }
}
