
import UIKit

class AddViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageUrl : String?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    @IBOutlet weak var releaseTextField: UITextField!
    
    @IBOutlet weak var genreTextField: UITextField!
    
    @IBOutlet weak var myImage: UIImageView!
    var firstVC : MyProtocol?
    
    var newMovie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImage.image = UIImage(named: "xmen.jpeg")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("inside didFinishPickingMediaWithInfo")
        
        myImage.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        
        
        let image : UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        
        let imageData : NSData = image.pngData()! as NSData
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        imageUrl = strBase64
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chooseMovieImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        print("inside done button")
        newMovie.title = titleTextField.text
        newMovie.image = imageUrl ?? "xmen.jpeg"
        newMovie.rating = Float(ratingTextField.text ?? "")
        newMovie.releaseYear = Int(releaseTextField.text ?? "")
        newMovie.genre = [genreTextField.text ?? ""]
        firstVC?.addNewMovie(movie: newMovie)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
