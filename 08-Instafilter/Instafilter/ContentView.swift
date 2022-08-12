//
//  ContentView.swift
//  Instafilter
//
//  Created by Rich Bobo on 2022/7/19.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
   @State private var image: Image?
   @State private var filterIntensity = 0.5
   @State private var filterRadius = 0.5
   @State private var filterScale = 1.0
   
   @State private var showingImagePicker = false
   @State private var inputImage: UIImage?
   
   @State private var currentFilter: CIFilter = .sepiaTone()
   let context = CIContext()
   
   @State private var showingFilterSheet = false
   
   @State private var processedImage: UIImage?

   var body: some View {
      NavigationView {
         VStack {
            ZStack {
               Rectangle()
                  .fill(.secondary)
               
               Text("Tap to select a picture")
                  .foregroundColor(.white)
                  .font(.headline)
               
               image?
                  .resizable()
                  .scaledToFit()
            }
            .onTapGesture {
               showingImagePicker = true
            }
            
            sliderView
            
            HStack {
               Button("Change Filter") {
                  showingFilterSheet = true
               }
               
               Spacer()
               
               Button("Save", action: save)
                  .disabled(image == nil)
            }
         }
         .padding([.horizontal, .bottom])
         .navigationTitle("Instafilter")
         .onChange(of: inputImage) { _ in loadImage() }
         .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
         }
         .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
           changeFilterView
         }
      }
   }
   
   func loadImage() {
      guard let inputImage = inputImage else { return }
      
      let beginImage = CIImage(image: inputImage)
      currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
      applyProcessing()
   }
   
   func applyProcessing() {
      let inputKeys = currentFilter.inputKeys
      
      if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
      if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
      if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
      
      guard let outputImage = currentFilter.outputImage else { return }
      
      if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         let uiImage = UIImage(cgImage: cgimg)
         image = Image(uiImage: uiImage)
         processedImage = uiImage
      }
   }
   
   func setFilter(_ filter: CIFilter) {
      currentFilter = filter
      loadImage()
   }
   
   func save() {
      guard let processedImage = processedImage else { return }
      
      let imageSaver = ImageSaver()
      
      imageSaver.successHandler = {
         print("Success!")
      }
      
      imageSaver.errorHandler = {
         print("Oops: \($0.localizedDescription)")
      }
      
      imageSaver.writeToPhotoAlbum(image: processedImage)
   }
   
   var sliderView: some View {
      VStack {
         HStack {
            Text("Intensity")
            Slider(value: $filterIntensity)
               .disabled(!currentFilter.inputKeys.contains(kCIInputIntensityKey))
               .onChange(of: filterIntensity) { _ in applyProcessing() }
         }
      
         HStack {
            Text("Radius")
            Slider(value: $filterRadius)
               .disabled(!currentFilter.inputKeys.contains(kCIInputRadiusKey))
               .onChange(of: filterRadius) { _ in applyProcessing() }
         }
      
         HStack {
            Text("Scale")
            Slider(value: $filterScale)
               .disabled(!currentFilter.inputKeys.contains(kCIInputScaleKey))
               .onChange(of: filterScale) { _ in applyProcessing() }
         }
      }
      .padding([.vertical, .horizontal])
   }
   
   var changeFilterView: some View {
      Group {
         Button("Crystallize") { setFilter(CIFilter.crystallize()) }
         Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
         Button("Pixellate") { setFilter(CIFilter.pixellate()) }
         Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
         Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
         Button("Vignette") { setFilter(CIFilter.vignette()) }
         Button("Cancel", role: .cancel) {}
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
