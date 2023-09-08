//
//  LottieHelper.swift
//
import UIKit
import Foundation
import Lottie

typealias LottieView = AnimationView

class LottieHelper {

    func addLottie(file : String = "succes_sent_order", with frame : CGRect)->LottieView{
        let heartView = AnimationView(name: file)
        heartView.frame = frame
        return heartView
    }
    func addShimmerLottie(file : String = "shimmer", with frame : CGRect)->LottieView{
        let heartView = AnimationView(name: file)
        heartView.frame = frame
        return heartView
    }
}
