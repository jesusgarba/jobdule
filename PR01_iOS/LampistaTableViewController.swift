//
//  LampistaTableViewController.swift
//  PR01_iOS
//
//  Created by Alumne on 06/04/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData


class LampistaTableViewController: UITableViewController {

    var newItem:Tarea?
    var tareas = [Tarea]()
    let context = AppDelegate.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request:NSFetchRequest<Tarea> = Tarea.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "estado", ascending: true)]
        request.predicate = NSPredicate(format: "oficio = 'lampista'")

        
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaLampista", for: indexPath)

         //Titulo
               cell.textLabel?.text = tareas[indexPath.row].titulo
               let blue = UIColor(
                   red: 0xB1/255, green: 0xD4/255, blue: 0xFB/255, alpha:1)
               let green = UIColor(
               red: 0xB1/255, green: 0xFB/255, blue: 0xC5/255, alpha: 1)
               
               let red = UIColor(
               red: 0xFB/255, green: 0xAB/255, blue: 0xAB/255, alpha: 1)
               if(tareas[indexPath.row].estado == "En curso"){
                   cell.backgroundColor = blue
               }else if(tareas[indexPath.row].estado == "Finalizada"){
                   cell.backgroundColor = red
               }else{
                   cell.backgroundColor = green
               }
               
               //Direccion
               
               cell.detailTextLabel?.text = tareas[indexPath.row].direccion
               
               return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tareas[indexPath.row])
    }*/
    
     
    @IBAction func goBackLampista(segue: UIStoryboardSegue){
        if let item = newItem{
            self.newItem = nil
            
            do{
               try context.save()
               tareas.append(item)
           }catch{
               print(error)
           }
        }
        self.tableView.reloadData()

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetailLampista" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell),
                let navigationController = segue.destination as? UINavigationController, let detailLampistaController = navigationController.visibleViewController as? LampistaDetailViewController{
                if let selectedText = tareas[indexPath.row].titulo, let selectedDirection = tareas[indexPath.row].direccion, let selectedFecha = tareas[indexPath.row].fechaTarea, let selectedDescripcion = tareas[indexPath.row].comentario,
                    let selectedEstado = tareas[indexPath.row].estado{
                    detailLampistaController.newSelectedTitle = selectedText
                    detailLampistaController.newSelectedDireccion = selectedDirection
                    detailLampistaController.newSelectedFecha = selectedFecha
                    detailLampistaController.newSelectedDescripcion = selectedDescripcion
                    detailLampistaController.newEstado = selectedEstado
                }
                
            }
           }
        
    }

    
   

}
