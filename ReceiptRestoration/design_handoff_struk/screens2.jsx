// screens2.jsx — Results + OCR + Empty state

// ═════════════════════════════════════════════════════════════
// Before/After draggable slider — interactive core element
// ═════════════════════════════════════════════════════════════
function BeforeAfter({ width = 320, height = 380 }) {
  const [pos, setPos] = React.useState(50); // percent
  const ref = React.useRef(null);

  const onMove = React.useCallback((clientX) => {
    const r = ref.current?.getBoundingClientRect();
    if (!r) return;
    const p = Math.max(0, Math.min(100, ((clientX - r.left) / r.width) * 100));
    setPos(p);
  }, []);

  const onDown = (e) => {
    e.preventDefault();
    const move = (ev) => onMove(ev.touches ? ev.touches[0].clientX : ev.clientX);
    const up = () => {
      window.removeEventListener('mousemove', move);
      window.removeEventListener('mouseup', up);
      window.removeEventListener('touchmove', move);
      window.removeEventListener('touchend', up);
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
    window.addEventListener('touchmove', move);
    window.addEventListener('touchend', up);
    move(e);
  };

  return (
    <div ref={ref} onMouseDown={onDown} onTouchStart={onDown}
         style={{
           position: 'relative', width, height, borderRadius: 20, overflow: 'hidden',
           background: '#111', cursor: 'ew-resize', userSelect: 'none', touchAction: 'none',
           backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 14px, rgba(255,255,255,0.04) 14px, rgba(255,255,255,0.04) 15px)',
         }}>
      {/* RESTORED (full underneath) */}
      <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <Receipt variant="restored" tilt={0} />
      </div>
      {/* DEGRADED (clipped on top by slider position) */}
      <div style={{ position: 'absolute', inset: 0, clipPath: `inset(0 ${100 - pos}% 0 0)`,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 14px, rgba(255,255,255,0.04) 14px, rgba(255,255,255,0.04) 15px)' }}>
        <Receipt variant="degraded" tilt={0} />
      </div>

      {/* labels */}
      <div style={{ position: 'absolute', top: 12, left: 12, padding: '4px 10px', borderRadius: 999,
                    background: 'rgba(0,0,0,0.55)', backdropFilter: 'blur(12px)',
                    fontFamily: FONT, fontSize: 11, fontWeight: 600, color: '#fff', letterSpacing: 0.4, textTransform: 'uppercase' }}>
        Sebelum
      </div>
      <div style={{ position: 'absolute', top: 12, right: 12, padding: '4px 10px', borderRadius: 999,
                    background: TOKENS.accent,
                    fontFamily: FONT, fontSize: 11, fontWeight: 600, color: '#fff', letterSpacing: 0.4, textTransform: 'uppercase' }}>
        Sesudah
      </div>

      {/* divider */}
      <div style={{ position: 'absolute', top: 0, bottom: 0, left: `${pos}%`,
                    width: 2, background: '#fff', transform: 'translateX(-1px)',
                    boxShadow: '0 0 16px rgba(0,0,0,0.5)' }}>
        <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
                      width: 38, height: 38, borderRadius: 19, background: '#fff',
                      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 2,
                      boxShadow: '0 4px 12px rgba(0,0,0,0.25), 0 0 0 4px rgba(255,255,255,0.18)' }}>
          <svg width="8" height="14" viewBox="0 0 8 14"><path d="M6 1L1 7l5 6" stroke={TOKENS.text} strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
          <svg width="8" height="14" viewBox="0 0 8 14"><path d="M2 1l5 6-5 6" stroke={TOKENS.text} strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
        </div>
      </div>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 4 — Results with before/after slider
// ═════════════════════════════════════════════════════════════
function ResultsScreen({ onViewData, onBack }) {
  return (
    <div style={{ position: 'relative', height: '100%', background: TOKENS.bg, overflow: 'hidden' }}>
      <StatusAndIsland />

      {/* Top bar */}
      <div style={{ position: 'absolute', top: 56, left: 0, right: 0, padding: '0 16px', zIndex: 6,
                    display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <button onClick={onBack} style={{
          appearance: 'none', border: 'none', cursor: 'pointer',
          width: 36, height: 36, borderRadius: 18, background: 'rgba(255,255,255,0.9)',
          backdropFilter: 'blur(20px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
        }}>{Icon.close(TOKENS.text, 16)}</button>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6,
                      padding: '6px 10px', borderRadius: 999, background: 'rgba(255,255,255,0.9)',
                      backdropFilter: 'blur(20px)', boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
          <div style={{ width: 6, height: 6, borderRadius: 3, background: '#34C759' }} />
          <div style={{ fontFamily: FONT, fontSize: 12, fontWeight: 600, color: TOKENS.text2, letterSpacing: -0.2 }}>
            Restorasi selesai · 2,3 dtk
          </div>
        </div>
        <div style={{ width: 36 }} />
      </div>

      {/* Body — scrollable */}
      <div style={{ position: 'absolute', top: 100, left: 0, right: 0, bottom: 110,
                    overflow: 'auto', padding: '0 16px' }}>

        <div style={{ fontFamily: FONT, fontSize: 26, fontWeight: 700, letterSpacing: -0.6, color: TOKENS.text,
                      marginTop: 4, marginBottom: 4 }}>
          Geser untuk bandingkan
        </div>
        <div style={{ fontFamily: FONT, fontSize: 14, color: TOKENS.text3, marginBottom: 14, letterSpacing: -0.2 }}>
          Tarik garis untuk melihat hasil restorasi.
        </div>

        <BeforeAfter width={'100%' /* parent gives w */} height={380} />

        {/* metrics row */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginTop: 16 }}>
          {[
            { l: 'Ketajaman', v: '+247%', tone: 'pos' },
            { l: 'Noise',     v: '−82%',  tone: 'pos' },
            { l: 'OCR',       v: '24/24', tone: 'neu' },
          ].map((m, i) => (
            <div key={i} style={{
              background: TOKENS.card, borderRadius: 14, padding: '10px 12px',
              border: `1px solid ${TOKENS.sep}`,
            }}>
              <div style={{ fontFamily: FONT, fontSize: 11, color: TOKENS.text3, textTransform: 'uppercase', letterSpacing: 0.4, fontWeight: 600 }}>
                {m.l}
              </div>
              <div style={{ fontFamily: FONT, fontSize: 17, fontWeight: 700, letterSpacing: -0.3,
                            color: m.tone === 'pos' ? '#1F8A3F' : TOKENS.text, marginTop: 2 }}>
                {m.v}
              </div>
            </div>
          ))}
        </div>

        {/* CTA: view extracted data */}
        <button onClick={onViewData} style={{
          appearance: 'none', border: 'none', cursor: 'pointer', textAlign: 'left',
          width: '100%', marginTop: 14, padding: '14px 16px', borderRadius: 16,
          background: TOKENS.card, border: `1px solid ${TOKENS.sep}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: TOKENS.accentDim,
                        display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <rect x="4" y="3" width="16" height="18" rx="2" stroke={TOKENS.accent} strokeWidth="1.7"/>
              <path d="M8 8h8M8 12h8M8 16h5" stroke={TOKENS.accent} strokeWidth="1.7" strokeLinecap="round"/>
            </svg>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: FONT, fontSize: 15, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.3 }}>
              Lihat data terbaca
            </div>
            <div style={{ fontFamily: FONT, fontSize: 12.5, color: TOKENS.text3, marginTop: 1 }}>
              6 item · Total Rp 102.675
            </div>
          </div>
          {Icon.chevR()}
        </button>
      </div>

      {/* Bottom action bar */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '12px 16px 38px',
                    background: 'linear-gradient(180deg, rgba(242,242,247,0) 0%, rgba(242,242,247,0.95) 30%)',
                    display: 'flex', gap: 10 }}>
        <button style={{
          appearance: 'none', border: `1px solid ${TOKENS.sep}`, cursor: 'pointer',
          flex: 1, height: 50, borderRadius: 14, background: TOKENS.card,
          color: TOKENS.text, fontFamily: FONT, fontSize: 15, fontWeight: 600, letterSpacing: -0.3,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          {Icon.copy(TOKENS.text, 17)}
          <span>Salin Teks</span>
        </button>
        <PrimaryButton icon={Icon.share('#fff', 17)} style={{ flex: 1 }}>
          Simpan
        </PrimaryButton>
      </div>

      <HomeIndicator />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 5 — OCR Structured fields
// ═════════════════════════════════════════════════════════════
function OCRScreen({ onBack }) {
  const items = [
    { name: 'Indomie Goreng',  qty: 3, price: '10.500' },
    { name: 'Aqua 600ml',      qty: 2, price:  '8.000' },
    { name: 'Susu UHT 1L',     qty: 1, price: '18.500' },
    { name: 'Roti Tawar',      qty: 1, price: '15.000' },
    { name: 'Telur Ayam 1kg',  qty: 1, price: '28.000' },
    { name: 'Kopi Kapal Api',  qty: 1, price: '12.500' },
  ];
  return (
    <div style={{ position: 'relative', height: '100%', background: TOKENS.bg, overflow: 'hidden' }}>
      <StatusAndIsland />

      {/* Top bar */}
      <div style={{ position: 'absolute', top: 56, left: 0, right: 0, padding: '0 16px', zIndex: 6,
                    display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <button onClick={onBack} style={{
          appearance: 'none', border: 'none', cursor: 'pointer',
          width: 36, height: 36, borderRadius: 18, background: 'rgba(255,255,255,0.9)',
          backdropFilter: 'blur(20px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
        }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none">
            <path d="M15 5l-7 7 7 7" stroke={TOKENS.text} strokeWidth="2.4" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>
        <div style={{ fontFamily: FONT, fontSize: 15, fontWeight: 600, color: TOKENS.text, letterSpacing: -0.3 }}>
          Data Struk
        </div>
        <div style={{ width: 36, height: 36, borderRadius: 18,
                      background: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(20px)',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
          {Icon.copy(TOKENS.text, 16)}
        </div>
      </div>

      {/* Body */}
      <div style={{ position: 'absolute', top: 100, left: 0, right: 0, bottom: 110,
                    overflow: 'auto', padding: '0 16px 16px' }}>

        {/* Tiny receipt thumb + title */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 18 }}>
          <div style={{ width: 56, height: 72, background: '#fff', borderRadius: 6,
                        boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
                        padding: '8px 6px', display: 'flex', flexDirection: 'column', gap: 2 }}>
            {Array.from({ length: 10 }).map((_, i) => (
              <div key={i} style={{ height: 1.2, background: 'rgba(0,0,0,0.5)',
                                    width: i === 0 ? '60%' : i === 9 ? '40%' : (55 + (i*17)%40) + '%' }}/>
            ))}
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: FONT, fontSize: 22, fontWeight: 700, letterSpacing: -0.5, color: TOKENS.text, lineHeight: '26px' }}>
              Indomaret
            </div>
            <div style={{ fontFamily: FONT, fontSize: 13, color: TOKENS.text3, marginTop: 2 }}>
              18 Mei 2026 · 14:32
            </div>
            <div style={{ marginTop: 6, display: 'inline-flex', alignItems: 'center', gap: 5,
                          padding: '3px 8px', borderRadius: 999,
                          background: 'rgba(31,138,63,0.10)' }}>
              <div style={{ width: 5, height: 5, borderRadius: 3, background: '#1F8A3F' }}/>
              <span style={{ fontFamily: FONT, fontSize: 11, fontWeight: 600, color: '#1F8A3F', letterSpacing: 0.2 }}>
                Akurasi 98%
              </span>
            </div>
          </div>
        </div>

        {/* Meta card */}
        <div style={{ background: TOKENS.card, borderRadius: 16, border: `1px solid ${TOKENS.sep}`, marginBottom: 14 }}>
          {[
            { l: 'Toko',     v: 'Indomaret · Sudirman' },
            { l: 'Alamat',   v: 'Jl. Sudirman No. 45, Jakarta Pusat' },
            { l: 'No. Struk', v: '20260518/0123' },
            { l: 'Kasir',    v: 'Andi' },
          ].map((r, i, arr) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '12px 14px', gap: 12,
              borderBottom: i === arr.length - 1 ? 'none' : `1px solid ${TOKENS.sep}`,
            }}>
              <span style={{ fontFamily: FONT, fontSize: 13, color: TOKENS.text3, letterSpacing: -0.1 }}>{r.l}</span>
              <span style={{ fontFamily: FONT, fontSize: 14, fontWeight: 500, color: TOKENS.text, letterSpacing: -0.2,
                             textAlign: 'right', flex: 1, marginLeft: 'auto', maxWidth: '70%' }}>{r.v}</span>
            </div>
          ))}
        </div>

        {/* Items section */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px', marginBottom: 8 }}>
          <div style={{ fontFamily: FONT, fontSize: 13, fontWeight: 600, color: TOKENS.text3, textTransform: 'uppercase', letterSpacing: 0.4 }}>
            Item · {items.length}
          </div>
          <div style={{ fontFamily: FONT, fontSize: 13, color: TOKENS.text3 }}>
            Rp 92.500
          </div>
        </div>

        <div style={{ background: TOKENS.card, borderRadius: 16, border: `1px solid ${TOKENS.sep}`, marginBottom: 14 }}>
          {items.map((it, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'center', padding: '11px 14px', gap: 12,
              borderBottom: i === items.length - 1 ? 'none' : `1px solid ${TOKENS.sep}`,
            }}>
              <div style={{ minWidth: 24, height: 24, borderRadius: 6,
                            background: TOKENS.bg, display: 'flex', alignItems: 'center', justifyContent: 'center',
                            fontFamily: FONT, fontSize: 12, fontWeight: 600, color: TOKENS.text2 }}>
                ×{it.qty}
              </div>
              <div style={{ flex: 1, fontFamily: FONT, fontSize: 15, color: TOKENS.text, letterSpacing: -0.2 }}>
                {it.name}
              </div>
              <div style={{ fontFamily: '"SF Mono", ui-monospace, monospace', fontSize: 14, fontWeight: 500, color: TOKENS.text }}>
                {it.price}
              </div>
            </div>
          ))}
        </div>

        {/* Totals card */}
        <div style={{ background: TOKENS.card, borderRadius: 16, border: `1px solid ${TOKENS.sep}`, padding: '4px 0' }}>
          {[
            { l: 'Subtotal',  v: '92.500', bold: false },
            { l: 'PPN 11%',   v: '10.175', bold: false },
            { l: 'Total',     v: '102.675', bold: true },
          ].map((r, i, arr) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '12px 14px',
              borderBottom: i === arr.length - 1 ? 'none' : `1px solid ${TOKENS.sep}`,
            }}>
              <span style={{ fontFamily: FONT, fontSize: r.bold ? 16 : 14, fontWeight: r.bold ? 700 : 400,
                             color: r.bold ? TOKENS.text : TOKENS.text2, letterSpacing: -0.2 }}>{r.l}</span>
              <span style={{ fontFamily: '"SF Mono", ui-monospace, monospace',
                             fontSize: r.bold ? 18 : 14, fontWeight: r.bold ? 700 : 500,
                             color: r.bold ? TOKENS.accent : TOKENS.text }}>
                Rp {r.v}
              </span>
            </div>
          ))}
        </div>

        {/* Payment */}
        <div style={{ background: TOKENS.card, borderRadius: 16, border: `1px solid ${TOKENS.sep}`, padding: '4px 0', marginTop: 14 }}>
          {[
            { l: 'Tunai',   v: '105.000' },
            { l: 'Kembali', v:   '2.325' },
          ].map((r, i, arr) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '11px 14px',
              borderBottom: i === arr.length - 1 ? 'none' : `1px solid ${TOKENS.sep}`,
            }}>
              <span style={{ fontFamily: FONT, fontSize: 14, color: TOKENS.text2, letterSpacing: -0.2 }}>{r.l}</span>
              <span style={{ fontFamily: '"SF Mono", ui-monospace, monospace', fontSize: 14, fontWeight: 500, color: TOKENS.text }}>
                Rp {r.v}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Bottom action bar */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '12px 16px 38px',
                    background: 'linear-gradient(180deg, rgba(242,242,247,0) 0%, rgba(242,242,247,0.95) 30%)',
                    display: 'flex', gap: 10 }}>
        <button style={{
          appearance: 'none', border: `1px solid ${TOKENS.sep}`, cursor: 'pointer',
          flex: 1, height: 50, borderRadius: 14, background: TOKENS.card,
          color: TOKENS.text, fontFamily: FONT, fontSize: 15, fontWeight: 600, letterSpacing: -0.3,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          {Icon.copy(TOKENS.text, 17)}
          <span>Salin Semua</span>
        </button>
        <PrimaryButton icon={Icon.save('#fff', 17)} style={{ flex: 1 }}>
          Ekspor
        </PrimaryButton>
      </div>

      <HomeIndicator />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// SCREEN 6 — Empty state (first-launch)
// ═════════════════════════════════════════════════════════════
function EmptyScreen({ onPick }) {
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
      </div>

      {/* Centered empty illustration */}
      <div style={{ position: 'absolute', top: 130, left: 0, right: 0, bottom: 200,
                    display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px' }}>
        <div style={{ position: 'relative', width: 220, height: 220, marginBottom: 18 }}>
          {/* fanned-out receipt stack */}
          {[
            { tilt: -14, x: -40, y:  10, v: 'degraded' },
            { tilt:   3, x:   0, y:   0, v: 'degraded' },
            { tilt:  16, x:  40, y:  10, v: 'restored' },
          ].map((r, i) => (
            <div key={i} style={{
              position: 'absolute', top: 0, left: '50%',
              transform: `translateX(calc(-50% + ${r.x}px)) translateY(${r.y}px) rotate(${r.tilt}deg) scale(0.85)`,
            }}>
              <Receipt variant={r.v} tilt={0} />
            </div>
          ))}
          {/* sparkle */}
          <div style={{ position: 'absolute', top: -6, right: 18,
                        width: 38, height: 38, borderRadius: 19, background: TOKENS.accent,
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                        boxShadow: `0 6px 20px ${TOKENS.accent}66` }}>
            {Icon.sparkle('#fff', 20)}
          </div>
        </div>
        <div style={{ fontFamily: FONT, fontSize: 24, fontWeight: 700, letterSpacing: -0.5, color: TOKENS.text, textAlign: 'center', marginTop: 8 }}>
          Belum ada struk
        </div>
        <div style={{ fontFamily: FONT, fontSize: 15, color: TOKENS.text3, textAlign: 'center', marginTop: 6, lineHeight: '20px', letterSpacing: -0.2 }}>
          Pilih foto struk yang pudar atau<br/>buram dan biarkan AI memperjelasnya.
        </div>
      </div>

      {/* Bottom CTAs */}
      <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '16px 20px 38px' }}>
        <PrimaryButton icon={Icon.library('#fff', 20)} onClick={onPick}>
          Pilih dari Galeri
        </PrimaryButton>
        <GhostButton icon={Icon.camera(TOKENS.text, 18)} style={{ marginTop: 4 }}>
          Ambil Foto
        </GhostButton>
      </div>

      <HomeIndicator />
    </div>
  );
}

Object.assign(window, { BeforeAfter, ResultsScreen, OCRScreen, EmptyScreen });
