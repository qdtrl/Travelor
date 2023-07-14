//
//  WeatherTest.swift
//  DT_Quentin_Travel-Application_052023Tests
//
//  Created by Quentin Dubut-Touroul on 24/06/2023.
//

import XCTest
@testable import DT_Quentin_Travel_Application_052023

class CurrencyServiceTestCase: XCTestCase {
    
    // MARK: - Tests getCurrency
    
    func testGetCurrencyShouldPostFailedCallbackIfError() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getSymbols { (success, currency) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
    }
    
    func testGetCurrencyShouldPostFailedCallBackIfNoData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getSymbols { (success, currency) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        
    }
    
    func testGetCurrencyShouldPostFailedCallBackIfIncorrectResponse() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.currencyCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getSymbols { (success, currency) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        
    }
    
    func testGetCurrencyShouldPostFailedCallBackIfIncorrectData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getSymbols { (success, currency) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        
    }
    
    // Tests getCurrency - When all Ok
    func testGetCurrencyShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.currencyCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getSymbols { (success, currency) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(currency)
            let symbols = [
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
                "ALL": "Albanian Lek",
                "AMD": "Armenian Dram",
                "ANG": "Netherlands Antillean Guilder",
                "AOA": "Angolan Kwanza",
                "ARS": "Argentine Peso",
                "AUD": "Australian Dollar",
                "AWG": "Aruban Florin",
                "AZN": "Azerbaijani Manat",
                "BAM": "Bosnia-Herzegovina Convertible Mark",
                "BBD": "Barbadian Dollar",
                "BDT": "Bangladeshi Taka",
                "BGN": "Bulgarian Lev",
                "BHD": "Bahraini Dinar",
                "BIF": "Burundian Franc",
                "BMD": "Bermudan Dollar",
                "BND": "Brunei Dollar",
                "BOB": "Bolivian Boliviano",
                "BRL": "Brazilian Real",
                "BSD": "Bahamian Dollar",
                "BTC": "Bitcoin",
                "BTN": "Bhutanese Ngultrum",
                "BWP": "Botswanan Pula",
                "BYN": "New Belarusian Ruble",
                "BYR": "Belarusian Ruble",
                "BZD": "Belize Dollar",
                "CAD": "Canadian Dollar",
                "CDF": "Congolese Franc",
                "CHF": "Swiss Franc",
                "CLF": "Chilean Unit of Account (UF)",
                "CLP": "Chilean Peso",
                "CNY": "Chinese Yuan",
                "COP": "Colombian Peso",
                "CRC": "Costa Rican Colón",
                "CUC": "Cuban Convertible Peso",
                "CUP": "Cuban Peso",
                "CVE": "Cape Verdean Escudo",
                "CZK": "Czech Republic Koruna",
                "DJF": "Djiboutian Franc",
                "DKK": "Danish Krone",
                "DOP": "Dominican Peso",
                "DZD": "Algerian Dinar",
                "EGP": "Egyptian Pound",
                "ERN": "Eritrean Nakfa",
                "ETB": "Ethiopian Birr",
                "EUR": "Euro",
                "FJD": "Fijian Dollar",
                "FKP": "Falkland Islands Pound",
                "GBP": "British Pound Sterling",
                "GEL": "Georgian Lari",
                "GGP": "Guernsey Pound",
                "GHS": "Ghanaian Cedi",
                "GIP": "Gibraltar Pound",
                "GMD": "Gambian Dalasi",
                "GNF": "Guinean Franc",
                "GTQ": "Guatemalan Quetzal",
                "GYD": "Guyanaese Dollar",
                "HKD": "Hong Kong Dollar",
                "HNL": "Honduran Lempira",
                "HRK": "Croatian Kuna",
                "HTG": "Haitian Gourde",
                "HUF": "Hungarian Forint",
                "IDR": "Indonesian Rupiah",
                "ILS": "Israeli New Sheqel",
                "IMP": "Manx pound",
                "INR": "Indian Rupee",
                "IQD": "Iraqi Dinar",
                "IRR": "Iranian Rial",
                "ISK": "Icelandic Króna",
                "JEP": "Jersey Pound",
                "JMD": "Jamaican Dollar",
                "JOD": "Jordanian Dinar",
                "JPY": "Japanese Yen",
                "KES": "Kenyan Shilling",
                "KGS": "Kyrgystani Som",
                "KHR": "Cambodian Riel",
                "KMF": "Comorian Franc",
                "KPW": "North Korean Won",
                "KRW": "South Korean Won",
                "KWD": "Kuwaiti Dinar",
                "KYD": "Cayman Islands Dollar",
                "KZT": "Kazakhstani Tenge",
                "LAK": "Laotian Kip",
                "LBP": "Lebanese Pound",
                "LKR": "Sri Lankan Rupee",
                "LRD": "Liberian Dollar",
                "LSL": "Lesotho Loti",
                "LTL": "Lithuanian Litas",
                "LVL": "Latvian Lats",
                "LYD": "Libyan Dinar",
                "MAD": "Moroccan Dirham",
                "MDL": "Moldovan Leu",
                "MGA": "Malagasy Ariary",
                "MKD": "Macedonian Denar",
                "MMK": "Myanma Kyat",
                "MNT": "Mongolian Tugrik",
                "MOP": "Macanese Pataca",
                "MRO": "Mauritanian Ouguiya",
                "MUR": "Mauritian Rupee",
                "MVR": "Maldivian Rufiyaa",
                "MWK": "Malawian Kwacha",
                "MXN": "Mexican Peso",
                "MYR": "Malaysian Ringgit",
                "MZN": "Mozambican Metical",
                "NAD": "Namibian Dollar",
                "NGN": "Nigerian Naira",
                "NIO": "Nicaraguan Córdoba",
                "NOK": "Norwegian Krone",
                "NPR": "Nepalese Rupee",
                "NZD": "New Zealand Dollar",
                "OMR": "Omani Rial",
                "PAB": "Panamanian Balboa",
                "PEN": "Peruvian Nuevo Sol",
                "PGK": "Papua New Guinean Kina",
                "PHP": "Philippine Peso",
                "PKR": "Pakistani Rupee",
                "PLN": "Polish Zloty",
                "PYG": "Paraguayan Guarani",
                "QAR": "Qatari Rial",
                "RON": "Romanian Leu",
                "RSD": "Serbian Dinar",
                "RUB": "Russian Ruble",
                "RWF": "Rwandan Franc",
                "SAR": "Saudi Riyal",
                "SBD": "Solomon Islands Dollar",
                "SCR": "Seychellois Rupee",
                "SDG": "Sudanese Pound",
                "SEK": "Swedish Krona",
                "SGD": "Singapore Dollar",
                "SHP": "Saint Helena Pound",
                "SLE": "Sierra Leonean Leone",
                "SLL": "Sierra Leonean Leone",
                "SOS": "Somali Shilling",
                "SRD": "Surinamese Dollar",
                "STD": "São Tomé and Príncipe Dobra",
                "SVC": "Salvadoran Colón",
                "SYP": "Syrian Pound",
                "SZL": "Swazi Lilangeni",
                "THB": "Thai Baht",
                "TJS": "Tajikistani Somoni",
                "TMT": "Turkmenistani Manat",
                "TND": "Tunisian Dinar",
                "TOP": "Tongan Paʻanga",
                "TRY": "Turkish Lira",
                "TTD": "Trinidad and Tobago Dollar",
                "TWD": "New Taiwan Dollar",
                "TZS": "Tanzanian Shilling",
                "UAH": "Ukrainian Hryvnia",
                "UGX": "Ugandan Shilling",
                "USD": "United States Dollar",
                "UYU": "Uruguayan Peso",
                "UZS": "Uzbekistan Som",
                "VEF": "Venezuelan Bolívar Fuerte",
                "VES": "Sovereign Bolivar",
                "VND": "Vietnamese Dong",
                "VUV": "Vanuatu Vatu",
                "WST": "Samoan Tala",
                "XAF": "CFA Franc BEAC",
                "XAG": "Silver (troy ounce)",
                "XAU": "Gold (troy ounce)",
                "XCD": "East Caribbean Dollar",
                "XDR": "Special Drawing Rights",
                "XOF": "CFA Franc BCEAO",
                "XPF": "CFP Franc",
                "YER": "Yemeni Rial",
                "ZAR": "South African Rand",
                "ZMK": "Zambian Kwacha (pre-2013)",
                "ZMW": "Zambian Kwacha",
                "ZWL": "Zimbabwean Dollar"
            ]
            XCTAssertEqual(true, currency?.success)
            XCTAssertEqual(symbols, currency?.symbols)
            
            expectation.fulfill()
        }
        
    }
    
    // MARK: - Tests getRate
    func testGetRateShouldPostFailedCallbackIfError() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let symbolPicked = "USD"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getChangeFor(currency: symbolPicked, amount: "12") { (success, rate) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRateShouldPostFailedCallBackIfNoData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let symbolPicked = "USD"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getChangeFor(currency: symbolPicked, amount: "12") { (success, rate) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
    }
    
    func testGetRateShouldPostFailedCallBackIfIncorrectResponse() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.ratesCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        
        // When
        let symbolPicked = "USD"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getChangeFor(currency: symbolPicked, amount: "12") { (success, rate) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRateShouldPostFailedCallBackIfIncorrectData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let symbolPicked = "USD"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getChangeFor(currency: symbolPicked, amount: "12") { (success, rate) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Tests getRate - When all Ok
    func testGetRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let currencyService = CurrencyService(
            session: URLSessionFake(data: FakeResponseData.ratesCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        // When
        let symbolPicked = "USD"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyService.getChangeFor(currency: symbolPicked, amount: "12") { (success, rate) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(rate)
            XCTAssertEqual(10.977648, rate?.result)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
