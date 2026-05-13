import SwiftUI

/// "AI Photo Assistant" chat screen — mirrors the Stitch AI assistant design.
struct AIAssistantView: View {
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var advisorService: PhotographyAdvisorService

    @State private var inputText = ""
    @FocusState private var inputFocused: Bool
    @State private var scrollProxy: ScrollViewProxy?

    private let assistantId = "bottom"

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    solarStateBar
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: FieldFocusTheme.Spacing.md) {
                                if advisorService.chatMessages.isEmpty {
                                    emptyPrompt
                                }
                                ForEach(advisorService.chatMessages) { message in
                                    ChatBubble(message: message)
                                }
                                if advisorService.isThinking {
                                    thinkingIndicator
                                }
                                Color.clear.frame(height: 1).id(assistantId)
                            }
                            .padding(FieldFocusTheme.Spacing.pagePad)
                        }
                        .onChange(of: advisorService.chatMessages.count) { _, _ in
                            withAnimation { proxy.scrollTo(assistantId) }
                        }
                    }
                    inputBar
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private var headerBar: some View {
        HStack {
            Image(systemName: "sparkles")
                .font(.system(size: 20))
                .foregroundColor(FieldFocusTheme.Color.orange)
            VStack(alignment: .leading, spacing: 1) {
                Text("FieldFocus AI")
                    .font(FieldFocusTheme.Typography.headlineSM())
                    .foregroundColor(.white)
                Text("Tell me about your subject and light conditions.")
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
    }

    // MARK: - Solar state bar
    private var solarStateBar: some View {
        HStack(spacing: FieldFocusTheme.Spacing.md) {
            Label {
                Text(solarStateText)
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(FieldFocusTheme.Color.textPrimary)
            } icon: {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(FieldFocusTheme.Color.orange)
                    .font(.system(size: 12))
            }
            Spacer()
            Label {
                Text(weatherService.snapshot.locationName)
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .lineLimit(1)
            } icon: {
                Image(systemName: "location.fill")
                    .foregroundColor(FieldFocusTheme.Color.navyDark)
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, 10)
        .background(FieldFocusTheme.Color.surfaceLow)
        .overlay(Divider(), alignment: .bottom)
    }

    private var solarStateText: String {
        let condition = weatherService.snapshot.condition
        switch condition {
        case .goldenHour:
            if let end = weatherService.snapshot.goldenHourEnd {
                let minutes = Int(end.timeIntervalSinceNow / 60)
                if minutes > 0 { return "Golden Hour — \(minutes) min remaining" }
            }
            return "Golden Hour — peaking now"
        default:
            return "\(condition.rawValue) — \(weatherService.snapshot.temperatureKelvin)K"
        }
    }

    // MARK: - Empty prompt
    private var emptyPrompt: some View {
        VStack(spacing: FieldFocusTheme.Spacing.md) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(FieldFocusTheme.Color.orange.opacity(0.5))
            Text("Ask me anything about your camera settings, composition, or conditions.")
                .font(FieldFocusTheme.Typography.bodyMD())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .multilineTextAlignment(.center)
            VStack(spacing: FieldFocusTheme.Spacing.sm) {
                ForEach(suggestedPrompts, id: \.self) { prompt in
                    Button {
                        inputText = prompt
                        sendMessage()
                    } label: {
                        Text(prompt)
                            .font(FieldFocusTheme.Typography.bodySM())
                            .foregroundColor(FieldFocusTheme.Color.orange)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                    }
                    .modifier(GlassPromptChip())
                }
            }
        }
        .padding(.top, 40)
        .padding(.horizontal, FieldFocusTheme.Spacing.xl)
    }

    private var suggestedPrompts: [String] {
        let c = weatherService.snapshot.condition
        switch c {
        case .goldenHour: return ["Best aperture for golden hour bokeh?", "How do I set white balance on the Stylus 1s?", "Composition tips for sunset landscapes?"]
        case .overcast:   return ["Settings for portrait photography?", "How do I handle flat light?", "What ISO for overcast outdoors?"]
        case .rain:       return ["Is the Stylus 1s waterproof?", "How do I photograph rain reflections?", "Best shutter for wet conditions?"]
        default:          return ["What are the best settings right now?", "How do I adjust aperture on the Stylus 1s?", "Composition tip for this light?"]
        }
    }

    // MARK: - Thinking indicator
    private var thinkingIndicator: some View {
        HStack(alignment: .bottom, spacing: FieldFocusTheme.Spacing.sm) {
            Image(systemName: "sparkles")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(FieldFocusTheme.Color.navyDark)
                .clipShape(Circle())
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(FieldFocusTheme.Color.textSecondary)
                        .frame(width: 7, height: 7)
                        .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2), value: advisorService.isThinking)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .glassCard(cornerRadius: FieldFocusTheme.Radius.lg)
            Spacer()
        }
    }

    // MARK: - Input bar
    private var inputBar: some View {
        HStack(spacing: FieldFocusTheme.Spacing.sm) {
            TextField("Ask about aperture, ISO, composition…", text: $inputText, axis: .vertical)
                .font(FieldFocusTheme.Typography.bodyMD())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .focused($inputFocused)
                .lineLimit(1...4)
                .padding(.horizontal, FieldFocusTheme.Spacing.md)
                .padding(.vertical, 10)
                .modifier(GlassInputField(isFocused: inputFocused))

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? FieldFocusTheme.Color.outline : FieldFocusTheme.Color.orange)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || advisorService.isThinking)
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.sm)
        .background(FieldFocusTheme.Color.surfaceLow) // intentional: not glass — structural bar
        .overlay(Divider(), alignment: .top)
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        inputText = ""
        inputFocused = false
        Task {
            await advisorService.sendMessage(text, weather: weatherService.snapshot)
        }
    }
}

// MARK: - Glass prompt chip modifier
private struct GlassPromptChip: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
                .glassEffect(.regular.interactive(), in: .capsule)
        } else {
            content
                .background(FieldFocusTheme.Color.orange.opacity(0.08))
                .cornerRadius(FieldFocusTheme.Radius.full)
        }
    }
}

// MARK: - Glass input field modifier
private struct GlassInputField: ViewModifier {
    let isFocused: Bool
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
                .glassEffect(
                    isFocused ? .regular.tint(FieldFocusTheme.Color.navyDark) : .regular,
                    in: .capsule
                )
        } else {
            content
                .background(FieldFocusTheme.Color.surface)
                .cornerRadius(FieldFocusTheme.Radius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.full)
                        .stroke(isFocused ? FieldFocusTheme.Color.navyDark : FieldFocusTheme.Color.outline, lineWidth: 1)
                )
        }
    }
}

// MARK: - Chat bubble
struct ChatBubble: View {
    let message: PhotographyAdvisorService.ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: FieldFocusTheme.Spacing.sm) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                Image(systemName: "sparkles")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(FieldFocusTheme.Color.navyDark)
                    .clipShape(Circle())
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                if !isUser {
                    Text("EXPERT CALIBRATION")
                        .font(FieldFocusTheme.Typography.labelCaps())
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                        .kerning(0.8)
                }
                Text(message.text)
                    .font(FieldFocusTheme.Typography.bodyMD())
                    .foregroundColor(isUser ? .white : FieldFocusTheme.Color.textPrimary)
                    .lineSpacing(4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .modifier(ChatBubbleBackground(isUser: isUser))
            }

            if isUser {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
            }

            if !isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Chat bubble background modifier
private struct ChatBubbleBackground: ViewModifier {
    let isUser: Bool
    func body(content: Content) -> some View {
        if isUser {
            // User bubbles stay navy — intentional dark treatment
            content
                .background(FieldFocusTheme.Color.navyDark)
                .cornerRadius(FieldFocusTheme.Radius.lg)
        } else {
            if #available(iOS 26, *) {
                content
                    .glassEffect(.regular, in: .rect(cornerRadius: FieldFocusTheme.Radius.lg))
            } else {
                content
                    .background(FieldFocusTheme.Color.surface)
                    .cornerRadius(FieldFocusTheme.Radius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.lg)
                            .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    AIAssistantView()
        .environmentObject(WeatherService())
        .environmentObject(PhotographyAdvisorService())
}
