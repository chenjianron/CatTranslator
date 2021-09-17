//
//  SettingTableViewCell.swift
//  CatTranslator
//
//  Created by GC on 2021/9/13.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    lazy var cellBack: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "cell_arrow")
        return imageView
    }()
    lazy var cellIcon:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func layoutUI() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(cellBack)
        contentView.addSubview(cellIcon)
        
        cellIcon.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20.4)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(cellIcon.snp.right).offset(11.6)
        }
        
        cellBack.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-19.52)
        }

    }

    func setData(icon:String,title:String){
        cellIcon.image = UIImage(named: icon)
        titleLabel.text = title
    }
    
}
