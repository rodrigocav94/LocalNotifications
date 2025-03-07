//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 27/06/24.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController {
    var datePicker: UIDatePicker?  = nil
    var notificationTitle = ""
    var notificationMessage = ""
    var repeats = false
    var dateType = DatePickerType.dateAndTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupNavBar()
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            2
        case 1:
            2
        case 2:
            3
        case 3:
            1
        default:
            0
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
            switch indexPath.row {
            case 0:
                id = "TextFieldCell"
            case 1:
                id = "TextViewCell"
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                id = "SegmentedCell"
            case 1:
                id = "DatePickerCell"
            case 2:
                id = "ToggleCell"
            default:
                break
            }
            
        case 3:
            id = "ButtonCell"
            buttonSettings = .scheduleNotification
            
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        switch cell {
        case let cell as ButtonCell:
            cell.customize(
                title: buttonSettings.title,
                color: buttonSettings.color,
                delegate: self
            )
        case let cell as SegmentedCell:
            cell.delegate = self
        case let cell as DatePickerCell:
            cell.setup(delegate: self, datePicker: &datePicker)
        case let cell as ToggleCell:
            cell.setup(title: "Repeat", delegate: self)
        case let cell as TextFieldCell:
            cell.setup(title: "Title", placeholder: "Enter the notification title", delegate: self)
        case let cell as TextViewCell:
            cell.setup(title: "Message", delegate: self)
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Shortcuts"
        case 1:
            return "Customize message"
        case 2:
            return "Schedule a new notification"
        default:
            break
        }
        return nil
    }
    
    func setupNavBar() {
        title = "local notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func registerCells() {
        tableView.register(SegmentedCell.self, forCellReuseIdentifier: "SegmentedCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "DatePickerCell")
        tableView.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "TextFieldCell")
        tableView.register(TextViewCell.self, forCellReuseIdentifier: "TextViewCell")
    }
    
    func displayAlert(type: ViewControllerAlertType) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: type.title, message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
}

// MARK: - Alert Enum Types
enum ViewControllerAlertType {
    case alertScheduled, pedingNotificationsRemoved, permissionGranted, permissionDenied
    
    var title: String {
        switch self {
        case .alertScheduled:
            "Notification has been scheduled!"
        case .pedingNotificationsRemoved:
            "All pending notifications have been removed."
        case .permissionGranted:
            "Notification permission has been granted."
        case .permissionDenied:
            "Notification permission has been denied."
        }
    }
}

// MARK: - TextView Methods
extension ViewController: TextViewCellDelegate {
    func textViewDidChange(text: String) {
        notificationMessage = text
    }
}

// MARK: - TextField Methods
extension ViewController: TextFieldDelegate {
    func onTextFieldChanged(text: String) {
        notificationTitle = text
    }
}

// MARK: - Toggle Methods
extension ViewController: ToggleCellDelegate {
    func onToggleChanged(isEnabled: Bool) {
        repeats = isEnabled
    }
}

// MARK: - Segmented Control Methods
extension ViewController: SegmentedCellDelegate {
    func onSegmentedValueChanged(control: UISegmentedControl) {
        guard let newValue = DatePickerType(rawValue: control.selectedSegmentIndex) else { return }
        customizeDatePicker(to: newValue)
        dateType = newValue
    }
}

// MARK: - DatePicker Methods
extension ViewController: DatePickerDelegate {
    func onDateChanged(date: Date) {
        return
    }
    
    func customizeDatePicker(to type: DatePickerType) {
        switch type {
        case .dateAndTime:
            datePicker?.minimumDate = .now
            datePicker?.datePickerMode = .dateAndTime
            datePicker?.preferredDatePickerStyle = .inline
            
        case .time:
            datePicker?.minimumDate = nil
            datePicker?.datePickerMode = .time
            datePicker?.preferredDatePickerStyle = .wheels
            
        case .countDownTimer:
            datePicker?.minimumDate = nil
            datePicker?.preferredDatePickerStyle = .wheels
            datePicker?.datePickerMode = .countDownTimer
        }
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
        case .scheduleNotification:
                .white
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
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                self?.displayAlert(type: .permissionGranted)
            } else {
                self?.displayAlert(type: .permissionDenied)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let reschedule = UNNotificationAction(
            identifier: "reschedule",
            title: "Remind me tomorrow",
            options: .foreground
        )
        
        let category = UNNotificationCategory(
            identifier: "alarm",
            actions: [reschedule],
            intentIdentifiers: []
        )
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let userInfo = userInfo["customData"] as? String {
            assert(userInfo == "This is a local notification!") // Verify if the userInfo has been passed.
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // The user swiped to unlock
                print("Default identifier")
                
            case "reschedule":
                // The user tapped our "show more info..." button
                rescheduleLocal(request: response.notification.request)
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationMessage
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "This is a local notification!"]
        content.sound = UNNotificationSound.default
        
        let trigger = createTrigger()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func rescheduleLocal(request: UNNotificationRequest) {
        let center = UNUserNotificationCenter.current()
        let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        let content = request.content
        let newRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: newTrigger)
        
        center.add(newRequest)
    }
    
    func triggerNotificationImmediately() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationMessage
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func createTrigger() -> UNNotificationTrigger {
        let datePickerDate = datePicker?.date ?? Date()
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .month, .day, .year], from: datePickerDate)
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .month, .day, .year], from: Date())
        
        switch dateType {
        case .dateAndTime:
            if datePickerDate <= Date() {
                if repeats {
                    triggerNotificationImmediately()
                } else {
                    return UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                }
            }
            displayAlert(type: .alertScheduled)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
            return trigger
        case .time:
            if (dateComponents.minute, dateComponents.hour) == (currentDateComponents.minute, currentDateComponents.hour) {
                if repeats {
                    triggerNotificationImmediately()
                } else {
                    return UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                }
            }
            displayAlert(type: .alertScheduled)
            dateComponents.month = nil
            dateComponents.day = nil
            dateComponents.year = nil
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
            return trigger
        case .countDownTimer:
            displayAlert(type: .alertScheduled)
            let duration = datePicker?.countDownDuration ?? 60
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: repeats)
            return trigger
        }
    }
    
    func removePendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        displayAlert(type: .pedingNotificationsRemoved)
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
