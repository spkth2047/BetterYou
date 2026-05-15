import UIKit

class StatsViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// KPI value label for total workouts count (e.g. "12")
    @IBOutlet weak var workoutsValueLabel: UILabel!

    /// KPI caption label "Workouts"
    @IBOutlet weak var workoutsCaptionLabel: UILabel!

    /// KPI value label for total time (e.g. "4h 30m")
    @IBOutlet weak var timeValueLabel: UILabel!

    /// KPI caption label "Time"
    @IBOutlet weak var timeCaptionLabel: UILabel!

    /// KPI value label for total volume (e.g. "8.5T")
    @IBOutlet weak var volumeValueLabel: UILabel!

    /// KPI caption label "Volume"
    @IBOutlet weak var volumeCaptionLabel: UILabel!

    /// Section header "This Week"
    @IBOutlet weak var thisWeekLabel: UILabel!

    /// Label showing weekly workout count (e.g. "3/4")
    @IBOutlet weak var weeklyCountLabel: UILabel!

    /// Progress bar for weekly workout goal
    @IBOutlet weak var weeklyProgressBar: UIProgressView!

    /// Section header "Body Weight"
    @IBOutlet weak var bodyWeightLabel: UILabel!

    /// "+" button to add a new weight entry
    @IBOutlet weak var addWeightButton: UIButton!

    /// Label placeholder for the Swift Charts weight graph
    @IBOutlet weak var chartPlaceholderLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stats"
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        loadStats()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStats()
    }

    // MARK: - IBActions (user interactions)

    /// Called when user taps the "+" button to log body weight
    @IBAction func addWeightTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Log Weight",
            message: "Enter your current weight in kg",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Weight (kg)"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text,
               let weight = Double(text), weight > 0 {
                print("Saved weight: \(weight) kg")
                // In production: create WeightLog entry in SwiftData
                // Update profile.bodyWeightKg
                // Chart would auto-refresh via @Query
                self?.showConfirmation(weight: weight)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Private Helpers

    private func loadStats() {
        // In production, this queries SwiftData for all Workout objects
        // and computes aggregate stats:
        //
        //   workoutsValueLabel.text = "\(workouts.count)"
        //   timeValueLabel.text = formatDuration(totalTimeSec)
        //   volumeValueLabel.text = formatVolume(totalVolume)
        //   weeklyCountLabel.text = "\(workoutsThisWeek)/4"
        //   weeklyProgressBar.progress = Float(workoutsThisWeek) / 4.0
    }

    private func showConfirmation(weight: Double) {
        let alert = UIAlertController(
            title: "Weight Logged",
            message: String(format: "%.1f kg recorded successfully!", weight),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
