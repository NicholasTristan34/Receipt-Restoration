// screens.jsx — All Struk app screens.
// Each export is a full-bleed component that fills an <IOSDevice> frame.

const TOKENS = {
  bg:        '#F2F2F7',
  card:      '#FFFFFF',
  accent:    '#D86A36',
  accentDim: 'rgba(216,106,54,0.10)',
  text:      '#000000',
  text2:     'rgba(60,60,67,0.78)',
  text3:     'rgba(60,60,67,0.6)',
  text4:     'rgba(60,60,67,0.3)',
  sep:       'rgba(60,60,67,0.12)',
  warnBg:    '#FFF4D0',
  warnBd:    '#F3D783',
  warnFg:    '#7C5300',
  warnIcon:  '#C28A18',
};
const FONT = '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif';

// ─────────────────────────────────────────────────────────────
// Tiny SVG icon set — drawn here once, used everywhere
// ─────────────────────────────────────────────────────────────
const Icon = {
  library: (c='#fff', s=24) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <rect x="3" y="6" width="14" height="11" rx="2" stroke={c} strokeWidth="1.7"/>
      <rect x="7" y="3" width="14" height="11" rx="2" stroke={c} strokeWidth="1.7" fill="none"/>
      <circle cx="11" cy="7.5" r="1.3" fill={c}/>
      <path d="M9 11.5l2 2 3-3 4 4" stroke={c} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  camera: (c='#000', s=22) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M3 8a2 2 0 012-2h2l1.5-2h7L17 6h2a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V8z" stroke={c} strokeWidth="1.6"/>
      <circle cx="12" cy="13" r="3.5" stroke={c} strokeWidth="1.6"/>
    </svg>
  ),
  sparkle: (c='#fff', s=20) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M12 3l1.8 4.7L18.5 9.5l-4.7 1.8L12 16l-1.8-4.7L5.5 9.5l4.7-1.8L12 3z" fill={c}/>
      <path d="M19 14l.8 2 2 .8-2 .8-.8 2-.8-2-2-.8 2-.8L19 14z" fill={c} opacity="0.7"/>
    </svg>
  ),
  warn: (c='#C28A18', s=20) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M12 3l10 18H2L12 3z" fill={c}/>
      <rect x="11.25" y="9" width="1.5" height="6" rx="0.75" fill="#fff"/>
      <circle cx="12" cy="17.5" r="1" fill="#fff"/>
    </svg>
  ),
  check: (c='#fff', s=16) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M5 12.5l4.5 4.5L19 7" stroke={c} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  copy: (c=TOKENS.text3, s=18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <rect x="8" y="8" width="12" height="13" rx="2.5" stroke={c} strokeWidth="1.6"/>
      <path d="M16 8V5a2 2 0 00-2-2H6a2 2 0 00-2 2v11a2 2 0 002 2h2" stroke={c} strokeWidth="1.6"/>
    </svg>
  ),
  save: (c='#fff', s=18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M12 4v12m0 0l-4-4m4 4l4-4M5 19h14" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  close: (c=TOKENS.text2, s=16) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M6 6l12 12M18 6L6 18" stroke={c} strokeWidth="2.2" strokeLinecap="round"/>
    </svg>
  ),
  chevR: (c=TOKENS.text4, s=12) => (
    <svg width={s/1.5} height={s} viewBox="0 0 8 14"><path d="M1 1l6 6-6 6" stroke={c} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
  ),
  info: (c=TOKENS.accent, s=22) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="12" r="9.5" stroke={c} strokeWidth="1.6"/>
      <circle cx="12" cy="8" r="1.2" fill={c}/>
      <rect x="11.1" y="11" width="1.8" height="7" rx="0.9" fill={c}/>
    </svg>
  ),
  share: (c='#fff', s=18) => (
    <svg width={s} height={s} viewBox="0 0 24 24" fill="none">
      <path d="M12 3v12m0-12l-4 4m4-4l4 4M5 13v5a2 2 0 002 2h10a2 2 0 002-2v-5" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
};

const t = (s) => s; // copy passthrough (could swap to i18n via tweaks)

// ═════════════════════════════════════════════════════════════
// Shared bits
// ═════════════════════════════════════════════════════════════
function StatusAndIsland({ dark = false }) {
  return (
    <>
      <div style={{ position: 'absolute', top: 11, left: '50%', transform: 'translateX(-50%)',
                    width: 126, height: 37, borderRadius: 24, background: '#000', zIndex: 50 }} />
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 10 }}>
        <IOSStatusBar dark={dark} />
      </div>
    </>
  );
}

function HomeIndicator({ dark = false }) {
  return (
    <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 60,
                  height: 34, display: 'flex', justifyContent: 'center', alignItems: 'flex-end',
                  paddingBottom: 8, pointerEvents: 'none' }}>
      <div style={{ width: 139, height: 5, borderRadius: 100,
                    background: dark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.25)' }} />
    </div>
  );
}

function PrimaryButton({ children, icon, accent = TOKENS.accent, onClick, style={} }) {
  return (
    <button onClick={onClick} style={{
      appearance: 'none', border: 'none', cursor: 'pointer',
      width: '100%', height: 54, borderRadius: 16,
      background: accent, color: '#fff',
      fontFamily: FONT, fontSize: 17, fontWeight: 600, letterSpacing: -0.4,
      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      boxShadow: '0 1px 2px rgba(0,0,0,0.06), 0 8px 22px rgba(216,106,54,0.28)',
      ...style,
    }}>
      {icon}
      <span>{children}</span>
    </button>
  );
}

function GhostButton({ children, icon, onClick, style={} }) {
  return (
    <button onClick={onClick} style={{
      appearance: 'none', border: 'none', background: 'transparent', cursor: 'pointer',
      width: '100%', height: 48, borderRadius: 14,
      color: TOKENS.text, fontFamily: FONT, fontSize: 16, fontWeight: 500, letterSpacing: -0.32,
      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      ...style,
    }}>
      {icon}
      <span>{children}</span>
    </button>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 1 — Home / Library picker
// ═════════════════════════════════════════════════════════════
function HomeScreen({ onPick }) {
  const recents = [
    { store: 'Alfamart',     date: '17 Mei',  total: '48.200',  tilt: -2 },
    { store: 'Indomaret',    date: '15 Mei',  total: '102.675', tilt:  1 },
    { store: 'Hypermart',    date: '12 Mei',  total: '256.000', tilt: -1 },
    { store: 'Warung Pak Y', date: '11 Mei',  total: '32.500',  tilt:  2 },
  ];
  return (
    <div style={{ position: 'relative', height: '100%', background: TOKENS.bg, overflow: 'hidden' }}>
      <StatusAndIsland />

      {/* Header */}
      <div style={{ padding: '62px 20px 0' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', height: 36 }}>
          <div style={{ fontFamily: FONT, fontSize: 13, fontWeight: 600, letterSpacing: 1.6, color: TOKENS.accent, textTransform: 'uppercase' }}>
            Struk
          </div>
          <div style={{ width: 32, height: 32, borderRadius: 16, background: TOKENS.accentDim,
                        display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {Icon.info(TOKENS.accent, 18)}
          </div>
        </div>
        <div style={{ fontFamily: FONT, fontSize: 32, fontWeight: 700, letterSpacing: -0.8, color: TOKENS.text, marginTop: 14, lineHeight: '38px' }}>
          Pulihkan struk<br/>yang pudar.
        </div>
        <div style={{ fontFamily: FONT, fontSize: 15, fontWeight: 400, color: TOKENS.text3, marginTop: 8, lineHeight: '20px', letterSpacing: -0.2 }}>
          Pilih foto struk dari galeri. AI akan menajamkan tulisan dan membaca isinya.
        </div>
      </div>

      {/* Hero CTA card */}
      <div style={{ padding: '24px 20px 0' }}>
        <button onClick={onPick} style={{
          appearance: 'none', border: 'none', cursor: 'pointer', textAlign: 'left',
          width: '100%', padding: 20, borderRadius: 24,
          background: `linear-gradient(135deg, ${TOKENS.accent} 0%, #C25420 100%)`,
          color: '#fff', boxShadow: '0 2px 6px rgba(0,0,0,0.06), 0 16px 32px rgba(216,106,54,0.32)',
          display: 'flex', flexDirection: 'column', gap: 22,
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <div style={{ width: 44, height: 44, borderRadius: 12, background: 'rgba(255,255,255,0.18)',
                          display: 'flex', alignItems: 'center', justifyContent: 'center',
                          backdropFilter: 'blur(8px)' }}>
              {Icon.library('#fff', 24)}
            </div>
            <div style={{
              padding: '4px 10px', borderRadius: 8, background: 'rgba(255,255,255,0.18)',
              fontFamily: FONT, fontSize: 11, fontWeight: 600, letterSpacing: 0.4,
              color: '#fff', textTransform: 'uppercase',
            }}>NAFNet · v2</div>
          </div>
          <div>
            <div style={{ fontFamily: FONT, fontSize: 22, fontWeight: 700, letterSpacing: -0.5 }}>
              Pilih dari Galeri
            </div>
            <div style={{ fontFamily: FONT, fontSize: 14, fontWeight: 400, opacity: 0.85, marginTop: 4, letterSpacing: -0.2 }}>
              Hasil terbaik untuk foto yang sudah ada
            </div>
          </div>
        </button>

        {/* Secondary: camera (de-emphasized) */}
        <button style={{
          appearance: 'none', cursor: 'pointer',
          marginTop: 12, width: '100%', padding: '14px 16px', borderRadius: 16,
          background: TOKENS.card, border: `1px solid ${TOKENS.sep}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: TOKENS.bg,
                        display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {Icon.camera(TOKENS.text, 20)}
          </div>
          <div style={{ flex: 1, textAlign: 'left' }}>
            <div style={{ fontFamily: FONT, fontSize: 15, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.3 }}>
              Ambil Foto Baru
            </div>
            <div style={{ fontFamily: FONT, fontSize: 12, color: TOKENS.text3, marginTop: 1 }}>
              Buka kamera
            </div>
          </div>
          {Icon.chevR()}
        </button>
      </div>

      {/* Recent grid */}
      <div style={{ padding: '24px 20px 0' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
          <div style={{ fontFamily: FONT, fontSize: 13, fontWeight: 600, color: TOKENS.text3, textTransform: 'uppercase', letterSpacing: 0.4 }}>
            Riwayat
          </div>
          <div style={{ fontFamily: FONT, fontSize: 14, fontWeight: 500, color: TOKENS.accent }}>
            Lihat semua
          </div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {recents.map((r, i) => (
            <div key={i} style={{
              background: TOKENS.card, borderRadius: 16, padding: 12,
              border: `1px solid ${TOKENS.sep}`,
              display: 'flex', flexDirection: 'column', gap: 10,
            }}>
              {/* mini receipt preview */}
              <div style={{ height: 78, background: TOKENS.bg, borderRadius: 10,
                            display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' }}>
                <div style={{
                  width: 50, height: 64, background: '#fff', borderRadius: 2,
                  boxShadow: '0 2px 6px rgba(0,0,0,0.08)',
                  transform: `rotate(${r.tilt}deg)`,
                  padding: '6px 4px', display: 'flex', flexDirection: 'column', gap: 1.5,
                }}>
                  {Array.from({ length: 9 }).map((_, j) => (
                    <div key={j} style={{
                      height: 1.2, background: 'rgba(0,0,0,0.35)',
                      width: j === 0 ? '70%' : j === 8 ? '50%' : (60 + (j*13)%35) + '%',
                    }} />
                  ))}
                </div>
              </div>
              <div>
                <div style={{ fontFamily: FONT, fontSize: 13, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.2 }}>
                  {r.store}
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 2 }}>
                  <span style={{ fontFamily: FONT, fontSize: 11, color: TOKENS.text3 }}>{r.date}</span>
                  <span style={{ fontFamily: FONT, fontSize: 11, fontWeight: 600, color: TOKENS.text2 }}>Rp {r.total}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <HomeIndicator />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 2 — Image picked + quality warning
// ═════════════════════════════════════════════════════════════
function PickedScreen({ onRestore, onCancel, showWarning = true }) {
  return (
    <div style={{ position: 'relative', height: '100%', background: TOKENS.bg, overflow: 'hidden' }}>
      <StatusAndIsland />

      {/* Top bar */}
      <div style={{ position: 'absolute', top: 56, left: 0, right: 0, padding: '0 16px', zIndex: 6,
                    display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <button onClick={onCancel} style={{
          appearance: 'none', border: 'none', cursor: 'pointer',
          width: 36, height: 36, borderRadius: 18, background: 'rgba(255,255,255,0.9)',
          backdropFilter: 'blur(20px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
        }}>{Icon.close(TOKENS.text, 16)}</button>
        <div style={{ fontFamily: FONT, fontSize: 15, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.3 }}>
          Pratinjau
        </div>
        <div style={{ width: 36 }} />
      </div>

      {/* Receipt preview area */}
      <div style={{ position: 'absolute', top: 110, left: 16, right: 16, bottom: 220,
                    background: TOKENS.card, borderRadius: 24,
                    border: `1px solid ${TOKENS.sep}`, overflow: 'hidden',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 14px, rgba(0,0,0,0.025) 14px, rgba(0,0,0,0.025) 15px)' }}>
        <Receipt variant="degraded" tilt={-3} />
      </div>

      {/* Quality warning banner */}
      {showWarning && (
        <div style={{ position: 'absolute', left: 16, right: 16, bottom: 200, zIndex: 5 }}>
          <div style={{
            background: TOKENS.warnBg,
            border: `1px solid ${TOKENS.warnBd}`,
            borderRadius: 14, padding: '12px 14px',
            display: 'flex', gap: 12, alignItems: 'flex-start',
            boxShadow: '0 8px 24px rgba(0,0,0,0.06)',
          }}>
            <div style={{ flexShrink: 0, marginTop: 1 }}>{Icon.warn(TOKENS.warnIcon, 20)}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: FONT, fontSize: 14, fontWeight: 600, color: TOKENS.warnFg, letterSpacing: -0.2 }}>
                Kualitas gambar rendah
              </div>
              <div style={{ fontFamily: FONT, fontSize: 12.5, color: TOKENS.warnFg, opacity: 0.8, marginTop: 2, lineHeight: '17px' }}>
                Foto buram dan tinta pudar. Restorasi tetap dapat dilakukan, tetapi sebagian teks mungkin tidak terbaca.
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Bottom action area */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '16px 20px 38px',
                    background: 'linear-gradient(180deg, rgba(242,242,247,0) 0%, rgba(242,242,247,1) 28%)' }}>
        <PrimaryButton icon={Icon.sparkle('#fff', 18)} onClick={onRestore}>
          Restorasi Struk
        </PrimaryButton>
        <GhostButton onClick={onCancel} style={{ marginTop: 4 }}>
          Pilih foto lain
        </GhostButton>
      </div>

      <HomeIndicator />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 3 — Processing
// ═════════════════════════════════════════════════════════════
function ProcessingScreen({ progress = 62, stage = 'Memulihkan teks' }) {
  return (
    <div style={{ position: 'relative', height: '100%', background: TOKENS.bg, overflow: 'hidden' }}>
      <StatusAndIsland />

      {/* dimmed receipt */}
      <div style={{ position: 'absolute', top: 110, left: 16, right: 16, bottom: 250,
                    background: TOKENS.card, borderRadius: 24,
                    border: `1px solid ${TOKENS.sep}`, overflow: 'hidden',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 14px, rgba(0,0,0,0.025) 14px, rgba(0,0,0,0.025) 15px)' }}>
        <div style={{ position: 'relative' }}>
          <Receipt variant="degraded" tilt={-3} />
          {/* scanning line */}
          <div style={{
            position: 'absolute', left: -8, right: -8, top: '45%',
            height: 2, background: TOKENS.accent,
            boxShadow: `0 0 24px ${TOKENS.accent}, 0 0 8px ${TOKENS.accent}`,
            borderRadius: 1, opacity: 0.9,
          }} />
          <div style={{
            position: 'absolute', left: -8, right: -8, top: 0, bottom: '55%',
            background: `linear-gradient(180deg, transparent 0%, ${TOKENS.accent}15 100%)`,
            pointerEvents: 'none',
          }} />
        </div>
      </div>

      {/* progress card */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '24px 20px 38px',
                    background: 'linear-gradient(180deg, rgba(242,242,247,0) 0%, rgba(242,242,247,1) 22%)' }}>
        <div style={{ background: TOKENS.card, borderRadius: 22, padding: 20,
                      boxShadow: '0 1px 2px rgba(0,0,0,0.04), 0 16px 40px rgba(0,0,0,0.08)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{ position: 'relative', width: 44, height: 44 }}>
              <svg width="44" height="44" viewBox="0 0 44 44">
                <circle cx="22" cy="22" r="18" stroke={TOKENS.accentDim} strokeWidth="3" fill="none"/>
                <circle cx="22" cy="22" r="18" stroke={TOKENS.accent} strokeWidth="3" fill="none"
                        strokeDasharray={`${(progress/100)*113} 113`} strokeLinecap="round"
                        transform="rotate(-90 22 22)"/>
              </svg>
              <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
                            fontFamily: FONT, fontSize: 11, fontWeight: 700, color: TOKENS.accent }}>
                {progress}%
              </div>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: FONT, fontSize: 16, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.3 }}>
                {stage}…
              </div>
              <div style={{ fontFamily: FONT, fontSize: 12.5, color: TOKENS.text3, marginTop: 2 }}>
                Model NAFNet · 4 langkah tersisa
              </div>
            </div>
          </div>

          {/* pipeline steps */}
          <div style={{ marginTop: 18, display: 'flex', flexDirection: 'column', gap: 10 }}>
            {[
              { label: 'Pra-pemrosesan',  state: 'done' },
              { label: 'Deteksi noise',   state: 'done' },
              { label: 'Restorasi NAFNet', state: 'active' },
              { label: 'Penajaman teks',   state: 'pending' },
              { label: 'Ekstraksi OCR',    state: 'pending' },
            ].map((s, i) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <div style={{
                  width: 18, height: 18, borderRadius: 9,
                  background: s.state === 'done' ? TOKENS.accent : s.state === 'active' ? TOKENS.accentDim : TOKENS.bg,
                  border: s.state === 'pending' ? `1px solid ${TOKENS.sep}` : 'none',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  {s.state === 'done' && Icon.check('#fff', 12)}
                  {s.state === 'active' && <div style={{
                    width: 7, height: 7, borderRadius: 4, background: TOKENS.accent,
                    animation: 'sk-pulse 1s ease-in-out infinite',
                  }}/>}
                </div>
                <div style={{ fontFamily: FONT, fontSize: 14,
                              fontWeight: s.state === 'active' ? 600 : 400,
                              color: s.state === 'pending' ? TOKENS.text3 : TOKENS.text,
                              letterSpacing: -0.2 }}>
                  {s.label}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <HomeIndicator />
      <style>{`@keyframes sk-pulse {0%,100% { transform: scale(1); opacity:1 } 50% { transform: scale(1.4); opacity: .5 }}`}</style>
    </div>
  );
}

Object.assign(window, { HomeScreen, PickedScreen, ProcessingScreen, TOKENS, FONT, Icon, PrimaryButton, GhostButton, StatusAndIsland, HomeIndicator });
