//
//  ViewController.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 06/05/2023.
//

import UIKit

class CurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private let networkManager = NetworkManager.shared

    private let currency = CurrencyService()
    private var amount = "1"
    private var currencyChoice = "FR"
    var currencyCodes: [String] = []

    @IBOutlet weak var amountChoice: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountChoice.resignFirstResponder()

        guard let amountResult = amountChoice.text else {
            return
        }
                
        amount = amountResult
        
        loadingIndicator.startAnimating()
        
        currency.getChangeFor(currency: currencyChoice, amount: amount) { (success, currencyChangeData) in
            guard let currencyChange = currencyChangeData, success == true else {
               return
            }
            DispatchQueue.main.async { [ weak self ] in
                self?.changeRate.text = "\(currencyChange.result)$USD"
                self?.loadingIndicator.stopAnimating()
            }
         }
    }
    @IBOutlet weak var changeRate: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true

        if networkManager.isReachable {
            loadingIndicator.startAnimating()
            currencyPicker.dataSource = self
            currencyPicker.delegate = self
            currency.getSymbols { (success, symbolsData) in
                guard let symbolsData = symbolsData, success == true else {
                    return
                }
                self.updateSymbols(symbols: symbolsData)
                DispatchQueue.main.async { [ weak self ] in
                    self?.currencyPicker.reloadAllComponents()
                }
                
                self.currency.getChangeFor(currency: self.currencyChoice, amount: self.amount) { (success, currencyChangeData) in
                    guard let currencyChange = currencyChangeData, success == true else {
                        return
                    }
                    DispatchQueue.main.async { [ weak self ] in
                        self?.changeRate.text = "\(currencyChange.result)$USD"
                        self?.loadingIndicator.stopAnimating()
                    }
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
    
    private func updateSymbols(symbols: CurrencySymbols) -> Void {
        currencyCodes = []
        
        for code in symbols.symbols {
            currencyCodes.append("\(code.key) - \(code.value)")
        }
        
        currencyCodes.sort()
        guard let code = currencyCodes[0].split(separator: " ").first else {
            return
        }
        
        currencyChoice = "\(code)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1 // We only have one component (column)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return currencyCodes.count // Return the number of rows in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return currencyCodes[row] // Return the currency code for each row
   }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Get the selected currency code
        guard let code = currencyCodes[row].split(separator: " ").first else {
            print("error codes recuperation from UiPicker")
            return
        }
        
        currencyChoice = "\(code)"
        
        loadingIndicator.startAnimating()
        
        currency.getChangeFor(currency: currencyChoice, amount: amount) { (success, currencyChangeData) in
            guard let currencyChange = currencyChangeData, success == true else {
               return
            }
            
            DispatchQueue.main.async { [ weak self ] in
                self?.changeRate.text = "\(currencyChange.result)$USD"
                self?.loadingIndicator.stopAnimating()
            }
         }
    }
}
