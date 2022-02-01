//
//  TareaTableViewController.swift
//  PR01_iOS
//
//  Created by alumne on 17/03/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData

class TareaTableViewController: UITableViewController {
    
    var newItem:Tarea?
    var tareas = [Tarea]()
    let context = AppDelegate.persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
	
        
        let request:NSFetchRequest<Tarea> = Tarea.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "estado", ascending: true)]
        request.predicate = NSPredicate(format: "oficio = 'albanil'")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

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
    
    
    func createAndShowAlert(){
        let alert = UIAlertController(title: "Tarea repetida", message: "Inserta una tarea no repetida", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    	

    
    @IBAction func goBack(segue: UIStoryboardSegue){
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tareas[indexPath.row])
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell),
                let navigationController = segue.destination as? UINavigationController, let detailController = navigationController.visibleViewController as? DetailScreenViewController{
                if let selectedText = tareas[indexPath.row].titulo, let selectedDirection = tareas[indexPath.row].direccion, let selectedFecha = tareas[indexPath.row].fechaTarea, let selectedDescripcion = tareas[indexPath.row].comentario,
                    let selectedEstado = tareas[indexPath.row].estado{
                    print(selectedText)
                    detailController.newTitle = selectedText
                    detailController.newDirection = selectedDirection
                    detailController.newFecha = selectedFecha
                    detailController.newDescripcion = selectedDescripcion
                    detailController.newEstado = selectedEstado
                }
                
            }
           }
        
    }
}
