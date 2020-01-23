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
    @IBOutlet weak var addNameBtn: UIButton!
    
    
    
    let disposeBag = DisposeBag()
    var namesArray : Variable<[String]> = Variable([])

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindSubmitBtn()
        bindAddNameBtn()
        
        namesArray.asObservable().subscribe(onNext: {
            names in
            self.namesLbl.text = names.joined(separator: ", ")
            }).disposed(by: disposeBag)
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
    
    func bindSubmitBtn() {
        submitButton.rx.tap
            .subscribe(onNext: {
                if self.nameEntryTextField.text != "" {
                    self.namesArray.value.append(self.nameEntryTextField.text!)
                    self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLbl.rx.text.onNext("Type your name below")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindAddNameBtn() {
        addNameBtn.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance).subscribe(onNext: {
                guard let addNameVC = self.storyboard?.instantiateViewController(identifier: "AddNameVC") as? AddNameVC else { fatalError("Could not create AddNameVC") }
                addNameVC.nameSubject.subscribe(onNext: { name in
                    self.namesArray.value.append(name)
                    addNameVC.dismiss(animated: true, completion: nil)
                }).disposed(by: self.disposeBag)
                self.present(addNameVC, animated: true, completion: nil)
            })
    }
}

