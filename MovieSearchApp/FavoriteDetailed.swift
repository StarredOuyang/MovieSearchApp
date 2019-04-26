//
//  FavoriteDetailed.swift
//  ChenxingOuyangLab4
//
//  Created by ouyang chenxing on 2/5/18.
//  Copyright © 2018 ouyang chenxing. All rights reserved.
//

import UIKit

class FavoriteDetailed: UIViewController {
    var favTitle : String!
    var theActors : String!
    var theDirector : String!
    var theBoxOffice : String!
    var thePlot : String!
    var theGenre : String!
    var theTomatoURL : String!

    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var actorsInfo: UILabel!
    @IBOutlet weak var directorInfo: UILabel!
    @IBOutlet weak var freshInfo: UILabel!
    @IBOutlet weak var meterInfo: UILabel!
    @IBOutlet weak var consensusInfo: UILabel!
    
    @IBAction func exploreTheMovie(_ sender: Any) {
        if (theTomatoURL != "N/A"){
            button.isHidden=false
            let tomatoUrl = URL(string: theTomatoURL)
            UIApplication.shared.open(tomatoUrl!, options: [:], completionHandler: nil)
        }else{
            button.isHidden=true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = favTitle
        self.actorsInfo.text = "Actors: " + self.theActors
        self.directorInfo.text = "Directors: " + self.theDirector
        self.freshInfo.text = "Box Office: " + self.theBoxOffice
        self.meterInfo.text = "Genre: " + self.theGenre
        self.consensusInfo.text = "Plot: " + self.thePlot
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
