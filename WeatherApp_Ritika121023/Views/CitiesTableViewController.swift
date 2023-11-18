//
//  CitiesTableViewController.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/12/23.
//

import UIKit
import CoreData

class CitiesTableViewController: UITableViewController {
   
    var fetchResultsController:NSFetchedResultsController<Cities>!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var fetchCitySearchBar: UISearchBar!
    
    func loadSavedData(city:String?){
        
        if let searchText = city {
            let fetchRequest = Cities.fetchRequest()
            fetchRequest.sortDescriptors = []
            if searchText != ""{
                fetchRequest.predicate = NSPredicate(format: "cityName contains[c] %@", searchText)
            }
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }else if fetchResultsController==nil {
            let fetchRequest = NSFetchRequest<Cities>(entityName: "Cities")
            let sort = NSSortDescriptor(key: "cityName", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
        }
            
        try? fetchResultsController.performFetch()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData(city:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared again")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let frcSections = fetchResultsController.sections?.count {
            return frcSections
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchResultsController?.sections else {
                fatalError("No sections in fetchedResultsController")
            }
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MyTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityDescCell", for: indexPath) as! MyTableViewCell
        
            guard let object = self.fetchResultsController?.object(at: indexPath) else {
                fatalError("Attempt to configure cell without a managed object")
            }
        cell.configCell(city: object)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let fetchedObjects = fetchResultsController.fetchedObjects else{
                return
            }
            let objToDel = fetchedObjects[indexPath.row]
            context.delete(objToDel)
            try? context.save()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoListSegue"{
            if let indexpath = tableView.indexPathForSelectedRow{
                let obj = fetchResultsController.object(at: indexpath)
                let destination = (segue.destination as! UINavigationController)
                let adv = destination.viewControllers[0] as! AddCityViewController
                adv.addedCty = obj
            }
        }
    }
}

extension CitiesTableViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            loadSavedData(city: searchText)
    }
    
}

extension CitiesTableViewController:NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }else if type == .delete{
            tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
