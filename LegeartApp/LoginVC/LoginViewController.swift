//
//  LoginViewController.swift
//  LegeartApp
//
//  Created by PRGR on 18.01.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var loginField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var button: UIButton!
    
    //viewWillAppear and viewWillDisappear use to change nav bar gradient/blue color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setGradientBackground(colors: [.white, .white], startPoint: .topLeft, endPoint: .bottomRight)
        navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00), UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)], startPoint: .topLeft, endPoint: .bottomRight)
        navigationController?.navigationBar.shouldRemoveShadow(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginField.layer.cornerRadius = 4
        loginField.indent(size: 15)
        passField.layer.cornerRadius = 4
        passField.indent(size: 15)
        button.layer.cornerRadius = 10
        
        SignIn()
    }

    @IBAction func ForgotPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "ResetPass", sender: nil)
    }
    @IBAction func Login(_ sender: UIButton) {
        logUserIn()
    }
    
    func SignIn(){ //проверка, входил ли пользователь в акк
        if Auth.auth().currentUser == nil {
            print("Нужно войти...")
        } else if Auth.auth().currentUser != nil {
            print((Auth.auth().currentUser?.email)! as String)
            performSegue(withIdentifier: "GoDoc", sender: (Any).self)
        }
    }
    
    func JoinInButton(){ //перемещение на основной экран
        performSegue(withIdentifier: "GoDoc", sender: nil)
    }
    func logUserIn(){ //вход в аккаунт через введенные поля
        let email = loginField.text
        let password = passField.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if error != nil{
                self.showAlert()
            }else if((!result!.user.uid.isEmpty) && (!(result?.user.email!.isEmpty)!)){
                print(result!.user.uid as String)
                print(result!.user.email! as String)
                self.JoinInButton()
                
                UserDefaults.standard.set(email, forKey: "email")
                
            }
        }
        
    }
    func showAlert() { //ошибка если данные не верные
        let alert = UIAlertController(title: "Внимание", message: "Логин или пароль неверные", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

class ForgotPasswordViewController: UIViewController{
    
    @IBOutlet weak var emailFieldReset: UITextField!
    @IBOutlet weak var ResetPassButton: UIButton!
    
    //viewWillAppear and viewWillDisappear use to change nav bar gradient/blue color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setGradientBackground(colors: [.white, .white], startPoint: .topLeft, endPoint: .bottomRight)
        navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00), UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)], startPoint: .topLeft, endPoint: .bottomRight)
        navigationController?.navigationBar.shouldRemoveShadow(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailFieldReset.layer.cornerRadius = 4
        emailFieldReset.indent(size: 15)
        ResetPassButton.layer.cornerRadius = 10
    }
    
    func showAlertResetPassword(){
        let email = emailFieldReset.text!
        let alert = UIAlertController(title: "Успешно", message: "Письмо со сбросом пароля отправлено на \(email)", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    func showAlertOnForgotPass() {
        let alert = UIAlertController(title: "Внимание", message: "Email введен неверно или такой почты не существует", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let email = emailFieldReset.text!
        if(!email.isEmpty){
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil{
                    self.showAlertResetPassword()
                }else{
                    self.showAlertOnForgotPass()
                }
            }
        }
    }
}

extension UITextField{ //расширение для создания отступа текста слева в TextField
    func indent(size: CGFloat){
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
