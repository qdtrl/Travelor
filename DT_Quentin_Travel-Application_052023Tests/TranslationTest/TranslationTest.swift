import XCTest
@testable import DT_Quentin_Travel_Application_052023

class TranslateTest: XCTestCase {
    var text = "Bonjour le monde"
    var target = "fr"
    
    func testGetTranslationShouldPostFailedCallbackIfError() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationTo(text: text, target: target) { (success, translation) in
                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(translation)
                                            expectation.fulfill()
        }
        
    }
    
    func testGetTranslationShouldPostFailedCallBackIfNoData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationTo(text: text, target: target) { (success, translation) in
                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(translation)
                                            expectation.fulfill()
        }

    }
    
    func testGetTranslationShouldPostFailedCallBackIfIncorrectResponse() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.englishTranslationCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
    
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationTo(text: text, target: target) { (success, translation) in
                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(translation)
                                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallBackIfIncorrectData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationTo(text: text, target: target) { (success, translation) in
                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(translation)
                                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Tests getTranslation - When all Ok
    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.englishTranslationCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationTo(text: text, target: target) { (success, translation) in
                                            // Then
                                            XCTAssertTrue(success)
                                            XCTAssertNotNil(translation)
                                            XCTAssertEqual("Hi world",
                                                           translation?.data.translations[0].translatedText)
                                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Tests getLanguage
    
    func testGetLanguageShouldPostFailedCallbackIfError() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getLanguages { (success, languages) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetLanguageShouldPostFailedCallBackIfNoData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getLanguages { (success, languages) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }

    }
    
    func testGetLanguageShouldPostFailedCallBackIfIncorrectResponse() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.languagesCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getLanguages { (success, languages) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }

    }
    
    func testGetLanguageShouldPostFailedCallBackIfIncorrectData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getLanguages { (success, languages) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    // Tests getLanguage - When all Ok
    func testGetLanguageShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translationService = TranslateService(
            session: URLSessionFake(data: FakeResponseData.languagesCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getLanguages { (success, languages) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(languages)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
