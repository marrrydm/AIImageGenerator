//
//  Builder.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 15.02.2024.
//

import UIKit

class Builder {
    static func build() -> UIViewController {
        let generateViewModel = GeneratorViewModel(apiKey: Constants.API_KEY)
        let controller = GenerateController(viewModel: generateViewModel)
        return controller
    }
}
