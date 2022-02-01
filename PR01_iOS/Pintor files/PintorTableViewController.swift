//
//  PintorTableViewController.swift
//  PR01_iOS
//
//  Created by Alumne on 07/04/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData


class PintorTableViewController: UITableViewController {
    
    var newItem:Tarea?
    var tareas = [Tarea]()
    let context = AppDelegate.persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        let request:NSFetchRequest<Tarea> = Tarea.fetchRequest()
           request.sortDescriptors = [NSSortDescriptor(key: "titulo", ascending: true)]
        request.predicate = NSPredicate(format: "oficio = 'pintor'")

           
           do{
               tareas = try context.fetch(request)
               
           }catch{
               print("Error on fetching")
           }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            context.delete(self.tareas[indexPath.row])
            tareas.remove(at: indexPath.row)
            do{
                try context.save()
            } catch {
                print("error")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

  

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tareas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPintor", for: indexPath)

          //Titulo
          cell.textLabel?.text = tareas[indexPath.row].titulo
          
          //Direccion
          
          cell.detailTextLabel?.text = tareas[indexPath.row].direccion
          
          //Estado
          //TODO: Pintar la celda de un color o otro dependiendo del estado (picker)
          
        
          return cell
      }
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        if let item = newItem{
            self.newItem = nil
            
            do{
               try context.save()
               tareas.append(item)
               self.tableView.reloadData()
           }catch{
               print(error)
           }
        }
    }

   
}
