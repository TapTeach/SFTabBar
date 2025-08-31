//
//  TipJar.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/9/20.
//

import SwiftUI

struct TipJar: View {
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack {
            List() {
                Section {
                    VStack {
                        HStack {
                            Text("Finding SF TabBar useful?")
                                .font(.headline)
                                .padding(.vertical, 4.0)
                            Spacer()
                        }
                        HStack {
                            Text("Please consider rating the app or sharing it with friends!")
                                .font(.body)
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(.pink)
                            Text("IAP functionality has been removed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical)
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
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("Rate & Share")
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
