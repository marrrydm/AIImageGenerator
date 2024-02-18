//
//  StablediffusionAPIManager.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 15.02.2024.
//

import Alamofire
import Kingfisher
import Foundation

protocol ImageGenerationService {
    func generateImageFromText(_ text: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class StablediffusionAPIManager: ImageGenerationService {
    private let apiKey: String
    private let session: Session

    init(apiKey: String, session: Session = Session.default) {
        self.apiKey = apiKey
        self.session = session
    }

    func generateImageFromText(_ text: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = "https://modelslab.com/api/v3/text2img"
        
        let parameters: [String: Any] = [
            "key": "\(apiKey)",
            "prompt": text,
            "width": "512",
            "height": "512",
            "samples": "1",
            "num_inference_steps": "50",
            "safety_checker": "yes",
            "enhance_prompt": "yes",
            "temp": "yes",
            "guidance_scale": 5.0
        ]

        session.request(url,
                        method: .post,
                        parameters: parameters,
                        encoding: JSONEncoding.default)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                    if let pngImgUrl = responseModel.output.first,
                       let url = URL(string: pngImgUrl) {
                        let resource = KF.ImageResource(downloadURL: url)
                        KingfisherManager.shared.retrieveImage(with: resource) { result in
                            switch result {
                            case .success(let imageResult):
                                completion(.success(imageResult.image))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.failure(APIError.invalidImageURL))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
