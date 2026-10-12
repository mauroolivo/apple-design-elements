//

import SwiftUI

struct LabEnvironmentAssumption: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}

struct ContentView: View {
    private let assumptions: [LabEnvironmentAssumption] = [
        .init(key: "Simulator model", value: "iPhone 18 Pro"),
        .init(key: "Simulator OS", value: "iOS 27.0"),
        .init(key: "SDK used to build", value: "iPhoneSimulator27.1"),
        .init(key: "Color scheme", value: "Light"),
        .init(key: "Dynamic Type", value: "Default (.large)"),
        .init(key: "Locale", value: "en_US (assumed; verify in simulator)"),
        .init(key: "Layout direction", value: "Left-to-right (assumed)")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Stage 0 Laboratory") {
                    Label("DesignSystemLab bootstrap", systemImage: "hammer")
                    Label("Apple references inventory started", systemImage: "book")
                    Label("Figma inspection unavailable", systemImage: "exclamationmark.triangle")
                }

                Section("Stage 1 Native vs Brand-Heavy") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Apple-native baseline")
                            .font(.headline)
                        AppleNativeExampleCard()
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Brand-heavy mockup (intentionally flawed)")
                            .font(.headline)
                        BrandHeavyExampleCard()
                    }
                    .padding(.vertical, 4)
                }

                Section("Stage 2 Typography Specimen") {
                    TypographySpecimenSection()
                }

                Section("Stage 3 Color Semantics & Appearance") {
                    ColorSemanticsSection()
                }

                Section("Baseline Visual Matrix") {
                    ForEach(assumptions) { assumption in
                        HStack(alignment: .firstTextBaseline) {
                            Text(assumption.key)
                                .foregroundStyle(.secondary)
                            Spacer(minLength: 12)
                            Text(assumption.value)
                                .multilineTextAlignment(.trailing)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }

                Section("Current Rule") {
                    Text("Use semantic typography and semantic color roles by default; fixed visual values in reusable UI require explicit justification.")
                }
            }
            .navigationTitle("DesignSystemLab")
        }
    }
}

private struct AppleNativeExampleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Project update")
                .font(.headline)
            Text("System typography, spacing, and controls preserve familiar behavior and accessibility.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Review details") {}
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct BrandHeavyExampleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PROJECT UPDATE")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Color(red: 0.91, green: 0.97, blue: 1.0))
            Text("Fixed typography + low contrast + tiny tap target are deliberate anti-patterns for Stage 1 analysis.")
                .font(.system(size: 11, weight: .thin, design: .rounded))
                .foregroundStyle(Color(red: 0.78, green: 0.88, blue: 0.97))
            Button("Details") {}
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(red: 0.08, green: 0.14, blue: 0.27))
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(10)
        .background(Color(red: 0.06, green: 0.16, blue: 0.31), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(red: 0.18, green: 0.32, blue: 0.55), lineWidth: 1)
        )
    }
}

private struct TypographySpecimenSection: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Apple semantic text styles")
                .font(.headline)

            SemanticStylesSpecimen()

            Divider()

            Text("Custom ramp with Dynamic Type-aware scaling")
                .font(.headline)

            CustomRampSpecimen()

            Divider()

            Text("Deliberately flawed fixed-size ramp")
                .font(.headline)

            FixedRampAntiPatternSpecimen()

            Text(dynamicTypeSize.isAccessibilitySize
                 ? "Accessibility size detected: stacked semantics should take priority over compact inline layout."
                 : "Standard size detected: compact inline layout remains acceptable.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct SemanticStylesSpecimen: View {
    private let styleRows: [(String, Font)] = [
        ("largeTitle", .largeTitle),
        ("title", .title),
        ("title2", .title2),
        ("headline", .headline),
        ("body", .body),
        ("callout", .callout),
        ("footnote", .footnote),
        ("caption", .caption)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(styleRows, id: \.0) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.0)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Sphinx of black quartz, judge my vow")
                        .font(row.1)
                        .lineLimit(2)
                }
            }
        }
    }
}

private struct CustomRampSpecimen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScaledCustomRow(name: "Display", basePointSize: 30, weight: .bold)
            ScaledCustomRow(name: "Body", basePointSize: 17, weight: .regular)
            ScaledCustomRow(name: "Meta", basePointSize: 13, weight: .medium)
        }
    }
}

private struct ScaledCustomRow: View {
    let name: String
    let basePointSize: CGFloat
    let weight: Font.Weight

    @ScaledMetric(relativeTo: .body) private var scaledBodyReference: CGFloat = 17
    @ScaledMetric(relativeTo: .body) private var scaledIconSide: CGFloat = 18

    private var computedPointSize: CGFloat {
        scaledBodyReference * (basePointSize / 17)
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Circle()
                .fill(.tint)
                .frame(width: scaledIconSide, height: scaledIconSide)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(name) / base \(Int(basePointSize))pt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Sphinx of black quartz, judge my vow")
                    .font(.system(size: computedPointSize, weight: weight, design: .rounded))
                    .lineLimit(2)
            }
        }
    }
}

private struct FixedRampAntiPatternSpecimen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Fixed Display 30")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .lineLimit(1)
            Text("Fixed Body 13")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .lineLimit(1)
            Text("Fixed Meta 10")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .lineLimit(1)
            Text("These lines do not scale with Dynamic Type and are expected to fail readability goals.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

private struct ColorSemanticsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Apple semantic colors (adaptive)")
                .font(.headline)
            AppleSemanticColorCard()

            Divider()

            Text("Hard-coded colors (intentional anti-pattern)")
                .font(.headline)
            HardCodedColorAntiPatternCard()

            Text("Inspect in light/dark + increased contrast: semantic roles adapt while fixed values become brittle.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct AppleSemanticColorCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Semantic surface")
                .font(.headline)
                .foregroundStyle(.primary)

            Text("This card uses system semantic foreground/background roles and should remain legible across appearance changes.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                SemanticSwatch(label: "Primary", fill: Color.primary)
                SemanticSwatch(label: "Secondary", fill: Color.secondary)
                SemanticSwatch(label: "Tint", fill: Color.accentColor)
            }

            Button("System action") {}
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct HardCodedColorAntiPatternCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fixed palette")
                .font(.headline)
                .foregroundStyle(Color(red: 0.89, green: 0.95, blue: 1.0))

            Text("These fixed values are intentionally brittle and may lose clarity in dark mode or increased contrast.")
                .font(.subheadline)
                .foregroundStyle(Color(red: 0.72, green: 0.83, blue: 0.95))

            HStack(spacing: 10) {
                SemanticSwatch(label: "Info", fill: Color(red: 0.22, green: 0.56, blue: 0.91))
                SemanticSwatch(label: "Border", fill: Color(red: 0.19, green: 0.35, blue: 0.59))
                SemanticSwatch(label: "Bg", fill: Color(red: 0.08, green: 0.16, blue: 0.28))
            }

            Text("Button look-alike")
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(red: 0.09, green: 0.14, blue: 0.24), in: Capsule())
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color(red: 0.06, green: 0.13, blue: 0.23), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(red: 0.16, green: 0.29, blue: 0.47), lineWidth: 1)
        )
    }
}

private struct SemanticSwatch: View {
    let label: String
    let fill: Color

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(fill)
                .frame(width: 42, height: 26)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color(uiColor: .separator), lineWidth: 0.5)
                )
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }
}

#Preview("Default") {
    ContentView()
}

#Preview("Accessibility 1") {
    ContentView()
        .dynamicTypeSize(.accessibility1)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
