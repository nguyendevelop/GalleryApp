//
//  HomeViewModel.swift
//  GalleryApp
//
//  Created by Nguyen Dang Quy on 21/05/2022.
//

import SwiftUI
//reload
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects
class HomeViewModel : ObservableObject {
    @Published var imagePicker = false
    @Published var imageData: Data = Data(count: 0)
    
}
