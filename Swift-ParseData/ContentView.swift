//
//  ContentView.swift
//  Swift-ParseData
//
//  Created by Majharul Huq on 2022/10/18.
//

import SwiftUI

struct Response : Codable {
    var results = [Result]()
}

struct Result : Codable {
    var trackId : Int
    var trackName : String
    var collectionName : String
    var artworkUrl60 : String;
}

struct ContentView: View {
    
    @State var results = [Result]()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            NavigationView{
                List(results, id: \.trackId){ item in
                    VStack{
                        CellView(imageUrl: item.artworkUrl60, trackName: item.trackName, collectionName: item.collectionName)
                    }
                }.navigationTitle("Bon Jovi Songs")
            }
            
        }.edgesIgnoringSafeArea(.all)
        .task {
            await loadSongData()
        }
    }
    
    func loadSongData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=bon+jovi&entity=song") else{
            print("Invalid Url")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                results = decodedResponse.results
                print(decodedResponse.results)
            }else{
                print("Decode Error")
            }
        }catch{
            print("Invalid Song Data")
        }
    }
    
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .none
       UITableView.appearance().backgroundColor = .none
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct CellView: View {
    
    var imageUrl : String
    var trackName : String
    var collectionName : String
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: imageUrl),content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 64, maxHeight: 64)
                
            },placeholder: {
                Image(systemName: "photo")
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 64, maxHeight: 64)
            }
            )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(trackName)
                    .fontWeight(.semibold)
                Text(collectionName)
                    .font(.subheadline)
            }
        }.listRowBackground(Color.green)
    }
}
