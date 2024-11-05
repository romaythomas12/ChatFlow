//
//  ChatView.swift
//  ChatFlow
//
//  Created by Thomas Romay on 03/11/2024.
//
import SwiftUI

@MainActor
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var scrollProxy: ScrollViewProxy? = nil
    @Namespace private var animationNamespace
    @State private var isAnimatingMessage = false
    @State private var textFieldHeight: CGFloat = 0
    @State private var scrollTrigger: Bool = false

    var body: some View {
        switch viewModel.state {
            case .initial,
                 .loading: SpinnerView()
            case .loaded: content
            case .error: errorView
        }
    }
}

private extension ChatView {
    private var content: some View {
        VStack {
            NavHeader(name: ChatViewModel.sampleUser)
            messageScrollView
            messageInputView
        }
        .overlay(animatedOverlayMessage(), alignment: .bottomTrailing)
    }

    private var errorView: some View {
        Text("Something went wrong")
            .foregroundColor(.red)
            .padding()
            .accessibilityLabel("Something went wrong")
            .accessibilityHint("An error occurred while loading images")
    }
}

private extension ChatView {
    // MARK: - Message Scroll View

    var messageScrollView: some View {
        GeometryReader { gr in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer()
                        Text("You matched 🎈").font(.title.bold())
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.groupedMessages, id: \.id) { groupedMessage in
                                if groupedMessage.message.type == .timestamp {
                                    TimestampView(text: groupedMessage.message.text)
                                        .padding(.vertical, groupedMessage.spacing)
                                } else {
                                    MessageBubble(message: groupedMessage.message)
                                        .padding(.vertical, groupedMessage.spacing)
                                        .id(groupedMessage.id)
                                        .matchedGeometryEffect(id: groupedMessage.id, in: animationNamespace)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .onAppear {
                            scrollProxy = proxy
                            scrollToBottom(animated: false)
                        }
                    }.frame(maxWidth: .infinity,
                            minHeight: gr.size.height - 20,
                            alignment: .bottom)
                }
                .scrollDismissesKeyboard(.interactively)

                .onChange(of: viewModel.groupedMessages) { oldValue, _ in

                    scrollToBottom(animated: oldValue.count > 0)
                }
            }
        }
    }

    // MARK: - Message Input View

    var messageInputView: some View {
        ZStack(alignment: .bottomTrailing) {
            inputTextField
            sendButton
        }
        .padding()
    }

    var inputTextField: some View {
        TextField("Message", text: $viewModel.inputText, axis: .vertical)
            .frame(minHeight: 30)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray)
            )
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.size.height) { newHeight, _ in
                            textFieldHeight = newHeight
                        }
                }
            )
            .onChange(of: viewModel.inputText) { newText, _ in

                if newText.isEmpty {
                    scrollToBottom(animated: false)
                }
            }
            .onChange(of: textFieldHeight) { _, _ in
                scrollToBottom(animated: false)
            }
    }

    var sendButton: some View {
        Button(action: sendMessageWithAnimation) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .disabled(!viewModel.isTextFieldNotEmpty)
        .frame(width: 40, height: 40)
        .offset(x: 10, y: -5)
        .padding(.horizontal)
    }
}

private extension ChatView {
    func sendMessageWithAnimation() {
        guard viewModel.isTextFieldNotEmpty else { return }

        // Prepare a new message object
        viewModel.prepareMessage()

        Task {
            // Animate message entry with ease-in effect
            withAnimation(.easeIn(duration: 0.15)) {
                isAnimatingMessage = true
            }

            try? await Task.sleep(nanoseconds: 150_000_000)

            // Send the message using the view model
            await viewModel.sendMessage()

            // Animate scroll to bottom with a spring effect
            withAnimation(.spring()) {
                scrollToBottom()
            }

            // End animation after a slight delay to smooth transition
            try? await Task.sleep(nanoseconds: 50_000_000)
            withAnimation {
                isAnimatingMessage = false
            }
        }
    }

    func scrollToBottom(animated: Bool = true) {
        guard let lastMessageID = viewModel.groupedMessages.last?.id else { return }

        if animated {
            withAnimation(.spring()) {
                scrollProxy?.scrollTo(lastMessageID, anchor: .bottom)
            }
        } else {
            scrollProxy?.scrollTo(lastMessageID, anchor: .bottom)
        }
    }

    @ViewBuilder
    func animatedOverlayMessage() -> some View {
        if let message = viewModel.messageBeingSent, isAnimatingMessage {
            MessageBubble(message: message)
                .matchedGeometryEffect(id: message.id, in: animationNamespace)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                .padding(.trailing, 20)
                .padding(.bottom, 20)
        }
    }
}
