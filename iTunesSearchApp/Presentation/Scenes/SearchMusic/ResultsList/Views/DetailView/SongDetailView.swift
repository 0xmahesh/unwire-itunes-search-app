//
//  SongDetailView.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 11/7/2023.
//

import Foundation
import SwiftUI

struct SongDetailView: View {
    
    @StateObject var viewModel: SongDetailViewModel
    
    var body: some View {
        VStack {
            
            AsyncImage(url: viewModel.albumArtworkUrl, content: { phase in
                switch phase {
                case .success( let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                default:
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                }
            })
            .frame(width: UIScreen.main.bounds.size.width)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("itunes_music_title_1".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("itunes_music_title_2".localized)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("itunes_music_title_3".localized)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            
            Spacer()
            
            VStack {
                Button(action: {
                    print("WIP")
                }, label: {
                    Text("itunes_start_listening_btn_title".localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: UIScreen.main.bounds.size.width - 40)
                        .frame(height: 50)

                })
                .background(.pink)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .padding(20)
            
            
            Spacer()
                .frame(height: 50)
            
        }
        .padding([.top], 20)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
    }
}
