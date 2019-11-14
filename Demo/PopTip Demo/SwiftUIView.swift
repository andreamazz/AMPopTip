//
//  SwiftUIView.swift
//  PopTip Demo
//
//  Created by Ernesto Rivera on 11/13/19.
//  Copyright © 2017 Andrea Mazzini. All rights reserved.
//

#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIView: View {
  
  var items = [Item(string: "First"),
               Item(string: "Second"),
               Item(string: "Third"),
               Item(string: "Fourth"),
               Item(string: "Fifth")]
  
  var body: some View {
    ScrollView {
      Text("Custom SwiftUI view")
      ForEach(items) { item in
        HStack {
          Image(systemName: "person.circle")
          Text(item.string)
          Spacer()
        }
        .foregroundColor(.secondary)
      }
    }
  }
}

class Item: Identifiable {
  let id = UUID()
  
  var string: String
  
  init(string: String) {
    self.string = string
  }
}

@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIView()
  }
}
#endif
