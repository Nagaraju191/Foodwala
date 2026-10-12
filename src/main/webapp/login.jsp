<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <meta name="color-scheme" content="light dark">
    <meta name="theme-color" content="#170A0E">

    <title>Foodwala - Login</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600;12..96,800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <script>
        document.documentElement.className += ' js';
    </script>

    <style>

        /* =========================================================
           FOODWALA LOGIN
           Palette inspired by Guntur chilli, turmeric and curry leaf
           ========================================================= */

        :root {
            --chili: #C21F32;
            --ember: #EB4B2A;
            --turmeric: #F6B21B;
            --leaf: #2F7D4F;

            --stage-bg: #170A0E;
            --stage-ink: #FFF4EC;
            --stage-ink-2: rgba(255, 244, 236, .72);

            --surface: #FFFBF9;
            --ink: #1E1214;
            --ink-2: #5E4F52;
            --ink-3: #7A6B6E;
            --line: rgba(60, 30, 36, .16);
            --field: #FFFFFF;
            --field-hover: #FFF3EE;

            --accent: #B3162A;
            --accent-tint: rgba(194, 31, 50, .14);
            --accent-gradient: linear-gradient(135deg, #E8452C 0%, #C21F32 60%, #9E1230 100%);
            --accent-shadow: 0 14px 28px rgba(194, 31, 50, .32),
                             inset 0 1.5px 0 rgba(255, 255, 255, .45),
                             inset 0 -3px 6px rgba(90, 0, 20, .25);

            --success: #0F7A3E;
            --success-bg: rgba(20, 160, 85, .12);
            --danger: #C62A20;
            --danger-bg: rgba(220, 50, 40, .1);

            --toast-bg: rgba(30, 18, 20, .92);
            --toast-fg: #fff;

            --display: "Bricolage Grotesque", "Segoe UI", -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial, sans-serif;
            --body: "DM Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", "Helvetica Neue", Arial, sans-serif;

            --spring: cubic-bezier(.34, 1.56, .64, 1);
            --ease: cubic-bezier(.22, .61, .36, 1);
        }

        @media (prefers-color-scheme: dark) {
            :root {
                --surface: #120A0D;
                --ink: #FBF1EC;
                --ink-2: #BFAFB2;
                --ink-3: #9F8F92;
                --line: rgba(255, 235, 230, .16);
                --field: rgba(255, 255, 255, .05);
                --field-hover: rgba(255, 255, 255, .09);

                --accent: #FF7A86;
                --accent-tint: rgba(255, 122, 134, .2);

                --success: #4BDB8A;
                --success-bg: rgba(75, 219, 138, .14);
                --danger: #FF8178;
                --danger-bg: rgba(255, 129, 120, .14);

                --toast-bg: rgba(251, 241, 236, .94);
                --toast-fg: #1E1214;
            }
        }

        /* ================= GLOBAL ================= */

        * { margin: 0; padding: 0; box-sizing: border-box; }

        [hidden] { display: none !important; }

        html { -webkit-text-size-adjust: 100%; }

        body {
            font-family: var(--body);
            background: var(--surface);
            color: var(--ink);
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
            overflow-x: hidden;
        }

        a { color: inherit; }

        button, input { font-family: inherit; }

        :focus-visible {
            outline: 3px solid var(--accent);
            outline-offset: 2px;
        }

        /* ================= LAYOUT ================= */

        .auth {
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1.08fr) minmax(0, .92fr);
        }

        /* ================= LEFT: STAGE ================= */

        .stage {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            background: var(--stage-bg);
            color: var(--stage-ink);
            padding: clamp(28px, 4vw, 56px);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 40px;
            animation: fadeIn .9s var(--ease) backwards;
        }

        .stage .glow {
            position: absolute;
            z-index: -2;
            border-radius: 50%;
            filter: blur(90px);
            pointer-events: none;
        }

        .stage .glow.g1 {
            width: 60vmax;
            height: 60vmax;
            left: -22vmax;
            bottom: -30vmax;
            background: radial-gradient(circle, rgba(222, 40, 50, .85), transparent 65%);
            opacity: .7;
            animation: drift 18s ease-in-out infinite alternate;
        }

        .stage .glow.g2 {
            width: 38vmax;
            height: 38vmax;
            right: -14vmax;
            top: -16vmax;
            background: radial-gradient(circle, rgba(246, 178, 27, .75), transparent 65%);
            opacity: .38;
            animation: drift 22s ease-in-out infinite alternate-reverse;
        }

        .stage .grain {
            position: absolute;
            inset: 0;
            z-index: -1;
            opacity: .09;
            mix-blend-mode: overlay;
            pointer-events: none;
            background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='.9' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%' height='100%' filter='url(%23n)'/></svg>");
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            width: fit-content;
            text-decoration: none;
            font-family: var(--display);
            font-weight: 800;
            font-size: 24px;
            letter-spacing: -.02em;
        }

        .brand .mark {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            font-size: 22px;
            color: #fff;
            background: var(--accent-gradient);
            box-shadow: 0 8px 20px rgba(194, 31, 50, .45),
                        inset 0 1.5px 0 rgba(255, 255, 255, .45);
            transform: rotate(-6deg);
        }

        .pitch { max-width: 540px; }

        .pitch h1 {
            font-family: var(--display);
            font-weight: 800;
            font-size: clamp(38px, 4.8vw, 66px);
            line-height: 1.02;
            letter-spacing: -.035em;
            margin-bottom: 18px;
            text-wrap: balance;
        }

        .pitch p {
            font-size: 16.5px;
            line-height: 1.65;
            color: var(--stage-ink-2);
            max-width: 46ch;
        }

        /* ================= TRACKER (the memorable element) ================= */

        .track {
            position: relative;
            width: min(100%, 470px);
            padding: 20px 20px 22px;
            border-radius: 26px;
            background: linear-gradient(160deg, rgba(255, 255, 255, .13), rgba(255, 255, 255, .05));
            border: 1px solid rgba(255, 255, 255, .16);
            -webkit-backdrop-filter: blur(22px) saturate(160%);
            backdrop-filter: blur(22px) saturate(160%);
            box-shadow: 0 30px 60px rgba(0, 0, 0, .4),
                        inset 0 1.5px 0 rgba(255, 255, 255, .28);
            animation: rise 1s var(--spring) .25s backwards;
        }

        .track-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
        }

        .track-title {
            font-family: var(--display);
            font-weight: 700;
            font-size: 18px;
            letter-spacing: -.01em;
        }

        .track-sub {
            margin-top: 3px;
            font-size: 13px;
            color: var(--stage-ink-2);
        }

        .eta {
            flex: none;
            text-align: right;
            padding: 8px 14px;
            border-radius: 16px;
            background: rgba(246, 178, 27, .16);
            border: 1px solid rgba(246, 178, 27, .4);
        }

        .eta b {
            display: block;
            font-family: var(--display);
            font-size: 19px;
            line-height: 1.1;
            color: #FFD36B;
            font-variant-numeric: tabular-nums;
        }

        .eta span {
            font-size: 11.5px;
            color: var(--stage-ink-2);
        }

        .route {
            display: block;
            width: 100%;
            height: auto;
            margin: 14px 0 6px;
            overflow: visible;
        }

        .route .path-base {
            fill: none;
            stroke: rgba(255, 255, 255, .22);
            stroke-width: 3;
            stroke-linecap: round;
            stroke-dasharray: 2 9;
            animation: march 1.6s linear infinite;
        }

        .route .pin-ring {
            fill: rgba(255, 255, 255, .14);
            stroke: rgba(255, 255, 255, .5);
            stroke-width: 1.5;
        }

        .route .rider-pulse {
            fill: rgba(246, 178, 27, .3);
            transform-box: fill-box;
            transform-origin: center;
            animation: pulse 1.8s ease-out infinite;
        }

        .status {
            margin: 4px 0 16px;
            font-size: 14.5px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .status::before {
            content: "";
            width: 9px;
            height: 9px;
            border-radius: 50%;
            background: var(--turmeric);
            box-shadow: 0 0 0 5px rgba(246, 178, 27, .22);
            animation: pulseDot 2s ease-in-out infinite;
        }

        .status.is-done::before {
            background: #4BDB8A;
            box-shadow: 0 0 0 5px rgba(75, 219, 138, .22);
            animation: none;
        }

        .steps {
            position: relative;
            list-style: none;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
        }

        .steps .bar {
            position: absolute;
            top: 7px;
            left: 12.5%;
            right: 12.5%;
            height: 3px;
            border-radius: 3px;
            background: rgba(255, 255, 255, .18);
            overflow: hidden;
        }

        .steps .bar i {
            display: block;
            height: 100%;
            width: 0;
            border-radius: inherit;
            background: linear-gradient(90deg, var(--turmeric), var(--ember));
            transition: width .9s var(--ease);
        }

        .steps li {
            position: relative;
            text-align: center;
            font-size: 12px;
            color: var(--stage-ink-2);
            padding-top: 24px;
            transition: color .4s ease;
        }

        .steps li::before {
            content: "";
            position: absolute;
            top: 0;
            left: 50%;
            width: 17px;
            height: 17px;
            margin-left: -8.5px;
            border-radius: 50%;
            background: var(--stage-bg);
            border: 2px solid rgba(255, 255, 255, .32);
            transition: background .4s ease, border-color .4s ease, transform .5s var(--spring);
        }

        .steps li.done,
        .steps li.now { color: var(--stage-ink); }

        .steps li.done::before {
            background: var(--turmeric);
            border-color: var(--turmeric);
        }

        .steps li.now::before {
            background: var(--ember);
            border-color: #FFD36B;
            transform: scale(1.22);
        }

        /* ================= RIGHT: FORM ================= */

        .auth-form {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: clamp(28px, 5vw, 64px);
            animation: fadeIn .9s var(--ease) .15s backwards;
        }

        .form-in {
            width: min(100%, 410px);
        }

        .form-in h2 {
            font-family: var(--display);
            font-weight: 800;
            font-size: clamp(32px, 3.2vw, 44px);
            line-height: 1.05;
            letter-spacing: -.035em;
            margin-bottom: 10px;
        }

        .sub {
            color: var(--ink-2);
            font-size: 15px;
            line-height: 1.55;
            margin-bottom: 26px;
        }

        /* ================= ALERT ================= */

        .alert {
            display: flex;
            gap: 11px;
            align-items: flex-start;
            padding: 13px 15px;
            border-radius: 14px;
            margin-bottom: 20px;
            font-size: 13.5px;
            line-height: 1.5;
            border: 1px solid transparent;
        }

        .alert strong { display: block; font-size: 14px; }

        .alert.err {
            color: var(--danger);
            background: var(--danger-bg);
            border-color: color-mix(in srgb, var(--danger) 30%, transparent);
            animation: shake .45s var(--ease);
        }

        .alert.okm {
            color: var(--success);
            background: var(--success-bg);
            border-color: color-mix(in srgb, var(--success) 30%, transparent);
        }

        /* ================= FIELDS ================= */

        .fg { margin-bottom: 18px; }

        .fg label {
            display: block;
            margin-bottom: 8px;
            font-size: 13.5px;
            font-weight: 600;
        }

        .inp { position: relative; }

        .inp .ic {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            color: var(--ink-3);
            pointer-events: none;
            transition: color .25s ease;
        }

        .field {
            width: 100%;
            height: 56px;
            padding: 0 48px 0 46px;
            border: 1.5px solid var(--line);
            border-radius: 14px;
            background: var(--field);
            color: var(--ink);
            font-size: 15.5px;
            outline: none;
            transition: border-color .25s ease, box-shadow .3s ease, background .25s ease;
        }

        .field::placeholder { color: var(--ink-3); }

        .field:hover { background: var(--field-hover); }

        .field:focus {
            border-color: var(--chili);
            background: var(--field);
            box-shadow: 0 0 0 4px var(--accent-tint);
        }

        .inp:focus-within .ic { color: var(--accent); }

        .fg.invalid .field {
            border-color: var(--danger);
            box-shadow: 0 0 0 4px var(--danger-bg);
        }

        .msg {
            margin-top: 7px;
            font-size: 12.5px;
            color: var(--danger);
            font-weight: 500;
        }

        .hint {
            margin-top: 7px;
            font-size: 12.5px;
            color: var(--ink-2);
        }

        /* ================= PASSWORD EYE ================= */

        .eye {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 11px;
            background: transparent;
            color: var(--ink-3);
            cursor: pointer;
            display: grid;
            place-items: center;
            transition: background .2s ease, color .2s ease;
        }

        .eye:hover { background: var(--accent-tint); color: var(--ink); }

        .eye .eye-off { display: none; }
        .eye.on .eye-open { display: none; }
        .eye.on .eye-off { display: block; }

        /* ================= BUTTON ================= */

        .btn {
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            min-height: 56px;
            margin-top: 8px;
            padding: 0 24px;
            border: none;
            border-radius: 16px;
            background: var(--accent-gradient);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: .005em;
            cursor: pointer;
            box-shadow: var(--accent-shadow);
            transition: transform .4s var(--spring), filter .2s ease, box-shadow .3s ease;
        }

        .btn::before {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: inherit;
            pointer-events: none;
            background: linear-gradient(180deg, rgba(255, 255, 255, .34) 0%, rgba(255, 255, 255, .06) 48%, rgba(255, 255, 255, 0) 50%);
        }

        .btn::after {
            content: "";
            position: absolute;
            top: -20%;
            bottom: -20%;
            left: -60%;
            width: 40%;
            pointer-events: none;
            transform: skewX(-22deg);
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .5), transparent);
            transition: left .7s var(--ease);
        }

        .btn:hover { transform: translateY(-2px); filter: brightness(1.06); }
        .btn:hover::after { left: 130%; }
        .btn:active { transform: scale(.97); }

        .btn > * { position: relative; z-index: 1; }

        .btn .arrow { transition: transform .35s var(--spring); }
        .btn:hover .arrow { transform: translateX(4px); }

        .btn .spin {
            display: none;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2.5px solid rgba(255, 255, 255, .4);
            border-top-color: #fff;
            animation: spin .7s linear infinite;
        }

        .btn.loading { pointer-events: none; filter: saturate(.85); }
        .btn.loading .spin { display: block; }
        .btn.loading .arrow { display: none; }

        /* ================= LINKS ================= */

        .alt {
            text-align: center;
            margin-top: 24px;
            color: var(--ink-2);
            font-size: 14.5px;
        }

        .alt a {
            color: var(--accent);
            font-weight: 700;
            text-decoration: none;
            margin-left: 4px;
        }

        .alt a:hover { text-decoration: underline; }

        .back {
            display: block;
            text-align: center;
            margin-top: 12px;
            font-size: 13.5px;
            color: var(--ink-3);
            text-decoration: none;
            transition: color .2s ease;
        }

        .back:hover { color: var(--ink); }

        /* ================= TOAST ================= */

        .toast-host {
            position: fixed;
            top: 24px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 300;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            pointer-events: none;
            width: max-content;
            max-width: 92vw;
        }

        .toast {
            background: var(--toast-bg);
            color: var(--toast-fg);
            padding: 12px 20px;
            border-radius: 999px;
            font-size: 14px;
            font-weight: 600;
            -webkit-backdrop-filter: blur(20px);
            backdrop-filter: blur(20px);
            box-shadow: 0 14px 34px rgba(0, 0, 0, .26);
            animation: toastIn .55s var(--spring);
        }

        .toast.out {
            opacity: 0;
            transform: translateY(-10px) scale(.96);
            transition: all .35s ease;
        }

        /* ================= RIPPLE ================= */

        .rip {
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
            transform: scale(0);
            z-index: 1;
            background: radial-gradient(circle, rgba(255, 255, 255, .7), rgba(255, 255, 255, 0) 68%);
            animation: rip .75s ease-out forwards;
        }

        /* ================= ANIMATIONS ================= */

        @keyframes fadeIn { from { opacity: 0; } }

        @keyframes rise {
            from { opacity: 0; transform: translateY(30px) scale(.96); }
        }

        @keyframes drift {
            to { transform: translate3d(5vmax, -4vmax, 0) scale(1.12); }
        }

        @keyframes march { to { stroke-dashoffset: -22; } }

        @keyframes pulse {
            0% { transform: scale(.6); opacity: .9; }
            100% { transform: scale(2.2); opacity: 0; }
        }

        @keyframes pulseDot { 50% { transform: scale(1.25); opacity: .75; } }

        @keyframes shake {
            20% { transform: translateX(-6px); }
            40% { transform: translateX(5px); }
            60% { transform: translateX(-3px); }
            80% { transform: translateX(2px); }
        }

        @keyframes toastIn {
            from { opacity: 0; transform: translateY(-16px) scale(.9); }
        }

        @keyframes rip { to { transform: scale(1); opacity: 0; } }

        @keyframes spin { to { transform: rotate(360deg); } }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 960px) {
            .auth { grid-template-columns: 1fr; }

            .stage {
                gap: 22px;
                padding: 26px 24px 34px;
            }

            .pitch h1 { font-size: clamp(32px, 8vw, 44px); }
            .pitch p { font-size: 15px; }

            .track { display: none; }

            .auth-form {
                padding: 34px 22px 44px;
                align-items: stretch;
            }

            .form-in { width: 100%; max-width: 460px; margin: 0 auto; }
        }

        @media (max-width: 420px) {
            .pitch p { display: none; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: .01ms !important;
            }
        }

    </style>

</head>

<body>

    <main class="auth">

        <!-- ================= LEFT: BRAND + LIVE ORDER PREVIEW ================= -->

        <section class="stage">

            <span class="glow g1" aria-hidden="true"></span>
            <span class="glow g2" aria-hidden="true"></span>
            <span class="grain" aria-hidden="true"></span>

            <a href="restaurant" class="brand">
                <span class="mark" aria-hidden="true">F</span>
                <span>Foodwala</span>
            </a>

            <div class="pitch">
                <h1>Hot food, right to your door.</h1>
                <p>
                    Browse restaurants near you, build your cart in a few taps
                    and watch your order arrive in real time.
                </p>
            </div>

            <aside class="track" aria-label="Preview of live order tracking">

                <div class="track-head">
                    <div>
                        <p class="track-title">Andhra Chicken Biryani</p>
                        <p class="track-sub">Spice Route Kitchen</p>
                    </div>
                    <div class="eta">
                        <b id="etaVal">28 min</b>
                        <span>arriving in</span>
                    </div>
                </div>

                <svg class="route" viewBox="0 0 340 112" aria-hidden="true">
                    <path id="routePath" class="path-base"
                          d="M24 88 C 84 92, 96 28, 160 40 S 262 92, 316 28"/>

                    <!-- restaurant pin -->
                    <g transform="translate(24 88)">
                        <circle class="pin-ring" r="13"/>
                        <path d="M-5 -5h10v8a2 2 0 0 1-2 2h-6a2 2 0 0 1-2-2z M-3 -8v2 M0 -8v2 M3 -8v2"
                              fill="none" stroke="#FFF4EC" stroke-width="1.6" stroke-linecap="round"/>
                    </g>

                    <!-- home pin -->
                    <g transform="translate(316 28)">
                        <circle class="pin-ring" r="13"/>
                        <path d="M-6 1 0 -5 6 1 M-4 0v6h8v-6"
                              fill="none" stroke="#FFF4EC" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                    </g>

                    <!-- rider -->
                    <g id="rider">
                        <circle class="rider-pulse" r="10"/>
                        <circle r="7" fill="#F6B21B" stroke="#170A0E" stroke-width="2"/>
                        <animateMotion dur="7s" repeatCount="indefinite" rotate="0"
                                       keyPoints="0;1" keyTimes="0;1" calcMode="linear">
                            <mpath href="#routePath"/>
                        </animateMotion>
                    </g>
                </svg>

                <p class="status" id="statusTxt" role="status" aria-live="polite">Order confirmed</p>

                <ol class="steps" id="steps">
                    <span class="bar"><i id="barFill"></i></span>
                    <li>Confirmed</li>
                    <li>Cooking</li>
                    <li>On the way</li>
                    <li>Delivered</li>
                </ol>

            </aside>

        </section>


        <!-- ================= RIGHT: LOGIN FORM ================= -->

        <section class="auth-form">

            <div class="form-in">

                <h2>Welcome back</h2>

                <p class="sub">Log in to pick up where your last order left off.</p>


                <!-- ================= ERROR / SUCCESS MESSAGES ================= -->

                <%
                    String error = request.getParameter("error");

                    if ("invalid".equals(error)) {
                %>

                    <div class="alert err" role="alert">
                        <span aria-hidden="true">⚠️</span>
                        <div>
                            <strong>Login failed</strong>
                            Invalid email or password.
                        </div>
                    </div>

                <%
                    } else if ("empty".equals(error)) {
                %>

                    <div class="alert err" role="alert">
                        <span aria-hidden="true">⚠️</span>
                        <div>
                            <strong>Missing details</strong>
                            Please enter your email and password.
                        </div>
                    </div>

                <%
                    } else if ("logout".equals(error)) {
                %>

                    <div class="alert okm" role="status">
                        <span aria-hidden="true">✓</span>
                        <div>
                            <strong>Logged out</strong>
                            You have been logged out successfully.
                        </div>
                    </div>

                <%
                    }
                %>


                <!-- ================= FORM ================= -->

                <form action="login" method="post" id="loginForm" novalidate>

                    <!-- EMAIL -->

                    <div class="fg" id="fgEmail">

                        <label for="email">Email address</label>

                        <div class="inp">

                            <span class="ic">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <rect x="3" y="5" width="18" height="14" rx="3"/>
                                    <path d="m3 7 9 6 9-6"/>
                                </svg>
                            </span>

                            <input class="field"
                                   type="email"
                                   id="email"
                                   name="email"
                                   placeholder="you@example.com"
                                   autocomplete="email"
                                   aria-describedby="emailMsg"
                                   required>
                        </div>

                        <p class="msg" id="emailMsg" hidden></p>

                    </div>


                    <!-- PASSWORD -->

                    <div class="fg" id="fgPass">

                        <label for="password">Password</label>

                        <div class="inp">

                            <span class="ic">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <rect x="4" y="11" width="16" height="10" rx="3"/>
                                    <path d="M8 11V8a4 4 0 0 1 8 0v3"/>
                                </svg>
                            </span>

                            <input class="field"
                                   type="password"
                                   id="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   autocomplete="current-password"
                                   aria-describedby="passMsg capsHint"
                                   required>

                            <button type="button" class="eye" id="eye" aria-label="Show password">

                                <svg class="eye-open" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>

                                <svg class="eye-off" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="M3 3l18 18"/>
                                    <path d="M10.6 5.1A10.6 10.6 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-3.2 4.1"/>
                                    <path d="M6.6 6.6C3.7 8.4 2 12 2 12s3.5 7 10 7c1.5 0 2.9-.4 4.1-.9"/>
                                    <path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/>
                                </svg>

                            </button>

                        </div>

                        <p class="msg" id="passMsg" hidden></p>
                        <p class="hint" id="capsHint" hidden>Caps Lock is on</p>

                    </div>


                    <!-- LOGIN BUTTON -->

                    <button type="submit" class="btn submit" id="submitBtn">

                        <span>Log in</span>

                        <svg class="arrow" width="18" height="18" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2.2"
                             stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M5 12h13"/>
                            <path d="m13 6 6 6-6 6"/>
                        </svg>

                        <span class="spin" aria-hidden="true"></span>

                    </button>

                </form>


                <!-- ================= REGISTER ================= -->

                <p class="alt">
                    New to Foodwala?
                    <a href="register.jsp">Create an account</a>
                </p>


                <!-- ================= BACK ================= -->

                <a class="back" href="restaurant">&larr; Continue browsing restaurants</a>

            </div>

        </section>

    </main>


    <!-- ================= JAVASCRIPT ================= -->

    <script>

        /* ================= TOAST + RIPPLE ================= */

        (function () {

            window.fwToast = function (msg) {

                var h = document.getElementById('toastHost');

                if (!h) {
                    h = document.createElement('div');
                    h.id = 'toastHost';
                    h.className = 'toast-host';
                    h.setAttribute('role', 'status');
                    h.setAttribute('aria-live', 'polite');
                    document.body.appendChild(h);
                }

                var t = document.createElement('div');
                t.className = 'toast';
                t.textContent = msg;
                h.appendChild(t);

                setTimeout(function () {
                    t.classList.add('out');
                    setTimeout(function () { t.remove(); }, 360);
                }, 2400);
            };


            document.addEventListener('pointerdown', function (e) {

                var t = e.target.closest('.btn');

                if (!t || t.disabled) { return; }

                var r = t.getBoundingClientRect();
                var s = Math.max(r.width, r.height) * 2.4;
                var sp = document.createElement('span');

                sp.className = 'rip';
                sp.style.cssText =
                    'width:' + s + 'px;' +
                    'height:' + s + 'px;' +
                    'left:' + (e.clientX - r.left - s / 2) + 'px;' +
                    'top:' + (e.clientY - r.top - s / 2) + 'px';

                t.appendChild(sp);

                setTimeout(function () { sp.remove(); }, 800);
            });

        })();


        /* ================= LOGIN FORM ================= */

        (function () {

            var f = document.getElementById('loginForm');
            var btn = document.getElementById('submitBtn');
            var pw = document.getElementById('password');
            var em = document.getElementById('email');
            var eye = document.getElementById('eye');
            var caps = document.getElementById('capsHint');

            var fgEmail = document.getElementById('fgEmail');
            var fgPass = document.getElementById('fgPass');
            var emailMsg = document.getElementById('emailMsg');
            var passMsg = document.getElementById('passMsg');


            function setError(group, msgEl, text) {
                group.classList.add('invalid');
                msgEl.textContent = text;
                msgEl.hidden = false;
            }

            function clearError(group, msgEl) {
                group.classList.remove('invalid');
                msgEl.hidden = true;
            }


            /* Password show / hide */

            eye.addEventListener('click', function () {

                var show = pw.type === 'password';

                pw.type = show ? 'text' : 'password';
                eye.classList.toggle('on', show);
                eye.setAttribute('aria-label', show ? 'Hide password' : 'Show password');

                pw.focus();
            });


            /* Caps Lock hint */

            function checkCaps(e) {
                if (e.getModifierState) {
                    caps.hidden = !e.getModifierState('CapsLock');
                }
            }

            pw.addEventListener('keydown', checkCaps);
            pw.addEventListener('keyup', checkCaps);
            pw.addEventListener('blur', function () { caps.hidden = true; });


            /* Clear errors while typing */

            em.addEventListener('input', function () { clearError(fgEmail, emailMsg); });
            pw.addEventListener('input', function () { clearError(fgPass, passMsg); });


            /* Validation */

            f.addEventListener('submit', function (e) {

                var emailVal = em.value.trim();
                var firstBad = null;

                clearError(fgEmail, emailMsg);
                clearError(fgPass, passMsg);

                if (!emailVal) {
                    setError(fgEmail, emailMsg, 'Enter your email address.');
                    firstBad = em;
                } else if (!em.checkValidity()) {
                    setError(fgEmail, emailMsg, 'Enter a valid email, like you@example.com.');
                    firstBad = em;
                }

                if (!pw.value) {
                    setError(fgPass, passMsg, 'Enter your password.');
                    if (!firstBad) { firstBad = pw; }
                }

                if (firstBad) {
                    e.preventDefault();

                    fwToast(
                        !emailVal && !pw.value
                            ? 'Please enter your email and password'
                            : 'Please check the highlighted field'
                    );

                    firstBad.focus();
                    return;
                }

                btn.classList.add('loading');
                btn.setAttribute('aria-busy', 'true');
            });


            /* Back / forward cache */

            window.addEventListener('pageshow', function () {
                btn.classList.remove('loading');
                btn.removeAttribute('aria-busy');
            });

        })();


        /* ================= ORDER TRACKER PREVIEW ================= */

        (function () {

            var steps = document.querySelectorAll('#steps li');
            var bar = document.getElementById('barFill');
            var eta = document.getElementById('etaVal');
            var status = document.getElementById('statusTxt');
            var rider = document.getElementById('rider');

            if (!steps.length) { return; }

            var stages = [
                { text: 'Order confirmed',          eta: '28 min' },
                { text: 'The chef is cooking',      eta: '22 min' },
                { text: 'Your rider is on the way', eta: '12 min' },
                { text: 'Delivered. Enjoy your meal!', eta: 'Done' }
            ];

            var current = 0;

            function setStage(i) {

                current = i;

                for (var k = 0; k < steps.length; k++) {
                    steps[k].classList.toggle('done', k < i);
                    steps[k].classList.toggle('now', k === i);
                }

                bar.style.width = (i / (steps.length - 1) * 100) + '%';
                eta.textContent = stages[i].eta;
                status.textContent = stages[i].text;
                status.classList.toggle('is-done', i === stages.length - 1);
            }

            var reduce = window.matchMedia &&
                         window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            if (reduce) {
                setStage(2);

                var svg = rider.ownerSVGElement;
                if (svg && svg.pauseAnimations) { svg.pauseAnimations(); }

                return;
            }

            setStage(0);

            (function tick() {
                setTimeout(function () {
                    setStage((current + 1) % stages.length);
                    tick();
                }, current === stages.length - 1 ? 4200 : 2600);
            })();

        })();

    </script>

</body>

</html>
