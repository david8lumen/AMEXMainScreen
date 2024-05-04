//
//  AppDelegate.swift
//
//  Created by David Grigoryan
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let cards = loadJSONData() ?? []
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        
        let mainViewController = storyboard.instantiateViewController(identifier: MainViewController.storyboardId) { coder in
            let mainViewController = MainViewController(coder: coder, cards: cards)
            return mainViewController
        }
        
        navigationController.viewControllers = [mainViewController]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func loadJSONData() -> [Card]? {
        guard let url = Bundle.main.url(forResource: "cards", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let cardsArray = jsonObject["cards"] as? [[String: Any]] {
                let decoder = JSONDecoder()
                let jsonData = try JSONSerialization.data(withJSONObject: cardsArray, options: [])
                let cards = try decoder.decode([Card].self, from: jsonData)
                return cards
            }
            return nil
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

