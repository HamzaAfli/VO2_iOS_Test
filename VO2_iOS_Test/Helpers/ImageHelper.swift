//
//  ImageHelper.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Foundation
import Kingfisher

class ImageHelper {
    static func loadAvatar(url: URL, in imageView: UIImageView) {
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: imageView.frame.height / 2)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
    }

}
