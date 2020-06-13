//
//  JHCollectionViewCell.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

open class JHCollectionViewCell: UICollectionViewCell, Reusable{

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configCellViews()
        contentView.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 继承 在内部实现布局
    /// 子类重写，进行view布局
    open func configCellViews() {
        
    }
    
    // MARK: - cell赋值
    /// cell的model赋值，也是需要子类重写
    /// - Parameter model: 赋值
    open func setCellModel<T>(model: T) {
        
    }

    // MARK: - 获取高度
    /// 获取cell高度
    /// - Parameter model: model
    /// - Returns: 高度
    public func getCellHeightWithModel<T>(model: T) -> CGFloat {
        setCellModel(model: model)
        layoutIfNeeded()
        updateConstraintsIfNeeded()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }

}
