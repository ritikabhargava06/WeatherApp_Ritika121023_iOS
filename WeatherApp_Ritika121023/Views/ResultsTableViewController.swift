//
//  ResultsTableViewController.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/12/23.
//

import UIKit

protocol resultDelegate{
    func selectCityDone(userSelectedCity:String)
}

class ResultsTableViewController: UITableViewController {
    
    var cityArray = [String](){
        didSet{
            DispatchQueue.main.async {[unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    var delegate:resultDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = cityArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCity = cityArray[indexPath.row]
            delegate?.selectCityDone(userSelectedCity: userCity)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




