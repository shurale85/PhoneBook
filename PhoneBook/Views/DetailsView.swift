//
//  DetailsView.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 29.01.2023.
//

import UIKit

class DetailsView: UIView {

    // MARK: - Outlets
    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var educationYears: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var phone: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var biography: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var temperament: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSelf() {
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(container)
        container.addArrangedSubview(name)
        container.setCustomSpacing(30, after: name)
        container.addArrangedSubview(educationYears)
        container.setCustomSpacing(10, after: educationYears)
        container.addArrangedSubview(temperament)
        container.setCustomSpacing(20, after: temperament)
        container.addArrangedSubview(phone)
        container.setCustomSpacing(20, after: phone)
        container.addArrangedSubview(biography)
    }
    
    func configureConstraints() {
        container.snp.makeConstraints { maker in
            maker.center .equalToSuperview()
            maker.width.equalToSuperview().inset(16)
        }
    }
    
    func setup(person: Person) {
        name.text = person.name
        educationYears.text = person.educationPeriod.description
        educationYears.textColor = Constants.mainGrayColor
        temperament.text = person.temperament.description
        temperament.textColor = Constants.mainGrayColor
        phone.setText(person.$phone, prependedBySymbolNameed: "phone.fill")
        biography.text = person.biography
        biography.textColor = Constants.mainGrayColor
        phone.isUserInteractionEnabled = true
    }
}
