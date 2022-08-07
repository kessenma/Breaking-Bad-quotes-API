//
//  ContentView.swift
//  BreakingBadAPI
//
//  Created by Kyle Essenmacher on 8/7/22.
//

import SwiftUI

struct Quote: Codable {
    var quote_id: Int
    var quote: String
    var author: String
    var series: String
}

struct ContentView: View {
    @State private var quotes = [Quote]()
    
    
    var body: some View {
        NavigationView{
            List(quotes, id: \.quote_id) { quote in
                VStack(alignment: .leading)  {
                    Text(quote.author)
                        .font(.headline)
                    Text(quote.quote)
                        .font(.body)
                }
            }
            .navigationTitle("Quotes")
            .task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async{
        //create the URl
        guard let url = URL(string: "https://www.breakingbadapi.com/api/quotes") else {
            print ("error")
            return
    }
        // fetch the data from the url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // decode the data from the url
            if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                quotes = decodedResponse
            }
        } catch {
            print("data not decoded")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
