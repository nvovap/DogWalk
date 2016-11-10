//
//  ViewController.swift
//  DogWalk
//
//  Created by Vladimir Nevinniy on 11/9/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    
    var currentDog: Dog!
    
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let dogEntity = NSEntityDescription.entity(forEntityName: "Dog", in: managedContext)
        
        let dogName = "Juddy"
        let dogFetch = NSFetchRequest<Dog>(entityName: "Dog")
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        
        do {
            let results = try managedContext.fetch(dogFetch)
            if results.count > 0 {
                currentDog = results.first
            } else {
                currentDog = Dog(entity: dogEntity!, insertInto: managedContext)
                currentDog.name = dogName
                
                try managedContext.save()
            }
        } catch let error {
            print(error)
        }    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func add(_ sender: Any) {
        
        let walkEntity = NSEntityDescription.entity(forEntityName: "Walk", in: managedContext)
        
        let walk = Walk(entity: walkEntity!, insertInto: managedContext)
        
        walk.date = NSDate()
        
        let walks = currentDog.walks?.mutableCopy() as! NSMutableOrderedSet
        
        walks.add(walk)
        
        currentDog.walks = walks
        
        do {
            try managedContext.save()
        } catch let error {
            print(error)
        }
        
        tableView.reloadData()
    }
    


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDog.walks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let walk = currentDog.walks![indexPath.row] as! Walk
        
        cell.textLabel?.text = dateFormatter.string(from: walk.date! as Date)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let walkToRemove = currentDog.walks![indexPath.row]
            
            managedContext.delete(walkToRemove as! Walk)
            
            do {
                try managedContext.save()
            } catch let error {
                print(error)
            }
            
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
