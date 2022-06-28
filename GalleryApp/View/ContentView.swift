//
//  ContentView.swift
//  GalleryApp
//
//  Created by Nguyen Dang Quy on 21/05/2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import PencilKit
import AlertToast
import StoreKit


struct ContentView: View {
    //Edit image variables
    @State private var gammaValue: Float = 1
    @State private var vignetteValue: Float = -1
    @State private var sepiaValue: Float = 0
    @State private var crystalizeValue: Float = 1
    @State private var hueLevel: Float = 0
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var showingImagePicker = true
    @State private var editPageSelected = 0
    
    @Environment(\.undoManager) private var undoManager
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pencil
    
    

    var body: some View {
        
        NavigationView {
            VStack {
                edit
//                    .alert("Saved", isPresented: $showingSuccessAlert) {Button("OK", role: .cancel) { }}
                    .toast(isPresenting: $showingSuccessAlert, duration: 4) {
                        AlertToast(displayMode: .hud,
                                   type: .systemImage("tray.and.arrow.down", .white),
                                   title: "Saved")
                    }
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    canvas.drawing = PKDrawing()
                }) {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    guard let processedImage = self.processedImage else {return}
                    
                    let imageSaver = ImageSaver()
                    
                    
                    imageSaver.successHandler = {
                        showingSuccessAlert.toggle()
                    }
                    
                    imageSaver.writeToPhotoAlbum(image: processedImage)
                    
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.showingImagePicker.toggle()
                }) {
                    Image(systemName: "photo.on.rectangle")
                }
            }
        }

}


    
    // MARK: - Edit image

    var edit: some View {

        VStack {
            ZStack {
                
                if image != nil {
                    TabView {
                        
                        //tab1
                        VStack {
                            image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer().frame(height:15, alignment: .center)
                            
                                if editPageSelected == 0 {
                                    Spacer(minLength: 30)
                                        .frame(height: 60)
                                }
                            
                                if editPageSelected == 1 {
                                    HStack(spacing: 20) {
                                        Text("Brightness: ")
                                            .foregroundColor(Color(.systemBlue))
                                        Slider(value: $gammaValue, in: 0.5...1.5)
                                            .padding(5)
                                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                            .cornerRadius(5)
                                            .onChange(of: gammaValue, perform: { value in applyFilters() }
                                            )
                                    }.padding()
                                }
                                if editPageSelected == 2 {
                                    HStack(spacing: 20) {
                                        //mo vieng
                                        Text("Vignette: ")
                                            .foregroundColor(Color(.systemBlue))
                                        Slider(value: $vignetteValue, in: -1.0...2.0)
                                            .padding(5)
                                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                            .cornerRadius(5)
                                            .onChange(of: vignetteValue, perform: { value in applyFilters() }
                                            )
                                    }.padding()
                                }
                                if editPageSelected == 3 {
                                    HStack(spacing: 20) {
                                        Text("Sepia: ")
                                            .foregroundColor(Color(.systemBlue))
                                        Slider(value: $sepiaValue, in: 0...1)
                                            .padding(5)
                                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                            .cornerRadius(5)
                                            .onChange(of: sepiaValue, perform: { value in applyFilters() }
                                            )
                                    }.padding()
                                }
                                if editPageSelected == 4 {
                                    HStack(spacing: 20) {
                                        Text("Crystallization: ")
                                            .foregroundColor(Color(.systemBlue))
                                        Slider(value: $crystalizeValue, in: 1...50)
                                            .padding(5)
                                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                            .cornerRadius(5)
                                            .onChange(of: crystalizeValue, perform: { value in applyFilters() }
                                            )
                                    }.padding()
                                }
                                if editPageSelected == 5 {
                                    HStack(spacing: 20) {
                                        Text("Color: ")
                                            .foregroundColor(Color(.systemBlue))
                                        Slider(value: $hueLevel, in: 0...7)
                                            .padding(5)
                                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                            .cornerRadius(5)
                                            .onChange(of: hueLevel, perform: { value in applyFilters() }
                                            )
                                    }.padding()
                                }
                            
                            Spacer()
                            
                            ScrollView(.horizontal, showsIndicators: false) {   //showsIndicators: an thanh cuon ben duoi
                                
                                HStack(spacing: 10) {
                                
                                    Button(action: {editPageSelected=1}, label: {Text("Brightness").foregroundColor(.secondary)})
                                    Button(action: {editPageSelected=2}, label: {Text("Vignette").foregroundColor(.secondary)})
                                    Button(action: {editPageSelected=3}, label: {Text("Sepia").foregroundColor(.secondary)})
                                    Button(action: {editPageSelected=4}, label: {Text("Crystallization").foregroundColor(.secondary)})
                                    Button(action: {editPageSelected=5}, label: {Text("Color").foregroundColor(.secondary)})
                                }}
                            .padding(5)
                            .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                            .cornerRadius(60)
                            .foregroundColor(Color(.systemGray))
                            .shadow(color: Color(.systemGray), radius: 10)
                            .padding()

                                
                        }
                        .tabItem {
                            Image(systemName: "camera.filters")
                        }
                        
                        //tab2
                        VStack {
                            image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color))
                            Spacer().frame(height:15, alignment: .center)
                            
                            
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(isDraw ? Color(.systemGray) : Color(.systemGray3))
                                .frame(height: 60)
                                .shadow(color: Color(.systemGray), radius: 10)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Group {             // ERASER
                                            Button(action: {
                                                isDraw = false
                                            }, label: {
                                                Image(systemName: "pencil.slash")
                                                    .foregroundColor(.black)
                                            })
                                            Spacer()
                                        }
                                        Group {             //un
                                            Button(action: {
                                                self.undoManager?.undo()
                                            }, label: {
                                                Image(systemName: "arrow.uturn.backward")
                                                    .foregroundColor(.black)
                                            })
                                            Spacer()
                                        }
                                        Group {             // COLORPICKER
                                            ColorPicker("", selection: $color)
                                                .labelsHidden()
                                            Spacer()
                                        }
                                        Group {             //re
                                            Button(action: {
                                                self.undoManager?.redo()
                                            }, label: {
                                                Image(systemName: "arrow.uturn.forward")
                                                    .foregroundColor(.black)
                                            })
                                            Spacer()
                                        }
                                        Group {             // BRUSH SELECT
                                            Menu {
                                                Button(action: {    // HIGHLIGHTER SELECTION
                                                    isDraw = true
                                                    type = .marker
                                                }, label: {
                                                    Label {
                                                        Text("Marker")
                                                    } icon: {
                                                        Image(systemName: "highlighter")
                                                    }
                                                })
                                                Button(action: {    // PENCIL SELECTION
                                                    isDraw = true
                                                    type = .pencil
                                                }, label: {
                                                    Label {
                                                        Text("Pencil")
                                                    } icon: {
                                                        Image(systemName: "applepencil")
                                                    }
                                                })

                                                Button(action: {    // PEN SELECTION
                                                    isDraw = true
                                                    type = .pen
                                                }, label: {
                                                    Label {
                                                        Text("Pen")
                                                    } icon: {
                                                        Image(systemName: "pencil.tip")
                                                    }
                                                })
                                            } label: {  // MENU LABEL
                                                Image(systemName: "scribble")
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                        }

                                        
//                                        Group {             // EXPORT BUTTON
//                                            Button(action: {
//                                                UIImageWriteToSavedPhotosAlbum(UIImage(), nil, nil, nil)
//                                                isSaved.toggle()
//                                            }, label: {
//                                                Image(systemName: "square.and.arrow.up")
//                                                    .foregroundColor(.black)
//                                            })
//
//                                            Spacer()
//                                        }
//                                        Group {         // .
//                                            Button(action: {
//
//                                            }, label: {
//                                                Image(systemName: "home")
//                                                    .foregroundColor(.black)
//                                            })
//                                            Spacer()
//                                        }
                                        
                                    }
                                )
                                .padding(25)
                                //.animation(.easeOut)
                        }
                        .tabItem {
                            Image(systemName: "pencil.and.outline")
                            
                        .ignoresSafeArea()

                            
                            
                        }
                        
                    }
                } else {
//                    Text("Please select a picture ...")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .fixedSize()
//                        .padding()
                    AlertToast(type: .loading, title: "Loading ...")
                }
            }//zstack
        }//vstack
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: $inputImage)
            
        })
            .navigationBarBackButtonHidden(true)
        //https://developer.apple.com/documentation/swiftui/view/navigationbarbackbuttonhidden(_:)
    }
    
    // MARK: - IMAGE FILTER FUNCTIONS
    
    func applyFilters() {
        let context = CIContext() //end tat ca qua trinh xu ly
        //WINIETA
        let vignetteFilter = CIFilter.vignette()
        vignetteFilter.inputImage = CIImage(image: inputImage!)
        vignetteFilter.intensity = vignetteValue
        //SEPIA
        let sepia = CIFilter.sepiaTone()
        sepia.inputImage = CIImage(image: inputImage!)
        sepia.intensity = sepiaValue
        //NOISE
        let crystallizeFilter = CIFilter.crystallize()
        crystallizeFilter.inputImage = CIImage(image: inputImage!)
        crystallizeFilter.radius = crystalizeValue
        
        crystallizeFilter.center = CGPoint(x: inputImage!.size.width / 2, y: inputImage!.size.height / 2)
        
        //Hue
        let hue = CIFilter.hueAdjust()
        hue.inputImage = CIImage(image: inputImage!)
        hue.angle = hueLevel
        
        //GAMMA
        let gamma = CIFilter.gammaAdjust()
        gamma.inputImage = CIImage(image: inputImage!)
        gamma.power = gammaValue
        
        
        sepia.setValue(vignetteFilter.outputImage, forKey: "inputImage")
        crystallizeFilter.setValue(sepia.outputImage, forKey: "inputImage")
        hue.setValue(crystallizeFilter.outputImage, forKey: "inputImage")
        gamma.setValue(hue.outputImage, forKey: "inputImage")
        
        
        if let output = gamma.outputImage{
            if let cgimg = context.createCGImage(output, from: output.extent) {
                var processedUIImage: UIImage
                    processedUIImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: UIImage.Orientation(rawValue: (inputImage?.imageOrientation)!.rawValue)!)
                image = Image(uiImage: processedUIImage)
                processedImage = processedUIImage
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
    }
    


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
//
//struct RequestReviewManager {
//    static func requestUserReview() {
//        if #available(iOS 14.0, *) {
//            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                SKStoreReviewController.requestReview(in: scene)
//            } else {
//                
//            }
//        } else {
//            SKStoreReviewController.requestReview()
//        }
//    }
//}
