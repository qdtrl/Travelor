//
//  TranslateViewController.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 23/05/2023.
//

import UIKit

class TranslateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private let networkManager = NetworkManager.shared
    private let translate = TranslateService()
    
    private var languageChoice: String = ""
    private var languageChoiceName: String = ""
    private var languagesNames: [String] = []
    private var languagesCodes: [String] = []

    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var translation: UILabel!
    
    @IBOutlet weak var textToTranslate: UITextField!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
        
        guard let text = textToTranslate.text else {
            print("Nothing to translate")
            return
        }
        
        if text == "" {
            self.textToTranslate.placeholder = "Entrez du text à traduire en " + languageChoiceName
        } else {
            loadingIndicator.startAnimating()
            
            translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
                guard let translationData = translationData, success == true else {
                    return
                }
                DispatchQueue.main.async { [ weak self ] in
                    self?.translation.text = translationData.data.translations[0].translatedText
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.hidesWhenStopped = true
        
        if networkManager.isReachable {
            loadingIndicator.startAnimating()
            
            languagePicker.dataSource = self
            languagePicker.delegate = self
            textToTranslate.delegate = self
            
            let maxWidth: CGFloat = 300 // Set the maximum width you desire
            translation.translatesAutoresizingMaskIntoConstraints = false
            
            // Create width constraint
            let widthConstraint = translation.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            widthConstraint.isActive = true
            translation.lineBreakMode = .byWordWrapping
            translation.sizeToFit()
            
            textToTranslate.translatesAutoresizingMaskIntoConstraints = false
            
            // Create width constraint
            
            textToTranslate.sizeToFit()
            
            translate.getLanguages() {(success, languageData) in
                guard let languageData = languageData, success == true else {
                    return
                }
                
                for lang in languageData.data.languages {
                    self.languagesCodes.append(lang.language)
                    self.languagesNames.append(lang.name)
                }
                
                self.languageChoice = self.languagesCodes[0]
                self.languageChoiceName = self.languagesNames[0]
                
                DispatchQueue.main.async { [weak self ] in
                    self?.textToTranslate.placeholder = "Entrez du text à traduire en " + (self?.languageChoiceName ?? "")
                    self?.languagePicker.reloadAllComponents()
                    self?.loadingIndicator.stopAnimating()
                }
            }
        } else {
            let alert = UIAlertController(title: "Connection Impossible", message: "Cette application requiert d'être connecter à Internet", preferredStyle: .alert)
              
              // Add an action to the alert (OK button)
              let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                  exit(0)
              }
              
              // Add the action to the alert
              alert.addAction(okAction)
              
              // Present the alert to the user
              present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1 // We only have one component (column)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return languagesNames.count // Return the number of rows in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return languagesNames[row] // Return the currency code for each row
   }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Get the selected currency code
        languageChoice = languagesCodes[row]
        languageChoiceName  = languagesNames[row]
        
        guard let text = textToTranslate.text else {
            print("Nothing to translate")
            return
        }
        
        if text == "" {
            self.textToTranslate.placeholder = "Entrez du text à traduire en " + languageChoiceName
        } else {
            loadingIndicator.startAnimating()
            translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
                guard let translationData = translationData, success == true else {
                    return
                }
                
                DispatchQueue.main.async { [ weak self ] in
                    self?.translation.text = translationData.data.translations[0].translatedText
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
    }
}

extension TranslateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textToTranslate.text else {
            print("Nothing to translate")
            return true
        }
        if text == "" {
            self.textToTranslate.placeholder = "Entrez du text à traduire en " + languageChoiceName
        } else {
            loadingIndicator.startAnimating()
            
            translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
                guard let translationData = translationData, success == true else {
                    return
                }
                DispatchQueue.main.async { [ weak self ] in
                    self?.translation.text = translationData.data.translations[0].translatedText
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        return true
    }
}
