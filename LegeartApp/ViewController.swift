//
//  ViewController.swift
//  LegeartApp
//
//  Created by PRGR on 18.01.2022.
//

import UIKit
import Firebase
import FSCalendar

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {

    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var gradientViewManager: UIView!
    @IBOutlet var tableViewOfTasks: UITableView!
//    @IBOutlet weak var incomingPush: UIButton!
//    @IBOutlet weak var incomingReq: UIButton!
//    @IBOutlet weak var incomingHot: UIButton!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeleftButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var mainCalendarTaskButton: UIButton!
    @IBOutlet weak var callManagerButton: UIButton!
    @IBOutlet weak var newMessageManagerButton: UIButton!
    let database = Database.database().reference()
    var calendar: FSCalendar!
    var formatter = DateFormatter()
    let labelName = UILabel(frame: CGRect(x: 25, y: 15, width: 300, height: 30))
    let gradientView = UIImageView(frame: CGRect(x: 0, y: 0, width: 414, height: 225))
    let classCalendarDates: Calendar = Calendar()
    let colorsOfStatus = [UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00), UIColor(red: 1.00, green: 0.77, blue: 0.34, alpha: 1.00), UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00), UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00) ,UIColor(red: 0.90, green: 0.15, blue: 0.07, alpha: 1.00)/*green[0],yellow[1],gray[2],blue[3],red[4]*/]
    
    let status = ["Принято", "Срок изменен", "В работе", "Завершена", "Принято", "Срок изменен", "В работе", "Завершена"]
    let managersStatus = ["В работе", "Завершена", "Просрочена", "Ждет подтверждения", "В работе", "Завершена", "Просрочена", "Ждет подтверждения"]
    let authorForManager = ["Антон Васильевич"]
    let nameOfCompany = ["ООО «Константинопольск никольский»"]
//    let numbersForButtons = ["123", "5", "05.04 в
    let arrayNameOfManager = ["Кристина"]
    //viewWillAppear and viewWillDisappear use to change nav bar gradient/blue colour
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelName.text = ""
        GetDataForDB()
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00), UIColor(red: 0.25, green: 0.13, blue: 0.27, alpha: 1.00)], startPoint: .custom(point: CGPoint(x: 0.25, y: 0.5)), endPoint: .custom(point: CGPoint(x: 0.75, y: 0.5)))
        navigationController?.navigationBar.shouldRemoveShadow(true)
        
        //check for admin
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            if let err = err{
                print(err)
            } else {
                for doc in snap!.documents {
                    if Auth.auth().currentUser?.uid == doc.documentID {
                        if (doc.data()["admin"] as? String) == "true"{
                            self.gradientViewManager.isHidden = true
                            self.viewThree.transform = CGAffineTransform( translationX: 0.0, y: -148.0 )
                        }
                    }
                }
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00), UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)], startPoint: .topLeft, endPoint: .bottomRight)
        navigationController?.navigationBar.shouldRemoveShadow(false)
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            if let err = err{
                print(err)
            } else {
                for doc in snap!.documents {
                    if Auth.auth().currentUser?.uid == doc.documentID {
                        if (doc.data()["admin"] as? String) == "true"{
                            self.viewThree.transform = CGAffineTransform( translationX: 0.0, y: 148.0 )
                        }
                    }
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        setupCalendar()
        
        
        tableViewOfTasks.layoutMargins = UIEdgeInsets.zero
        tableViewOfTasks.separatorInset = UIEdgeInsets.zero
        
    }
    
    func setupCalendar(){
        calendar = FSCalendar(frame: CGRect(x: 20, y: 60, width: Int(viewThree.frame.size.width - 40), height: 250))
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        calendar.scope = .week
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.appearance.headerDateFormat = "LLLL"
        calendar.appearance.caseOptions = .headerUsesCapitalized
        calendar.appearance.headerTitleColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.weekdayTextColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.titleDefaultColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.todayColor = UIColor(red: 0.31, green: 0.18, blue: 0.33, alpha: 1.00)
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.selectionColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.headerHeight = 20
        calendar.weekdayHeight = 30
        calendar.dataSource = self
        calendar.delegate = self
        
        viewThree.addSubview(calendar)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        formatter.dateFormat = "dd-MM-yyyy"
        for perDate in classCalendarDates.importantDates {
            let excludedData = formatter.date(from: perDate)
            if date.compare(excludedData!) == .orderedSame {
                return nil
            }
            continue
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        formatter.dateFormat = "dd-MM-yyyy"
        for impDate in classCalendarDates.importantDates {
            let eventDate = formatter.date(from: impDate)
            if date.compare(eventDate!) == .orderedSame {
                return 1
            }
            continue
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MM-yyyy"
        for impData in classCalendarDates.importantDates{
            if formatter.string(from: date) == impData{
                print("You'r date is: " + formatter.string(from: date))
            }
        }
    }
    
    //all views, targets on buttons and scrollView and his settings.
    func setupViews(){
        //add shadow and corner radius for all views
        for views in [viewOne, viewTwo, viewThree, gradientViewManager]{
            views?.layer.cornerRadius = 20
            views?.layer.shadowColor = UIColor.black.cgColor
            views?.layer.shadowOffset = .zero
            views?.layer.shadowOpacity = 0.2
            views?.layer.shadowRadius = 6.0
        }
        
        //white sublayers for buttons
        let whiteLayer = CALayer()
        whiteLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.08).cgColor
        whiteLayer.cornerRadius = 15
        whiteLayer.frame = CGRect(x: 0, y: 0, width: 174, height: 30)
        playButton.layer.addSublayer(whiteLayer)
        
        let whiteLayerTwo = CALayer()
        whiteLayerTwo.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.08).cgColor
        whiteLayerTwo.cornerRadius = 15
        whiteLayerTwo.frame = CGRect(x: 0, y: 0, width: 174, height: 30)
        timeleftButton.layer.addSublayer(whiteLayerTwo)
        
        let whiteLayerBig = CALayer()
        whiteLayerBig.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.08).cgColor
        whiteLayerBig.cornerRadius = 15
        whiteLayerBig.frame = CGRect(x: 0, y: 0, width: 364, height: 30)
        calendarButton.layer.addSublayer(whiteLayerBig)
        
        //gradient view
        gradientView.layer.zPosition = -100
        gradientView.addBlackGradientLayerInBackground(frame: gradientView.bounds, colors: [UIColor(red: 0.133, green: 0.176, blue: 0.282, alpha: 1), UIColor(red: 0.25, green: 0.13, blue: 0.27, alpha: 1.00)])
        
        //manager gradient view
        gradientViewManager.addBlackGradientLayerInBackground(frame: gradientViewManager.bounds, colors: [UIColor(red: 0.133, green: 0.176, blue: 0.282, alpha: 1), UIColor(red: 0.25, green: 0.13, blue: 0.27, alpha: 1.00)])
        gradientViewManager.layer.masksToBounds = true
        
        let img = UIImageView(frame: CGRect(x: 20, y: 61, width: 45, height: 45))
        img.image = UIImage(named: "Kris")
        
        let nameOfManager = UILabel(frame: CGRect(x: 76, y: 68, width: 100, height: 16))
        nameOfManager.font = UIFont.systemFont(ofSize: 14)
        nameOfManager.textColor = .white
        nameOfManager.text = arrayNameOfManager[0]
        
        let descriptionText = UILabel(frame: CGRect(x: 76, y: 87, width: 180, height: 13))
        descriptionText.font = UIFont.systemFont(ofSize: 10)
        descriptionText.textColor = .white
        descriptionText.text = "Есть вопросы? Я всегда на связи!"
        
        let online = UIImageView(frame: CGRect(x: 37, y: 37, width: 8, height: 8))
        online.image = UIImage(named: "statusOnline")
        
        img.addSubview(online)
        gradientViewManager.addSubview(img)
        gradientViewManager.addSubview(nameOfManager)
        gradientViewManager.addSubview(descriptionText)
        
        //targets for buttons
        playButton.addTarget(self, action: #selector(inJobButtonPressed), for: .touchUpInside)
        timeleftButton.addTarget(self, action: #selector(timeLeftButtonPressed), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(deadEndButtonPressed), for: .touchUpInside)
        callManagerButton.addTarget(self, action: #selector(callAManager), for: .touchUpInside)
        newMessageManagerButton.addTarget(self, action: #selector(newMessageButtonPressed), for: .touchUpInside)
        
        //set scrollView and object on it
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        view.addSubview(scrollView)
        scrollView.addSubview(playButton)
        scrollView.addSubview(timeleftButton)
        scrollView.addSubview(calendarButton)
        scrollView.addSubview(gradientView)
        scrollView.addSubview(viewTwo)
        scrollView.addSubview(viewThree)
        scrollView.addSubview(gradientViewManager)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        scrollView.showsVerticalScrollIndicator = false
        
    }
    // take count of tasks for buttons title and take name of account
    func GetDataForDB(){
        
        
        labelName.text = "Загрузка..."
        labelName.textColor = .white
        labelName.font = UIFont.systemFont(ofSize: 24)
        
        let situation = UILabel(frame: CGRect(x: 25, y: 55, width: 200, height: 25))
        situation.textColor = .white
        situation.text = "ситуация по задачам:"
        situation.font = UIFont.systemFont(ofSize: 16)

        database.child("Situation").observe(.value, with: { snap in
            guard let value = snap.value as? [String: String] else {
                return
            }
            self.playButton.setTitle(" в работе: \(value["inJob"] ?? "000")", for: .normal)
            self.timeleftButton.setTitle(" на очереди: \(value["inQueue"] ?? "000")", for: .normal)
            self.calendarButton.setTitle(" завершим работы: \(value["deadLine"] ?? "000")", for: .normal)
        })

        let safeEmail = ChatViewController.safeEmail(emailAddress: Auth.auth().currentUser?.email ?? "Error in email")
        database.child("Users").observe(.value, with: { snap in
            guard let value = snap.value as? [[String: String]] else {
                print("Ошибка получения данных с БД")
                return
            }
            for i in 0..<value.count{
                if value[i]["email"] == safeEmail{
                    self.labelName.text = "\(value[i]["name"] ?? "Default"),"
                }
            }
        })
        
        gradientView.addSubview(labelName)
        gradientView.addSubview(situation)
    }
    //settings table view cell "Tasks"
    func setupTableView(){
        tableViewOfTasks.delegate = self
        tableViewOfTasks.dataSource = self
        tableViewOfTasks.tableFooterView = UIView()
        
        let nib = UINib(nibName: "TaskViewCell", bundle: nil)
        tableViewOfTasks.register(nib, forCellReuseIdentifier: "TaskViewCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vc = self.storyboard?.instantiateViewController(identifier: "Tasks") as? Tasks{
            return vc.namesTasks.count
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOfTasks.dequeueReusableCell(withIdentifier: "TaskViewCell", for: indexPath) as! TaskViewCell

        cell.status.textAlignment = .right
//        cell.textOfTask.text = namedOfTask[indexPath.row]
        cell.author1.image = UIImage(named: "Anna")
        cell.author2.image = UIImage(named: "Anna")
        cell.author3.image = UIImage(named: "Anna")
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "Tasks") as? Tasks{
            
            
            cell.textOfTask.text = vc.namesTasks[indexPath.row]
            cell.status.text = status[indexPath.row]
            cell.data.text = vc.datesTasks[indexPath.row]
            
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        let company = UILabel(frame: CGRect(x: 20, y: 74, width: 180, height: 14))
        company.textColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00) //blue colour font
        company.text = self.nameOfCompany[0]
        company.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0))
        
        let name = UILabel(frame: CGRect(x: 208, y: 74, width: 115, height: 14))
        name.textAlignment = .right
        name.text = self.authorForManager[0]
        name.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0))
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            if let err = err{
                print(err)
            } else {
                for doc in snap!.documents {
                    if Auth.auth().currentUser?.uid == doc.documentID {
                        
                        if (doc.data()["admin"] as? String) == "true"{
                            cell.author1.isHidden = true
                            cell.author2.isHidden = true
                            
                            cell.addSubview(company)
                            cell.addSubview(name)
                            cell.status.text = self.managersStatus[indexPath.row]
                        } else {
                            cell.author1.isHidden = false
                            cell.author2.isHidden = false
                            company.removeFromSuperview()
                            name.removeFromSuperview()
                            cell.status.text = self.status[indexPath.row]
                        }
                        
                        if cell.status.text == "Принято" || cell.status.text == "В работе"{
                            cell.status.textColor = self.colorsOfStatus[0]
                        } else if cell.status.text == "Срок изменен"{
                            cell.status.textColor = self.colorsOfStatus[1]
                        } else if cell.status.text == "Завершена"{
                            cell.status.textColor = self.colorsOfStatus[2]
                        } else if cell.status.text == "Просрочена"{
                            cell.status.textColor = self.colorsOfStatus[4]
                        } else if cell.status.text == "Ждет подтверждения"{
                            cell.status.textColor = self.colorsOfStatus[3]
                        } else{
                            cell.status.textColor = UIColor.red
                        }
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "AnyTaskView") as! AnyTaskView
        let AnotherVc = self.storyboard?.instantiateViewController(identifier: "Tasks") as! Tasks
        
        vc.HeaderOfTaskLabel.text = AnotherVc.namesTasks[indexPath.row]
        vc.dateLabel.text = AnotherVc.datesTasks[indexPath.row]
        vc.statusLabel.text = status[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
        tableViewOfTasks.deselectRow(at: indexPath, animated: true)
    }
    @objc func callAManager(){
        print("Позвонить...")
    }
    @objc func newMessageButtonPressed(){
        print("Написать новое сообщение...")
    }
    @objc func inJobButtonPressed(){
        print("В работе...")
    }
    @objc func timeLeftButtonPressed(){
        print("На очереди...")
    }
    @objc func deadEndButtonPressed(){
        print("Завершим работы...")
    }
    @IBAction func pressIncomingPush(_ sender: UIButton) {
        performSegue(withIdentifier: "VhodUved", sender: nil)
    }
    @IBAction func pressIncomingReq(_ sender: UIButton) {
        performSegue(withIdentifier: "VhodZapr", sender: nil)
    }
    @IBAction func pressIncomingHot(_ sender: UIButton) {
        performSegue(withIdentifier: "VhodHot", sender: nil)
    }
    @IBAction func TasksTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Tasks", sender: nil)
    }
    @IBAction func CalendarTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Calendar", sender: nil)
    }
    
}
//set the gradient button style/corner radius and colours
class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(red: 0.133, green: 0.176, blue: 0.282, alpha: 1).cgColor, UIColor(red: 0.282, green: 0.145, blue: 0.314, alpha: 1).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 15
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
//set the main view on gradient
extension UIView{
   // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
   }
}
extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

