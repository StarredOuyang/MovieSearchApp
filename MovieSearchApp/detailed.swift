//
//  detailed.swift
//  ChenxingOuyangLab4
//
//  Created by ouyang chenxing on 2/5/18.
//  Copyright © 2018 ouyang chenxing. All rights reserved.
//

import UIKit

class detailed: UIViewController {
    
    var thePoster: UIImage!
    var theTitle: String!
    var theReleased: String!
    var theRated: String!
    var theImdbRating: String!

    @IBOutlet weak var posterInfo: UIImageView!
    @IBOutlet weak var rateInfo: UILabel!
    @IBOutlet weak var releasedInfo: UILabel!
    @IBOutlet weak var imdbratingInfo: UILabel!
    @IBOutlet weak var personalRating: UITextField!
    
    
    var defaults = UserDefaults.standard
    
    //creative part 2: personal rating: before users add their movies to the favorite list, they should enter a personal rating(any number between 0-9.999), we do the input checking and display their favorite movies list by desending order
    @IBAction func addToFavorite(_ sender: Any) {
        if (checkRating(rating: personalRating.text!) == true && personalRating.text != ""){
            let value = Double(personalRating.text!)!
            if(value > 9.999 || value < 0){
               personalRating.text = "invalid"
            }else{
                 var favoriteMovie = defaults.array(forKey: "fav") as? [[String:Any]]
                if (favoriteMovie != nil){
                    favoriteMovie!.append (["title" : theTitle, "rating" : personalRating.text!])
                    
                    defaults.set(favoriteMovie, forKey: "fav")
                    personalRating.text = "success"
                }else{
                    let favoriteMovie = [["title" : theTitle, "rating" : personalRating.text!]]
                    defaults.set(favoriteMovie, forKey: "fav")
                    personalRating.text = "success"
                }
            }
        }else{
            personalRating.text = "invalid"
        }
    }
    
    func checkRating(rating:String) -> Bool
    {
        let num = CharacterSet.decimalDigits
        let ratingSet = CharacterSet(charactersIn: rating)
        if (rating.range(of:".")) != nil {
            let dec = rating.components(separatedBy: ".").count
            if (dec == 2 && rating != "."){
                return true
            }else{
                return false
            }
        }
        return num.isSuperset(of: ratingSet)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = theTitle
        posterInfo.image = thePoster
        rateInfo.text = "Imdb id: " + theRated
        releasedInfo.text = "Movie run time: " +  theReleased
        imdbratingInfo.text = "Release date " +  theImdbRating
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
