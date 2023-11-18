//
//  MyTableViewCell.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/13/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var iconName : String? = nil {
        didSet{
            let weatherImageUrlStr = "http://openweathermap.org/img/wn/(icon)@2x.png"
            guard let icon = iconName else{
               return
            }
            let updatedUrl = weatherImageUrlStr.replacingOccurrences(of: "(icon)", with: icon)
            print("\(updatedUrl)")
            Service.shared.getData(urlStr: updatedUrl, queryItems: nil) { result in
                switch result{
                case .failure(let err) : print ("\(err)")
                case .success(let xdata) :
                    print("\(xdata)")
                    if let img = UIImage(data: xdata){
                        DispatchQueue.main.async {[unowned self] in
                            self.myImageView.image = img
                        }
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(city:Cities){
        cityNameLabel.text = city.cityName
        
        let weatherApiStr = "https://api.openweathermap.org/data/2.5/weather"
        let queryItems:[URLQueryItem] = [URLQueryItem(name: "q", value:city.cityName), URLQueryItem(name: "appid", value: "c53c2d696bcbd2372a035fdd8e4daa0a")]
        Service.shared.getData(urlStr: weatherApiStr, queryItems: queryItems) { result in
            switch result{
            case .failure(let err) : print ("\(err)")
            case .success(let xdata) :
                print("\(xdata)")
                if let results = try? JSONDecoder().decode(WeatherResults.self, from: xdata){
                    self.iconName = results.weather?.first?.icon
                    DispatchQueue.main.async {[unowned self] in
                        self.tempLabel.text = String(results.main.temp)
                    }
                }
            }
        }
    }
}
