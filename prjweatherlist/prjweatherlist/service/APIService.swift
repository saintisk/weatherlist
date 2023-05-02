//
//  APIService.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/03.
//

import Foundation

import Alamofire
import RxSwift

struct APIService {
    
    let baseUrl = "https://api.openweathermap.org"
    let appid = "1388b02cf20dab1173c8e75d73616220"
    
    func requestWeather(lat: CGFloat, lon: CGFloat) -> Observable<ResponseWeather> {
        return Observable.create { emitter in
            let url = "\(baseUrl)/data/2.5/weather?appid=\(appid)&lat=\(lat)&lon=\(lon)"
            let params:[String:String] = [:]
            AF.request(url,
                       method: .get,
                       parameters: params,
                       encoder: .urlEncodedForm,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseDecodable(of: ResponseWeather.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let err):
                    emitter.onError(err)
                }
            }
            
            return Disposables.create {
                
            }
        }
    }
    
    func requestForecast(lat: CGFloat, lon: CGFloat) -> Observable<ResponseForecast> {
        return Observable.create { emitter in
            let url = "\(baseUrl)/data/2.5/forecast?appid=\(appid)&lat=\(lat)&lon=\(lon)"
            let params:[String:String] = [:]
            AF.request(url,
                       method: .get,
                       parameters: params,
                       encoder: .urlEncodedForm,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseDecodable(of: ResponseForecast.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let err):
                    emitter.onError(err)
                }
            }
            
            return Disposables.create {
                
            }
        }
    }
}
