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
        switch section {
        case 0:
            2
        default:
            1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var id = ""
        var buttonSettings = ViewControllerButton.requestPermission
        
        switch indexPath.section {
        case 0:
            id = "ButtonCell"
            if indexPath.row == 1 {
                buttonSettings = .removePendingNotifications
            }
        case 1:
            id = "SegmentedCell"
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        if let buttonCell = cell as? ButtonCell {
            buttonCell.customize(
                title: buttonSettings.title,
                color: buttonSettings.color,
                delegate: self
            )
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Shortcuts"
        case 1:
            return "Setup a new notification"
        default:
            break
        }
        return nil
    }
    
    func setupNavBar() {
        title = "LocalNotifications"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    func registerCells() {
        tableView.register(SegmentedCell.self, forCellReuseIdentifier: "SegmentedCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
    }
}

// MARK: - Button Related Methods
enum ViewControllerButton: CaseIterable {
    case requestPermission, scheduleNotification, removePendingNotifications
    
    var title: String {
        switch self {
        case .requestPermission:
            "Request Notification Permission"
        case .scheduleNotification:
            "Schedule Notification"
        case .removePendingNotifications:
            "Remove All Pending Notifications"
        }
    }
    
    var color: UIColor {
        switch self {
        case .removePendingNotifications:
            .red
        default:
            .tintColor
        }
    }
}

extension ViewController: ButtonCellDelegate {
    func onDidTapButton(cell: ButtonCell) {
        guard let buttonType = ViewControllerButton.allCases.first(where: {
            $0.title == cell.button.titleLabel?.text
        }) else { return }
        
        switch buttonType {
        case .requestPermission:
            registerLocal()
        case .removePendingNotifications:
            removePendingNotifications()
        case .scheduleNotification:
            scheduleLocal()
        }
    }
}

// MARK: - Notification Related Methods
extension ViewController: UNUserNotificationCenterDelegate  {
    
    func registerLocal() {
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
    
    func removePendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
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
