import UIKit
import SwiftData

class HomeViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// Label displaying the user's current level number (e.g. "5")
    @IBOutlet weak var levelLabel: UILabel!

    /// Label showing "LEVEL" text below the level number
    @IBOutlet weak var levelCaptionLabel: UILabel!

    /// Progress bar showing XP progress toward next level
    @IBOutlet weak var xpProgressBar: UIProgressView!

    /// Label showing lifetime XP count (e.g. "⚡ 1350  Lifetime XP")
    @IBOutlet weak var lifetimeXPLabel: UILabel!

    /// Label showing current streak (e.g. "🔥 5 days  Streak")
    @IBOutlet weak var streakLabel: UILabel!

    /// Section header label "Today's Quests"
    @IBOutlet weak var questsSectionLabel: UILabel!

    /// Label for first daily quest (e.g. "Log 1 Workout  +100 XP")
    @IBOutlet weak var quest1Label: UILabel!

    /// Progress bar for first quest
    @IBOutlet weak var quest1ProgressBar: UIProgressView!

    /// Label for second daily quest
    @IBOutlet weak var quest2Label: UILabel!

    /// Progress bar for second quest
    @IBOutlet weak var quest2ProgressBar: UIProgressView!

    /// Green "Log Workout" button at the bottom
    @IBOutlet weak var logWorkoutButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BetterYou"
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        setupUI()
        loadProfileData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
    }

    // MARK: - IBActions (button tap handlers)

    /// Called when user taps the "Log Workout" button
    @IBAction func logWorkoutTapped(_ sender: UIButton) {
        // Navigate to Log Workout screen or switch to Quests tab
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1 // Switch to Quests tab
        }
    }

    // MARK: - Private Helpers

    private func setupUI() {
        // Style the Log Workout button
        logWorkoutButton?.layer.cornerRadius = 16
        logWorkoutButton?.clipsToBounds = true
        logWorkoutButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        // Style progress bars
        xpProgressBar?.progressTintColor = UIColor(red: 0.224, green: 1.0, blue: 0.533, alpha: 1.0)
        xpProgressBar?.trackTintColor = UIColor(red: 0.086, green: 0.086, blue: 0.122, alpha: 1.0)
    }

    private func loadProfileData() {
        // In production, this would query SwiftData for the UserProfile
        // and update all IBOutlet labels with live data:
        //
        //   levelLabel.text = "\(profile.level)"
        //   lifetimeXPLabel.text = "⚡ \(profile.lifetimeXP)  Lifetime XP"
        //   streakLabel.text = "🔥 \(profile.currentStreak) days  Streak"
        //   xpProgressBar.progress = Float(profile.xpProgress)
        //
        // For the Storyboard demo, these values are set in Interface Builder.
    }
}
