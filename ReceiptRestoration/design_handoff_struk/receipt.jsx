// receipt.jsx — Faux Indonesian convenience-store receipt
// Renders the same content at two fidelities so the before/after slider
// actually communicates restoration value. Content is canonical structured
// data; only the *rendering* is degraded vs restored.

const RECEIPT_LINES = [
  { kind: 'title', text: 'INDOMARET' },
  { kind: 'sub',   text: 'JL. SUDIRMAN NO. 45' },
  { kind: 'sub',   text: 'JAKARTA PUSAT  10210' },
  { kind: 'sub',   text: '021-555-0188' },
  { kind: 'rule' },
  { kind: 'meta',  l: 'NO STRUK', r: '20260518/0123' },
  { kind: 'meta',  l: 'KASIR',    r: 'ANDI' },
  { kind: 'meta',  l: 'TGL',      r: '18-05-26 14:32' },
  { kind: 'rule' },
  { kind: 'item',  l: 'INDOMIE GORENG x3', r: '10.500' },
  { kind: 'item',  l: 'AQUA 600ML x2',     r: '8.000'  },
  { kind: 'item',  l: 'SUSU UHT 1L',       r: '18.500' },
  { kind: 'item',  l: 'ROTI TAWAR',        r: '15.000' },
  { kind: 'item',  l: 'TELUR AYAM 1KG',    r: '28.000' },
  { kind: 'item',  l: 'KOPI KAPAL API',    r: '12.500' },
  { kind: 'rule' },
  { kind: 'meta',  l: 'SUBTOTAL', r: '92.500' },
  { kind: 'meta',  l: 'PPN 11%',  r: '10.175' },
  { kind: 'total', l: 'TOTAL',    r: '102.675' },
  { kind: 'rule' },
  { kind: 'meta',  l: 'TUNAI',    r: '105.000' },
  { kind: 'meta',  l: 'KEMBALI',  r:   '2.325' },
  { kind: 'rule' },
  { kind: 'foot',  text: 'TERIMA KASIH' },
  { kind: 'foot',  text: 'SELAMAT BELANJA KEMBALI' },
];

// A line of the receipt, rendered at one of two fidelities.
function ReceiptLine({ line, restored }) {
  const c = restored ? '#111' : 'rgba(40,28,12,0.78)';
  const mono = '"SF Mono", ui-monospace, Menlo, Consolas, monospace';
  const base = {
    fontFamily: mono,
    fontSize: 9,
    lineHeight: '13px',
    color: c,
    letterSpacing: 0.2,
    whiteSpace: 'nowrap',
  };
  if (line.kind === 'title') return (
    <div style={{ ...base, fontSize: 13, fontWeight: 700, textAlign: 'center', letterSpacing: 1.5, marginTop: 2 }}>
      {line.text}
    </div>
  );
  if (line.kind === 'sub') return (
    <div style={{ ...base, textAlign: 'center', opacity: 0.85 }}>{line.text}</div>
  );
  if (line.kind === 'rule') return (
    <div style={{
      borderTop: `1px dashed ${restored ? 'rgba(0,0,0,0.5)' : 'rgba(40,28,12,0.4)'}`,
      margin: '4px 0',
    }} />
  );
  if (line.kind === 'meta') return (
    <div style={{ ...base, display: 'flex', justifyContent: 'space-between' }}>
      <span>{line.l}</span><span>{line.r}</span>
    </div>
  );
  if (line.kind === 'item') return (
    <div style={{ ...base, display: 'flex', justifyContent: 'space-between' }}>
      <span style={{ overflow: 'hidden', textOverflow: 'ellipsis' }}>{line.l}</span>
      <span>{line.r}</span>
    </div>
  );
  if (line.kind === 'total') return (
    <div style={{ ...base, display: 'flex', justifyContent: 'space-between', fontWeight: 700, fontSize: 11 }}>
      <span>{line.l}</span><span>Rp {line.r}</span>
    </div>
  );
  if (line.kind === 'foot') return (
    <div style={{ ...base, textAlign: 'center', marginTop: 2 }}>{line.text}</div>
  );
  return null;
}

// One physical receipt — fully styled paper card.
//   variant: 'degraded' | 'restored'
//   tilt:    degrees of subtle rotation (degraded only)
function Receipt({ variant = 'restored', tilt = 0, style = {} }) {
  const restored = variant === 'restored';
  const paperBg = restored
    ? '#ffffff'
    : 'linear-gradient(170deg, #f0e3c2 0%, #e8d6a0 45%, #d9c184 100%)';
  const paperShadow = restored
    ? '0 1px 2px rgba(0,0,0,0.06), 0 8px 24px rgba(0,0,0,0.08)'
    : '0 1px 2px rgba(0,0,0,0.18), 0 14px 28px rgba(80,50,10,0.25)';

  return (
    <div style={{
      position: 'relative',
      width: 200,
      transform: `rotate(${tilt}deg)`,
      filter: restored ? 'none' : 'blur(0.5px) contrast(0.78) saturate(0.85)',
      ...style,
    }}>
      <div style={{
        position: 'relative',
        background: paperBg,
        boxShadow: paperShadow,
        padding: '14px 14px 18px',
        // jagged thermal-receipt top/bottom edges
        clipPath: 'polygon(0 4px, 4px 0, 12px 4px, 20px 0, 28px 4px, 36px 0, 44px 4px, 52px 0, 60px 4px, 68px 0, 76px 4px, 84px 0, 92px 4px, 100px 0, 108px 4px, 116px 0, 124px 4px, 132px 0, 140px 4px, 148px 0, 156px 4px, 164px 0, 172px 4px, 180px 0, 188px 4px, 196px 0, 200px 4px, 200px calc(100% - 4px), 196px 100%, 188px calc(100% - 4px), 180px 100%, 172px calc(100% - 4px), 164px 100%, 156px calc(100% - 4px), 148px 100%, 140px calc(100% - 4px), 132px 100%, 124px calc(100% - 4px), 116px 100%, 108px calc(100% - 4px), 100px 100%, 92px calc(100% - 4px), 84px 100%, 76px calc(100% - 4px), 68px 100%, 60px calc(100% - 4px), 52px 100%, 44px calc(100% - 4px), 36px 100%, 28px calc(100% - 4px), 20px 100%, 12px calc(100% - 4px), 4px 100%, 0 calc(100% - 4px))',
      }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
          {RECEIPT_LINES.map((line, i) => <ReceiptLine key={i} line={line} restored={restored} />)}
        </div>
        {/* degraded-only artifacts */}
        {!restored && (
          <>
            {/* coffee stain */}
            <div style={{
              position: 'absolute', top: 78, left: -8,
              width: 56, height: 56, borderRadius: '50%',
              background: 'radial-gradient(circle, rgba(120,70,20,0.35) 0%, rgba(120,70,20,0.18) 50%, transparent 75%)',
              pointerEvents: 'none',
            }} />
            {/* crease */}
            <div style={{
              position: 'absolute', top: 0, bottom: 0, left: '38%',
              width: 1, background: 'linear-gradient(180deg, transparent, rgba(60,30,0,0.25) 30%, rgba(60,30,0,0.25) 70%, transparent)',
              pointerEvents: 'none',
            }} />
            {/* noise grain */}
            <svg style={{ position: 'absolute', inset: 0, opacity: 0.18, mixBlendMode: 'multiply', pointerEvents: 'none' }}>
              <filter id="grain"><feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" /></filter>
              <rect width="100%" height="100%" filter="url(#grain)" />
            </svg>
            {/* faded patch */}
            <div style={{
              position: 'absolute', top: '55%', right: -4, width: 70, height: 40,
              background: 'radial-gradient(ellipse, rgba(255,240,200,0.7), transparent 70%)',
              pointerEvents: 'none',
            }} />
          </>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { Receipt, RECEIPT_LINES });
