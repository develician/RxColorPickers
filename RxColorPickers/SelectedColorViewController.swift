//
//  SelectedColorViewController.swift
//  RxColorPickers
//
//  Created by killi8n on 2018. 7. 22..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectedColorViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let addButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: nil)
        return btn
    }()
    
    let colors: BehaviorSubject<[UIColor]> = BehaviorSubject(value: [UIColor.red, UIColor.green, UIColor.blue, UIColor.brown, UIColor.cyan])
    
    let refreshControl: UIRefreshControl = {
        let ctrl = UIRefreshControl()
        return ctrl
    }()
    
    let reverseButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "reverse", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        return btn
    }()
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.refreshControl = refreshControl
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        cv.backgroundColor = .white
        cv.delegate = self
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews()
        bind()
    }
    
    
    
    
}

extension SelectedColorViewController {
    func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = reverseButton
        
        let components = [colorCollectionView]
        components.forEach { component in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
        
    }
    
    func setupViews() {
        colorCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        colorCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        colorCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        colorCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func bind() {
        
        typealias Section = AnimatableSectionModel<String, UIColor>
        let datasource: RxCollectionViewSectionedAnimatedDataSource<Section> = RxCollectionViewSectionedAnimatedDataSource(configureCell: { (datasource, collectionView, indexPath, color) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            cell.contentView.backgroundColor = color
            return cell
        }, configureSupplementaryView: { (datasource, collectionView, string, indexPath) -> UICollectionReusableView in
            return collectionView.dequeueReusableSupplementaryView(ofKind: string, withReuseIdentifier: "a", for: indexPath)
        })
        
        colors.map {
            [Section(model: "", items: $0)]
            }.bind(to: colorCollectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        
        refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {return}
                let colors = (try? self.colors.value()) ?? []
                self.colors.onNext(colors.reversed())
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        addButton.rx.tap.flatMap {
            [weak self] _ in
            return ColorViewController.rx.create(parent: self)
                .flatMap {
                    $0.rx.selectedColor
                }.take(1)
            }.subscribe(onNext: { [weak self] color in
                guard let `self` = self else {return}
                var colors = (try? self.colors.value()) ?? []
                colors.append(color)
                self.colors.onNext(colors)
            }).disposed(by: disposeBag)
        
        reverseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            let colors = (try? self.colors.value()) ?? []
            self.colors.onNext(colors.reversed())
            //            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        colorCollectionView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else {return}
            var colors = (try? self.colors.value()) ?? []
            colors.remove(at: indexPath.item)
            self.colors.onNext(colors)
        }).disposed(by: disposeBag)
    }
    
    
}


extension SelectedColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.view.frame.width/3) - 4), height:((self.view.frame.width / 3) - 4))
    }
}

extension UIColor: IdentifiableType  {
    public var identity : Int {
        return self.cgColor.hashValue
    }
}
