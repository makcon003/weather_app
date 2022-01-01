//
//  CityViewController.swift
//  weather_app
//
//  Created by Max on 19.12.2021.
//

import Alamofire
import UIKit
class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var citytable: UITableView!
    @IBOutlet var add: UIButton!
    let vc = ViewController()
    var cit = [Cities]()
    var cities = [Cities]()
    var cityWeather: CityWeatherResponse?
    var name = ""
    var loclon = 0.0
    var loclat = 0.0
    var lon = ""
    var lat = ""
    private var filteredcities = [Cities]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredcities.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        var new: String?
        if isFiltering {
            new = filteredcities[indexPath.row].city
        } else {
            new = cities[indexPath.row].city
        }
        cell.textLabel?.text = new
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = cities[indexPath.row].city
        vc.name = name
        performSegue(withIdentifier: "reload", sender: self)
        
    }
    
    func localjson() {
        guard let path = Bundle.main.path(forResource: "ua", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            self.cities = try JSONDecoder().decode([Cities].self, from: data)
            DispatchQueue.main.async {
                self.citytable.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reload" {
            if let indexPath = self.citytable.indexPathForSelectedRow {
                let controller = segue.destination as! ViewController
                controller.llat = cities[indexPath.row].lat
                controller.llon = cities[indexPath.row].lng
                controller.name = cities[indexPath.row].city
                
            }
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: "citylocation", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        localjson()
        citytable.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        citytable.delegate = self
        citytable.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationController?.navigationBar.backgroundColor =  UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Location", style: .plain, target: self, action: #selector(buttonAction))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}


extension CityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredcities = cities.filter { (city: Cities) -> Bool in
            city.city.lowercased().contains(searchText.lowercased())
        }
        citytable.reloadData()
    }
}
