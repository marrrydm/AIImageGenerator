//
//  GeneratorViewModel.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 17.02.2024.
//

import UIKit

class GeneratorViewModel {
    private let apiManager: StablediffusionAPIManager

    init(apiKey: String) {
        apiManager = StablediffusionAPIManager(apiKey: apiKey)
    }

    func generateImageFromText(_ text: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        apiManager.generateImageFromText(text) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

