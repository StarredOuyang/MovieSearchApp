//
//  ViewController.swift
//  ChenxingOuyangLab4
//
//  Created by ouyang chenxing on 2/5/18.
//  Copyright © 2018 ouyang chenxing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var movieData:[MovieInfo] = []
    var posterCache: [UIImage]=[]
    var movieDetailData:[MovieDetail] = []

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchContent: UISearchBar!
    //press the enter key(or search button on screen keyboard) to search movies
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTitle = searchBar.text
        let searchComplete = searchTitle?.replacingOccurrences(of: " ", with: "+")
        let pathPage1 = "https://api.themoviedb.org/3/search/movie?api_key=23bc68e387eef019b784d517395d55b9&language=en-US&query=\(searchComplete!)&page=1&include_adult=false"
        
        let pathPage2 = "https://api.themoviedb.org/3/search/movie?api_key=23bc68e387eef019b784d517395d55b9&language=en-US&query=\(searchComplete!)&page=2&include_adult=false"
        self.view.endEditing(true)
        setupCollectionView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForColectionView(url1: pathPage1, url2: pathPage2)
            self.cachePoster()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterCache.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviePosterCollectionViewCell
        cell.posterView?.image = posterCache[indexPath.row]
        cell.titleView!.text = movieData[indexPath.row].title
        return cell
    }
    
    //detailed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedMovie = detailed(nibName: "detailed", bundle: nil)
        detailedMovie.theTitle = movieData[indexPath.row].title
        let searchId = movieData[indexPath.row].movieId
        let jsonDetailed = getJSON(path: "https://api.themoviedb.org/3/movie/\(searchId)?api_key=23bc68e387eef019b784d517395d55b9&language=en-US")
        detailedMovie.theReleased = jsonDetailed["runtime"].stringValue
        detailedMovie.theImdbRating = jsonDetailed["release_date"].stringValue
        detailedMovie.theRated = jsonDetailed["imdb_id"].stringValue
        detailedMovie.thePoster = posterCache[indexPath.row]
        
        navigationController?.pushViewController(detailedMovie, animated: true)

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
    
    private func cachePoster() {
        self.posterCache.removeAll()
        for item in movieData {
            let posterUrl = URL(string: item.poster_path)
            let data = try? Data(contentsOf: posterUrl!)
            let poster = UIImage(data: data!)
            posterCache.append(poster!)
        }
    }
    private func fetchDataForColectionView(url1:String,url2:String) {
        spinner.startAnimating()
        let json = getJSON(path: url1)
        self.movieData.removeAll()
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let id = result["id"].stringValue
            if (result["poster_path"].stringValue == ""){
                let poster = "http://prancingthroughlife.com/wp-content/uploads/2014/03/na.jpg"
                movieData.append(MovieInfo(title: title, poster_path: poster, movieId: id))
            } else{
                let poster = "https://image.tmdb.org/t/p/w500" + result["poster_path"].stringValue
                print(poster)
                movieData.append(MovieInfo(title: title, poster_path: poster, movieId: id))
            }
        }
        let jsonPage2 = getJSON(path: url2)
        
        for resultPage2 in jsonPage2["results"].arrayValue {
            let title2 = resultPage2["title"].stringValue
            let id = resultPage2["id"].stringValue
            if (resultPage2["poster_path"].stringValue == "N/A"){
                let poster2 = "http://prancingthroughlife.com/wp-content/uploads/2014/03/na.jpg"
                movieData.append(MovieInfo(title: title2, poster_path: poster2, movieId: id))
            } else{
                let poster2 = "https://image.tmdb.org/t/p/w500" + resultPage2["poster_path"].stringValue
                movieData.append(MovieInfo(title: title2, poster_path: poster2, movieId: id))
            }
        }
        spinner.stopAnimating()
    }

    private func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spinner.hidesWhenStopped = true
        self.title = "movies"
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "Movies")
        self.tabBarController?.tabBar.items![1].image = UIImage(named: "Favorite")
        self.tabBarController?.tabBar.items![2].image = UIImage(named: "Explore")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

