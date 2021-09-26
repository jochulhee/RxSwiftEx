//
//  ViewModel.swift
//  RxswiftEx
//
//  Created by 조철희 on 2021/08/10.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ViewModel {
    //Input
    let emailTextRelay = BehaviorSubject<String>(value: "")
    let pwTextRelay = BehaviorSubject<String>(value: "")
    
    //Output
    let emailIsValid = BehaviorRelay<Bool>(value: false)
    let pwIsValid = BehaviorRelay<Bool>(value: false)
    
    func isValid() -> Observable<Bool> {
//        return Observable.combineLatest(emailTextRelay, pwTextRelay).map { id, pw in
//            return self.checkEmailValid(id) && self.checkPassworkValid(pw)
//        }
        return Observable.combineLatest(emailIsValid, pwIsValid) { b1, b2 in b1 && b2 }
    }
    
    init() {
        _ = emailTextRelay
            .map(checkEmailValid)
            .bind(to: emailIsValid)
        
        _ = pwTextRelay
            .map(checkPassworkValid)
            .bind(to: pwIsValid)
    }
    
    // MARK: - Logics
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPassworkValid(_ pass: String) -> Bool {
        return pass.count > 5
    }
}
