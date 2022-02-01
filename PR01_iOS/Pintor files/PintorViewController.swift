//
//  PintorViewController.swift
//  PR01_iOS
//
//  Created by Alumne on 07/04/2020.
//  Copyright © 2020 Angel Guimera. All rights reserved.
//

import UIKit
import CoreData


class PintorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    let context: NSManagedObjectContext = AppDelegate.persistentContainer.viewContext
    
    var changedView = false;
    var job = "";
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nuevoEstadoPintor.delegate = self
        self.nuevoEstadoPintor.dataSource = self
        pickerData = ["Abierta","En curso","Finalizada"]

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return pickerData.count
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
       }
    

    @IBOutlet weak var nuevoTituloPintor: UITextField!{
        didSet{
            self.nuevoTituloPintor.delegate = self
        }
    }
    
    
    @IBOutlet weak var nuevaDireccionPintor: UITextField!{
        didSet{
            self.nuevaDireccionPintor.delegate = self
        }
    }
    
    @IBOutlet weak var nuevaFechaPintor: UIDatePicker!
    
    
    @IBOutlet weak var nuevaDescripcionPintor: UITextView!
    
    
    @IBOutlet weak var nuevoEstadoPintor: UIPickerView!
    
    
    @IBOutlet weak var oficio: UINavigationItem!{
        didSet{
            job = "pintor"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nuevoTituloPintor.resignFirstResponder()
        self.nuevaDireccionPintor.resignFirstResponder()
        return true
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           if identifier == "saveSegue"{
               if let text = self.nuevoTituloPintor.text, text.isEmpty{
                   print("shouldperform \(text)")
                   return false
               }
           }
           return true
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let identifier = segue.identifier, identifier ==
               "saveSegue"{
               if let tareaTVC = segue.destination as?
                   PintorTableViewController{
                   let tarea = Tarea(context: context)
                   tareaTVC.newItem = tarea
                   tarea.titulo = self.nuevoTituloPintor.text!
                   tarea.direccion = self.nuevaDireccionPintor.text!
                 //   tarea.fecha = self.nuevaFechaPintor.date
                   tarea.oficio = self.job
                  // tarea.estado = picker.(inComponent: 0)
               }
           }
           
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
    }
    @objc func keyboardWillShow(notification: Notification){
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
    if(self.view.frame.height-keyboardFrame.height)<=nuevoTituloPintor.frame.minY || (self.view.frame.height-keyboardFrame.height)>=nuevoTituloPintor.frame.minY && (self.view.frame.height-keyboardFrame.height)<=nuevoTituloPintor.frame.maxY {
        self.view.frame.origin.y-=50
        changedView = true
        }
    }
    
    @objc func keyboardWillHide(notification:Notification){
        if changedView{
            self.view.frame.origin.y+=50
            changedView = false
        }
    }
    
    

}
