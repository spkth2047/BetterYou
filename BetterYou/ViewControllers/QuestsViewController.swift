import UIKit

class QuestsViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// Segmented control to switch between Daily and Weekly quests
    @IBOutlet weak var cadenceSegmentedControl: UISegmentedControl!

    /// Quest 1 - title label (e.g. "Log 1 Workout")
    @IBOutlet weak var quest1TitleLabel: UILabel!

    /// Quest 1 - description label (e.g. "Complete any workout today")
    @IBOutlet weak var quest1DetailLabel: UILabel!

    /// Quest 1 - progress bar
    @IBOutlet weak var quest1ProgressBar: UIProgressView!

    /// Quest 1 - reward label (e.g. "+100 XP  +25 coins")
    @IBOutlet weak var quest1RewardLabel: UILabel!

    /// Quest 2 - title label
    @IBOutlet weak var quest2TitleLabel: UILabel!

    /// Quest 2 - description label
    @IBOutlet weak var quest2DetailLabel: UILabel!

    /// Quest 2 - progress bar
    @IBOutlet weak var quest2ProgressBar: UIProgressView!

    /// Quest 3 - title label
    @IBOutlet weak var quest3TitleLabel: UILabel!

    /// Quest 3 - progress bar
    @IBOutlet weak var quest3ProgressBar: UIProgressView!

    /// Floating "Log Workout" button
    @IBOutlet weak var logWorkoutButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quests"
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        setupUI()
        loadQuests()
    }

    // MARK: - IBActions (user interactions)

    /// Called when user switches between Daily / Weekly segment
    @IBAction func cadenceChanged(_ sender: UISegmentedControl) {
        let selectedCadence = sender.selectedSegmentIndex == 0 ? "daily" : "weekly"
        print("Switched to \(selectedCadence) quests")
        loadQuests()
    }

    /// Called when user taps the "+ Log Workout" button
    @IBAction func logWorkoutTapped(_ sender: UIButton) {
        // Perform segue to Log Workout screen
        performSegue(withIdentifier: "showLogWorkout", sender: self)
    }

    // MARK: - Private Helpers

    private func setupUI() {
        // Style the floating button with rounded corners
        logWorkoutButton?.layer.cornerRadius = 22
        logWorkoutButton?.clipsToBounds = true
        logWorkoutButton?.backgroundColor = UIColor(red: 0.224, green: 1.0, blue: 0.533, alpha: 1.0)
    }

    private func loadQuests() {
        // In production, this queries SwiftData for Quest objects
        // filtered by the selected cadence (.daily or .weekly)
        // and updates all IBOutlet labels:
        //
        //   quest1TitleLabel.text = quest.title
        //   quest1DetailLabel.text = quest.detail
        //   quest1ProgressBar.progress = Float(quest.progressFraction)
        //   quest1RewardLabel.text = "+\(quest.xpReward) XP  +\(quest.coinReward) coins"
    }
}
