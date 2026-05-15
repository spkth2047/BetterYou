import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// Avatar display label (showing emoji/icon)
    @IBOutlet weak var avatarLabel: UILabel!

    /// Title badge label (e.g. "Newbie", "Iron Lifter")
    @IBOutlet weak var titleBadgeLabel: UILabel!

    /// Section header "Display Name"
    @IBOutlet weak var displayNameSectionLabel: UILabel!

    /// Text field for editing the display name
    @IBOutlet weak var nameTextField: UITextField!

    /// "Edit" button to toggle name editing
    @IBOutlet weak var editNameButton: UIButton!

    /// Section header "Body Weight"
    @IBOutlet weak var bodyWeightSectionLabel: UILabel!

    /// Label showing current body weight (e.g. "72.5 kg")
    @IBOutlet weak var bodyWeightValueLabel: UILabel!

    /// "Update" button to change body weight
    @IBOutlet weak var updateWeightButton: UIButton!

    /// Section header "About"
    @IBOutlet weak var aboutSectionLabel: UILabel!

    /// Version label (e.g. "Version 1.0.0")
    @IBOutlet weak var versionLabel: UILabel!

    /// Team member 1 label
    @IBOutlet weak var teamMember1Label: UILabel!

    /// Team member 2 label
    @IBOutlet weak var teamMember2Label: UILabel!

    /// Red "Reset Progress" destructive button
    @IBOutlet weak var resetProgressButton: UIButton!

    // MARK: - Properties

    private var isEditingName = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        setupUI()
        loadProfileData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
    }

    // MARK: - IBActions (user interactions)

    /// Called when user taps the "Edit" button to toggle name editing
    @IBAction func editNameTapped(_ sender: UIButton) {
        isEditingName.toggle()

        if isEditingName {
            // Switch to editing mode
            nameTextField?.isEnabled = true
            nameTextField?.becomeFirstResponder()
            editNameButton?.setTitle("Save", for: .normal)
        } else {
            // Save the new name
            nameTextField?.isEnabled = false
            nameTextField?.resignFirstResponder()
            editNameButton?.setTitle("Edit", for: .normal)

            if let newName = nameTextField?.text, !newName.isEmpty {
                print("Name updated to: \(newName)")
                // In production: profile.name = newName
            }
        }
    }

    /// Called when user taps the "Update" button to change body weight
    @IBAction func updateWeightTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Update Weight",
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
                self?.bodyWeightValueLabel?.text = String(format: "%.1f kg", weight)
                print("Weight updated to: \(weight) kg")
                // In production:
                // profile.bodyWeightKg = weight
                // Also create a WeightLog entry for the chart
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Called when user taps the "Reset Progress" button
    @IBAction func resetProgressTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Reset Progress",
            message: "This will delete all workouts, quests, and reset your level. This cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            print("Progress reset!")
            // In production, this resets the UserProfile:
            //   profile.currentXP = 0
            //   profile.lifetimeXP = 0
            //   profile.level = 1
            //   profile.coinBalance = 0
            //   profile.currentStreak = 0
            //   profile.streakFreezesOwned = 0
            //
            // And deletes all data:
            //   Delete all Workout objects
            //   Delete all Quest objects
            //   Delete all WeightLog objects
            //   Refresh quests with QuestEngine.refreshIfNeeded()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Private Helpers

    private func setupUI() {
        // Style the avatar label as a circle
        avatarLabel?.layer.cornerRadius = 40
        avatarLabel?.clipsToBounds = true

        // Style the reset button
        resetProgressButton?.layer.cornerRadius = 12
        resetProgressButton?.layer.borderWidth = 1
        resetProgressButton?.layer.borderColor = UIColor.systemRed.cgColor

        // Initially disable name editing
        nameTextField?.isEnabled = false
    }

    private func loadProfileData() {
        // In production, this queries SwiftData for the UserProfile
        // and updates all IBOutlets:
        //
        //   avatarLabel.text = profile.avatarID  (SF Symbol mapped to emoji)
        //   titleBadgeLabel.text = profile.selectedTitle
        //   nameTextField.text = profile.name
        //   bodyWeightValueLabel.text = String(format: "%.1f kg", profile.bodyWeightKg ?? 0)
        //   versionLabel.text = "Version 1.0.0"
        //   teamMember1Label.text = "Surya Prakash Seth"
        //   teamMember2Label.text = "Naman Ahuja"
    }
}
