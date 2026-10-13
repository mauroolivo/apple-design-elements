import SwiftUI
import UIKit

enum DSFieldState: String, CaseIterable, Identifiable {
    case normal = "Normal"
    case focused = "Focused"
    case disabled = "Disabled"
    case error = "Error"

    var id: String { rawValue }
}

struct DSField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var state: DSFieldState = .normal
    var helperText: String? = nil
    var errorText: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var submitLabel: SubmitLabel = .done

    @Environment(\.dsTokenBundle) private var tokenBundle
    @FocusState private var isFocused: Bool

    private var isDisabled: Bool { state == .disabled }
    private var isError: Bool { state == .error }

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.inline) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(isDisabled ? tokenBundle.semantics.text.muted : tokenBundle.semantics.text.primary)

            fieldBody
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(fieldBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(fieldBorder, lineWidth: fieldBorderWidth)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(fieldFocusTint.opacity(isFocused ? 1 : 0), lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.14), value: isFocused)
                .opacity(isDisabled ? 0.65 : 1.0)

            footerText
        }
    }

    @ViewBuilder
    private var fieldBody: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .focused($isFocused)
                .disabled(isDisabled)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .submitLabel(submitLabel)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        } else {
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .disabled(isDisabled)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .submitLabel(submitLabel)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
    }

    @ViewBuilder
    private var footerText: some View {
        if let errorText, isError {
            Label(errorText, systemImage: "exclamationmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.red)
        } else if let helperText {
            Text(helperText)
                .font(.caption)
                .foregroundStyle(tokenBundle.semantics.text.muted)
        }
    }

    private var fieldBackground: Color {
        if isDisabled {
            return Color(uiColor: .tertiarySystemBackground)
        }
        if isError {
            return Color.red.opacity(0.06)
        }
        if isFocused || state == .focused {
            return tokenBundle.semantics.surfaces.accent.opacity(0.28)
        }
        return Color(uiColor: .secondarySystemBackground)
    }

    private var fieldBorder: Color {
        if isDisabled {
            return tokenBundle.semantics.borders.subtle.opacity(0.5)
        }
        if isError {
            return .red
        }
        if isFocused || state == .focused {
            return tokenBundle.semantics.actions.primary
        }
        return tokenBundle.semantics.borders.subtle
    }

    private var fieldBorderWidth: CGFloat {
        if isFocused || state == .focused || isError {
            return 2
        }
        return tokenBundle.semantics.borders.width
    }

    private var fieldFocusTint: Color {
        tokenBundle.semantics.actions.primary
    }
}

#Preview("DSField Matrix") {
    VStack(spacing: 16) {
        DSField(
            title: "Email",
            placeholder: "name@domain.com",
            text: .constant(""),
            helperText: "We will use this for account updates."
        )

        DSField(
            title: "Password",
            placeholder: "Enter a password",
            text: .constant(""),
            state: .error,
            errorText: "Password must contain at least 8 characters.",
            isSecure: true,
            keyboardType: .default,
            textContentType: .password,
            submitLabel: .done
        )

        DSField(
            title: "Referral code",
            placeholder: "Optional",
            text: .constant("ABC-123"),
            state: .disabled,
            helperText: "Disabled example",
            keyboardType: .default,
            submitLabel: .next
        )
    }
    .padding()
    .dsTheme(.ocean)
}
