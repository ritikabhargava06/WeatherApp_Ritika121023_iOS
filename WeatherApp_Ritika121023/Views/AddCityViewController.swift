//
//  ViewController.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/12/23.
//

import UIKit

class AddCityViewController: UIViewController {
    
    
    
    @IBOutlet weak var toDoListStackView: UIStackView!
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var usrSearchText : String?
    var userCity:String?
    var addedCty:Cities?
    var toDoAdded = false
    var toDoDeleted = false
    lazy var toDoList=[String]()
    var toDoObjArray = [ToDo]()
    var cityObj:Cities?
    
    
    lazy var searchResultsTableController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsStoryBoard") as? ResultsTableViewController
    lazy var searchController = UISearchController(searchResultsController: searchResultsTableController)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currCity = addedCty{
            toDoListStackView.isHidden = false
            title = currCity.cityName
            if let cityToDoList = currCity.toDoList{
                let toDoObjArr = cityToDoList.allObjects
                for eachToDoObj in toDoObjArr {
                    let todo = eachToDoObj as! ToDo
                    if let attName = todo.attractionName{
                        toDoList.append(attName)
                    }
                }
            }
            print("\(toDoList)")
            toDoListTableView.reloadData()
        }else{
            toDoListStackView.isHidden = true
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater=self
            searchResultsTableController?.delegate = self
        }
    }
    
    @IBAction func addToDoPressed() {
        let toDoObj = ToDo(context: appDelegate.persistentContainer.viewContext)
        toDoObj.attractionName = toDoTextField.text
        if let note = toDoTextField.text{
            toDoList.append(note)
        }
        print("\(toDoList)")
        toDoObjArray.append(toDoObj)
        toDoAdded=true
        toDoTextField.text=""
        toDoListTableView.reloadData()
    }
  
    
    @IBAction func navBarbuttonPressed(_ sender: UIBarButtonItem) {
        print("\(toDoList)")
        if sender.title=="Save"{
            if !toDoDeleted{
                if let currCity = addedCty{
                    for obj in toDoObjArray{
                        currCity.addToToDoList(obj)
                    }
                }else{
                    let cityObj = Cities(context: appDelegate.persistentContainer.viewContext)
                    cityObj.cityName = userCity
                    for obj in toDoObjArray {
                        cityObj.addToToDoList(obj)
                    }
                }
            }
            appDelegate.saveContext()
        }else if sender.title=="Cancel"{
            if let currCity = addedCty{
                if toDoDeleted && toDoAdded {
                    guard let currToDoList = currCity.toDoList else{return}
                    let lastObj = currToDoList.allObjects.last
                    currCity.removeFromToDoList(lastObj as! ToDo)
                    print("\(toDoList)")
                }
            }
        }
        dismiss(animated: true)
    }
}

extension AddCityViewController: resultDelegate{
    func selectCityDone(userSelectedCity: String) {
        searchController.isActive=false
        userCity=userSelectedCity
        title = userCity
        toDoListStackView.isHidden = false
    }
}

extension AddCityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTxt = searchController.searchBar.text{
            print("\(searchTxt)")
            if searchTxt.count>2 {
                if let arr = searchResultsTableController?.cityArray {
                    if(arr.count>0){
                        searchResultsTableController?.cityArray.removeAll()
                    }
                }
                let cityUrl = "http://gd.geobytes.com/AutoCompleteCity"
                let queryItems : [URLQueryItem] = [URLQueryItem(name: "q", value: searchTxt), URLQueryItem(name: "callBack", value: "?")]
                Service.shared.getData(urlStr: cityUrl, queryItems: queryItems) { result in
                    switch result{
                    case .failure(let err) : print ("\(err)")
                    case .success(let xdata) :
                        if let jsonStr = String(data: xdata, encoding: .utf8){
                            let cleanJsonStr = jsonStr.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ";", with: "")
                            guard let cleanData = cleanJsonStr.data(using: .utf8), let resultSet = try? JSONDecoder().decode([String].self, from: cleanData) else {return}
                            for result in resultSet{
                                let resultArray = result.components(separatedBy: ",")
                                if let cityName = resultArray.first{
                                    self.searchResultsTableController?.cityArray.append(cityName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


extension AddCityViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            guard let currCity = addedCty, let currToDoList = currCity.toDoList else{return}
            let currToDo = currToDoList.allObjects[indexPath.row] as! ToDo
            currCity.removeFromToDoList(currToDo)
            toDoDeleted = true
            toDoList.remove(at: indexPath.row)
            toDoListTableView.reloadData()
        }
    }
}

