//

import SwiftUI

struct LabEnvironmentAssumption: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}

private enum LabCoursePart: String, CaseIterable, Identifiable {
    case partI = "Part I"
    case partII = "Part II"
    case partIII = "Part III"

    var id: String { rawValue }
}

struct ContentView: View {
    @State private var selectedPart: LabCoursePart = .partI

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
                Section("Course Part") {
                    Picker("Course Part", selection: $selectedPart) {
                        ForEach(LabCoursePart.allCases) { part in
                            Text(part.rawValue).tag(part)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if selectedPart == .partI {
                    PartIFoundationsScreen(assumptions: assumptions)
                } else if selectedPart == .partII {
                    PartIICustomSystemScreen(assumptions: assumptions)
                } else {
                    PartIIICustomSystemScreen(assumptions: assumptions)
                }
            }
            .navigationTitle("DesignSystemLab")
        }
    }
}

private struct PartIFoundationsScreen: View {
    let assumptions: [LabEnvironmentAssumption]

    var body: some View {
        Group {
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

            Section("Stage 4 Materials, Surfaces & Depth") {
                MaterialSurfacesSection()
            }

            Section("Stage 5 Controls & Behavioral Contracts") {
                ControlsBehaviorSection()
            }

            Section("Stage 6 Iconography & Symbol Behavior") {
                IconographySection()
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
                Text("Use semantic typography, color roles, system materials, native controls, and SF Symbols semantics by default; fixed visual values or custom behavior require explicit justification.")
            }
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

private struct MaterialSurfacesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Apple material baseline (context-aware)")
                .font(.headline)
            AppleMaterialSurfaceCard()

            Divider()

            Text("Brand blur-stack anti-pattern (intentional)")
                .font(.headline)
            FragileCustomSurfaceCard()

            Text("Validate in light/dark, scrolling, and reduced transparency settings: material adapts contextually while custom blur stacks drift.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct AppleMaterialSurfaceCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.45), Color.pink.opacity(0.45), Color.blue.opacity(0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 10) {
                Text("System material surface")
                    .font(.headline)
                Text("This panel relies on `.regularMaterial` for contextual depth while preserving platform behavior.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    MaterialChip(label: "Ultra Thin", material: .ultraThinMaterial)
                    MaterialChip(label: "Regular", material: .regularMaterial)
                    MaterialChip(label: "Thick", material: .thickMaterial)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(uiColor: .separator), lineWidth: 1)
            )
            .padding(10)
        }
        .frame(height: 190)
    }
}

private struct FragileCustomSurfaceCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.17, green: 0.23, blue: 0.36), Color(red: 0.08, green: 0.11, blue: 0.18)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 10) {
                Text("Fixed faux-glass")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Multiple hard-coded opacities and blur radii mimic depth at one state but are intentionally fragile.")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.78))

                HStack(spacing: 8) {
                    Text("Layer A")
                    Text("Layer B")
                    Text("Layer C")
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.34), radius: 16, x: 0, y: 8)
            .blur(radius: 0.25)
            .padding(10)
        }
        .frame(height: 190)
    }
}

private struct MaterialChip: View {
    let label: String
    let material: Material

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(material, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color(uiColor: .separator), lineWidth: 0.5)
            )
    }
}

private struct ControlsBehaviorSection: View {
    @State private var nativeTapCount = 0
    @State private var customTapCount = 0
    @State private var disableActions = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Disable both actions", isOn: $disableActions)

            Text("Customized native Button baseline")
                .font(.headline)
            NativeButtonContractCard(
                tapCount: nativeTapCount,
                isDisabled: disableActions,
                action: { nativeTapCount += 1 }
            )

            Divider()

            Text("Fully custom look-alike (intentional risk)")
                .font(.headline)
            CustomButtonContractCard(
                tapCount: customTapCount,
                isDisabled: disableActions,
                action: { customTapCount += 1 }
            )

            ControlBehaviorChecklist()
        }
        .padding(.vertical, 4)
    }
}

private struct NativeButtonContractCard: View {
    let tapCount: Int
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Native semantics retained")
                .font(.subheadline.weight(.semibold))

            Button("Review details (\(tapCount))", action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isDisabled)

            Text("System control keeps traits, focus behavior, disabled semantics, and platform updates.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct CustomButtonContractCard: View {
    let tapCount: Int
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Custom surface mimicking a button")
                .font(.subheadline.weight(.semibold))

            Text("Review details (\(tapCount))")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isDisabled ? Color.gray.opacity(0.35) : Color(red: 0.10, green: 0.34, blue: 0.78), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(.white)
                .onTapGesture {
                    guard !isDisabled else { return }
                    action()
                }

            Text("Deliberate anti-pattern: this look-alike must manually restore semantics, states, and accessibility behavior.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct ControlBehaviorChecklist: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Behavior inventory for custom replacements")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            Label("Button role and VoiceOver traits", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Pressed, disabled, and focus states", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Keyboard/pointer interactions where applicable", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Future platform behavior updates", systemImage: "checkmark.circle")
                .font(.footnote)
        }
        .foregroundStyle(.secondary)
    }
}

private struct IconographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("SF Symbols rendering modes and scales")
                .font(.headline)
            SymbolRenderingModesCard()

            Divider()

            Text("Text alignment + custom icon pairing")
                .font(.headline)
            SymbolAlignmentCard()

            Divider()

            Text("Directional symbols and RTL sensitivity")
                .font(.headline)
            RTLSymbolComparisonCard()

            Text("Anti-pattern note: fixed raster-like icon sizing and direction-insensitive arrows become fragile across Dynamic Type and RTL.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct SymbolRenderingModesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Native symbol semantics")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 16) {
                SymbolSample(label: "Monochrome", imageName: "bell.badge.fill")
                SymbolSample(label: "Hierarchical", imageName: "bell.badge.fill", mode: .hierarchical)
                SymbolSample(label: "Palette", imageName: "bell.badge.fill", mode: .multicolor)
            }

            Text("Use rendering modes and semantic tinting before exporting custom icon sets.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct SymbolAlignmentCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("System symbol aligned to text metrics", systemImage: "bookmark.circle.fill")
                .font(.headline)

            HStack(spacing: 10) {
                CourseCreatedBadgeIcon()
                    .frame(width: 22, height: 22)
                    .accessibilityHidden(true)
                Text("Course-created icon shape paired with body text")
                    .font(.body)
            }

            HStack(spacing: 10) {
                Image(systemName: "bookmark.circle.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("Anti-pattern: resizable symbol detached from font metrics")
                    .font(.system(size: 12, weight: .regular))
            }
            .foregroundStyle(.secondary)

            Text("Prefer `font`-driven sizing for symbols in text contexts.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct RTLSymbolComparisonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Directional semantics")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 12) {
                Label("Forward semantic", systemImage: "chevron.forward")
                    .font(.subheadline)
                Label("Fixed right arrow", systemImage: "arrow.right")
                    .font(.subheadline)
            }

            Text("In RTL, semantic directions are preferred because they adapt with layout direction. Fixed absolute arrows often require manual correction.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct SymbolSample: View {
    let label: String
    let imageName: String
    var mode: SymbolRenderingMode? = nil

    var body: some View {
        VStack(spacing: 6) {
            if let mode {
                Image(systemName: imageName)
                    .font(.title2)
                    .symbolRenderingMode(mode)
                    .foregroundStyle(.blue, .orange)
            } else {
                Image(systemName: imageName)
                    .font(.title2)
                    .foregroundStyle(.tint)
            }

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

private struct CourseCreatedBadgeIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.tint.opacity(0.18))
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(.tint, lineWidth: 1)
            Path { path in
                path.move(to: CGPoint(x: 5, y: 11))
                path.addLine(to: CGPoint(x: 9, y: 15))
                path.addLine(to: CGPoint(x: 17, y: 7))
            }
            .stroke(.tint, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
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
