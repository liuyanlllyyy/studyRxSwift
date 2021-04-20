//
//  EasyViewModel.swift
//  studyRxSwift
//
//  Created by 刘衍 on 2021/4/20.
//

import Foundation
import RxSwift
struct EasyListModel {
    let data = Observable.just([
        Person(name: "A", age: 14),
        Person(name: "B", age: 24),
        Person(name: "C", age: 34),
        Person(name: "D", age: 44),
    ])
    
}
