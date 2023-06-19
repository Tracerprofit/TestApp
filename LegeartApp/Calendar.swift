//
//  Calendar.swift
//  LegeartApp
//
//  Created by PRGR on 28.01.2022.
//

import UIKit
import FSCalendar

class Calendar: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    
    var calendar: FSCalendar!
    var formatter = DateFormatter()
    let importantDates = ["19-05-2022", "21-05-2022", "24-05-2022", "28-05-2022", "5-05-2022"]
    let importantTask = ["Сделать корзину заказов", "Оформить подписку на Яндекс.Плюс", "Отредактировать страницу заказа", "Заказать пиццу с ананасами", "Порадоваться началу мая"]
    let MonthsEng = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let MonthsRus = ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"]
    let notificationLogo = [UIImage(named: "Anna")]
    let centerLabel = UILabel(frame: CGRect(x: 20, y: 400, width: 350, height: 200))
    @IBOutlet var logo: UIBarButtonItem!
    @IBOutlet var profileLogo: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        logo.setBackgroundImage(UIImage(named: "logoBlackNew"), for: .normal, barMetrics: .default)
        logo.title = " "
        profileLogo.setBackgroundImage(notificationLogo[0], for: .normal, barMetrics: .default)
        addViewNavBar()
        addCalendar()
        setupViews()
    }
    func setupViews(){
        centerLabel.text = "Нажмите на нужную дату."
        centerLabel.numberOfLines = 4
        view.addSubview(centerLabel)
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Календарь"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        let buttonBack = UIButton(frame: CGRect(x: 15, y: 0, width: 10, height: 15))
        buttonBack.setBackgroundImage(UIImage(named: "backVector"), for: .normal)
        buttonBack.center.y = mainView.center.y
        buttonBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(buttonBack)
        
        let bigBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        bigBackButton.center.y = mainView.center.y
        bigBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(bigBackButton)
        
        view.addSubview(mainView)
        
    }
    func addCalendar(){
        calendar = FSCalendar(frame: CGRect(x: 10, y: 40, width: view.frame.size.width - 20, height: 300))
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.appearance.headerDateFormat = "LLLL YYYY"
        calendar.appearance.caseOptions = .headerUsesCapitalized
        calendar.appearance.headerTitleColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.weekdayTextColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.titleDefaultColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.appearance.todayColor = UIColor(red: 0.31, green: 0.18, blue: 0.33, alpha: 1.00)
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.selectionColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        calendar.headerHeight = 30
        calendar.weekdayHeight = 30
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        formatter.dateFormat = "dd-MM-yyyy"
        for impDate in importantDates {
            let eventDate = formatter.date(from: impDate)
            if date.compare(eventDate!) == .orderedSame {
                return 1
            }
            continue
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "d-MM-yyyy"
        formatter.timeZone = NSTimeZone(name: "MSK") as TimeZone?
        for i in 0..<(importantDates.count){
            if formatter.string(from: date) == importantDates[i]{
                formatter.dateFormat = "MMMM"
                for j in 0..<(MonthsEng.count){
                    if formatter.string(from: date) == MonthsEng[j]{
                        formatter.dateFormat = "dd"
                        let day = formatter.string(from: date)
                        formatter.dateFormat = "yyyy"
                        let year = formatter.string(from: date)
                        centerLabel.text = "\(day) \(MonthsRus[j]) \(year) \n" + importantTask[i]
                    }
                }
            }
        }
    }
    
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func profileLogoTapped(_ sender: UIBarButtonItem){
        print("tap")
    }
}
extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
