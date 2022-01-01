//
//  ViewController.swift
//  weather_app
//
//  Created by Max on 13.12.2021.
//

import Alamofire
import CoreLocation
import MapKit
import UIKit
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $1) }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet var add: UIButton!
    @IBOutlet var table: UITableView!
    var long = 0.0
    var lat = 0.0
    var models = [DailyWeather]()
    var hourlymodels = [HourlyWeather]()
    var current: CurrentWeather?
    static let controller = ViewController()
    var temp = ""
    var llon = "" 
    var llat = ""
    var name = ""
    var m = 0
    let convert = 273.15
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlymodels)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return cell
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func requestWeatherForLocation() {
        if(llon == ""){
            guard let currentLocation = currentLocation else {
                return
            }
            long = currentLocation.coordinate.longitude
            lat = currentLocation.coordinate.latitude
            let location = CLLocation(latitude: lat, longitude: long)
            location.fetchCityAndCountry { city, error in
                guard let city = city, error == nil else { return }
                self.temp = city
            }
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=fba02848d8920784eff0be44d201ecff"
            var json: WeatherResponse?
            AF.request(url).responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    do {
                        json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    }
                    catch {
                        print(error)
                    }
                    guard let result = json else {
                        return
                    }
                    let entries = result.daily
                    self.models.append(contentsOf: entries)
                    let current = result.current
                    self.current = current
                    self.hourlymodels = result.hourly
                    DispatchQueue.main.async {
                        self.table.reloadData()
                        self.table.tableHeaderView = self.createTableHeader()
                    }
                case .failure(let error):
                    print(error)
                }
                
            })
        }else {
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(llat)&lon=\(llon)&exclude=minutely&appid=fba02848d8920784eff0be44d201ecff"
            var json: WeatherResponse?
            AF.request(url).responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    do {
                        json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    }
                    catch {
                        print(error)
                    }
                    guard let result = json else {
                        return
                    }
                    let entries = result.daily
                    self.models.append(contentsOf: entries)
                    let current = result.current
                    self.current = current
                    self.hourlymodels = result.hourly
                    DispatchQueue.main.async {
                        self.table.reloadData()
                        self.table.tableHeaderView = self.createTableHeader()
                    }
                case .failure(let error):
                    print(error)
             }
                
            })
        }
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = .red
        add = UIButton(frame: CGRect(x: 130, y: 5, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        add.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/3))
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        headerView.addSubview(add)
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        if (llon == "") {
            locationLabel.text = self.temp
        }
        else{
            locationLabel.text = name
        }
        guard let currentWeather = self.current else {
            return UIView()
        }
        let t = Int(currentWeather.temp-convert)
        tempLabel.text = "\(t)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = self.current?.weather.first?.main
        add.setTitle("+", for: .normal)
        return headerView
    }
    
    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: "city", sender: sender)
    }
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.requestWeatherForLocation()
            }
        }
    }
    @IBAction func unwindToLocal(segue: UIStoryboardSegue) {
        llon = ""
        llat = ""
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.requestWeatherForLocation()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
    }
}
