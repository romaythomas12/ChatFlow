//
//  TitleRow.swift
//  ChatFlow
//
//  Created by Thomas Romay on 04/11/2024.
//

import SwiftUI

struct NavHeader: View {
    var imageUrl = URL(string: "https://xsgames.co/randomusers/avatar.php?g=female")! // Mock profile image url
    let name: String

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ProfileImageView(imageUrl: imageUrl)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.title).bold()

                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            // Placeholder icons
            HStack(spacing: 8) {
                IconButton(icon: "phone.fill")
                IconButton(icon: "video")
                IconButton(icon: "ellipsis")
            }
        }
        .padding()
    }
}

// MARK: - Subviews

struct ProfileImageView: View {
    var imageUrl: URL

    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(25)
        } placeholder: {
            ProgressView()
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(25)
        }
    }
}

struct IconButton: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .foregroundColor(.black)
            .padding(10)
            .background(Color.white)
            .cornerRadius(25)
    }
}

#Preview {
    NavHeader(imageUrl: URL(string: "https://xsgames.co/randomusers/avatar.php?g=female")!, name: "Jane Doe")
}
