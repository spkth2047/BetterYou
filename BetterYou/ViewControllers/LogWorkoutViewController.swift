import UIKit

class LogWorkoutViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// Title label "Log Workout"
    @IBOutlet weak var titleLabel: UILabel!

    /// Segmented control for workout type: Strength / Cardio / Bodyweight / Custom
    @IBOutlet weak var workoutTypeSegment: UISegmentedControl!

    /// Text field for workout name
    @IBOutlet weak var nameTextField: UITextField!

    /// Text field for duration in minutes
    @IBOutlet weak var durationTextField: UITextField!

    /// Label "Sets" section header
    @IBOutlet weak var setsLabel: UILabel!

    /// Text field for entering reps count
    @IBOutlet weak var repsTextField: UITextField!

    /// Text field for entering weight in kg
    @IBOutlet weak var weightTextField: UITextField!

    /// Text field for notes
    @IBOutlet weak var notesTextField: UITextField!

    /// Green "Save Workout" button
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        setupUI()
    }

    // MARK: - IBActions (user interactions)

    /// Called when user changes workout type in the segmented control
    @IBAction func workoutTypeChanged(_ sender: UISegmentedControl) {
        let types = ["Strength", "Cardio", "Bodyweight", "Custom"]
        let selectedType = types[sender.selectedSegmentIndex]
        print("Selected workout type: \(selectedType)")

        // Show/hide sets vs distance fields based on type
        switch sender.selectedSegmentIndex {
        case 0: // Strength
            setsLabel?.isHidden = false
            repsTextField?.isHidden = false
            weightTextField?.isHidden = false
        case 1: // Cardio
            setsLabel?.isHidden = true
            repsTextField?.isHidden = true
            weightTextField?.isHidden = true
        case 2: // Bodyweight
            setsLabel?.isHidden = false
            repsTextField?.isHidden = false
            weightTextField?.isHidden = true
        case 3: // Custom
            setsLabel?.isHidden = true
            repsTextField?.isHidden = true
            weightTextField?.isHidden = true
        default:
            break
        }
    }

    /// Called when user taps the "Save Workout" button
    @IBAction func saveWorkoutTapped(_ sender: UIButton) {
        guard let name = nameTextField?.text, !name.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter a workout name.")
            return
        }

        let durationMinutes = Int(durationTextField?.text ?? "0") ?? 0
        let durationSec = durationMinutes * 60
        let reps = Int(repsTextField?.text ?? "0") ?? 0
        let weightKg = Double(weightTextField?.text ?? "0") ?? 0.0

        print("Saving workout: \(name), duration: \(durationSec)s, reps: \(reps), weight: \(weightKg)kg")

        // In production, this would:
        // 1. Create a Workout object and insert into SwiftData
        // 2. Call XPEngine.awardWorkout(profile:) → +50 XP, +10 coins
        // 3. Call QuestEngine.recomputeProgress() → update quest progress
        // 4. Check XPEngine.didLevelUp() → show LevelUpSheet if leveled up
        // 5. Dismiss this view controller

        showAlert(title: "Workout Saved!", message: "+50 XP and +10 Coins earned!") {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Private Helpers

    private func setupUI() {
        saveButton?.layer.cornerRadius = 16
        saveButton?.clipsToBounds = true

        // Dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
