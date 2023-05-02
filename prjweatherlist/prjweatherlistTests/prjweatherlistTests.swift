//
//  prjweatherlistTests.swift
//  prjweatherlistTests
//
//  Created by 김성인 on 2023/05/02.
//

import XCTest
import RxSwift

final class prjweatherlistTests: XCTestCase {
    
    var testCoords: [(CGFloat, CGFloat)]!
    var testMocksWeather: [String]!
    var testMocksForecast: [String]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testCoords = [
            (37.5665,126.978), //seoul
            (51.5099,-0.1181), //london
            (41.8781,-87.6298) //chicago
        ]
        testMocksWeather = [
            "mock_weather_seoul",
            "mock_weather_london",
            "mock_weather_chicago"
        ]
        testMocksForecast = [
            "mock_forecast_seoul",
            "mock_forecast_london",
            "mock_forecast_chicago"
        ]
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
    
    func testWeatherApi() {
        
        let issueExpectation = expectation(description: "testWeatherApi")
        issueExpectation.expectedFulfillmentCount = testCoords.count
        
        testCoords.forEach { coord in
            
            APIService().requestWeather(lat: coord.0, lon: coord.1)
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
        }
        
        wait(for: [issueExpectation], timeout: 5 * Double(issueExpectation.expectedFulfillmentCount))
    }
    
    func testForecastApi() {
        
        let issueExpectation = expectation(description: "testForecastApi")
        issueExpectation.expectedFulfillmentCount = testCoords.count
        
        testCoords.forEach { coord in
            
            APIService().requestForecast(lat: coord.0, lon: coord.1)
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
        }
        wait(for: [issueExpectation], timeout: 5 * Double(issueExpectation.expectedFulfillmentCount))
    }
    
    func testWeather() {
        weatherTestFrom(mockname: testMocksWeather[0])
        weatherTestFrom(mockname: testMocksWeather[1])
        weatherTestFrom(mockname: testMocksWeather[2])
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
        forecastTestFrom(mockname: testMocksForecast[0])
        forecastTestFrom(mockname: testMocksForecast[1])
        forecastTestFrom(mockname: testMocksForecast[2])
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
