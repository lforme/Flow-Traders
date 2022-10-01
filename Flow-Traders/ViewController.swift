//
//  ViewController.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 30.9.22.
//

import UIKit
import SavannaKit
import Hue
import RxSwift
import NSObject_Rx
import RxCocoa
import SnapKit
import SwiftDate
import Hero
import SwiftWebVC


class ViewController: UIViewController {
    
    @IBOutlet weak var terminalView: SyntaxTextView!
    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    
    let terminalConfig = TerminalDescriptionConfig()
    let lexer = CustomLexer()
    var indexMonologue = 0
    var navigationPoped = false
    
    private var timerDisposable: Disposable?
    let db = MetaDb()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        setupViews()
        gameExecute()
        
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .zoomOut
        
        
//        let webVC = SwiftModalWebVC(urlString: "https://asd12312sad.github.io/asd12312asa.github.io/", sharingEnabled: true)
//        webVC.modalPresentationStyle = .fullScreen
//        self?.present(webVC, animated: true)
        
        
    }
    
}

private extension ViewController {
    
    func setupViews() {
        
        terminalView.delegate = self
        terminalView.theme = TerminalTheme()
        terminalView.text = terminalConfig.loginWelcome
        terminalView.contentTextView.returnKeyType = .done
        
        
        keyboardHeight()
            .drive(onNext: {[weak self] (value, animationDuration) in
                
                self?.bottomOffset.constant = value
                UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                    self?.view.layoutIfNeeded()
                })
            }).disposed(by: rx.disposeBag)
    }
    
    typealias KeyboardHeightInfo = (CGFloat, TimeInterval)
    
    func keyboardHeight() -> Driver<KeyboardHeightInfo> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> KeyboardHeightInfo in
                        let userInfo = notification.userInfo
                        let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                        return (value, animationDuration)
                    },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { notification -> KeyboardHeightInfo in
                        let userInfo = notification.userInfo
                        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                        return (0, animationDuration)
                    }
            ])
            .merge()
            .asDriver(onErrorDriveWith: .never())
    }
    
    func loadMonologue(keyPath: String, displaySpeed: Int = 50) {
        
        guard let array = FileContent.content[keyPath]?
            .components(separatedBy: "\n") else { return }
        
        let textArray = array.compactMap { Array($0) }
        var current = textArray[indexMonologue]
        
        timerDisposable?.dispose()
        timerDisposable = Observable<Int>
            .timer(RxTimeInterval.seconds(1), period: RxTimeInterval.milliseconds(displaySpeed), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] value in
                guard let this = self else { return }
                if this.indexMonologue >= textArray.count {
                    this.terminalView.contentTextView.isEditable = (current.count == 0)
                    self?.indexMonologue = 0
                    self?.timerDisposable?.dispose()
                    return
                }
                
                if current.count == 0 {
                    this.indexMonologue += 1
                    if this.indexMonologue < textArray.count {
                        this.loadMonologue(keyPath: keyPath)
                    }
                }
                
                if !current.isEmpty {
                    let str = current.removeFirst()
                    var text = this.terminalView.text
                    text += String(str)
                    this.terminalView.text = text
                    
                } else {
                    var text = this.terminalView.text
                    text += "\n"
                    this.terminalView.text = text
                    this.terminalView.contentTextView.scrollToBottom(animated: true)
                }
                
            }, onCompleted: {[weak self] in
                self?.indexMonologue = 0
            })
    }
    
    func gameExecute() {
        lexer.execute {[weak self] command in
            guard let cmd = command else {
                return
            }
            
            switch cmd {
                
            case .help:
                self?.loadMonologue(keyPath: "help", displaySpeed: 50)
                
            case .customs(let op):
                
                switch op {
                case let .time(index):
                    self?.loadMonologue(keyPath: index, displaySpeed: 50)
                    
                case let .message(endTime, msg, index):
                    
                    JKEKEvent.addCalendarsEvents(title: "Flow", startDate: Date(), endDate: endTime, notes: msg) { isFinish, id in
                        
                        if isFinish {
                            self?.loadMonologue(keyPath: index, displaySpeed: 100)
                            self?.db.save(endTime, content: msg)
                            
                        } else {
                            self?.lexer.endTime = nil
                            self?.lexer.processIndex = nil
                        }
                    }
                }
                
            case .history:
                
                let historyVC: HistoryViewController = ViewLoader.Storyboard.controller(from: "Main")
                self?.navigationController?.pushViewController(historyVC, animated: true)
                historyVC.db = self?.db
                
            case .clearAll:
                self?.db.deleteAll()
                
            }
        }
    }
}

extension ViewController: SyntaxTextViewDelegate {
    
    func didChangeText(_ syntaxTextView: SyntaxTextView) {
        
        if syntaxTextView.text.count < terminalConfig.loginWelcome.count {
            syntaxTextView.text = terminalConfig.loginWelcome
        } else if syntaxTextView.text.count == terminalConfig.loginWelcome.count {
            loadMonologue(keyPath: "1")
        }
    }
    
    func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {
        
        
    }
    
    func lexerForSource(_ source: String) -> TerminalLexer {
        
        return lexer
    }
    
}
