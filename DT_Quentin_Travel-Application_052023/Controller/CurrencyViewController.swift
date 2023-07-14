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

    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var amountChoice: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountChoice.resignFirstResponder()
        
        guard let amountResult = amountChoice.text else {
            return
        }
                
        amount = amountResult
        
        currency.getChangeFor(currency: currencyChoice, amount: amount) { (success, currencyChangeData) in
            guard let currencyChange = currencyChangeData, success == true else {
               return
            }
            DispatchQueue.main.async {
                self.changeRate.text = "\(currencyChange.result)$USD"
            }
         }
    }
    @IBOutlet weak var changeRate: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !networkManager.isReachable {
            networkStatus.text = "Veuillez vous connectez à internet pour utiliser l'application"
        } else {
            networkStatus.isHidden = true
            currencyPicker.dataSource = self
            currencyPicker.delegate = self
            currency.getSymbols { (success, symbolsData) in
                guard let symbolsData = symbolsData, success == true else {
                    return
                }
                self.updateSymbols(symbols: symbolsData)
                DispatchQueue.main.async {
                    self.currencyPicker.reloadAllComponents()
                }
                self.currency.getChangeFor(currency: self.currencyChoice, amount: self.amount) { (success, currencyChangeData) in
                    guard let currencyChange = currencyChangeData, success == true else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.changeRate.text = "\(currencyChange.result)$USD"
                    }
                }
            }
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
        
        
        currency.getChangeFor(currency: currencyChoice, amount: amount) { (success, currencyChangeData) in
            guard let currencyChange = currencyChangeData, success == true else {
               return
            }
            DispatchQueue.main.async {
                self.changeRate.text = "\(currencyChange.result)$USD"
            }
         }
    }
}
