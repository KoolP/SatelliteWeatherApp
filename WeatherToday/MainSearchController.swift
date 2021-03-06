//
//  MainSearchController.swift
//  WeatherToday
//
//  Created by Patrik Rikama Hinnenberg on 2018-03-24.
//  Copyright © 2018 Patrik Rikama Hinnenberg. All rights reserved.
//

import UIKit

var locationCity: [[String: String]] = []
var rowNr: Int = 0

class MainSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarMain: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    //API search from searchbarView
    func searchBarSearchButtonClicked(_ searchBarMain: UISearchBar) {
        print("Search button/enter pressed")
        
        if let safeString = searchBarMain.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(safeString)&units=metric&format=json&pretty=1&appid=a46f63c4899f9a64dc67f7114b104f2b") {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:
            { (data : Data?, response : URLResponse?, error: Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        do {
                            let locationResponse = try decoder.decode(WeatherCondition2.self, from: actualData)
                            //TEST:
                            //print(locationResponse)
                            print("Now WeatherCondition2")
                            //print(locationResponse.main) gives temp
                            print(locationResponse)

                            locationCity.append(["city": locationResponse.name, "temp": String(format:"%.0f",(locationResponse.main.temp)!),
                                                      "icon": "\(locationResponse.weather[0].icon)",
                                "wind": "\(locationResponse.wind["speed"] ?? 0) m/s",])
                            print(locationCity)
                            
                            DispatchQueue.main.async {
                                self.searchTableView.reloadData()
                            }
            
                            
                        } catch let e {
                            print("Error parsing json: \(e)")
                        }
                        
                        
                    } else {
                        print("Data was nil")
                    }
                }
            })
            task.resume()
        } else {
            print("Bad URL")
        }
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationCity.count
        
        //TEST, dummyData
        //return(locations.count)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MainSearchControllerCell = tableView.dequeueReusableCell(withIdentifier: "mainLocationsTableViewCell") as! MainSearchControllerCell
        
            cell.locationCityName?.text = locationCity[indexPath.row]["city"]
            cell.locationTemp.text = locationCity[indexPath.row]["temp"]
            cell.locationWeatherIcon.image = UIImage (named: locationCity[indexPath.row]["icon"]!)
        
            //TEST dummy data
            //cell.locationCityName?.text = self.locations[indexPath.row]
            //cell.locationWeatherIcon.image = weatherImageArray[indexPath.row]
            //self.temp.text = String(format:"%.0f", (locationResponse.main.temp)!) + " °C"
        
        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowNr = indexPath.row
        self.parent?.performSegue(withIdentifier: "detailSegue", sender: self)
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







//
//search of temp double append temp version 1:
//"temp": String(format:"%.0f",(locationResponse.main.temp)!) + "°C",
//this gives ex 21 without C string
//cell.locationTemp.text = locationCity[indexPath.row]["temp"]


//locationCity.append(["city": locationResponse.name, "temp": String(format:"%.0f",(locationResponse.main.temp)!),

//TEST

////TESTCLASS WITH DUMMYDATA FROM plist
//class MainWeeklyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    let locations = ["Gothenburg", "Helsinki", "Stockholm", "Miami", "Amsterdam"]
//    
//    var weatherImageArray = [UIImage(named: "01d"), UIImage(named: "02d"), UIImage(named: "03d"), UIImage(named: "04d"), UIImage(named: "01d")]
//    
//    
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return(locations.count)
//    }
//    
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell:MainWeeklyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mainLocationsTableViewCell") as! MainWeeklyTableViewCell
//        
//        cell.locationCityName?.text = self.locations[indexPath.row]
//        
//        cell.locationWeatherIcon.image = weatherImageArray[indexPath.row]
//        
//        return(cell)
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//}
