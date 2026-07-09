// app.jsx — Struk app: design canvas showing all key screens + interactive flow.

// Wrap a screen in a non-scrolling iPhone frame, sized so the artboard equals the device.
function Frame({ children, dark = false }) {
  return (
    <div style={{
      width: 360, height: 780, borderRadius: 44, overflow: 'hidden',
      position: 'relative', background: dark ? '#000' : TOKENS.bg,
      boxShadow: '0 40px 80px rgba(0,0,0,0.16), 0 0 0 1px rgba(0,0,0,0.10)',
      fontFamily: FONT, WebkitFontSmoothing: 'antialiased',
    }}>
      {children}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Interactive flow — wires screens together in a single device
// ─────────────────────────────────────────────────────────────
function FlowDevice() {
  const [step, setStep] = React.useState('home'); // home | picked | processing | results | ocr
  const [progress, setProgress] = React.useState(0);
  const [stage, setStage] = React.useState('Pra-pemrosesan');

  React.useEffect(() => {
    if (step !== 'processing') return;
    setProgress(0);
    setStage('Pra-pemrosesan');
    const stages = [
      { at: 15, name: 'Deteksi noise' },
      { at: 35, name: 'Restorasi NAFNet' },
      { at: 75, name: 'Penajaman teks' },
      { at: 92, name: 'Ekstraksi OCR' },
    ];
    let p = 0;
    const id = setInterval(() => {
      p += 2;
      setProgress(p);
      const cur = stages.filter(s => p >= s.at).pop();
      if (cur) setStage(cur.name);
      if (p >= 100) { clearInterval(id); setTimeout(() => setStep('results'), 320); }
    }, 60);
    return () => clearInterval(id);
  }, [step]);

  return (
    <Frame>
      {step === 'home' && <HomeScreen onPick={() => setStep('picked')} />}
      {step === 'picked' && <PickedScreen onRestore={() => setStep('processing')} onCancel={() => setStep('home')} />}
      {step === 'processing' && <ProcessingScreen progress={progress} stage={stage} />}
      {step === 'results' && <ResultsScreen onViewData={() => setStep('ocr')} onBack={() => setStep('home')} />}
      {step === 'ocr' && <OCRScreen onBack={() => setStep('results')} />}

      {/* tiny step indicator overlay — helps reviewer see current step */}
      <div style={{
        position: 'absolute', top: 56, left: '50%', transform: 'translateX(-50%)',
        display: step === 'home' || step === 'ocr' ? 'none' : 'none',
        zIndex: 70,
      }} />
    </Frame>
  );
}

// ─────────────────────────────────────────────────────────────
// Root — DesignCanvas with all screens
// ─────────────────────────────────────────────────────────────
function App() {
  return (
    <DesignCanvas
      title="Struk — Receipt Restoration"
      subtitle="iOS app for restoring degraded Indonesian receipts with NAFNet + OCR"
    >
      <DCSection id="flow" title="Interactive flow" subtitle="Tap through the full restoration journey.">
        <DCArtboard id="live" label="Live prototype · tap to advance" width={360} height={780}>
          <FlowDevice />
        </DCArtboard>
      </DCSection>

      <DCSection id="screens" title="Screens" subtitle="Each step of the primary flow as a standalone artboard.">
        <DCArtboard id="home"       label="01 · Home"                   width={360} height={780}>
          <Frame><HomeScreen /></Frame>
        </DCArtboard>
        <DCArtboard id="picked"     label="02 · Picked + quality warn"  width={360} height={780}>
          <Frame><PickedScreen /></Frame>
        </DCArtboard>
        <DCArtboard id="processing" label="03 · Processing (NAFNet)"    width={360} height={780}>
          <Frame><ProcessingScreen progress={62} stage="Restorasi NAFNet" /></Frame>
        </DCArtboard>
        <DCArtboard id="results"    label="04 · Before/After"           width={360} height={780}>
          <Frame><ResultsScreen /></Frame>
        </DCArtboard>
        <DCArtboard id="ocr"        label="05 · OCR · structured data"  width={360} height={780}>
          <Frame><OCRScreen /></Frame>
        </DCArtboard>
        <DCArtboard id="empty"      label="06 · Empty state"            width={360} height={780}>
          <Frame><EmptyScreen /></Frame>
        </DCArtboard>
      </DCSection>

      <DCSection id="states" title="State variations" subtitle="Edge cases worth designing for.">
        <DCArtboard id="no-warn" label="Picked · clean photo (no warning)" width={360} height={780}>
          <Frame><PickedScreen showWarning={false} /></Frame>
        </DCArtboard>
        <DCArtboard id="proc-early" label="Processing · early"           width={360} height={780}>
          <Frame><ProcessingScreen progress={12} stage="Deteksi noise" /></Frame>
        </DCArtboard>
        <DCArtboard id="proc-late" label="Processing · final"            width={360} height={780}>
          <Frame><ProcessingScreen progress={94} stage="Ekstraksi OCR" /></Frame>
        </DCArtboard>
      </DCSection>
    </DesignCanvas>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
