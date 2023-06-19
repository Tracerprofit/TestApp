//
//  ContactsController.swift
//  LegeartApp
//
//  Created by PRGR on 24.01.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import UniformTypeIdentifiers

class AddTaskController: UIViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate{
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var NameOfTask: UITextField!
    @IBOutlet weak var DescriptionTask: UITextField!
    @IBOutlet weak var DeadlineTask: UITextField!
    @IBOutlet weak var TakeATaskButton: UIButton!
    let popView = UIView(frame: CGRect(x: 0, y: 0, width: 353, height: 230)) //374x249
    
    let name = UITextField(frame: CGRect(x: 20, y: 10, width: 300, height: 35))
    let lastName = UITextField(frame: CGRect(x: 20, y: 55, width: 300, height: 35))
    let email = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 35))
    let password = UITextField(frame: CGRect(x: 20, y: 145, width: 300, height: 35))
    
    let closeWindow = UIButton(frame: CGRect(x: 330, y: 10, width: 15, height: 15))
    let closeAndRegisterButton = UIButton(frame: CGRect(x: 220, y: 190, width: 100, height: 30))
    var checkBox = UISwitch(frame: CGRect(x: 65, y: 195, width: 30, height: 10))
    
    var statusManager : String!
    let datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    var photoImageView = UIImageView(frame: CGRect(x: 200, y: 550, width: 66, height: 66))
    var countOfDocuments = UILabel(frame: CGRect(x: 150, y: 128, width: 20, height: 20))
    var count = 0
    var countOfUsers = 0
    let database = Database.database().reference()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
        SetupFields()
        addViewNavBar()
        createDataPicker()
        setCountOfUsers()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //hide popView if touch != popView
        let touch: UITouch? = touches.first
        if touch?.view != popView {
            popView.isHidden = true
        }
        NameOfTask.resignFirstResponder()
        DescriptionTask.resignFirstResponder()
        DeadlineTask.resignFirstResponder()
        name.resignFirstResponder()
        lastName.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func createDataPicker(){
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        DeadlineTask.text = formatter.string(from: date)
        toolbar.sizeToFit()
        toolbar.backgroundColor = .gray
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        let but1 = UIBarButtonItem(customView: doneButton)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let but2 = UIBarButtonItem(customView: closeButton)
        toolbar.setItems([but1, spaceButton, but2], animated: true)
        
        DeadlineTask.inputAccessoryView = toolbar
        DeadlineTask.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        datePicker.locale = NSLocale(localeIdentifier: "ru") as Locale
        datePicker.layer.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00).cgColor
        
    }
    func SetupView(){
        MainView.layer.cornerRadius = 10
        MainView.layer.shadowColor = UIColor.black.cgColor
        MainView.layer.shadowOffset = .zero
        MainView.layer.shadowOpacity = 0.2
        MainView.layer.shadowRadius = 6.0
        
        popView.layer.zPosition = 100
        popView.backgroundColor = .white
        popView.layer.cornerRadius = 10
        popView.layer.shadowColor = UIColor.black.cgColor
        popView.layer.shadowOffset = .zero
        popView.layer.shadowOpacity = 0.2
        popView.layer.shadowRadius = 6.0
        
        let buttonClearOne = UIButton(type: .custom)
        buttonClearOne.setImage(UIImage(named: "crossClose")!.alpha(0.5), for: .normal)
        buttonClearOne.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        buttonClearOne.addTarget(self, action: #selector(clearOne), for: .touchUpInside)
        name.rightView = buttonClearOne
        name.rightViewMode = .always
        
        let buttonClearTwo = UIButton(type: .custom)
        buttonClearTwo.setImage(UIImage(named: "crossClose")!.alpha(0.5), for: .normal)
        buttonClearTwo.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        buttonClearTwo.addTarget(self, action: #selector(clearTwo), for: .touchUpInside)
        lastName.rightView = buttonClearTwo
        lastName.rightViewMode = .always
        
        let buttonClearThree = UIButton(type: .custom)
        buttonClearThree.setImage(UIImage(named: "crossClose")!.alpha(0.5), for: .normal)
        buttonClearThree.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        buttonClearThree.addTarget(self, action: #selector(clearThree), for: .touchUpInside)
        email.rightView = buttonClearThree
        email.rightViewMode = .always
        
        let buttonClearFour = UIButton(type: .custom)
        buttonClearFour.setImage(UIImage(named: "crossClose")!.alpha(0.5), for: .normal)
        buttonClearFour.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        buttonClearFour.addTarget(self, action: #selector(clearFour), for: .touchUpInside)
        password.rightView = buttonClearFour
        password.rightViewMode = .always
        
        
        
        name.placeholder = "Имя"
        lastName.placeholder = "Фамилия"
        email.placeholder = "Email"
        email.autocapitalizationType = .none
        email.autocorrectionType = .no
        password.placeholder = "Пароль"
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.isSecureTextEntry = true
        
        for fields in [name, email, password, lastName]{
            fields.layer.cornerRadius = 10
            fields.font = UIFont.systemFont(ofSize: 14)
        }
        
        let bottomLine0 = CALayer()
        bottomLine0.frame = CGRect(x: 0, y: name.frame.height, width: name.frame.width, height: 1)
        bottomLine0.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0, y: email.frame.height, width: email.frame.width, height: 1)
        bottomLine1.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor //gray
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: password.frame.height, width: password.frame.width, height: 1)
        bottomLine2.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0, y: lastName.frame.height, width: lastName.frame.width, height: 1)
        bottomLine3.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        name.layer.addSublayer(bottomLine0)
        email.layer.addSublayer(bottomLine1)
        password.layer.addSublayer(bottomLine2)
        lastName.layer.addSublayer(bottomLine3)
        
        closeAndRegisterButton.setTitle("Добавить", for: .normal)
        closeAndRegisterButton.setTitleColor(.white, for: .normal)
        closeAndRegisterButton.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        closeAndRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        closeAndRegisterButton.layer.cornerRadius = 10
        closeAndRegisterButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        closeWindow.setTitle("", for: .normal)
        closeWindow.setImage(UIImage(systemName: "cross.fill"), for: .normal)
        closeWindow.tintColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        closeWindow.addTarget(self, action: #selector(justClose), for: .touchUpInside)
        closeWindow.transform = closeWindow.transform.rotated(by: CGFloat(Double.pi/4))
        
        let bigCloseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        bigCloseButton.center = closeWindow.center
        bigCloseButton.setTitle("", for: .normal)
        bigCloseButton.addTarget(self, action: #selector(justClose), for: .touchUpInside)
        popView.addSubview(bigCloseButton)
        
        let regNewUser = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        regNewUser.center = self.view.center
        regNewUser.setTitle("Добавить нового пользователя", for: .normal)
        regNewUser.setTitleColor(.white, for: .normal)
        regNewUser.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        regNewUser.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        regNewUser.layer.cornerRadius = 10
        regNewUser.addTarget(self, action: #selector(self.showPopView), for: .touchUpInside)
        
        let manager = UILabel(frame: CGRect(x: 0, y: 185, width: 60, height: 10))
        manager.center.x = checkBox.center.x + 8
        manager.text = "Менеджер"
        manager.textColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        manager.font = UIFont.systemFont(ofSize: 8)
        
        //exit account button
        let exit = UIButton(frame: CGRect(x: 0, y: 500, width: 70, height: 30))
        exit.setTitle("Выйти", for: .normal)
        exit.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        exit.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        exit.layer.cornerRadius = 10
        exit.center.x = view.center.x
        exit.addTarget(self, action: #selector(exitInAcc), for: .touchUpInside)
        view.addSubview(exit)
        
        popView.center.x = regNewUser.center.x
        popView.center.y = regNewUser.center.y + 20
        popView.addSubview(manager)
        popView.addSubview(checkBox)
        popView.addSubview(closeWindow)
        popView.addSubview(name)
        popView.addSubview(lastName)
        popView.addSubview(email)
        popView.addSubview(password)
        popView.addSubview(closeAndRegisterButton)
        view.addSubview(popView)
        popView.isHidden = true
        
        db.collection("users").getDocuments { (snap, err) in
            if let err = err{
                print(err)
            } else {
                for doc in snap!.documents {
                    if Auth.auth().currentUser?.uid == doc.documentID {
                        if (doc.data()["admin"] as? String) == "true"{
                            self.view.addSubview(regNewUser)
                        } else {
                            regNewUser.removeFromSuperview()
                        }
                    }
                }
            }
        }
        
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Новая задача"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        view.addSubview(mainView)
        
    }
    func SetupFields(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: NameOfTask.frame.height, width: NameOfTask.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0, y: DescriptionTask.frame.height, width: DescriptionTask.frame.width, height: 1)
        bottomLine1.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor //gray
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: DeadlineTask.frame.height, width: MainView.frame.width - 20, height: 1)
        bottomLine2.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        
        NameOfTask.layer.addSublayer(bottomLine)
        DescriptionTask.layer.addSublayer(bottomLine1)
        DeadlineTask.layer.addSublayer(bottomLine2)

        for tasks in [NameOfTask, DescriptionTask, DeadlineTask]{
            tasks!.borderStyle = .none
            tasks!.indent(size: 15)
            tasks!.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
            tasks!.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        }
        
        for fields in [name, email, password, lastName]{
            fields.indent(size: 15)
            fields.addTarget(self, action: #selector(editingBeganSmallWindow(_:)), for: .editingDidBegin)
            fields.addTarget(self, action: #selector(editingEndedSmallWindow(_:)), for: .editingDidEnd)
        }
        
        let buttonDoc = UIButton(type: .custom)
        buttonDoc.setImage(UIImage(named: "doc"), for: .normal)
        buttonDoc.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        buttonDoc.frame = CGRect(x: CGFloat(DescriptionTask.frame.size.width - 25), y: 5, width: 25, height: 25)
        buttonDoc.addTarget(self, action: #selector(self.AddDocumentPressed), for: .touchUpInside)
        DescriptionTask.rightView = buttonDoc
        DescriptionTask.rightViewMode = .always
        
        let buttonCalendar = UIButton(type: .custom)
        buttonCalendar.setImage(UIImage(named: "calendar"), for: .normal)
        buttonCalendar.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        buttonCalendar.frame = CGRect(x: CGFloat(DeadlineTask.frame.size.width - 25), y: 5, width: 25, height: 25)
        buttonCalendar.addTarget(self, action: #selector(self.AddDateForCalendar), for: .touchUpInside)
        DeadlineTask.rightView = buttonCalendar
        DeadlineTask.rightViewMode = .always
        
        view.addSubview(photoImageView)
        
        countOfDocuments.textColor = .gray
        countOfDocuments.font = UIFont.systemFont(ofSize: 12)
        countOfDocuments.text = "0"
        countOfDocuments.textAlignment = .center
        countOfDocuments.center.x = buttonDoc.center.x + 15
        view.addSubview(countOfDocuments)
        
        if Int(countOfDocuments.text!) == 0{
            countOfDocuments.isHidden = true
        } else {
            countOfDocuments.isHidden = false
        }
    }
    func uploadPhoto(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void){
        let ref = Storage.storage().reference().child("AllFiles").child(String(Int.random(in: 1..<1000000000000)))
        
        //MARK: COMPRESSION ON PHOTO 0...1
        guard let imageData = photoImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    let alert = UIAlertController(title: "Ошибка", message: "Изображение не было загружено", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                completion(.success(url))
                let alert = UIAlertController(title: "Успешно", message: "Изображение успешно\nзагружено на сервер", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        print("import result : \(myURL)")
        
        let storage = Storage.storage().reference().child("AllFiles")
        storage.child((urls.first?.lastPathComponent)!).putFile(from: urls.first!, metadata: nil) {
            (_, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                let alert = UIAlertController(title: "Ошибка", message: "Файл не был загружен", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "Успешно", message: "Файл успешно\nзагружен на сервер", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            self.present(alert, animated: true, completion: nil)
            print("success")
            self.count+=1
            self.countOfDocuments.text = "\(self.count)"
            self.countOfDocuments.isHidden = false
        }
        
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    func setCountOfUsers(){
        database.child("Users").observe(.value, with: { snap in
            guard let value = snap.value as? [[String: String]] else {
                return
            }
            self.countOfUsers = value.count
            print("All users: \(self.countOfUsers)")
        })
    }
    @objc func AddDocumentPressed(){ //список дейсвтий при нажатии на кнопку "прикрепить файл"
        let actionSheet = UIAlertController(title: "Прикрепить файл", message: "Что вы желаете прикрепить?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in
            self.TapOnMakeAPicture()
        }))
        actionSheet.addAction(UIAlertAction(title: "Выбрать фото из галереи", style: .default, handler: { _ in
            self.TapOnAddPicture()
        }))
        actionSheet.addAction(UIAlertAction(title: "Выбрать файл", style: .default, handler: { _ in
            self.TapOnAddDocument()
        }))
        present(actionSheet, animated: true)
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        DeadlineTask.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
    @objc func exitInAcc(){
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error{
            print(error)
        }
    }
    @objc func clearOne(){
        name.text = ""
    }
    @objc func clearTwo(){
        lastName.text = ""
    }
    @objc func clearThree(){
        email.text = ""
    }
    @objc func clearFour(){
        password.text = ""
    }
    @objc func justClose(){
        UIView.transition(with: popView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.popView.isHidden = true
                      })
    }
    @objc func showPopView(){
        UIView.transition(with: popView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.popView.isHidden = false
                      })
    }
    func loginWithOldUser(email: String, pass: String){
        Auth.auth().signIn(withEmail: email, password: pass, completion: { (result, error) in
            if error != nil{
                print(error!)
                return
            } else {
                print("Successful user registered")
            }
        })
    }
    @objc func addNewTask(){
        guard let name = NameOfTask.text, let time = DeadlineTask.text else { return }
//        let deadlineText = DeadlineTask.text
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard name != "" && time != "" else {
            print("Важные поля не заполнены")
            return
        }
        
        let safeEmail = ChatViewController.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "Error in email")
        
        
        let newTask: [String: String] = [
            "name" : name,
            "description" : self.DescriptionTask.text!,
            "deadline" : time,
            "sender" : safeEmail
        ]
        
        self.database.child("Tasks/\(NameOfTask.text ?? "Error название задачи")").setValue(newTask)
        
        self.NameOfTask.text = ""
        self.DescriptionTask.text = ""
        self.DeadlineTask.text = ""
        
        print("Success create new task")
        
    }
    @objc func register(){
        if email.text != "" && password.text != ""{

            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
                if error != nil {
                    print(error!)
                    let alert = UIAlertController(title: "Внимание", message: "Произошла ошибка регистрации\nВозможно неверно указан тип почты", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                    print(error.unsafelyUnwrapped)
                } else {

                    if self.checkBox.isOn{
                        self.statusManager = "true"
                    } else {
                        self.statusManager = "false"
                    }
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData(["name" : self.name.text!,
                                                                                    "email" : self.email.text!,
                                                                                    "pass" : self.password.text!,
                                                                                    "admin" : self.statusManager!
                    ])
                    
                    let newUser: [String: String] = [
                        "email" : self.email.text!,
                        "name" : self.name.text!,
                        "lastname" : self.lastName.text!
                    ]
                    
                    let userSafeEmail = ChatViewController.safeEmail(emailAddress: newUser["email"]!)
                    
                    self.database.child("Users/\(self.countOfUsers)").setValue(newUser)
                    self.database.child(userSafeEmail).setValue(["email" : self.email.text!,
                                                        "name" : self.name.text!])
                    print(newUser)
                    
                    for field in [self.name, self.email, self.password, self.lastName]{
                        field.text = ""
                    }
                    self.checkBox.isOn = false
                }
            }
            print("email: \(email.text! as String) password: \(password.text! as String)")
            popView.isHidden = true
            
            do {
                try Auth.auth().signOut()
                navigationController?.popToRootViewController(animated: true)
                print("successful registered new user")
            } catch let error{
                print(error)
            }
        }
        else{
            let alert = UIAlertController(title: "Внимание", message: "Поля пустые", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func editingBegan(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: NameOfTask.frame.height, width: NameOfTask.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func editingEnded(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: NameOfTask.frame.height, width: NameOfTask.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func editingBeganSmallWindow(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: name.frame.height, width: name.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func editingEndedSmallWindow(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: name.frame.height, width: name.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func TapOnAddPicture(){ //нажатие на выбор фото из галереи
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @objc func TapOnMakeAPicture(){ //нажатие на сделать фото
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) { //на симуляторе не работает камера
            let alertController = UIAlertController(title: nil, message: "На данном устройстве отсутствует камера", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Принять", style: .default, handler: { (alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    @objc func TapOnAddDocument(){ //нажатие на добавление файла
        let allTypes = [UTType.pdf, .text, .image, .content, .zip, .html, .script]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: allTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func AddDateForCalendar(_ sender: Any) {
        toolbar.isHidden = !toolbar.isHidden
        datePicker.isHidden = !datePicker.isHidden
        if datePicker.isHidden{
            DeadlineTask.inputView = .none
        } else{
            DeadlineTask.inputView = datePicker
        }
        DeadlineTask.becomeFirstResponder()
    }
    @IBAction func AddTaskPressed(_ sender: UIButton) {
        print("\nemail: \(Auth.auth().currentUser?.email ?? "default email")\nuid: \( Auth.auth().currentUser?.uid ?? "default uid")\n")
        
        addNewTask()
        
        self.count = 0
        self.countOfDocuments.isHidden = true
    }//Action for "Поставить задачу"
    @IBAction func AddStuffPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addStuff", sender: UIButton.self)
    }
    
}
extension AddTaskController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
        
        self.uploadPhoto(currentUserId: Auth.auth().currentUser!.uid, photo: image) { (result) in
            switch result {
            case .success(let url):
                print(url.absoluteString)
                self.count += 1
                self.countOfDocuments.text = "\(self.count)"
                self.countOfDocuments.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
    }
}
