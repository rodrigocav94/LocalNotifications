//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 27/06/24.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupNavBar()
        tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = indexPath.section == 0 ? "ButtonCell" : "SegmentedCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
//        if let cellButton = cell as? ButtonCell {
//            cellButton.setupView()
//        }
        return cell
    }
    
    func setupNavBar() {
        title = "LocalNotifications"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    func registerCells() {
        tableView.register(SegmentedCell.self, forCellReuseIdentifier: "SegmentedCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
    }
}

// MARK: - Alert Related Methods
extension ViewController: UNUserNotificationCenterDelegate  {
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(
            identifier: "show",
            title: "Tell me more...",
            options: .foreground
        )
        
        let category = UNNotificationCategory(
            identifier: "alarm",
            actions: [show],
            intentIdentifiers: []
        )
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // The user swiped to unlock
                print("Default identifier")
                
            case "show":
                // The user tapped our "show more info..." button
                print("Show more information...")
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = createTrigger()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func createTrigger(hour: Int? = nil, minute: Int? = nil) -> UNNotificationTrigger {
        if let hour, let minute {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            return trigger
        } else {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            return trigger
        }
    }
}

// MARK: - Preview
#Preview {
    UIStoryboard(
        name: "Main",
        bundle: nil
    )
    .instantiateInitialViewController()!
}
