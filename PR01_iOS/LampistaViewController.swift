//
//  LampistaViewController.swift
//  PR01_iOS
//
//  Created by Alumne on 06/04/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData

class LampistaViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource  {
    
    var changedView = false
    let context: NSManagedObjectContext = AppDelegate.persistentContainer.viewContext
    var job = ""
    var status:String = "Abierta"
    let dateFormatter = DateFormatter()
    var seDesplazaView = false
    
    
    var pickerData: [String] = [String]()


    override func viewDidLoad() {
     super.viewDidLoad()
     self.nuevoEstadoLampista.delegate = self
     self.nuevoEstadoLampista.dataSource = self
     dateFormatter.dateStyle = .medium
     dateFormatter.timeStyle = .medium
     dateFormatter.locale = Locale(identifier: "es_ES")
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var nuevoTituloLampista: UITextField!{
        didSet{
            self.nuevoTituloLampista.delegate = self
        }
    }
    
   
    @IBOutlet weak var nuevaDireccionLampista: UITextField!{
        didSet{
            self.nuevaDireccionLampista.delegate = self
        }
    }
 
    @IBOutlet weak var nuevaFechaL: UIDatePicker!
    
    @IBOutlet weak var nuevaDescripcionLampista: UITextView!{
        
        didSet{
            self.nuevaDescripcionLampista.delegate = self
        }
        
    }
    
    
    @IBOutlet weak var nuevoEstadoLampista: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return 1
       }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Abierta"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBOutlet weak var oficio: UINavigationItem!{
        didSet{
            job = "lampista"
        }
    }
    
    /*
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveSegueLampista"{
            if let text = self.nuevoTituloLampista.text, text.isEmpty{
                return false
            }
        }
        return true
    }*/
    
    override func shouldPerformSegue(withIdentifier identifier:
    String, sender: Any?) -> Bool {
    var task=[Tarea]()
    if identifier == "saveSegueLampista"{
        
        let appDelegate = UIApplication.shared.delegate as!
        AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Tarea> =
            Tarea.fetchRequest()
        do{
            let result = try
                managedContext.fetch(fetchRequest)
            task = result as [NSManagedObject] as! [Tarea]
        }catch _ as NSError {
            print ("error")
        }
        if let text = self.nuevoTituloLampista.text, text.isEmpty{
            return false
        }else {
            for usuarioComprobar in task{
                if usuarioComprobar.titulo ==
                    self.nuevoTituloLampista.text{
                    self.nuevoTituloLampista.textColor=UIColor.red
                        self.createAndShowAlert()
                        return false
                }
            }
        }
    }
    return true
    }
    
    
    func createAndShowAlert(){
        let alert = UIAlertController(title: "Tarea repetida",
                                      message: "Inserta una tarea no repetida", preferredStyle:
            .alert)
        alert.addAction(UIAlertAction(title:
            NSLocalizedString("OK", comment: ""), style: .default))
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier ==
            "saveSegueLampista"{
            if let tareaTVC = segue.destination as?
                LampistaTableViewController{
                let tarea = Tarea(context: context)
                tareaTVC.newItem = tarea
                tarea.titulo = self.nuevoTituloLampista.text!
                tarea.direccion = self.nuevaDireccionLampista.text!
                tarea.oficio = self.job
                tarea.fechaTarea = dateFormatter.string(from: self.nuevaFechaL.date)
                tarea.comentario = self.nuevaDescripcionLampista.text!	
                tarea.estado = "Abierta"
                
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
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
        seDesplazaView = true
       }
       
       @objc func keyboardWillHide(notification:Notification){
        if seDesplazaView {
            let userInfo = notification.userInfo
            let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.view.frame.origin.y+=keyboardFrame.height
            seDesplazaView = false
            }
       }
}

