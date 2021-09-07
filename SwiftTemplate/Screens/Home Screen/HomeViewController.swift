//
//  ViewController.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 12/03/2020.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {

    // MARK: - UI elements
    let label = UILabel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews(label)

        setupUI()
        setupConstraints()
    }

    // MARK: - UI setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        label.text = String(format: localizedString(for: "welcome_to"), "SwiftTemplate")
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}
