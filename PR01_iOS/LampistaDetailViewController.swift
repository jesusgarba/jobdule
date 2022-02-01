//
//  LampistaDetailViewController.swift
//  PR01_iOS
//
//  Created by Alumne on 15/04/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData

class LampistaDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    var newSelectedTitle:String = ""
    var newSelectedDireccion:String = ""
    var newSelectedFecha:String? = ""
    var newSelectedDescripcion:String = ""
    var pickerData: [String] = [String]()
    var selectedValue:String = ""
    var newEstado:String = ""

    
    
    @IBOutlet weak var newTituloLampista: UILabel!
    
    
    @IBOutlet weak var newDireccionLampista: UILabel!
    
    
    @IBOutlet weak var newFechaLampista: UILabel!
    
    
    @IBOutlet weak var newDescripcionLampista: UITextView!{
        didSet{
            self.newDescripcionLampista.delegate = self
        }
    }
    
    
    @IBOutlet weak var newPickerLampista: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTituloLampista.text = newSelectedTitle
        newDireccionLampista.text = newSelectedDireccion
        newFechaLampista.text = newSelectedFecha
        newDescripcionLampista.text = newSelectedDescripcion
        pickerData = ["Abierta","En curso","Finalizada"]
        
        var selectedIndex = 0
        selectedValue = newEstado
        
        self.newPickerLampista.delegate = self
        self.newPickerLampista.dataSource = self
              
              switch (newEstado) {
              case "Abierta":
                  selectedIndex = 0
              case "En curso":
                  selectedIndex = 1
              case "Finalizada":
                  selectedIndex = 2
              default:
                  selectedIndex = 0
              }
              self.newPickerLampista.selectRow(selectedIndex, inComponent: 0, animated: false)


    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        if identifier == "returnAndSaveLampistaSegue"{
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest : NSFetchRequest<Tarea> = Tarea.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "titulo= %@", newSelectedTitle)
            do{
                let result = try context.fetch(fetchRequest)
                let objetoUpdate = result[0] as NSManagedObject
               objetoUpdate.setValue(newDescripcionLampista.text, forKey: "comentario")
               objetoUpdate.setValue(selectedValue, forKey: "estado")
            
                do{
                    try context.save()
                }
                catch{
                    print ("error")
                    return false
                }
                
            }catch _ as NSError {
                print ("error")
                return false
            }
           
        }
        return true
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:
        Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedValue = pickerData[row]
        
    }
   
    // control teclado
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if(text == "\n") {
           textView.resignFirstResponder()
           return false
       }
       return true
   }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
           }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }

       @objc func keyboardDidShow(notification: Notification){
           let userInfo = notification.userInfo
           let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.view.frame.origin.y-=keyboardFrame.height
       }
       
       @objc func keyboardWillHide(notification:Notification){
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.view.frame.origin.y+=keyboardFrame.height
       }
    


}


















































