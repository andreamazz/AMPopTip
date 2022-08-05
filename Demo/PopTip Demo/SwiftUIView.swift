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
struct SwiftUIOneView: View {
  
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
struct SwiftUIOneView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIOneView()
      .previewLayout(.sizeThatFits)
  }
}

@available(iOS 13.0, *)
struct SwiftUITwoView: View {
  
  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      VStack(alignment: .leading, spacing: 4) {
        Text("This is a title")
        Text("This is an AMPopTip which utilises a SwiftUI view as its content")
      }
      Spacer(minLength: 0)
      Image(systemName: "bubble.left")
        .resizable()
        .scaledToFit()
        .frame(width: 12, height: 12)
    }
  }
}

@available(iOS 13.0, *)
struct SwiftUITwoView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUITwoView()
      .previewLayout(.sizeThatFits)
  }
}

#endif
