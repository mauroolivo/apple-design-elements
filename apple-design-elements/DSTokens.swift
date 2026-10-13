import SwiftUI

enum DSBrandDecision: String, CaseIterable, Identifiable {
    case ocean = "Ocean"
    case plum = "Plum"

    var id: String { rawValue }
}

struct DSTokenBundle {
    let primitives: DSPrimitiveTokens
    let semantics: DSSemanticTokens
    let components: DSComponentTokens

    static func make(for brand: DSBrandDecision) -> Self {
        let primitives = DSPrimitiveTokens.make(for: brand)
        let semantics = DSSemanticTokens.make(from: primitives)
        let components = DSComponentTokens.make(from: semantics)
        return Self(primitives: primitives, semantics: semantics, components: components)
    }
}

struct DSPrimitiveTokens {
    let spacing: DSPrimitiveSpacing
    let radius: DSPrimitiveRadius
    let border: DSPrimitiveBorder
    let brand: DSPrimitiveBrandPalette

    static func make(for brandDecision: DSBrandDecision) -> Self {
        let brand: DSPrimitiveBrandPalette

        switch brandDecision {
        case .ocean:
            brand = DSPrimitiveBrandPalette(
                name: "Ocean",
                accent: Color(red: 0.12, green: 0.47, blue: 0.93),
                accentPressed: Color(red: 0.08, green: 0.34, blue: 0.74),
                accentSoft: Color(red: 0.87, green: 0.94, blue: 1.0)
            )
        case .plum:
            brand = DSPrimitiveBrandPalette(
                name: "Plum",
                accent: Color(red: 0.54, green: 0.24, blue: 0.73),
                accentPressed: Color(red: 0.41, green: 0.17, blue: 0.57),
                accentSoft: Color(red: 0.95, green: 0.90, blue: 0.99)
            )
        }

        return Self(
            spacing: .init(xs: 4, sm: 8, md: 12, lg: 16),
            radius: .init(card: 14, control: 12, badge: 999),
            border: .init(subtle: 1),
            brand: brand
        )
    }
}

struct DSPrimitiveSpacing {
    let xs: CGFloat
    let sm: CGFloat
    let md: CGFloat
    let lg: CGFloat
}

struct DSPrimitiveRadius {
    let card: CGFloat
    let control: CGFloat
    let badge: CGFloat
}

struct DSPrimitiveBorder {
    let subtle: CGFloat
}

struct DSPrimitiveBrandPalette {
    let name: String
    let accent: Color
    let accentPressed: Color
    let accentSoft: Color
}

struct DSSemanticTokens {
    let spacing: DSSemanticSpacing
    let text: DSSemanticText
    let surfaces: DSSemanticSurfaces
    let actions: DSSemanticActions
    let borders: DSSemanticBorders

    static func make(from primitives: DSPrimitiveTokens) -> Self {
        Self(
            spacing: .init(
                stack: primitives.spacing.md,
                inline: primitives.spacing.sm,
                cardPadding: primitives.spacing.lg
            ),
            text: .init(
                primary: .primary,
                muted: .secondary,
                onAccent: .white
            ),
            surfaces: .init(
                primary: Color(uiColor: .secondarySystemBackground),
                accent: primitives.brand.accentSoft
            ),
            actions: .init(
                primary: primitives.brand.accent,
                pressed: primitives.brand.accentPressed
            ),
            borders: .init(
                subtle: Color(uiColor: .separator),
                width: primitives.border.subtle
            )
        )
    }
}

struct DSSemanticSpacing {
    let stack: CGFloat
    let inline: CGFloat
    let cardPadding: CGFloat
}

struct DSSemanticText {
    let primary: Color
    let muted: Color
    let onAccent: Color
}

struct DSSemanticSurfaces {
    let primary: Color
    let accent: Color
}

struct DSSemanticActions {
    let primary: Color
    let pressed: Color
}

struct DSSemanticBorders {
    let subtle: Color
    let width: CGFloat
}

struct DSComponentTokens {
    let card: DSCardComponentTokens
    let button: DSButtonComponentTokens
    let badge: DSBadgeComponentTokens

    static func make(from semantics: DSSemanticTokens) -> Self {
        Self(
            card: .init(
                background: semantics.surfaces.primary,
                border: semantics.borders.subtle,
                borderWidth: semantics.borders.width,
                cornerRadius: 14,
                padding: semantics.spacing.cardPadding
            ),
            button: .init(
                background: semantics.actions.primary,
                foreground: semantics.text.onAccent,
                cornerRadius: 12,
                horizontalPadding: 14,
                verticalPadding: 10
            ),
            badge: .init(
                background: semantics.surfaces.accent,
                foreground: semantics.actions.primary,
                horizontalPadding: 10,
                verticalPadding: 6
            )
        )
    }
}

struct DSCardComponentTokens {
    let background: Color
    let border: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let padding: CGFloat
}

struct DSButtonComponentTokens {
    let background: Color
    let foreground: Color
    let cornerRadius: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
}

struct DSBadgeComponentTokens {
    let background: Color
    let foreground: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
}
