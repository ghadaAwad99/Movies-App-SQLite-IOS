

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var genreLable: UILabel!
    
    var movie : Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = movie.title
        image.image = UIImage(data: Data(base64Encoded: (movie.image)!, options: .ignoreUnknownCharacters)!)  ?? UIImage(named:"xmen.jpeg")
        ratingLable.text =  String(movie.rating ?? 0.0)
        releaseYear.text =  String( movie.releaseYear ?? 0)
        genreLable.text = movie.genre.joined(separator: " , ")
    }
    
    
}

