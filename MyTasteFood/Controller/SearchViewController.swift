//
//  SearchViewController.swift
//  MyTasteFood
//
//  Created by kibeom lee on 2018. 7. 27..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, NMapLocationManagerDelegate{
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var outcomeList : [searchOutcomeModel] = [searchOutcomeModel]()
    let SearchAPI_URL = "https://openapi.naver.com/v1/search/local.json"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 105
        
        if let lm = NMapLocationManager.getSharedInstance() {
            lm.setDelegate(self)
            lm.startContinuousLocationInfo()
        }
       
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - NMAP
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        print("yes did update")
        print(location.coordinate)
        print(location.coordinate.longitude)
    }
    
    @nonobjc func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        print("ffailled")
        print(errorType.rawValue)
    }
    


    
    //MARK: - tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outcomeCell", for: indexPath) as! searchOutcomeTableCell
        
        cell.title.text = outcomeList[indexPath.row].title
        cell.address.text = outcomeList[indexPath.row].address
        cell.category.text = outcomeList[indexPath.row].category

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outcomeList.count
    }
    
    
    //MARK: - search function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            
            let params : [String : String] = ["query" : "\(searchText) 음식 식당"]
            
            //Setting Header
            var clientID : String?
            var clientSecret : String?
            
            if let path = Bundle.main.path(forResource: "API", ofType: "plist"){
                let keys = NSDictionary(contentsOfFile: path)
             
                if let dict = keys {
                    clientID = dict["clientId"] as? String
                    clientSecret = dict["clientSecret"] as? String
                }
            }
            let headers : [String : String] = ["X-Naver-Client-Id" : clientID!, "X-Naver-Client-Secret" : clientSecret!]
       
        
            //Get API response
            Alamofire.request(SearchAPI_URL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
                if response.result.isSuccess {
                    self.outcomeList.removeAll()
                    
                    let data : JSON = JSON(response.result.value!)
                    
                    for i in 0..<data["items"].count {
                        let item = searchOutcomeModel()
                        let value = data["items"][i]
                        
                        item.mapx = value["mapx"].stringValue
                        item.mapy = value["mapy"].stringValue
                        let tmptitle = value["title"].stringValue.replacingOccurrences(of: "<b>", with: "")
                        item.title = tmptitle.replacingOccurrences(of: "</b>", with: "")
                        item.category = value["category"].stringValue
                        item.address = value["address"].stringValue
                        item.telephone = value["telephone"].stringValue
                        
                        self.outcomeList.append(item)
                    }
                    
                    self.tableView.reloadData()
                    
                }else {
                    print(response.result.error as Any)
                }
            }
            
            
        }
    }



}
