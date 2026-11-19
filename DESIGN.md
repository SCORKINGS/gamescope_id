# GameScope ID : Design Reference

## Identity

**Product:** GameScope ID  
**Tagline:** Gaming. Technology. What's Next.  
**Category:** Editorial gaming and technology news portal  
**Target:** Indonesian gaming enthusiasts, 16-35 years old  
**Platform:** Flutter Web (Chrome) + Android

---

## Visual Dials

| Dial | Level | Reason |
|---|---|---|
| ENERGY | 2 | Authoritative news portal, not a flashy game launcher. High signal, controlled intensity. |
| RHYTHM | 2 | Featured hero card breaks the grid; below that, a consistent list rhythm. |
| MOTION | 1 | Hover states and pull-to-refresh indicator only. No decorative animations. |

---

## Color System

All colors chosen for editorial clarity on dark backgrounds. Contrast ratios checked against WCAG AA.

| Token | Hex | Usage | Reason |
|---|---|---|---|
| `bgPrimary` | `#101318` | Page background | Near-black graphite, warmer than pure black, easier on eyes in dark rooms |
| `bgSurface` | `#1D2530` | Cards, containers | Lifted surface, distinguishable from bg without floating shadow |
| `bgElevated` | `#252E3A` | AppBar, chips, hover states | Second elevation level, used sparingly |
| `accentLime` | `#C7F464` | Active category chip, primary action, featured badge | Electric lime is the identity anchor: unusual, legible at small size on dark surface |
| `accentOrange` | `#FF7452` | Error state accent, "Baca Berita Asli" CTA, source label | Warm orange for action and urgency, pairs with lime for a gaming-editorial feel |
| `textPrimary` | `#F2F4F7` | Headlines, article titles | Near-white for maximum contrast on dark surface |
| `textSecondary` | `#A7B0BC` | Descriptions, metadata, timestamps | Muted but legible (contrast ratio ~4.6:1 on bgSurface) |
| `textOnAccent` | `#0D1117` | Text placed on lime accent | Near-black for contrast on bright lime (R-25 compliant) |
| `error` | `#F06464` | Error messages | Red-orange, distinct from both accents |
| `divider` | `#2A3545` | Subtle separators | Low-contrast divider, not decorative |

Palette count: 3 core neutrals + 2 accents. Within R-29 cap.

---

## Typography

| Role | Style | Reason |
|---|---|---|
| App name / Hero title | Bold, 22-28px | Needs to read like a masthead, not a UI label |
| Article title | SemiBold, 15-17px | Card titles must carry weight without feeling crowded |
| Body / description | Regular, 13-14px | Comfortable reading size on mobile |
| Metadata | Regular, 11-12px | Source and date are supporting info, not primary |
| Category chip | Medium, 12px | Small interactive element, needs legibility |

Font: System default (Flutter's default Roboto). Chosen because: it is the standard editorial font for Android, familiar to Indonesian mobile users, and loads with zero overhead. No vanity font is needed when the layout hierarchy does the design work.

Tracking and line height are set by content hierarchy, not decoration.

---

## Layout Principles

**Featured Article (top of feed):** Full-width image card with title overlay. This is the visual anchor. Only one per category load. Its prominence is earned by being the latest article.

**Article List:** Horizontal image (3:2 ratio) + vertical text stack. No identical card heights (natural content length drives height). Max image width: 110px thumbnail on list; full width on featured/detail.

**Category Bar:** Horizontal scroll of ChoiceChips. Active chip = lime accent. Inactive = elevated surface. Chips are compact (height 32px), not pill-shaped (6px radius).

**AppBar:** Dark graphite, logo left, search icon right. No shadow: the slight surface color difference provides separation.

**Spacing system:** 8px base unit. Sections: 16px padding. Card internal: 12px padding. Between cards: 1px divider (not gap).

---

## Component Decisions

**Cards:** `bgSurface` background, 8px radius (not pill). No shadow: surface color is the elevation signal. Border: none. The image does the visual lifting.

**Chips:** 6px radius (deliberately not pill). Inactive: `bgElevated` with `textSecondary`. Active: `accentLime` with `textOnAccent`.

**Buttons:** Primary action ("Baca Berita Asli") uses `accentOrange` with `textPrimary`, 4px radius, full-width. No icon-with-arrow decoration.

**Error view:** Icon + message + retry button. Icon uses `error` color. Retry button uses surface style, not accent: the accent is for positive actions.

**Empty state:** Search icon, single-line message, one-line suggestion. No illustration.

**Loading:** CircularProgressIndicator in `accentLime`. Single centered placement.

---

## What is Explicitly Avoided (R-31 documented)

| Avoided | Why |
|---|---|
| Full-page gradient hero | No hierarchy function; this is a news list, not a landing page |
| Glassmorphism on cards | Adds zero information value; news cards need clear separation |
| Generic AI icons (sparkle, lightning) | No connection to gaming/tech content |
| Three-column card grid | Monotonous; makes all stories equal, defeating editorial hierarchy |
| Fake trending badges or stats | Violates R-17 and R-36; we have no analytics |
| Lucide-style thin icons | Flutter Material Icons are thicker and clearer at small sizes on dark backgrounds |
| Pull-quote or testimonial sections | Not a news portal pattern; would look fabricated |
| "Unlock the power" or similar CTAs | Violates R-15 and R-16 |
