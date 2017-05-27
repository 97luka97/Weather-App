//
//  ViewController.swift
//  weatherApp
//
//  Created by Kostic on 5/23/17.
//  Copyright © 2017 Kostic. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadIcon(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        })
        task.resume()
    }
    
    
}

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var pressure2Label: UILabel!
    @IBOutlet weak var humidity2Label: UILabel!
    @IBOutlet weak var windSpeed2Label: UILabel!
    @IBOutlet weak var visibility2Label: UILabel!
    
    
    var city: String!
    var time: String!
    var condition: String!
    var temperature: Int!
    var pressure: Double!
    var humidity: Int!
    var windSpeed: Double!
    var visibility: Int!
    var iconUrl: String!
    var exists: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        pressure2Label.isHidden = true
        humidity2Label.isHidden = true
        windSpeed2Label.isHidden = true
        visibility2Label.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var cityName: String = ""
        print("1")
        cityName = (searchBar.text?.replacingOccurrences(of: " ", with: "%20"))!
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&APPID=8eb788f74183cd20724731e7bfdb84c7") {
            print("2")
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        print(json)
                        
                        if let city = json["name"] as? String {
                            self.city = city
                        }
                        if let main = json["main"] as? [String: Any] {
                            if let temp_c = main["temp"] as? Int {
                                self.temperature = temp_c
                            }
                            if let pressure = main["pressure"] as? Double {
                                self.pressure = pressure
                            }
                            if let humidity = main["humidity"] as? Int {
                                self.humidity = humidity
                            }
                        }
                        
                        
                        if let wind = json["wind"] as? [String: Any] {
                            if let windSpeed = wind["speed"] as? Double {
                                self.windSpeed = windSpeed
                            }
                        }
                        
                        if let weather = json["weather"] as? [[String: Any]] {
                            if let mainWeather = weather[0]["main"] as? String {
                                self.condition = mainWeather
                                print(mainWeather)
                            }
                            if let icon = weather[0]["icon"] as? String {
                                self.iconUrl = "http://openweathermap.org/img/w/\(icon).png"
                            }
                        }
                        
                        if let visibility = json["visibility"] as? Int {
                            self.visibility = visibility
                        }
                        
                        
                        if let _ = json["error"] {
                            self.exists = false
                        }
                        
                        DispatchQueue.main.async {
                            self.cityStateLabel.text = self.city
                            self.conditionLabel.text = self.condition
                            self.windSpeedLabel.text = self.windSpeed.description + "m/s"
                            self.temperatureLabel.text = String(self.temperature - 273) + " ℃"
                            self.pressureLabel.text = self.pressure.description + "mb"
                            self.humidityLabel.text = self.humidity.description + "%"
                            if self.visibility != nil {
                                self.visibilityLabel.text = self.visibility.description + " m"
                            } else {
                                self.visibilityLabel.text = "Unknown"
                            }
                            
                            self.weatherImage.downloadIcon(from: self.iconUrl)
                            self.pressure2Label.isHidden = false
                            self.humidity2Label.isHidden = false
                            self.windSpeed2Label.isHidden = false
                            self.visibility2Label.isHidden = false
                        }
                        
                    } catch let jsonError {
                        print(jsonError.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
