//
//  ViewController2.swift
//  ChenxingOuyangLab4
//
//  Created by ouyang chenxing on 2/5/18.
//  Copyright © 2018 ouyang chenxing. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var defaults = UserDefaults.standard
    var tableView: UITableView!
    
    private func setupTableView() {
        
        tableView = UITableView(frame: view.frame.offsetBy(dx: 0, dy: 70))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
    }
    
    func ranking(_ s1: [String:String], _ s2: [String:String]) -> Bool {
        return s1["rating"]! > s2["rating"]!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteList = defaults.array(forKey: "fav") as? [[String:String]]
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let sortedList = favoriteList?.sorted(by:ranking)
        cell.textLabel!.text = sortedList?[indexPath.row]["title"]
        cell.detailTextLabel?.text = sortedList?[indexPath.row]["rating"]
        //print(sortedList!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let favoriteList = defaults.array(forKey: "fav") as? [[String:String]]
        if (favoriteList == nil){
            return 1
        }else{
            return favoriteList!.count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let favoriteList = defaults.array(forKey: "fav") as? [[String:String]]
        var sortedList = favoriteList?.sorted(by:ranking)
        if editingStyle == UITableViewCellEditingStyle.delete{
            sortedList?.remove(at: indexPath.row)
            defaults.set(sortedList, forKey: "fav")
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    //creative part 3: More info about user's favorite movies. Users could select each movie in their favorite list to enter next page. They will see a detailed plot as well as other info(director, actor, boxoffice). If the tomatoURL is avaliable, they could press the button to view a rottentomatoes.com/movie page.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteDetailView = FavoriteDetailed(nibName: "FavoriteDetailed", bundle: nil)
        let favoriteList = defaults.array(forKey: "fav") as? [[String:String]]
        let sortedList = favoriteList?.sorted(by:ranking)
        let favoriteTitle = sortedList?[indexPath.row]["title"]!.replacingOccurrences(of: " ", with: "+")
        favoriteDetailView.favTitle = sortedList?[indexPath.row]["title"]
        let jsonFavDetailed = getJSON(path: "http://www.omdbapi.com/?t=\(favoriteTitle!)&&plot=full&&tomatoes=true")
        favoriteDetailView.theActors = jsonFavDetailed["Actors"].stringValue
        favoriteDetailView.theDirector = jsonFavDetailed["Director"].stringValue
        favoriteDetailView.thePlot = jsonFavDetailed["Plot"].stringValue
        favoriteDetailView.theTomatoURL = jsonFavDetailed["tomatoURL"].stringValue
        favoriteDetailView.theBoxOffice = jsonFavDetailed["BoxOffice"].stringValue
        favoriteDetailView.theGenre = jsonFavDetailed["Genre"].stringValue
        navigationController?.pushViewController(favoriteDetailView, animated: true)
    }
    
    private func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        do {
            let data = try Data(contentsOf: url)
            return JSON(data: data)
        } catch {
            return JSON.null
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        self.tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "favorites"
        setupTableView()
        //defaults.removeObject(forKey: "fav")
        DispatchQueue.global(qos: .userInitiated).async {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
