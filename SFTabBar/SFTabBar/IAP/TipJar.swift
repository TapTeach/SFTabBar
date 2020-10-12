//
//  TipJar.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/9/20.
//

import SwiftUI
import Purchases

struct TipJar: View {
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack {
            List() {
            Section(header: Text("Send a Thank You")) {
                VStack {
                    HStack {
                        Text("Finding SF TabBar useful?")
                            .font(.headline)
                            .padding(.vertical, 4.0)
                        Spacer()
                    }
                    HStack {
                        Text("A \"small\" or \"large\" tip would be much appreciated! Thank you. ")
                            .font(.body)
                        Spacer()
                    }
                    HStack{
                        TipButton(icon: "hand.thumbsup", label: "Small Tip", price: "$0.99")
                        TipButton(icon: "heart", label: "Large Tip", price: "$2.99")
                    }.padding(.vertical)
                }
                
            }
            Section(header: Text("Share the App")) {
                HStack {
                    Link(destination: URL(string: "https://apps.apple.com/us/app/id1533863571?mt=8&action=write-review")!) {
                        Text("Rate the App")
                    }
                }
                HStack {
                    Button(action: {
                        self.showingShareSheet = true
                    }) {
                        Text("Share with Friends")
                    }
                    .sheet(isPresented: $showingShareSheet,
                           content: {
                            ActivityView(activityItems: [NSURL(string: "https://apps.apple.com/us/app/id1533863571")!] as [Any], applicationActivities: nil) })
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        Spacer()
        Text("version: " + appVersionString)
            .font(.footnote)
            .foregroundColor(Color.gray)
            .padding(.top, 2.0)
        
        }.navigationBarTitle("Sharing is Caring")
 }
}



struct FilledStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: 295.0)
            .background(Color(.systemPink))
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.callout)
            
    }
}

struct TipButton: View {
    
    var icon: String
    var label: String
    var price: String
    
    var body: some View {
        //no idea how to make this work I guess
        Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
            VStack(spacing: 4.0) {
                Image(systemName: icon)
                    .imageScale(.large)
                    .padding(.bottom, 6.0)
                Text(label)
                    .fontWeight(.medium)
                Text(price)
                    .font(.caption)
            }
            .padding(.all)
        }.buttonStyle(FilledStyle())
    }
}

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}


struct TipJar_Previews: PreviewProvider {
    static var previews: some View {
        TipJar()
    }
}
