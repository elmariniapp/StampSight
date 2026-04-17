<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Legal Notice — StampSight</title>
  <meta
    name="description"
    content="Legal Notice for StampSight, published by EL MARINI APP."
  />
  <style>
    :root {
      --bg: #f5f7fb;
      --surface: rgba(255, 255, 255, 0.78);
      --surface-strong: rgba(255, 255, 255, 0.92);
      --text: #0f172a;
      --muted: #5b6475;
      --line: rgba(15, 23, 42, 0.08);
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
      --max: 1160px;
    }

    * { box-sizing: border-box; }
    html { scroll-behavior: smooth; }

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

    a:hover { text-decoration: underline; }

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
      max-width: 8ch;
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

    .card p:last-child { margin-bottom: 0; }

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

      .hero h1 { max-width: none; }

      .button { width: 100%; }

      .cta-row { flex-direction: column; }
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
              <path d="M12 4.5l7 3.2v4.8c0 4.5-2.8 7.9-7 9.7-4.2-1.8-7-5.2-7-9.7V7.7l7-3.2z" stroke="currentColor" stroke-width="1.8"/>
              <path d="M9 12h6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
            </svg>
          </div>
          <div>
            <p class="eyebrow">StampSight</p>
            <p class="brand-title">Legal Notice</p>
          </div>
        </div>

        <div class="nav-links">
          <a class="nav-pill" href="PRIVACY_POLICY.html">Privacy Policy</a>
          <a class="nav-pill" href="TERMS_OF_USE.html">Terms of Use</a>
          <a class="nav-pill" href="data-deletion.html">Data Deletion</a>
        </div>
      </div>
    </div>

    <section class="hero">
      <div class="hero-grid">
        <div>
          <p class="eyebrow">Legal Transparency</p>
          <h1>Publisher and legal information.</h1>
          <p class="lead">
            This Legal Notice provides legal and publisher information relating to <strong>StampSight</strong> and its related materials.
          </p>

          <div class="hero-meta">
            <span class="chip">Last updated: April 17, 2026</span>
            <span class="chip">Publisher: EL MARINI APP</span>
            <span class="chip">Documentation tool</span>
          </div>

          <div class="cta-row">
            <a class="button button-primary" href="mailto:support@elmariniapp.com?subject=StampSight%20Legal%20Question">Contact support</a>
            <a class="button button-secondary" href="#contents">Jump to sections</a>
          </div>
        </div>

        <aside class="hero-card">
          <h2>Quick summary</h2>
          <p>
            StampSight is a field proof and documentation application designed for structured workflows such as inspections, deliveries, incidents, progress tracking, inventory proof, and related operational use cases.
          </p>
          <div class="highlight">
            <strong>Important:</strong>
            <p style="margin:8px 0 0;">
              StampSight is a documentation tool and workflow product. It is not presented as a legal certification service.
            </p>
          </div>
        </aside>
      </div>
    </section>

    <div class="grid">
      <section class="card" id="contents">
        <div class="kicker">Contents</div>
        <h2>Sections overview</h2>
        <div class="toc">
          <a href="#application">1. Application information</a>
          <a href="#publisher">2. Publisher</a>
          <a href="#contact">3. Contact</a>
          <a href="#ip">4. Intellectual property</a>
          <a href="#availability">5. Availability and information accuracy</a>
          <a href="#responsibility">6. User responsibility</a>
          <a href="#verification">7. Verification features</a>
          <a href="#third-party">8. Third-party platforms and services</a>
          <a href="#no-guarantee">9. No legal or evidentiary guarantee</a>
          <a href="#premium">10. Purchases and premium features</a>
          <a href="#privacy">11. Privacy and data handling</a>
          <a href="#terms">12. Terms of use</a>
          <a href="#governing">13. Governing information</a>
          <a href="#updates">14. Update of this Legal Notice</a>
          <a href="#summary">15. Summary of related legal documents</a>
        </div>
      </section>

      <section class="card" id="application">
        <div class="kicker">1 · Application information</div>
        <h2>Application information</h2>
        <p><strong>Application name:</strong> StampSight</p>
        <p><strong>Category:</strong> Field proof and documentation application</p>
        <p><strong>Purpose:</strong> Capture, organize, enrich, verify, and export photographic proof records and related contextual information.</p>
        <p>
          StampSight is designed for professional and personal documentation workflows, including but not limited to inspections, incident records, delivery evidence, condition reporting, progress documentation, inventory proof, intervention follow-up, and related operational use cases.
        </p>
        <div class="note">
          <strong>Clarification.</strong>
          <p style="margin:8px 0 0;">
            StampSight is a documentation tool and workflow product. It is not presented as a legal certification service.
          </p>
        </div>
      </section>

      <section class="card" id="publisher">
        <div class="kicker">2 · Publisher</div>
        <h2>Publisher</h2>
        <p><strong>Publisher name:</strong> EL MARINI APP</p>
        <p>
          EL MARINI APP is the publisher of the StampSight application and related materials unless otherwise stated.
        </p>
      </section>

      <section class="card" id="contact">
        <div class="kicker">3 · Contact</div>
        <h2>Contact</h2>
        <div class="highlight">
          <strong>EL MARINI APP</strong><br />
          Email: <a href="mailto:support@elmariniapp.com">support@elmariniapp.com</a>
        </div>
      </section>

      <section class="card" id="ip">
        <div class="kicker">4 · Intellectual property</div>
        <h2>Intellectual property</h2>
        <p>
          Unless otherwise stated, all elements relating to StampSight are protected by applicable intellectual property laws.
        </p>
        <ul>
          <li>the application name</li>
          <li>branding</li>
          <li>logos</li>
          <li>visual identity</li>
          <li>interface design</li>
          <li>texts</li>
          <li>documentation</li>
          <li>structure</li>
          <li>source code</li>
          <li>exported templates</li>
          <li>verification presentation elements</li>
          <li>graphic assets</li>
          <li>product concepts</li>
          <li>related proprietary materials</li>
        </ul>
        <p>
          No part of StampSight may be copied, reproduced, distributed, modified, published, sublicensed, or commercially exploited without prior written authorization, except where permitted by applicable law.
        </p>
      </section>

      <section class="card" id="availability">
        <div class="kicker">5 · Availability and information accuracy</div>
        <h2>Availability and information accuracy</h2>
        <p>
          We make reasonable efforts to provide accurate and up-to-date information relating to StampSight. However, we do not guarantee that all information, content, features, or related materials will always be complete, accurate, current, uninterrupted, secure, or error-free.
        </p>
        <p>
          StampSight may evolve over time. Features, descriptions, purchase options, verification workflows, and related materials may be updated, modified, suspended, restricted, or removed without notice, subject to applicable law.
        </p>
      </section>

      <section class="card" id="responsibility">
        <div class="kicker">6 · User responsibility</div>
        <h2>User responsibility</h2>
        <p>Users remain solely responsible for:</p>
        <ul>
          <li>the way they use the application</li>
          <li>the legality of the data they capture or process</li>
          <li>the review of any photo, proof, metadata, verification result, or exported report</li>
          <li>the storage, sharing, publication, and use of generated files</li>
          <li>compliance with all applicable legal, contractual, regulatory, and professional obligations</li>
        </ul>
        <div class="highlight">
          <strong>Important.</strong>
          <p style="margin:8px 0 0;">
            StampSight is a documentation tool only and does not replace legal, compliance, technical, evidentiary, or professional review.
          </p>
        </div>
      </section>

      <section class="card" id="verification">
        <div class="kicker">7 · Verification features</div>
        <h2>Verification features</h2>
        <p>
          StampSight may offer verification-related features, including QR-based verification workflows and public verification pages for certain proofs or exports.
        </p>

        <div class="info-grid">
          <div class="mini">
            <h3>Limited backend support</h3>
            <p>Verification features may rely on limited backend processing.</p>
          </div>
          <div class="mini">
            <h3>Limited public display</h3>
            <p>Public verification pages may display only a limited subset of proof-related information.</p>
          </div>
        </div>

        <div class="note">
          <strong>No certification guarantee.</strong>
          <p style="margin:8px 0 0;">
            Verification features do not, by themselves, constitute legal certification or guarantee acceptance in any legal, contractual, insurance, administrative, or regulatory context.
          </p>
        </div>
      </section>

      <section class="card" id="third-party">
        <div class="kicker">8 · Third-party platforms and services</div>
        <h2>Third-party platforms and services</h2>
        <p>
          StampSight may be distributed through third-party platforms such as mobile app stores and may interact with third-party device, infrastructure, or system services such as file viewers, sharing interfaces, email clients, billing providers, backend providers, and operating-system-level permission flows.
        </p>
        <p>
          Such third-party platforms and services are governed by their own terms, conditions, and privacy practices.
        </p>
        <p>
          EL MARINI APP is not responsible for the operation, availability, billing behavior, or policies of third-party services outside the direct scope of the application.
        </p>
      </section>

      <section class="card" id="no-guarantee">
        <div class="kicker">9 · No legal or evidentiary guarantee</div>
        <h2>No legal or evidentiary guarantee</h2>
        <p>
          StampSight is intended to help users document situations and generate structured records. However, EL MARINI APP does not guarantee that any output of the application, including any export, metadata record, or verification result, will be accepted, recognized, or considered sufficient in any legal, contractual, insurance, administrative, or regulatory context.
        </p>
        <p>
          Users are solely responsible for assessing the relevance, completeness, and admissibility of any record, report, export, or verification result they create or use.
        </p>
      </section>

      <section class="card" id="premium">
        <div class="kicker">10 · Purchases and premium features</div>
        <h2>Purchases and premium features</h2>
        <p>
          Some StampSight features may be available only through premium access, one-time purchases, subscriptions, or other purchase-based models.
        </p>
        <p>
          Where applicable, purchases are processed through the relevant platform billing provider, and access to premium functionality depends on the successful processing and recognition of the purchase under the relevant platform rules.
        </p>
        <div class="highlight">
          <strong>Billing platforms.</strong>
          <p style="margin:8px 0 0;">
            EL MARINI APP does not control third-party billing platforms and is not responsible for purchase failures, store-side delays, restore limitations, or billing-related restrictions caused by those platforms.
          </p>
        </div>
      </section>

      <section class="card" id="privacy">
        <div class="kicker">11 · Privacy and data handling</div>
        <h2>Privacy and data handling</h2>
        <p>
          Use of StampSight is also subject to the <a href="PRIVACY_POLICY.html">Privacy Policy</a> made available with the application and related materials.
        </p>
        <p>
          Users are encouraged to review the Privacy Policy to understand how data may be accessed, stored, used, and shared in connection with the application and its related services.
        </p>
      </section>

      <section class="card" id="terms">
        <div class="kicker">12 · Terms of use</div>
        <h2>Terms of use</h2>
        <p>
          Use of StampSight is also governed by the applicable <a href="TERMS_OF_USE.html">Terms of Use</a>.
        </p>
        <p>
          By using the application, users acknowledge that they are responsible for reviewing and complying with those Terms.
        </p>
      </section>

      <section class="card" id="governing">
        <div class="kicker">13 · Governing information</div>
        <h2>Governing information</h2>
        <p>
          This Legal Notice is provided for transparency and information purposes. It should be read together with the Privacy Policy and Terms of Use applicable to StampSight.
        </p>
        <p>
          If any provision of this Legal Notice is found to be invalid or unenforceable, the remaining provisions remain in effect to the fullest extent permitted by law.
        </p>
      </section>

      <section class="card" id="updates">
        <div class="kicker">14 · Update of this Legal Notice</div>
        <h2>Update of this Legal Notice</h2>
        <p>
          We may update this Legal Notice from time to time to reflect product changes, billing changes, legal developments, infrastructure changes, or operational updates.
        </p>
        <p>
          When updated, the “Last updated” date at the top of the page will be revised.
        </p>
      </section>

      <section class="card" id="summary">
        <div class="kicker">15 · Summary of related legal documents</div>
        <h2>Summary of related legal documents</h2>
        <p>For StampSight, the main legal documents are:</p>
        <ul>
          <li><a href="PRIVACY_POLICY.html">Privacy Policy</a></li>
          <li><a href="TERMS_OF_USE.html">Terms of Use</a></li>
          <li><a href="data-deletion.html">Data Deletion Request</a></li>
        </ul>
        <div class="success">
          <strong>Read together.</strong>
          <p style="margin:8px 0 0;">
            These pages should be read together for a complete overview of the current legal and privacy framework relating to the application.
          </p>
        </div>
      </section>
    </div>

    <footer class="footer">
      <p>
        <strong>StampSight</strong> is published by <strong>EL MARINI APP</strong>. This page should be read together with the Privacy Policy, Terms of Use, and Data Deletion page applicable to the app.
      </p>
    </footer>
  </div>
</body>
</html>
