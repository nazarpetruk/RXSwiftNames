//
//  AddNameVC.swift
//  RXSwiftNames
//
//  Created by Nazar Petruk on 23/01/2020.
//  Copyright © 2020 Nazar Petruk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class AddNameVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var newNameTxt: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    let nameSubject = PublishSubject<String>()
    let disposebag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubbmitBtn()
    }
    
    
    func bindSubbmitBtn() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.newNameTxt.text != "" {
                self.nameSubject.onNext(self.newNameTxt.text!)
            }
        })
        .disposed(by: disposebag)
    }
}
