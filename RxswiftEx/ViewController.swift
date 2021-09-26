//
//  ViewController.swift
//  RxswiftEx
//
//  Created by 조철희 on 2021/08/10.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let viewModel = ViewModel();
    var disposBag = DisposeBag() // dispose 시킬 Disposable 들을 담을 객체,
                                 // 새로 생성 시 담아둔 disposable 들을 각각 dispose 시킴
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }

    //MARK: - set layout design
    
    override func viewDidLayoutSubviews() {
        idValidView.layer.cornerRadius = 8.0
        pwValidView.layer.cornerRadius = 8.0
    }

    
    // MARK: - IBOutlet
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idValidView: UIView!
    @IBOutlet weak var pwValidView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Bind UI
    
    private func bindInput() {
        idTextField.rx.text
            .orEmpty// null 이면 "" 로 처리
            .distinctUntilChanged()//변화가 발생할때까지 무시.
            .bind(to: viewModel.emailTextRelay)//disposable object. 종료 시 dispose 시킬 필요가 있음
            .disposed(by: disposBag)//dispose 할 수 있도록 disposebag 에 담기
        
        pwTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.pwTextRelay)
            .disposed(by: disposBag)
    }
    
    private func bindOutput() {
        viewModel.isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposBag)
        
        viewModel.isValid()
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposBag)

        viewModel.emailIsValid
            .distinctUntilChanged()
            .bind(to: idValidView.rx.isHidden) // subscribe 내용을 간단히 한 형태
            .disposed(by: disposBag)
        
        
        viewModel.pwIsValid
            .distinctUntilChanged()
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposBag)
            
    }
}

