

import Foundation
class Movie{
    var genre = ["Action", "Romance", "Drama"]
    subscript (index: Int) -> String {
        get{
            return genre[index]
        }
        set {
            self.genre[index] = newValue
        }
    }
    var movieId : Int?
    var title : String?
    var image : String?
    var rating : Float?
    var releaseYear : Int?
}
