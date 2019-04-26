//
//  ViewController3.swift
//  ChenxingOuyangLab4
//
//  Created by ouyang chenxing on 2/5/18.
//  Copyright © 2018 ouyang chenxing. All rights reserved.
//

import UIKit
import WebKit

class ViewController3: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    //creative part 1: Explore movie news: let users to choose their favorite movie website to explore the latest movie news without using safari
    @IBAction func exploreMovieWeb(_ sender: Any) {
        let action = UIAlertController(title: "Choose a movie site", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "imdb.com", style: .default, handler: openMovieWeb))
        action.addAction(UIAlertAction(title: "rottentomatoes.com", style: .default, handler: openMovieWeb))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(action,animated: true, completion: nil)
        
    }

    func openMovieWeb(action: UIAlertAction){
        let url = URL(string: "http://" + action.title!)
        webView.load(URLRequest(url: url!))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
