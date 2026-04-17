<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Privacy Policy — StampSight</title>
  <meta
    name="description"
    content="Privacy Policy for StampSight, published by EL MARINI APP."
  />
  <style>
    :root {
      --bg: #f5f7fb;
      --bg-accent: #eef3ff;
      --surface: rgba(255, 255, 255, 0.78);
      --surface-strong: rgba(255, 255, 255, 0.92);
      --text: #0f172a;
      --muted: #5b6475;
      --line: rgba(15, 23, 42, 0.08);
      --line-strong: rgba(15, 23, 42, 0.12);
      --primary: #2563eb;
      --primary-soft: rgba(37, 99, 235, 0.10);
      --success: #0f766e;
      --success-soft: rgba(15, 118, 110, 0.10);
      --warning: #9a6700;
      --warning-soft: rgba(154, 103, 0, 0.10);
      --shadow-lg: 0 20px 60px rgba(15, 23, 42, 0.10);
      --shadow-md: 0 10px 30px rgba(15, 23, 42, 0.07);
      --radius-xl: 28px;
      --radius-lg: 22px;
      --radius-md: 16px;
      --max: 1160px;
    }

    * {
      box-sizing: border-box;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      margin: 0;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
        "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, rgba(37, 99, 235, 0.10), transparent 28%),
        radial-gradient(circle at top right, rgba(14, 165, 233, 0.10), transparent 26%),
        linear-gradient(180deg, #f8faff 0%, #f4f7fb 48%, #eef3f9 100%);
      min-height: 100vh;
    }

    a {
      color: var(--primary);
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    .shell {
      width: 100%;
      max-width: var(--max);
      margin: 0 auto;
      padding: 24px 20px 56px;
    }

    .topbar {
      position: sticky;
      top: 0;
      z-index: 20;
      margin: 0 auto 22px;
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
    }

    .topbar-inner {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      padding: 14px 16px;
      border: 1px solid var(--line);
      background: rgba(255, 255, 255, 0.72);
      border-radius: 20px;
      box-shadow: var(--shadow-md);
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      min-width: 0;
    }

    .brand-mark {
      width: 40px;
      height: 40px;
      border-radius: 14px;
      background:
        linear-gradient(135deg, rgba(37, 99, 235, 0.14), rgba(14, 165, 233, 0.10)),
        #ffffff;
      border: 1px solid rgba(37, 99, 235, 0.12);
      display: grid;
      place-items: center;
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
      flex-shrink: 0;
    }

    .brand svg {
      width: 20px;
      height: 20px;
      color: var(--primary);
    }

    .brand-text {
      min-width: 0;
    }

    .eyebrow {
      margin: 0 0 2px;
      font-size: 12px;
      letter-spacing: 0.12em;
      text-transform: uppercase;
      color: var(--muted);
      font-weight: 700;
    }

    .brand-title {
      margin: 0;
      font-size: 15px;
      font-weight: 700;
      color: var(--text);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .nav-links {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      justify-content: flex-end;
    }

    .nav-pill {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 10px 14px;
      border-radius: 999px;
      background: rgba(255,255,255,0.75);
      border: 1px solid var(--line);
      color: var(--text);
      font-size: 14px;
      font-weight: 600;
      transition: 180ms ease;
    }

    .nav-pill:hover {
      transform: translateY(-1px);
      text-decoration: none;
      border-color: rgba(37, 99, 235, 0.22);
      background: rgba(255,255,255,0.94);
    }

    .hero {
      position: relative;
      overflow: hidden;
      padding: 34px;
      border-radius: var(--radius-xl);
      border: 1px solid rgba(255, 255, 255, 0.68);
      background:
        linear-gradient(135deg, rgba(255,255,255,0.88), rgba(255,255,255,0.70)),
        linear-gradient(135deg, rgba(37, 99, 235, 0.08), rgba(14, 165, 233, 0.06));
      box-shadow: var(--shadow-lg);
      margin-bottom: 24px;
    }

    .hero::before,
    .hero::after {
      content: "";
      position: absolute;
      border-radius: 999px;
      filter: blur(24px);
      pointer-events: none;
    }

    .hero::before {
      width: 240px;
      height: 240px;
      right: -60px;
      top: -60px;
      background: rgba(37, 99, 235, 0.10);
    }

    .hero::after {
      width: 180px;
      height: 180px;
      left: -40px;
      bottom: -50px;
      background: rgba(14, 165, 233, 0.10);
    }

    .hero-grid {
      position: relative;
      z-index: 1;
      display: grid;
      grid-template-columns: minmax(0, 1.2fr) minmax(280px, 0.8fr);
      gap: 24px;
      align-items: start;
    }

    .hero h1 {
      margin: 0 0 14px;
      font-size: clamp(34px, 5vw, 58px);
      line-height: 1.02;
      letter-spacing: -0.04em;
      max-width: 10ch;
    }

    .hero p.lead {
      margin: 0;
      font-size: 18px;
      line-height: 1.65;
      color: #334155;
      max-width: 68ch;
    }

    .hero-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 20px;
    }

    .chip {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 14px;
      border-radius: 999px;
      background: rgba(255,255,255,0.78);
      border: 1px solid var(--line);
      font-size: 13px;
      font-weight: 600;
      color: #334155;
    }

    .hero-card {
      padding: 22px;
      border-radius: 24px;
      background: rgba(255,255,255,0.84);
      border: 1px solid var(--line);
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
    }

    .hero-card h2 {
      margin: 0 0 10px;
      font-size: 17px;
      letter-spacing: -0.02em;
    }

    .hero-card p {
      margin: 0;
      color: var(--muted);
      line-height: 1.7;
      font-size: 15px;
    }

    .cta-row {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 20px;
    }

    .button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 13px 18px;
      border-radius: 14px;
      font-weight: 700;
      font-size: 14px;
      text-decoration: none;
      transition: 180ms ease;
      border: 1px solid transparent;
    }

    .button:hover {
      transform: translateY(-1px);
      text-decoration: none;
    }

    .button-primary {
      color: #fff;
      background: linear-gradient(135deg, #1d4ed8, #2563eb);
      box-shadow: 0 12px 28px rgba(37, 99, 235, 0.22);
    }

    .button-secondary {
      color: var(--text);
      background: rgba(255,255,255,0.82);
      border-color: var(--line);
    }

    .grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 18px;
      margin-top: 18px;
    }

    .card {
      padding: 28px;
      border-radius: var(--radius-lg);
      background: var(--surface);
      border: 1px solid var(--line);
      box-shadow: var(--shadow-md);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    .card h2 {
      margin: 0 0 14px;
      font-size: clamp(22px, 3vw, 28px);
      line-height: 1.15;
      letter-spacing: -0.03em;
    }

    .card p {
      margin: 0 0 14px;
      color: #334155;
      line-height: 1.75;
      font-size: 16px;
    }

    .card p:last-child {
      margin-bottom: 0;
    }

    .kicker {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 12px;
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      font-weight: 800;
      color: var(--muted);
    }

    .highlight,
    .note,
    .success {
      border-radius: 18px;
      padding: 18px;
      border: 1px solid transparent;
      margin-top: 16px;
    }

    .highlight {
      background: var(--primary-soft);
      border-color: rgba(37, 99, 235, 0.12);
    }

    .note {
      background: var(--warning-soft);
      border-color: rgba(154, 103, 0, 0.12);
    }

    .success {
      background: var(--success-soft);
      border-color: rgba(15, 118, 110, 0.12);
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 14px;
      margin-top: 18px;
    }

    .mini {
      padding: 18px;
      border-radius: 18px;
      background: var(--surface-strong);
      border: 1px solid var(--line);
    }

    .mini h3 {
      margin: 0 0 8px;
      font-size: 15px;
      letter-spacing: -0.02em;
    }

    .mini p {
      margin: 0;
      font-size: 14px;
      line-height: 1.65;
      color: var(--muted);
    }

    ul {
      margin: 14px 0 0;
      padding-left: 20px;
      color: #334155;
    }

    li {
      margin: 10px 0;
      line-height: 1.7;
    }

    .toc {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 12px;
      margin-top: 18px;
    }

    .toc a {
      display: block;
      padding: 14px 16px;
      border-radius: 16px;
      border: 1px solid var(--line);
      background: rgba(255,255,255,0.82);
      color: var(--text);
      font-weight: 600;
      font-size: 14px;
    }

    .toc a:hover {
      text-decoration: none;
      border-color: rgba(37, 99, 235, 0.22);
      transform: translateY(-1px);
    }

    .footer {
      margin-top: 28px;
      padding: 24px;
      border-radius: 22px;
      background: rgba(255,255,255,0.72);
      border: 1px solid var(--line);
      box-shadow: var(--shadow-md);
    }

    .footer p {
      margin: 0;
      color: var(--muted);
      line-height: 1.7;
      font-size: 14px;
    }

    @media (max-width: 920px) {
      .hero-grid,
      .info-grid,
      .toc {
        grid-template-columns: 1fr;
      }

      .topbar-inner {
        align-items: flex-start;
        flex-direction: column;
      }

      .nav-links {
        width: 100%;
        justify-content: flex-start;
      }
    }

    @media (max-width: 640px) {
      .shell {
        padding: 16px 14px 40px;
      }

      .hero,
      .card {
        padding: 22px;
      }

      .hero h1 {
        max-width: none;
      }

      .button {
        width: 100%;
      }

      .cta-row {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <div class="shell">
    <div class="topbar">
      <div class="topbar-inner">
        <div class="brand">
          <div class="brand-mark" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M12 3l7 3v5c0 4.8-2.9 8.3-7 10-4.1-1.7-7-5.2-7-10V6l7-3z" stroke="currentColor" stroke-width="1.8"/>
              <path d="M9 12.2l2 2 4-4.3" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="brand-text">
            <p class="eyebrow">StampSight</p>
            <p class="brand-title">Privacy Policy</p>
          </div>
        </div>

        <div class="nav-links">
          <a class="nav-pill" href="TERMS_OF_USE.html">Terms of Use</a>
          <a class="nav-pill" href="LEGAL_NOTICE.html">Legal Notice</a>
          <a class="nav-pill" href="data-deletion.html">Data Deletion</a>
        </div>
      </div>
    </div>

    <section class="hero">
      <div class="hero-grid">
        <div>
          <p class="eyebrow">Privacy & Transparency</p>
          <h1>Your data, explained clearly.</h1>
          <p class="lead">
            This Privacy Policy explains how <strong>StampSight</strong> may access, use, store, and share information when you use the app, its related features, and associated services.
          </p>

          <div class="hero-meta">
            <span class="chip">Last updated: April 17, 2026</span>
            <span class="chip">Publisher: EL MARINI APP</span>
            <span class="chip">Local-first by design</span>
          </div>

          <div class="cta-row">
            <a class="button button-primary" href="mailto:support@elmariniapp.com?subject=StampSight%20Privacy%20Request">Contact support</a>
            <a class="button button-secondary" href="#contents">Jump to sections</a>
          </div>
        </div>

        <aside class="hero-card">
          <h2>Quick summary</h2>
          <p>
            StampSight is designed to store a significant part of operational data locally on your device. Some limited verification-related data may also be processed through backend services when verification features are used.
          </p>
          <div class="highlight">
            <strong>Important:</strong>
            <p style="margin:8px 0 0;">
              StampSight is a documentation and workflow tool. It is not presented as a legal certification service and does not guarantee absolute legal validity.
            </p>
          </div>
        </aside>
      </div>
    </section>

    <div class="grid">
      <section class="card" id="contents">
        <div class="kicker">Contents</div>
        <h2>Sections overview</h2>
        <p>
          Use the sections below to quickly navigate this Privacy Policy.
        </p>

        <div class="toc">
          <a href="#about">1. About StampSight</a>
          <a href="#data-types">2. Information the app may access or process</a>
          <a href="#how-used">3. How StampSight uses information</a>
          <a href="#legal-basis">4. Legal basis and user control</a>
          <a href="#local-storage">5. Local storage on your device</a>
          <a href="#sharing">6. Sharing of information</a>
          <a href="#third-party">7. Third-party services</a>
          <a href="#location">8. Location information</a>
          <a href="#permissions">9. Permissions requested by the app</a>
          <a href="#retention">10. Data retention</a>
          <a href="#security">11. Security</a>
          <a href="#international">12. International use</a>
          <a href="#children">13. Children’s privacy</a>
          <a href="#choices">14. Your choices</a>
          <a href="#deletion">15. Data deletion and support requests</a>
          <a href="#changes">16. Changes to this Privacy Policy</a>
          <a href="#contact">17. Contact</a>
          <a href="#publisher">18. Publisher information</a>
          <a href="#note">19. Important note</a>
        </div>
      </section>

      <section class="card" id="about">
        <div class="kicker">1 · About StampSight</div>
        <h2>About StampSight</h2>
        <p>
          StampSight is a premium field proof application designed to help users create, organize, and export clear, contextualized, traceable, and actionable documentation.
        </p>
        <p>
          The app is intended for professional or personal documentation workflows such as proof capture, condition reporting, intervention follow-up, delivery evidence, incident documentation, inventory proof, and similar operational use cases.
        </p>
        <div class="note">
          <strong>Clarification.</strong>
          <p style="margin:8px 0 0;">
            StampSight is a documentation and reporting tool. It is not presented as a legal certification service or as a guarantee of absolute legal validity.
          </p>
        </div>
      </section>

      <section class="card" id="data-types">
        <div class="kicker">2 · Information the app may access or process</div>
        <h2>Information the app may access or process</h2>

        <div class="info-grid">
          <div class="mini">
            <h3>2.1 Camera data</h3>
            <p>StampSight may access your device camera to allow you to capture proof photos directly inside the app.</p>
          </div>
          <div class="mini">
            <h3>2.2 Photos, files, and stored documents</h3>
            <p>StampSight may access, create, read, store, and manage image files, exported files, and PDF reports in order to support app functionality.</p>
          </div>
          <div class="mini">
            <h3>2.3 Location data</h3>
            <p>If you grant permission, StampSight may access location-related information to enrich a proof with contextual data such as approximate or precise location, address information, or other location-derived metadata.</p>
          </div>
          <div class="mini">
            <h3>2.4 User-provided content</h3>
            <p>StampSight may process information that you manually enter into the app, including client names, company names, site names, mission names, notes, proof descriptions, report-related details, session-related context, and export preferences.</p>
          </div>
          <div class="mini">
            <h3>2.5 App and device information</h3>
            <p>StampSight may process limited device or app information necessary for functionality, compatibility, local persistence, diagnostics, security, stability, or performance.</p>
          </div>
          <div class="mini">
            <h3>2.6 Verification-related metadata</h3>
            <p>When verification-related features are used, StampSight may process limited verification metadata such as proof identifiers, verification identifiers, timestamps, integrity hashes, publication status, and related technical records.</p>
          </div>
        </div>
      </section>

      <section class="card" id="how-used">
        <div class="kicker">3 · How StampSight uses information</div>
        <h2>How StampSight uses information</h2>
        <p>
          StampSight uses information only for legitimate app functionality and related operational purposes.
        </p>
        <ul>
          <li>capture proof photos</li>
          <li>create and organize proof records</li>
          <li>associate a proof with a client, site, mission, or session</li>
          <li>attach contextual metadata such as date, time, and location</li>
          <li>generate exportable PDF reports</li>
          <li>generate derived export images</li>
          <li>support grouped reports or multi-photo reports</li>
          <li>support QR verification and related proof validation workflows</li>
          <li>open or share files at your request</li>
          <li>save user preferences and app settings</li>
          <li>unlock or restore premium functionality after a valid purchase</li>
          <li>support troubleshooting, diagnostics, stability, security, and service maintenance</li>
        </ul>
        <div class="success">
          <strong>No unrelated use.</strong>
          <p style="margin:8px 0 0;">
            StampSight does not use your information for unrelated purposes.
          </p>
        </div>
      </section>

      <section class="card" id="legal-basis">
        <div class="kicker">4 · Legal basis and user control</div>
        <h2>Legal basis and user control</h2>
        <p>
          Where applicable, data access is based on one or more of the following:
        </p>
        <ul>
          <li>your permission, for example camera or location access</li>
          <li>your direct action inside the app</li>
          <li>legitimate operational necessity to provide the requested feature</li>
        </ul>
        <p>
          You remain in control of many app actions, including when you choose to capture a photo, attach or omit context, generate a report, export a file, share a file, grant or deny permissions, or use optional verification-related features.
        </p>
      </section>

      <section class="card" id="local-storage">
        <div class="kicker">5 · Local storage on your device</div>
        <h2>Local storage on your device</h2>
        <p>
          StampSight is designed to store a significant part of its operational data locally on your device.
        </p>
        <ul>
          <li>proof records</li>
          <li>captured images</li>
          <li>additional images linked to a proof</li>
          <li>temporary draft files</li>
          <li>generated PDF files</li>
          <li>export files</li>
          <li>app preferences</li>
          <li>client and site data</li>
          <li>active session data</li>
          <li>local integrity or history records related to exports</li>
        </ul>
        <div class="highlight">
          <strong>Why this matters.</strong>
          <p style="margin:8px 0 0;">
            Local storage helps the app function properly, preserve your work, and support report generation, retrieval, and local-first usage.
          </p>
        </div>
      </section>

      <section class="card" id="sharing">
        <div class="kicker">6 · Sharing of information</div>
        <h2>Sharing of information</h2>
        <p>
          StampSight does <strong>not</strong> sell personal data.
        </p>

        <div class="info-grid">
          <div class="mini">
            <h3>6.1 Sharing initiated by you</h3>
            <p>If you choose to export or share a proof image, PDF, or related file, the selected information may be transmitted through the method, app, or service you choose.</p>
          </div>
          <div class="mini">
            <h3>6.2 Verification and backend processing</h3>
            <p>If you use QR verification or related proof verification features, limited verification-related data may be processed through backend services used by StampSight in order to provide those features.</p>
          </div>
          <div class="mini">
            <h3>6.3 Purchases and premium entitlement</h3>
            <p>If you purchase or restore premium access, purchase-related information may be processed through the platform billing provider in order to validate the transaction and unlock premium features.</p>
          </div>
          <div class="mini">
            <h3>6.4 Legal obligations</h3>
            <p>We may disclose information if required to do so by law, regulation, legal process, or enforceable governmental request.</p>
          </div>
        </div>

        <div class="note">
          <strong>Public verification is intentionally limited.</strong>
          <p style="margin:8px 0 0;">
            Public verification pages intentionally display only a limited subset of information relevant to verification. Original source photos and full exported PDF files are not publicly exposed through the verification page.
          </p>
        </div>
      </section>

      <section class="card" id="third-party">
        <div class="kicker">7 · Third-party services</div>
        <h2>Third-party services</h2>
        <p>
          StampSight may rely on third-party services that are necessary to operate certain features.
        </p>

        <div class="info-grid">
          <div class="mini">
            <h3>7.1 Google Firebase / Google Cloud services</h3>
            <p>StampSight may use Google Firebase and related Google Cloud services to support limited backend functionality such as verification workflows, technical operations, service security, or related feature delivery.</p>
          </div>
          <div class="mini">
            <h3>7.2 Google Play Billing</h3>
            <p>On Android, in-app purchases and premium entitlement restoration may rely on Google Play Billing or related Google Play services.</p>
          </div>
          <div class="mini">
            <h3>7.3 Device and platform services</h3>
            <p>StampSight may also rely on device-level or platform-level services for actions such as opening files, sharing files, launching email apps, opening device settings, or using operating system permission flows.</p>
          </div>
          <div class="mini">
            <h3>Third-party terms</h3>
            <p>These services are governed by the relevant platform, manufacturer, or third-party privacy practices.</p>
          </div>
        </div>
      </section>

      <section class="card" id="location">
        <div class="kicker">8 · Location information</div>
        <h2>Location information</h2>
        <p>
          If enabled by the user, location information may be used to enrich proof documentation with contextual data.
        </p>
        <ul>
          <li>geographic coordinates</li>
          <li>derived address information</li>
          <li>contextual place metadata</li>
          <li>time-location association for a proof</li>
        </ul>
        <p>
          Location access is optional and feature-dependent. Denying location access may limit certain contextual proof features.
        </p>
      </section>

      <section class="card" id="permissions">
        <div class="kicker">9 · Permissions requested by the app</div>
        <h2>Permissions requested by the app</h2>
        <p>
          StampSight may request certain permissions when they are relevant to the feature being used.
        </p>
        <ul>
          <li><strong>Camera</strong> — to capture proof images</li>
          <li><strong>Location</strong> — to attach contextual location data to proofs</li>
          <li><strong>Photos / Files / Storage</strong> — to read, store, export, open, or share proof assets and PDF files</li>
        </ul>
        <p>
          Permissions are requested only when needed for the related feature flow. You can generally manage permissions through your device settings.
        </p>
      </section>

      <section class="card" id="retention">
        <div class="kicker">10 · Data retention</div>
        <h2>Data retention</h2>
        <p>
          Data handled by StampSight may remain on your device until you delete it, remove the app, clear app storage, or otherwise remove the relevant files or records.
        </p>
        <p>
          Retention may vary depending on your own actions, app storage cleanup operations, export or deletion flows, temporary file handling, verification publication status where applicable, and necessary technical retention related to security, integrity, or service operation.
        </p>
        <div class="highlight">
          <strong>Backend-supported verification data.</strong>
          <p style="margin:8px 0 0;">
            Where limited verification-related records are processed through backend services, they may be retained for as long as reasonably necessary to provide the verification feature, maintain service integrity, comply with legal obligations, resolve abuse, or support troubleshooting and security.
          </p>
        </div>
      </section>

      <section class="card" id="security">
        <div class="kicker">11 · Security</div>
        <h2>Security</h2>
        <p>
          We take reasonable steps to help protect the information handled by StampSight.
        </p>
        <p>
          These measures may include local storage controls, access restrictions, technical safeguards, and integrity-related mechanisms designed to support proof handling and verification features.
        </p>
        <p>
          However, no method of storage, software operation, or electronic transmission is completely secure. As a result, we cannot guarantee absolute security.
        </p>
      </section>

      <section class="card" id="international">
        <div class="kicker">12 · International use</div>
        <h2>International use</h2>
        <p>
          If StampSight becomes available in multiple jurisdictions, the handling of information may be subject to different legal requirements depending on the country or region in which the app is used.
        </p>
        <p>
          Users are responsible for ensuring that their use of the app complies with applicable local laws, especially when documenting locations, property, goods, or third parties.
        </p>
      </section>

      <section class="card" id="children">
        <div class="kicker">13 · Children’s privacy</div>
        <h2>Children’s privacy</h2>
        <p>
          StampSight is not intended for children under the age of 13, and we do not knowingly design the app for use by children.
        </p>
        <p>
          If you believe that a child has provided information in a way that should not have occurred, please contact us.
        </p>
      </section>

      <section class="card" id="choices">
        <div class="kicker">14 · Your choices</div>
        <h2>Your choices</h2>
        <ul>
          <li>deny permissions</li>
          <li>delete proofs or local records</li>
          <li>avoid adding optional metadata</li>
          <li>avoid using verification-related features</li>
          <li>avoid sharing exported files</li>
          <li>remove the app and its local data</li>
          <li>contact us regarding privacy concerns</li>
        </ul>
        <p>
          Certain app features may not function fully if required permissions are denied.
        </p>
      </section>

      <section class="card" id="deletion">
        <div class="kicker">15 · Data deletion and support requests</div>
        <h2>Data deletion and support requests</h2>
        <p>
          Because StampSight is designed with significant local-first behavior, many records can be removed directly by deleting local proofs, exports, app data, or the app itself from your device.
        </p>
        <p>
          If you have a privacy, deletion, or compliance request related to backend-supported verification data or support-managed issues, you may contact us at the email address below.
        </p>
        <div class="success">
          <strong>Dedicated deletion page available.</strong>
          <p style="margin:8px 0 0;">
            For practical deletion instructions, see <a href="data-deletion.html">Data Deletion Request</a>.
          </p>
        </div>
      </section>

      <section class="card" id="changes">
        <div class="kicker">16 · Changes to this Privacy Policy</div>
        <h2>Changes to this Privacy Policy</h2>
        <p>
          We may update this Privacy Policy from time to time to reflect product changes, legal requirements, operational improvements, or service integrations.
        </p>
        <p>
          When we update this Privacy Policy, we will revise the “Last updated” date at the top of the page.
        </p>
      </section>

      <section class="card" id="contact">
        <div class="kicker">17 · Contact</div>
        <h2>Contact</h2>
        <p>
          For privacy, legal, or compliance questions related to StampSight, you may contact:
        </p>
        <div class="highlight">
          <strong>EL MARINI APP</strong><br />
          Email: <a href="mailto:support@elmariniapp.com">support@elmariniapp.com</a>
        </div>
      </section>

      <section class="card" id="publisher">
        <div class="kicker">18 · Publisher information</div>
        <h2>Publisher information</h2>
        <p><strong>Application name:</strong> StampSight</p>
        <p><strong>Publisher:</strong> EL MARINI APP</p>
      </section>

      <section class="card" id="note">
        <div class="kicker">19 · Important note</div>
        <h2>Important note</h2>
        <p>
          StampSight is a documentation tool. The way users capture, store, export, share, or rely on proof records remains under their responsibility.
        </p>
        <p>
          Users are responsible for ensuring that their use of the app, including any documentation or reporting activity, complies with applicable laws, regulations, contractual duties, and professional obligations.
        </p>
      </section>
    </div>

    <footer class="footer">
      <p>
        <strong>StampSight</strong> is published by <strong>EL MARINI APP</strong>. This page is provided for transparency and privacy support purposes. It should be read together with the Terms of Use, Legal Notice, and Data Deletion page applicable to the app.
      </p>
    </footer>
  </div>
</body>
</html>
