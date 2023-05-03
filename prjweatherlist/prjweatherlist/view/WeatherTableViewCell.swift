//
//  WeatherTableViewCell.swift
//  prjweatherlist
//
//  Created by 김성인 on 2023/05/03.
//

import UIKit
import SnapKit

class WeatherTableViewCell: UITableViewCell {

    var day: UILabel!
    var icon: UIImageView!
    var weather_desc: UILabel!
    
    var temp_max: UILabel!
    var temp_min: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        day = UILabel()
        day.font = UIFont(name: day.font.fontName, size: 16)
        self.contentView.addSubview(day)
        day.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        
        icon = UIImageView()
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(day.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        
        weather_desc = UILabel()
        self.contentView.addSubview(weather_desc)
        weather_desc.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.bottom.equalTo(icon.snp.bottom).offset(-10)
        }
        
        temp_min = UILabel()
        temp_min.font = UIFont(name: temp_min.font.fontName, size: 12)
        self.contentView.addSubview(temp_min)
        temp_min.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(icon.snp.centerY)
        }
        
        temp_max = UILabel()
        temp_max.font = UIFont(name: temp_max.font.fontName, size: 12)
        self.contentView.addSubview(temp_max)
        temp_max.snp.makeConstraints { make in
            make.trailing.equalTo(temp_min.snp.leading).offset(-16)
            make.centerY.equalTo(icon.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
