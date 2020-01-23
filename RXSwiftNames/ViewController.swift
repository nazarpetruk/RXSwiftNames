//
//  ViewController.swift
//  RXSwiftNames
//
//  Created by Nazar Petruk on 23/01/2020.
//  Copyright © 2020 Nazar Petruk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        nameEntryTextField.rx.text.debounce(0.5, scheduler: MainScheduler.instance)
            .map{
                if $0 == ""{
                    return "Type your name below."
                }else{
                    return "HELLO, \($0!)."
                }
        }
        .bind(to: helloLbl.rx.text)
        .disposed(by: disposeBag)
    }
}

