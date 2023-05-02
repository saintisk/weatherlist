//
//  prjweatherlistTests.swift
//  prjweatherlistTests
//
//  Created by 김성인 on 2023/05/02.
//

import XCTest

final class prjweatherlistTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testApi() {
        
        let issueExpectation = expectation(description: "API Test")
        issueExpectation.expectedFulfillmentCount = 2
        
        APIService().requestWeather(lat: 41.8781, lon: -87.6298)
            .debug()
            .subscribe { [weak self] event in
                switch event {
                case .next(let data):
                    print("next")
                case .completed:
                    print("completed")
                    issueExpectation.fulfill()
                case .error(let err):
                    print("error : \(err)")
                    XCTFail("testApi fail")
                }
            }
        
        APIService().requestForecast(lat: 41.8781, lon: -87.6298)
            .debug()
            .subscribe { [weak self] event in
                switch event {
                case .next(let data):
                    print("next")
                case .completed:
                    print("completed")
                    issueExpectation.fulfill()
                case .error(let err):
                    print("error : \(err)")
                    XCTFail("testApi fail")
                }
            }
        
        wait(for: [issueExpectation], timeout: 5 * Double(issueExpectation.expectedFulfillmentCount))
    }
    
    func testWeather() {
        weatherTestFrom(mockname: "mock_weather_seoul")
        weatherTestFrom(mockname: "mock_weather_london")
        weatherTestFrom(mockname: "mock_weather_chicago")
    }
    
    func weatherTestFrom(mockname: String) {
        guard let path = Bundle.main.path(forResource: "mock_weather_seoul", ofType: "json") else {
            XCTFail("load mock resource fail")
            return
        }
        
        guard let mockStr = try? String(contentsOfFile: path) else {
            XCTFail("mock fail : \(path)")
            return
        }
        
        guard let data = mockStr.data(using: .utf8) else {
            XCTFail("data mock fail")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let weatherinfo = try decoder.decode(ResponseWeather.self, from: data)
//            print("data: \(weatherinfo)")
        } catch let err {
            XCTFail("decode mock fail \(err.localizedDescription)")
        }
    }
    
    func testForecast() {
        // 테스트 데이터 준비
        forecastTestFrom(mockname: "mock_forecast_seoul")
        forecastTestFrom(mockname: "mock_forecast_london")
        forecastTestFrom(mockname: "mock_forecast_chicago")
    }
    
    func forecastTestFrom(mockname: String) {
        guard let path = Bundle.main.path(forResource: mockname, ofType: "json") else {
            XCTFail("load mock resource fail")
            return
        }
        
        guard let mockStr = try? String(contentsOfFile: path) else {
            XCTFail("mock fail : \(path)")
            return
        }
        
        guard let data = mockStr.data(using: .utf8) else {
            XCTFail("data mock fail")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let weatherinfo = try decoder.decode(ResponseForecast.self, from: data)
            print("data: \(weatherinfo)")
        } catch let err {
            XCTFail("decode mock fail \(err)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
