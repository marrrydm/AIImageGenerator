//
//  ResponseModel.swift
//  AIImageGenerator
//
//  Created by Мария Ганеева on 15.02.2024.
//

import Foundation

struct ResponseModel: Decodable {
    let status, tip: String
    let generationTime: Float
    let id: Int
    let output, proxy_links: [String]
    let nsfw_content_detected: String
    let meta: Meta

    struct Meta: Decodable {
        let H, W: Int
        let enable_attention_slicing, file_prefix: String
        let guidance_scale: Double
        let instant_response, model: String
        let n_samples: Int
        let negative_prompt, outdir, prompt, revision: String
        let safetychecker: String
        let seed, steps: Int
        let temp, vae: String
    }
}
