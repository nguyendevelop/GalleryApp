//
//  DrawingView.swift
//  GalleryApp
//
//  Created by Nguyen Dang Quy on 21/05/2022.
//

import SwiftUI
import PencilKit

struct DrawingView : UIViewRepresentable {  // DRAWING INFO
    
    
    @Binding var canvas : PKCanvasView          // canvas to draw on
    @Binding var isDraw : Bool                  // Am I drawing or erasing?
    @Binding var type : PKInkingTool.InkType    // Pencil, Pen or Marker?
    @Binding var color : Color                  // Tip color
    
//    let picker = PKToolPicker.init()
    
    
    var ink : PKInkingTool {
        PKInkingTool(type, color: UIColor(color))   // Set up the tip
    }
    
    let eraser = PKEraserTool(.bitmap)  // Eraser type
    

    
    
    func makeUIView(context: Context) -> PKCanvasView {
        let imageView = UIImageView(image: UIImage())

        let subView = self.canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        
        canvas.backgroundColor = .clear
        canvas.isOpaque = false         // ko mo dam
        
        canvas.drawingPolicy = .anyInput    // bat ky input nao cung can draw
        canvas.tool = isDraw ? ink : eraser // xac dinh xem tool draw or eraser
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink : eraser
//        picker.addObserver(canvas)
//        picker.setVisible(true, forFirstResponder: uiView)
//        DispatchQueue.main.async {
//            uiView.becomeFirstResponder()
//        }
    }
}
