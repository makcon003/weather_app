//
//  DetailCityViewController.swift
//  weather_app
//
//  Created by Max on 21.12.2021.
//

import Alamofire
import UIKit
class DetailCityViewController: UIViewController {
    var model: CityWeatherResponse?
    var weather = [Weather]()
    @IBOutlet var back: UIButton!
    var convert = 273.15
    
    func createHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = .red
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/3))
        
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        back = UIButton(frame: CGRect(x: -120, y: 5, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        
        back.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        headerView.addSubview(back)
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        locationLabel.text = model?.name
        let t = Int(model!.main.temp-convert)
        tempLabel.text = "\(t)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = weather.first?.main
        back.setTitle("Back", for: .normal)
        return headerView
    }

    func loadjson() {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=&appid=fba02848d8920784eff0be44d201ecff"
        var json: CityWeatherResponse?
        AF.request(url).responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                do {
                    json = try JSONDecoder().decode(CityWeatherResponse.self, from: data)
                    }
                catch {
                    print(error)
                }
                guard let result = json else {
                    return
                }
                self.model = result
                self.weather = result.weather
                DispatchQueue.main.async {
                    self.view.addSubview(self.createHeader())
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: "backToCityList", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadjson()
    }
}
