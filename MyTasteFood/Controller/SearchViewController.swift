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

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var textExample: UILabel!
    
    
    let SearchAPI_URL = "https://openapi.naver.com/v1/search/local.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text as Any )
        
        
        
        if let searchText = searchBar.text {
            let params : [String : String] = ["query" : searchText]
            
            var keys : NSDictionary?
            var clientID : String?
            var clientSecret : String?
            
            if let path = Bundle.main.path(forResource: "API", ofType: "plist"){
                keys = NSDictionary(contentsOfFile: path)
                print(keys as Any)
             
                if let dict = keys {
                    clientID = dict["clientId"] as? String
                    clientSecret = dict["clientSecret"] as? String
                }
            }
            
            
            
            let headers : [String : String] = ["X-Naver-Client-Id" : clientID!, "X-Naver-Client-Secret" : clientSecret!]
       
        
            Alamofire.request(SearchAPI_URL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
                if response.result.isSuccess {
                    print(JSON(response.result.value!))
                }else {
                    print(response.result.error as Any)
                }
            }
            
            
        }
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
