//
//  ColorViewController.swift
//  RxColorPickers
//
//  Created by killi8n on 2018. 7. 22..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ColorViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let cancelButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: nil)
        return btn
    }()
    
    let doneButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: nil)
        return btn
    }()
    
    let colorView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.red
        return view
    }()
    
    let hexTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let applyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("적용", for: UIControlState.normal)
        return btn
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("저장", for: UIControlState.normal)
        return btn
    }()
    
    let loadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("불러오기", for: UIControlState.normal)
        return btn
    }()
    
    let savedView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var centerStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [saveButton, loadButton])
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let rSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let rLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let gSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let gLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let bSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let bLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews()
        bind()
    }
    
    
}

extension ColorViewController {
    func setup() {
        let components = [colorView, hexTextField, applyButton, centerStack, savedView, rSlider, rLabel, gSlider, gLabel, bSlider, bLabel]
        components.forEach { (component) in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        colorView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 24).isActive = true
        colorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        colorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 154).isActive = true
        
        hexTextField.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 24).isActive = true
        hexTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        hexTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        applyButton.topAnchor.constraint(equalTo: hexTextField.topAnchor).isActive = true
        applyButton.leftAnchor.constraint(equalTo: hexTextField.rightAnchor, constant: 16).isActive = true
        applyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        centerStack.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 16).isActive = true
        centerStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        centerStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        centerStack.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        
        savedView.centerYAnchor.constraint(equalTo: centerStack.centerYAnchor, constant: 0).isActive = true
        savedView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        savedView.leftAnchor.constraint(equalTo: centerStack.rightAnchor, constant: 16).isActive = true
        savedView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        rSlider.topAnchor.constraint(equalTo: centerStack.bottomAnchor, constant: 16).isActive = true
        rSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        rSlider.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        
        rLabel.centerYAnchor.constraint(equalTo: rSlider.centerYAnchor).isActive = true
        rLabel.leftAnchor.constraint(equalTo: rSlider.rightAnchor, constant: 16).isActive = true
        rLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        rLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        gSlider.topAnchor.constraint(equalTo: rLabel.bottomAnchor, constant: 16).isActive = true
        gSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        gSlider.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        
        gLabel.centerYAnchor.constraint(equalTo: gSlider.centerYAnchor).isActive = true
        gLabel.leftAnchor.constraint(equalTo: gSlider.rightAnchor, constant: 16).isActive = true
        gLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        gLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        bSlider.topAnchor.constraint(equalTo: gLabel.bottomAnchor, constant: 16).isActive = true
        bSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        bSlider.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        
        bLabel.centerYAnchor.constraint(equalTo: bSlider.centerYAnchor).isActive = true
        bLabel.leftAnchor.constraint(equalTo: bSlider.rightAnchor, constant: 16).isActive = true
        bLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        bLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

    }
    
    func bind() {
        let color = Observable.combineLatest(rSlider.rx.value, gSlider.rx.value, bSlider.rx.value) { (rValue, gValue, bValue) -> UIColor in
            UIColor(red: CGFloat(rValue), green: CGFloat(gValue), blue: CGFloat(bValue), alpha: 1.0)
        }
        
        color.subscribe(onNext: { [weak self] color in
            
            self?.colorView.backgroundColor = color
        }).disposed(by: disposeBag)
        

        color.map { (color: UIColor) in
            color.hexString
            }.subscribe(onNext: { [weak self] (hexString) in
                self?.hexTextField.text = hexString
            }).disposed(by: disposeBag)
        
        let rObservable = rSlider.rx.value.map { $0 }
        let gObservable = gSlider.rx.value.map { $0 }
        let bObservable = bSlider.rx.value.map { $0 }

        rObservable.map { "\(Int($0 * 255))" }.bind(to: rLabel.rx.text).disposed(by: disposeBag)
        gObservable.map { "\(Int($0 * 255))" }.bind(to: gLabel.rx.text).disposed(by: disposeBag)
        bObservable.map { "\(Int($0 * 255))" }.bind(to: bLabel.rx.text).disposed(by: disposeBag)

        
        applyButton.rx.tap.asObservable().flatMap { [weak self]
            _ -> Observable<String> in
            guard let text = self?.hexTextField.text else {return Observable.empty()}
            return Observable.just(text)
            }.subscribe(onNext: { [weak self] (hexText) in
                guard let rgbValue = hexText.rgb else {return}
                
                guard let `self` = self else { return }
                self.rSlider.rx.value.onNext(Float(rgbValue.0) / 255.0)
                self.rSlider.sendActions(for: UIControlEvents.valueChanged)
                
                self.gSlider.rx.value.onNext(Float(rgbValue.1) / 255.0)
                self.gSlider.sendActions(for: UIControlEvents.valueChanged)
                
                self.bSlider.rx.value.onNext(Float(rgbValue.2) / 255.0)
                self.bSlider.sendActions(for: UIControlEvents.valueChanged)
            }).disposed(by: disposeBag)
        
        saveButton.rx.tap.asObservable().withLatestFrom(colorView.rx.observe(UIColor.self, "backgroundColor")).map {
            $0!
            }.flatMap {
                (color: UIColor) -> Observable<UIColor> in
                return ColorArchiveAPI.instance.save(color: color)
            }.subscribe(onNext: { [weak self] (saveColor: UIColor) in
                self?.savedView.backgroundColor = saveColor
            }).disposed(by: disposeBag)
        
        loadButton.rx.tap.asObservable().flatMap {
            _ -> Observable<UIColor> in
            return ColorArchiveAPI.instance.load()
            }.subscribe(onNext: { [weak self] (savedColor: UIColor) in
                self?.hexTextField.rx.text.onNext(savedColor.hexString)
                self?.hexTextField.sendActions(for: .valueChanged)
                self?.applyButton.sendActions(for: UIControlEvents.touchUpInside)
            }).disposed(by: disposeBag)
        
        ColorArchiveAPI.instance.load()
            .subscribe(onNext: { [weak self] color in
                self?.savedView.backgroundColor = color
            }).disposed(by: disposeBag)
    }
}

extension Reactive where Base: ColorViewController {
    static func create(parent: UIViewController?, animated: Bool = true) -> Observable<ColorViewController> {
        return Observable.create({ [weak parent] (observer) -> Disposable in
            let colorViewController = ColorViewController()
            let dismissDisposable = colorViewController.cancelButton.rx.tap.subscribe(onNext: { [weak colorViewController] _ in
                guard let colorViewController = colorViewController else {return}
                colorViewController.dismiss(animated: animated, completion: nil)
            })
            let naviController = UINavigationController(rootViewController: colorViewController)
            parent?.present(naviController, animated: animated, completion: {
                observer.onNext(colorViewController)
            })
            return Disposables.create(dismissDisposable, Disposables.create {
                colorViewController.dismiss(animated: animated, completion: nil)
            })
        })
    }
    
    var selectedColor: Observable<UIColor> {
        return base.doneButton.rx.tap.withLatestFrom(base.colorView.rx.observe(UIColor.self, "backgroundColor")).map {
            color in
            return color!
        }
    }
}

extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%.2X%.2X%.2X" , Int(255*red), Int(255*green) ,Int(255*blue))
    }
}

extension String {
    var rgb: (Int, Int, Int)? {
        guard let number: Int = Int(self, radix: 16) else { return nil }
        let blue = number & 0x0000ff
        let green = (number & 0x00ff00) >> 8
        let red = (number & 0xff0000) >> 16
        return (red, green, blue)
    }
}


class ColorArchiveAPI {
    static let instance: ColorArchiveAPI = ColorArchiveAPI()
    var color: UIColor? = nil
    
    func save(color: UIColor) -> Observable<UIColor> {
        self.color = color
        return Observable.just(color).delay(0.7, scheduler: MainScheduler.instance)
    }
    
    func load() -> Observable<UIColor> {
        guard let color = color else {
            return Observable.empty().delay(0.7, scheduler: MainScheduler.instance)
        }
        return Observable.just(color).delay(0.7, scheduler: MainScheduler.instance)
    }
}
