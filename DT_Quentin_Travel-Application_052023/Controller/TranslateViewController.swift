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
    private var languagesNames: [String] = []
    private var languagesCodes: [String] = []

    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var translation: UILabel!
    
    @IBOutlet weak var textToTranslate: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
        guard let text = textToTranslate.text else {
            print("Nothing to translate")
            return
        }
        translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
            guard let translationData = translationData, success == true else {
               return
            }
            DispatchQueue.main.async {
                self.translation.text = translationData.data.translations[0].translatedText
            }
         }
    }
    @IBOutlet weak var networkStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !networkManager.isReachable {
            networkStatus.text = "Veuillez vous connectez à internet pour utiliser l'application"
        } else {
            networkStatus.isHidden = true
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
                
                DispatchQueue.main.async {
                    self.textToTranslate.placeholder = "Entrez du text à traduire en " + self.languagesNames[0]
                    self.languagePicker.reloadAllComponents()
                }
            }
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
        if self.textToTranslate.text == "" {
            self.textToTranslate.placeholder = "Entrez du text à traduire en " + self.languagesNames[row]
        } else {
            guard let text = textToTranslate.text else {
                print("Nothing to translate")
                return
            }
            translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
                guard let translationData = translationData, success == true else {
                   return
                }
                DispatchQueue.main.async {
                    self.translation.text = translationData.data.translations[0].translatedText
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
        translate.getTranslationTo(text: text, target: languageChoice) { (success, translationData) in
            guard let translationData = translationData, success == true else {
               return
            }
            DispatchQueue.main.async {
                self.translation.text = translationData.data.translations[0].translatedText
            }
         }
        return true
    }
}