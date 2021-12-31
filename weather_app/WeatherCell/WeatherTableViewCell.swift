//
//  WeatherTableViewCell.swift
//  weather_app
//
//  Created by Max on 13.12.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet var daylabel: UILabel!
    @IBOutlet var highTemp: UILabel!
    @IBOutlet var lowTemp: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    let convert = 273.15
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    func configure(with model: DailyWeather) {
        self.lowTemp.text = "\(Int(model.temp.min-self.convert))°"
        self.lowTemp.textColor = .gray
        self.highTemp.text = "\(Int(model.temp.max-self.convert))°"
        self.highTemp.textColor = .white
        self.daylabel.text = self.getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.daylabel.textColor = .white
        self.iconImageView.image = UIImage(named: "cloud")
        self.iconImageView.contentMode = .scaleAspectFit
        switch model.weather.first?.main {
        case "Rain":
            self.iconImageView.image = UIImage(named: "Rain")
        case "Snow":
            self.iconImageView.image = UIImage(named: "Snow")
        case "Clouds":
            self.iconImageView.image = UIImage(named: "Clouds")
        case "Clear":
            self.iconImageView.image = UIImage(named: "Clear")
        default:
            print("Unknown icon name")
        }
    }

    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
}
