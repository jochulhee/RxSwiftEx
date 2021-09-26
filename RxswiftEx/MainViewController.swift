//
//  LoginViewController.swift
//  RxswiftEx
//
//  Created by 조철희 on 2021/08/11.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    enum OptionType {
        case none, opt1, opt2, opt3
    }
    enum SubjectType {
        case none, sub1, sub2, sub3
    }
    
    var filter1Relay = BehaviorRelay(value: OptionType.none) // type opt
    var filter2Relay = BehaviorRelay(value: SubjectType.none) // type subject
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var opt1Btn: UIButton!
    @IBOutlet weak var opt2Btn: UIButton!
    @IBOutlet weak var opt3Btn: UIButton!

    @IBOutlet weak var sub1Btn: UIButton!
    @IBOutlet weak var sub2Btn: UIButton!
    @IBOutlet weak var sub3Btn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    // MARK: - Bind
    private func bindView() {
//        opt1Btn.rx.tap.map { OptionType.opt1 } // input 에 대한 output 고정. OptionType
//            .bind(to: filter1Relay) // bind 하여 결과 대입
//            .disposed(by: disposeBag)
//        opt2Btn.rx.tap.map { OptionType.opt2 }
//            .bind(to: filter1Relay)
//            .disposed(by: disposeBag)
//        opt3Btn.rx.tap.map { OptionType.opt3 }
//            .bind(to: filter1Relay)
//            .disposed(by: disposeBag)
        Observable.merge(
            opt1Btn.rx.tap.map { OptionType.opt1 },
            opt2Btn.rx.tap.map { OptionType.opt2 },
            opt3Btn.rx.tap.map { OptionType.opt3 }
        ).bind(to: filter1Relay)
        .disposed(by: disposeBag)
        
        
//        filter1Relay.map { $0 == OptionType.opt1 } // input 에 대한 조건처리 결과. Boolean
//            .bind(to: opt1Btn.rx.isSelected ) // bind 하여 결과 대입.
//            .disposed(by: disposeBag)
//        filter1Relay.map { $0 == OptionType.opt2 }
//            .bind(to: opt2Btn.rx.isSelected )
//            .disposed(by: disposeBag)
//        filter1Relay.map { $0 == OptionType.opt3 }
//            .bind(to: opt3Btn.rx.isSelected )
//            .disposed(by: disposeBag)
        let flatMap = filter1Relay.flatMap { [weak self] in
            Observable.from([
                ($0 == OptionType.opt1, self?.opt1Btn),
                ($0 == OptionType.opt2, self?.opt2Btn),
                ($0 == OptionType.opt3, self?.opt3Btn)
            ])
        }
        flatMap.asDriver(onErrorJustReturn: (false, nil))// flatMap 타입추론 지연성 오류로 코드 분리..
            .drive(onNext: { selected, button in
                button?.isSelected = selected
            })
            .disposed(by: disposeBag)
        
        
        
//        sub1Btn.rx.tap.map { SubjectType.sub1 }
//            .bind(to: filter2Relay)
//            .disposed(by: disposeBag)
//        sub2Btn.rx.tap.map { SubjectType.sub2 }
//            .bind(to: filter2Relay)
//            .disposed(by: disposeBag)
//        sub3Btn.rx.tap.map { SubjectType.sub3 }
//            .bind(to: filter2Relay)
//            .disposed(by: disposeBag)
        Observable.merge(
            sub1Btn.rx.tap.map { SubjectType.sub1 },
            sub2Btn.rx.tap.map { SubjectType.sub2 },
            sub3Btn.rx.tap.map { SubjectType.sub3 }
        ).bind(to: filter2Relay)
        .disposed(by: disposeBag)
        
        
//        filter2Relay.map { $0 == SubjectType.sub1 }
//            .bind(to: sub1Btn.rx.isSelected)
//            .disposed(by: disposeBag)
//        filter2Relay.map { $0 == SubjectType.sub2 }
//            .bind(to: sub2Btn.rx.isSelected)
//            .disposed(by: disposeBag)
//        filter2Relay.map { $0 == SubjectType.sub3 }
//            .bind(to: sub3Btn.rx.isSelected)
//            .disposed(by: disposeBag)
        let flatMap2 = filter2Relay.flatMap { [weak self] in
            Observable.from([
                ($0 == SubjectType.sub1, self?.sub1Btn),
                ($0 == SubjectType.sub2, self?.sub2Btn),
                ($0 == SubjectType.sub3, self?.sub3Btn)
            ])
        }
        flatMap2.asDriver(onErrorJustReturn: (false, nil))
            .drive(onNext: { selected, button in
                button?.isSelected = selected
            })
            .disposed(by: disposeBag)
        
        
        
        Observable.combineLatest(filter1Relay, filter2Relay) { f1, f2 in
            f1 != OptionType.none && f2 != SubjectType.none
        }
        .bind(to: confirmBtn.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}
