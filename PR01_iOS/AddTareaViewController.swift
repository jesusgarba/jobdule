import UIKit
import CoreData



class AddTareaViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate, 	UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    let context: NSManagedObjectContext =
        AppDelegate.persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    var job = "";
    var seDesplazaView = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "es_ES")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row:
        Int, forComponent component: Int) -> String? {
        return "Abierta"
    }
    
    @IBOutlet weak var nuevoTitulo: UITextField!{
        didSet{
            self.nuevoTitulo.delegate = self
        }
    }
    
    @IBOutlet weak var nuevaDireccion: UITextField!{
        didSet{
            self.nuevaDireccion.delegate = self
        }
    }
    
    @IBOutlet weak var nuevaFecha: UIDatePicker!
    
    @IBOutlet weak var nuevaDescripcion: UITextView!{
        didSet{
            self.nuevaDescripcion.delegate = self
        }
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var jobName: UINavigationItem!{
        didSet{
            job = "albanil"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn
        range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.addObserver(self, selector:
            #selector(self.keyboardDidShow(notification:)), name:
            UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillHide(notification:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: Notification){
        let userInfo = notification.userInfo
        let keyboardFrame =
            userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.view.frame.origin.y-=keyboardFrame.height
        seDesplazaView = true
    }
    
    @objc func keyboardWillHide(notification: Notification){
        if seDesplazaView{
            let userInfo = notification.userInfo
            let keyboardFrame =
                userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.view.frame.origin.y+=keyboardFrame.height
            seDesplazaView = false
        }
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
    
    override func shouldPerformSegue(withIdentifier identifier:
        String, sender: Any?) -> Bool {
        var task=[Tarea]()
        if identifier == "saveSegue"{
            
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
            if let text = self.nuevoTitulo.text, text.isEmpty{
                return false
            }else {
                for usuarioComprobar in task{
                    if usuarioComprobar.titulo ==
                        self.nuevoTitulo.text{
                        self.nuevoTitulo.textColor=UIColor.red
                            self.createAndShowAlert()
                            return false
                    }
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if let identifier = segue.identifier, identifier ==
            "saveSegue"{
            if let tareaTVC = segue.destination as?
                TareaTableViewController{
                let tarea = Tarea(context: context)
                tareaTVC.newItem = tarea
                tarea.titulo = self.nuevoTitulo.text!
                tarea.direccion = self.nuevaDireccion.text!
                tarea.fechaTarea = dateFormatter.string(from:
                    self.nuevaFecha.date)
                tarea.oficio = self.job
                tarea.comentario = self.nuevaDescripcion.text
                tarea.estado = "Abierta"
            }
        }
        
    }
 
    
}
