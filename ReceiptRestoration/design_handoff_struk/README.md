# Handoff: Struk — Indonesian Receipt Restoration App

## Overview
Struk is a mobile iOS app that helps users restore degraded receipt photos (faded thermal paper, blur, creases, stains) and extract structured data from them. The core ML pipeline is a **NAFNet** deep-learning model for image restoration followed by **OCR** to extract structured fields (store, date, items, subtotal, PPN, total). UI copy is in Indonesian.

## About the Design Files
The files in this bundle are **design references created in HTML** — interactive prototypes showing intended look and behavior, **not production code to copy directly**.

Your task is to **recreate these HTML designs in the target codebase's existing environment** (SwiftUI, React Native, Flutter, etc.) using its established patterns, component libraries, and conventions. If no environment exists yet, choose the most appropriate native iOS framework — **SwiftUI** is recommended given the iOS-first scope.

The HTML uses React + inline styles because that's the prototype medium; do not literally port the JSX. Read the styles, copy the *values* (colors, spacing, type, radii), and re-implement using native iOS primitives (`VStack`, `HStack`, `ZStack`, `.background`, `.cornerRadius`, etc.).

## Fidelity
**High-fidelity (hifi).** Final colors, typography scale, spacing, corner radii, and interaction details are all locked. Recreate pixel-perfectly using the codebase's existing libraries — but adopt the codebase's component vocabulary where one already exists (e.g. use the project's existing `PrimaryButton` rather than rebuilding mine).

---

## Screens / Views

### 01 — Home (`HomeScreen`)
**Purpose:** Entry point. User picks a receipt from the photo library (primary) or opens the camera (secondary). Recent restorations are listed below.

**Layout (top → bottom):**
- Status bar (system)
- Header row: small uppercase "STRUK" wordmark (left, accent color) + circular info button (right, 32×32, accent-tinted bg)
- Large title: "Pulihkan struk yang pudar." (32/700, letter-spacing -0.8, two lines)
- Subtitle: 15/regular, secondary gray, ~20px line-height
- **Primary CTA card** — full-width, padding 20, radius 24, linear-gradient `135deg, #D86A36 → #C25420`, white text, drop shadow `0 16px 32px rgba(216,106,54,0.32)`. Contains: 44×44 frosted icon square (top-left), "NAFNet · v2" pill (top-right), title "Pilih dari Galeri" 22/700, subtitle 14/regular at 0.85 opacity.
- **Secondary button** — full-width, radius 16, white bg, 1px sep border, 36×36 gray icon square + "Ambil Foto Baru" / "Buka kamera" stacked + chevron-right.
- **Riwayat** (Recent) section header — 13/600 uppercase secondary gray, "Lihat semua" link in accent on the right
- 2×2 grid (gap 10) of recent-receipt cards (radius 16, 1px sep border): mini receipt thumbnail (78px tall, white tile with thin horizontal lines simulating text, slight rotation) + store name + date · total

### 02 — Picked + Quality Warning (`PickedScreen`)
**Purpose:** Show the picked photo, surface a quality warning when input is poor, and offer the restore action.

**Layout:**
- Top bar (absolute, top 56): 36×36 close button (frosted white, blur(20)) on left, "Pratinjau" title centered, spacer on right
- **Preview frame** (absolute, top 110, bottom 220, 16px side margins): white card, radius 24, 1px sep border, 45° diagonal-stripe background pattern (subtle gray). Receipt image displayed inside at a slight tilt (-3°).
- **Quality warning banner** (absolute, bottom 200): yellow card (`#FFF4D0` bg, `#F3D783` border), radius 14, 12/14 padding. Triangle warning icon (`#C28A18`) on left. Title "Kualitas gambar rendah" (14/600 `#7C5300`) + body "Foto buram dan tinta pudar. Restorasi tetap dapat dilakukan, tetapi sebagian teks mungkin tidak terbaca." (12.5/400 same color at 0.8 opacity).
- **Bottom action area** (absolute, bottom 0, 16/20/38 padding, fade-up gradient bg):
  - PrimaryButton "Restorasi Struk" with sparkle icon
  - Ghost button "Pilih foto lain"

Provide a `showWarning: Bool` flag — when false, the banner is hidden and the bottom area takes the freed space.

### 03 — Processing (`ProcessingScreen`)
**Purpose:** Show inference progress with a sense of what the model is doing.

**Layout:**
- Top: dimmed receipt preview frame (same dimensions as screen 02 but `bottom: 250`)
- An animated **scanning line** crosses the receipt horizontally — 2px tall accent-colored line with a strong glow (`0 0 24px ${accent}, 0 0 8px ${accent}`) and a subtle accent gradient fading down from the top of the receipt to where the line is.
- **Progress card** (bottom, white, radius 22, padding 20, soft shadow):
  - Top row: 44×44 **circular progress ring** (3px stroke, accent-tinted bg ring + accent foreground arc using `strokeDasharray`), centered percentage text inside. To the right: current stage name (16/600) + sub-label "Model NAFNet · N langkah tersisa" (12.5/secondary).
  - **Pipeline checklist** below — 5 steps with 18×18 status circles + 14px label. States: `done` (accent filled circle + white check), `active` (accent-tinted bg + pulsing 7×7 accent dot, label bold), `pending` (gray bg + 1px sep border, label tertiary gray).
- Steps in order: Pra-pemrosesan → Deteksi noise → Restorasi NAFNet → Penajaman teks → Ekstraksi OCR.

**Animation:** The pulsing dot uses `@keyframes` scaling 1.0 → 1.4 with opacity 1 → 0.5 over 1s, ease-in-out, infinite. The whole flow takes ~3 seconds from 0–100% in the prototype; in production it should be driven by the real model progress callback.

### 04 — Before/After Results (`ResultsScreen`)
**Purpose:** Let the user judge restoration quality, then route to OCR output.

**Layout:**
- Top bar: close (left), centered pill showing "● Restorasi selesai · 2,3 dtk" with a green status dot, spacer (right)
- Body (scrollable):
  - Title "Geser untuk bandingkan" (26/700)
  - Subtitle "Tarik garis untuk melihat hasil restorasi." (14/secondary)
  - **Before/After slider** (the hero — see "Interactions" below)
  - 3-column metric grid: Ketajaman `+247%`, Noise `−82%`, OCR `24/24`. Each: white card, radius 14, 1px sep border, 11px uppercase label + 17/700 value. Positive metrics use green `#1F8A3F`.
  - **"Lihat data terbaca" card** — white, radius 16, 1px sep border. 36×36 accent-tinted icon square (lined-document SVG) + title "Lihat data terbaca" + subtitle "6 item · Total Rp 102.675" + chevron-right.
- Bottom bar (sticky, fade-up bg): Two equal buttons — secondary "Salin Teks" (copy icon) + primary "Simpan" (share/export icon).

### 05 — OCR Structured Data (`OCRScreen`)
**Purpose:** Show extracted data as queryable fields, not a text wall.

**Layout:**
- Top bar: back chevron, centered "Data Struk" title, copy button on right
- Body (scrollable):
  - **Header row**: 56×72 mini receipt thumbnail (white card with thin horizontal text-simulating lines) + store name (22/700) + "18 Mei 2026 · 14:32" + small green accuracy badge "Akurasi 98%".
  - **Meta card** (white, radius 16, 1px sep border): four label/value rows (Toko, Alamat, No. Struk, Kasir). Labels 13/secondary on the left, values 14/500 right-aligned, separated by hairline borders.
  - **Items section header**: "Item · 6" on left, subtotal preview on right (both 13/secondary)
  - **Items card**: list of rows — quantity chip (24×24 gray square `×N`) + item name (15/regular) + price (14/500 monospace, right-aligned).
  - **Totals card**: Subtotal (14/400 secondary), PPN 11% (14/400), **Total** (16/700 in primary text, value 18/700 in **accent color, monospace**).
  - **Payment card**: Tunai (cash) + Kembali (change), both 14/regular.

### 06 — Empty State (`EmptyScreen`)
**Purpose:** First-launch / cleared-history view.

**Layout:**
- Same small "STRUK" wordmark header
- Centered illustration area: three faux-receipt cards fanned out (one degraded, one mid, one restored — at -14°, +3°, +16° rotation, 0.85 scale, with horizontal offsets -40/0/+40). A 38×38 accent circle with sparkle icon overlays the top-right of the stack.
- Title "Belum ada struk" (24/700)
- Subtitle "Pilih foto struk yang pudar atau buram dan biarkan AI memperjelasnya." (15/secondary, two lines, centered)
- Bottom: PrimaryButton "Pilih dari Galeri" + GhostButton "Ambil Foto"

---

## Interactions & Behavior

### Before/After Slider (core element)
- Vertical white divider with a 38×38 circular handle (white bg, two chevron glyphs pointing left/right, drop shadow + 4px white halo).
- **Drag** the handle or **drag anywhere** on the image to move the split (mouse + touch).
- Implementation: position is a 0–100 percentage. The "before" (degraded) layer sits on top of the "after" (restored) layer and is **clipped** via `clipPath: inset(0 ${100 - pos}% 0 0)` on the right side, so the restored image is revealed as the user drags right.
- On native iOS: use a `DragGesture` on the divider; compute split position relative to the image bounds; clip with a mask layer.
- Labels: "Sebelum" pill (black 55% bg, top-left) and "Sesudah" pill (accent bg, top-right) stay fixed.

### Navigation Flow
```
Home ──Pilih dari Galeri──▶ Picked
Picked ──Restorasi Struk──▶ Processing ──auto on complete──▶ Results
Picked ──Pilih foto lain / X──▶ Home
Results ──Lihat data terbaca──▶ OCR
Results ──X──▶ Home
OCR ──back chevron──▶ Results
```

### Quality Warning Logic
The warning banner shows when the model's input-quality assessment indicates poor input. Suggested heuristic for production: combine Laplacian-variance blur score + brightness uniformity + edge density. Below a threshold → show warning. Keep the warning **informative, not blocking** — restoration still proceeds.

### Processing Animation
While inference runs:
- Scanning line sweeps top-to-bottom over the receipt preview (subtle, ~3s loop).
- Active pipeline step's dot pulses.
- Done steps stay checked; pending steps stay outlined.
- Percentage and stage label update from the real progress callback.

### Loading / Empty / Error States
- **Empty:** Screen 06 above.
- **Restoration failed:** Re-use the warning banner styling in red — `#FDECEA` bg, `#E07A6E` border, `#8E1F11` text. Title "Restorasi gagal", subtitle with retry CTA.
- **OCR low confidence:** Replace the green "Akurasi 98%" badge with an amber one and underline ambiguous values in the meta/items cards (1px dashed amber underline).

---

## State Management

Required state per session:
- `currentScreen`: `home | picked | processing | results | ocr | empty`
- `selectedImage`: source `UIImage` / file URL
- `qualityScore`: derived from the input image
- `restoredImage`: model output (kept in memory + optionally saved to Photos)
- `processingProgress`: 0–100 percentage
- `processingStage`: enum of pipeline steps
- `ocrResult`: structured object (see schema below)
- `splitPosition`: 0–100 for the before/after slider

OCR result shape:
```ts
{
  store: { name: string, address: string, phone?: string }
  receipt: { number: string, cashier: string, datetime: ISO8601 }
  items: { name: string, quantity: number, unitPrice?: number, lineTotal: number }[]
  totals: { subtotal: number, tax: { label: string, amount: number }, total: number }
  payment: { method: string, paid: number, change: number }
  confidence: number  // 0..1
}
```

Persisted state (Core Data / SwiftData / Realm):
- History of past restorations (image refs + extracted JSON + timestamps)

---

## Design Tokens

### Colors
| Token | Value | Use |
|---|---|---|
| `accent` | `#D86A36` | Primary action, brand wordmark, total amount, focus states |
| `accent-gradient` | `linear-gradient(135deg, #D86A36 → #C25420)` | Hero CTA card |
| `accent-dim` | `rgba(216,106,54,0.10)` | Accent-tinted icon backgrounds, progress ring track |
| `bg` | `#F2F2F7` | System background (iOS systemGray6) |
| `card` | `#FFFFFF` | Cards, sheets, list backgrounds |
| `text` | `#000000` | Primary text |
| `text-2` | `rgba(60,60,67,0.78)` | Secondary text |
| `text-3` | `rgba(60,60,67,0.6)` | Tertiary / metadata |
| `text-4` | `rgba(60,60,67,0.3)` | Quaternary (chevrons, separators) |
| `sep` | `rgba(60,60,67,0.12)` | Card borders, hairline dividers |
| `warn-bg` | `#FFF4D0` | Quality warning background |
| `warn-bd` | `#F3D783` | Quality warning border |
| `warn-fg` | `#7C5300` | Quality warning text |
| `warn-icon` | `#C28A18` | Quality warning triangle icon |
| `success` | `#1F8A3F` | Positive metrics, status dots |
| `success-bg` | `rgba(31,138,63,0.10)` | Success pill bg |

### Spacing
- Side gutters: **16px** (content), **20px** (hero blocks)
- Card internal padding: **14px** (rows) — **20px** (hero cards)
- Vertical rhythm: 6 / 10 / 14 / 18 / 24 / 32

### Typography
- Family: **SF Pro Text** (system) for UI, **SF Mono** for receipt-text and monetary amounts
- Sizes / weights:
  - 11/600 uppercase — labels, badges (letter-spacing 0.4–1.6)
  - 12.5–13/400–600 — captions, metadata
  - 14–15/400–600 — body, list rows
  - 16–17/600 — button labels, list emphasis (letter-spacing -0.3)
  - 22/700 — section titles inside cards (letter-spacing -0.5)
  - 26/700 — screen titles in body (letter-spacing -0.6)
  - 32/700 — large hero title (letter-spacing -0.8)

### Radii
- Inputs / list rows: **14px**
- Cards / sheets: **16px**
- Hero / preview frames: **20–24px**
- Pills / circular handles: **9999px** (fully round)

### Shadows
- Card resting: `0 1px 2px rgba(0,0,0,0.04), 0 8px 24px rgba(0,0,0,0.06)`
- Primary button: `0 1px 2px rgba(0,0,0,0.06), 0 8px 22px rgba(216,106,54,0.28)`
- Hero card: `0 2px 6px rgba(0,0,0,0.06), 0 16px 32px rgba(216,106,54,0.32)`
- Floating top bar buttons: `0 2px 8px rgba(0,0,0,0.08)` with `backdropFilter: blur(20px)` and 90%-white bg

---

## Assets
- **Receipt imagery** in the prototype is rendered procedurally (CSS + monospace text + SVG turbulence noise). Replace with actual image rendering in production.
- **Icons** are all hand-drawn inline SVGs in `screens.jsx` (`Icon.library`, `Icon.camera`, `Icon.sparkle`, `Icon.warn`, `Icon.check`, `Icon.copy`, `Icon.save`, `Icon.close`, `Icon.chevR`, `Icon.info`, `Icon.share`). On iOS, replace with **SF Symbols** equivalents:
  - `library` → `photo.on.rectangle.angled`
  - `camera` → `camera`
  - `sparkle` → `sparkles`
  - `warn` → `exclamationmark.triangle.fill`
  - `check` → `checkmark`
  - `copy` → `doc.on.doc`
  - `save` → `square.and.arrow.down`
  - `close` → `xmark`
  - `chevR` → `chevron.right`
  - `info` → `info.circle`
  - `share` → `square.and.arrow.up`
- **No bitmap assets** in this design.

## Localization
All UI copy is in **Indonesian**. Externalize strings as soon as you start; an `id.lproj/Localizable.strings` is the iOS-idiomatic location. Key strings:

| Key | Value |
|---|---|
| `home.title` | "Pulihkan struk yang pudar." |
| `home.subtitle` | "Pilih foto struk dari galeri. AI akan menajamkan tulisan dan membaca isinya." |
| `home.cta.primary` | "Pilih dari Galeri" |
| `home.cta.secondary` | "Ambil Foto Baru" |
| `home.recent` | "Riwayat" |
| `picked.title` | "Pratinjau" |
| `picked.restore` | "Restorasi Struk" |
| `picked.warn.title` | "Kualitas gambar rendah" |
| `picked.warn.body` | "Foto buram dan tinta pudar. Restorasi tetap dapat dilakukan, tetapi sebagian teks mungkin tidak terbaca." |
| `results.title` | "Geser untuk bandingkan" |
| `results.subtitle` | "Tarik garis untuk melihat hasil restorasi." |
| `results.before` / `results.after` | "Sebelum" / "Sesudah" |
| `ocr.title` | "Data Struk" |
| `ocr.confidence` | "Akurasi {percent}%" |

---

## Files in this bundle

| File | Purpose |
|---|---|
| `Struk Receipt App.html` | Entry point — loads scripts, mounts `<App />` |
| `app.jsx` | DesignCanvas layout + `FlowDevice` (interactive screen-stepper) |
| `screens.jsx` | `HomeScreen`, `PickedScreen`, `ProcessingScreen`, tokens, icons, button primitives |
| `screens2.jsx` | `BeforeAfter` slider, `ResultsScreen`, `OCRScreen`, `EmptyScreen` |
| `receipt.jsx` | Procedural faux receipt component (degraded / restored variants) |
| `ios-frame.jsx` | Device frame primitives (status bar, glass pill, nav bar) |
| `design-canvas.jsx` | Pan/zoom canvas for presenting screens side-by-side (not needed in production) |

Open `Struk Receipt App.html` in a browser to see the live prototype before re-implementing.
