//
//  ViewController.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/02.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

class ViewController: UIViewController {

    var tableview: UITableView!
    var forecastData: [[ResponseForecast.ListInfo]] = []
    
    let citys: [(String, CGFloat, CGFloat)] = [
        ("Seoul", 37.5665,126.978), //seoul
        ("London", 51.5099,-0.1181), //london
        ("Chicago", 41.8781,-87.6298) //chicago
    ]
    
    var infos: [(ResponseWeather, [ResponseForecast.ListInfo])] = []
    
    internal enum CellType: String {
        case Weather
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        self.tableview = UITableView()
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.register(WeatherTableViewCell.self, forCellReuseIdentifier: CellType.Weather.rawValue)
        self.tableview.estimatedRowHeight = 100
        
        self.requestWeather()
    }
    
    func requestWeather() {
        
        let weatherObs1:Observable<ResponseWeather> = APIService().requestWeather(lat: citys[0].1, lon: citys[0].2)
        let weatherObs2:Observable<ResponseWeather> = APIService().requestWeather(lat: citys[1].1, lon: citys[1].2)
        let weatherObs3:Observable<ResponseWeather> = APIService().requestWeather(lat: citys[2].1, lon: citys[2].2)
        let forecastObs1:Observable<ResponseForecast> = APIService().requestForecast(lat: citys[0].1, lon: citys[0].2)
        let forecastObs2:Observable<ResponseForecast> = APIService().requestForecast(lat: citys[1].1, lon: citys[1].2)
        let forecastObs3:Observable<ResponseForecast> = APIService().requestForecast(lat: citys[2].1, lon: citys[2].2)
        
        Observable.combineLatest(weatherObs1, weatherObs2, weatherObs3, forecastObs1, forecastObs2, forecastObs3)
        .subscribe{ [weak self] event in
            switch event {
            case .next(let data):
                print("next")
                self?.infos.append((data.0, self!.filterForecast(data: data.3)))
                self?.infos.append((data.1, self!.filterForecast(data: data.4)))
                self?.infos.append((data.2, self!.filterForecast(data: data.5)))
            case .completed:
                print("completed")
                self?.tableview.reloadData()
            case .error(let err):
                print("error")
            }
        }

    }
    
    func filterForecast(data: ResponseForecast) -> [ResponseForecast.ListInfo] {
        // 내일부터 4일간 데이터를 고른다
        var results: [ResponseForecast.ListInfo] = []
        
        for i in 0..<data.list.count {
            let listinfo = data.list[i]
            let dt = listinfo.dt
            let date = Date(timeIntervalSince1970: dt)
            let dateComponent = Calendar.current.dateComponents(in: .gmt, from: date)
            
            let now = Calendar.current.dateComponents(in: .current, from: Date())
            
            let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
            let dateTomorrow = Calendar.current.date(from: tomorrow)!
            
            let afterFive = DateComponents(year: now.year, month: now.month, day: now.day! + 5)
            let dateAfterFive = Calendar.current.date(from: afterFive)!
            
            let range = dateTomorrow..<dateAfterFive
            if dateComponent.hour == 12 && range.contains(date) {
                // 정오 시간만 사용
                results.append(listinfo)
            }
        }
        return results
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.infos.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return citys[section].0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.infos[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Weather.rawValue, for: indexPath) as! WeatherTableViewCell
        
        if indexPath.row == 0 {
            let data = self.infos[indexPath.section].0
            cell.day.text = "Today"
            
            let url = URL(string: "https://openweathermap.org/img/wn/\(data.weather[0].icon)@2x.png")
            cell.icon.kf.setImage(with: url)
            cell.weather_desc.text = data.weather[0].desc
            
            cell.temp_min.text = "Min : \(convertTemp(kelvin: data.main.temp_min))°C"
            cell.temp_max.text = "Max : \(convertTemp(kelvin: data.main.temp_max))°C"
        } else {
            let data = self.infos[indexPath.section].1[indexPath.row-1]
            cell.day.text = dateFromTimestamp(dt: data.dt)
            
            // 아이콘 : https://openweathermap.org/weather-conditions
            let url = URL(string: "https://openweathermap.org/img/wn/\(data.weather[0].icon)@2x.png")
            cell.icon.kf.setImage(with: url)
            cell.weather_desc.text = data.weather[0].desc
            
            cell.temp_min.text = "Min : \(convertTemp(kelvin: data.main.temp_min))°C"
            cell.temp_max.text = "Max : \(convertTemp(kelvin: data.main.temp_max))°C"
        }
        
        return cell
    }
    
}
