//
//  WeatherCollectionViewCell.swift
//  weather_app
//
//  Created by Max on 16.12.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    let convert = 273.15
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }

    func configure(with model: HourlyWeather) {
        self.tempLabel.text = "\(Int(model.temp - convert))°"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "Rain")
        switch model.weather.first?.main {
        case "Rain":
            iconImageView.image = UIImage(named: "Rain")
        case "Snow":
            iconImageView.image = UIImage(named: "Snow")
        case "Clouds":
            iconImageView.image = UIImage(named: "Clouds")
        case "Clear":
            iconImageView.image = UIImage(named: "Clear")
        default:
            print("Unknown icon name")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
