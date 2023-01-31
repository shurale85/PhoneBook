//
//  ContactCellView.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 26.01.2023.
//

import UIKit
import SnapKit

class ContactCellView: UITableViewCell {
    
    // MARK: - Outlets
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
//        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var temperamentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    static let cellId = "contactCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Configuations
    private func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(temperamentLabel)
    }
    
    private func configureConstraints() {
        nameLabel.snp.makeConstraints {  make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(180)
        }
        
        phoneLabel.snp.makeConstraints { [weak self] make in
            guard let `self` = self else {
                return
            }
            make.leading.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp_bottomMargin).offset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        temperamentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    func setupCell(person: Person) {
        nameLabel.text = person.name
        phoneLabel.text = person.$phone
        phoneLabel.textColor = Constants.mainGrayColor
        temperamentLabel.text = person.temperament.description
        temperamentLabel.textColor = Constants.mainGrayColor
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}
