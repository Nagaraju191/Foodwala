<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.CartItem"%>

<%
    Integer loggedInUserId =
            (Integer) session.getAttribute("userId");
%>

<%!
    private static String esc(Object value) {
        if (value == null) return "";

        String s = String.valueOf(value);
        StringBuilder out = new StringBuilder(s.length() + 16);

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);

            switch (c) {
                case '&':
                    out.append("&amp;");
                    break;

                case '<':
                    out.append("&lt;");
                    break;

                case '>':
                    out.append("&gt;");
                    break;

                case '"':
                    out.append("&quot;");
                    break;

                case '\'':
                    out.append("&#39;");
                    break;

                default:
                    out.append(c);
            }
        }

        return out.toString();
    }
%>

<%
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

    double subtotal = 0.0;
    int totalItems = 0;

    if (cart != null) {
        for (CartItem item : cart) {
            subtotal += item.getTotalAmount();
            totalItems += item.getQuantity();
        }
    }

    double grandTotal = subtotal;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, viewport-fit=cover">

    <meta name="color-scheme" content="light dark">

    <meta name="theme-color"
          content="#F3EEFA"
          media="(prefers-color-scheme: light)">

    <meta name="theme-color"
          content="#07060D"
          media="(prefers-color-scheme: dark)">

    <title>Foodwala - Cart</title>


    <style>

        /* =========================================================
           FOODWALA - GLOSSY LIQUID GLASS
           ========================================================= */

        :root {

            --bg: #F3EEFA;

            --label: #1B1726;
            --label-2: #5A5468;
            --label-3: #75708A;

            --separator: rgba(60,50,90,.14);
            --hover: rgba(255,255,255,.6);

            --a1: #FF8A3D;
            --a2: #FF2E63;
            --a3: #C026D3;

            --t1: #22D3C5;
            --t2: #6366F1;

            --accent-gradient:
                linear-gradient(
                    135deg,
                    var(--a1) 0%,
                    var(--a2) 55%,
                    var(--a3) 115%
                );

            --cool-gradient:
                linear-gradient(135deg,var(--t1),var(--t2));

            --gold-gradient:
                linear-gradient(
                    135deg,
                    #FFE066 0%,
                    #FFB300 55%,
                    #FF8A00 100%
                );

            --accent-solid: #D61F52;
            --accent-tint: rgba(255,46,99,.12);
            --accent-glow: rgba(255,46,99,.38);

            --success: #0F8A45;
            --success-bg: rgba(20,170,90,.16);

            --danger: #E0342B;
            --danger-bg: rgba(255,59,48,.13);

            --glass: rgba(255,255,255,.52);
            --glass-strong: rgba(255,255,255,.78);
            --glass-soft: rgba(255,255,255,.28);

            --glass-border: rgba(255,255,255,.85);

            --glass-inset:
                inset 0 1.5px 0 rgba(255,255,255,1),
                inset 0 -1px 0 rgba(255,255,255,.3),
                inset 0 0 22px rgba(255,255,255,.35);

            --glass-shadow:
                0 10px 34px rgba(60,40,120,.12),
                0 2px 6px rgba(60,40,120,.06);

            --glass-shadow-hover:
                0 22px 56px rgba(60,40,120,.2),
                0 4px 12px rgba(60,40,120,.08);

            --blur: blur(28px) saturate(200%);

            --skel-a: rgba(255,255,255,.35);
            --skel-b: rgba(255,255,255,.85);

            --toast-bg: rgba(27,23,38,.88);
            --toast-fg: #fff;

            --gloss:
                linear-gradient(
                    180deg,
                    rgba(255,255,255,.55) 0%,
                    rgba(255,255,255,.12) 48%,
                    rgba(255,255,255,0) 50%
                );

            --shadow-accent:
                0 12px 26px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6),
                inset 0 -3px 6px rgba(120,0,40,.22);

            --r-xl: 28px;
            --r-lg: 18px;
            --r-md: 14px;
            --r-full: 999px;

            --spring: cubic-bezier(.34,1.56,.64,1);
            --ease: cubic-bezier(.22,.61,.36,1);

            --wave:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 60' preserveAspectRatio='none'%3E%3Cpath d='M0 34 C200 6 400 62 600 34 S1000 6 1200 34 V60 H0Z'/%3E%3C/svg%3E");
        }


        /* =========================================================
           DARK MODE
           ========================================================= */

        @media (prefers-color-scheme: dark) {

            :root {

                --bg: #07060D;

                --label: #F6F4FB;
                --label-2: #A6A2B6;
                --label-3: #8F8BA2;

                --separator: rgba(255,255,255,.12);
                --hover: rgba(255,255,255,.1);

                --accent-solid: #FF7391;
                --accent-tint: rgba(255,115,145,.17);

                --success: #34D67A;
                --success-bg: rgba(52,214,122,.17);

                --danger: #FF7168;
                --danger-bg: rgba(255,113,104,.17);

                --glass: rgba(40,36,58,.5);
                --glass-strong: rgba(48,43,68,.76);
                --glass-soft: rgba(255,255,255,.06);

                --glass-border: rgba(255,255,255,.17);

                --glass-inset:
                    inset 0 1.5px 0 rgba(255,255,255,.22),
                    inset 0 -1px 0 rgba(255,255,255,.04),
                    inset 0 0 22px rgba(255,255,255,.04);

                --glass-shadow:
                    0 10px 34px rgba(0,0,0,.55),
                    0 2px 6px rgba(0,0,0,.3);

                --glass-shadow-hover:
                    0 22px 56px rgba(0,0,0,.65),
                    0 4px 12px rgba(0,0,0,.35);

                --skel-a: rgba(255,255,255,.06);
                --skel-b: rgba(255,255,255,.17);

                --toast-bg: rgba(246,244,251,.92);
                --toast-fg: #1B1726;

                --gloss:
                    linear-gradient(
                        180deg,
                        rgba(255,255,255,.34) 0%,
                        rgba(255,255,255,.08) 48%,
                        rgba(255,255,255,0) 50%
                    );
            }
        }


        /* =========================================================
           BACKDROP FALLBACK
           ========================================================= */

        @supports not ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {

            :root {
                --glass: rgba(255,255,255,.95);
                --glass-strong: #fff;
            }
        }

        @media (prefers-color-scheme: dark) {

            @supports not ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {

                :root {
                    --glass: rgba(34,31,48,.96);
                    --glass-strong: #292539;
                }
            }
        }


        /* =========================================================
           GLOBAL
           ========================================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        [hidden] {
            display: none !important;
        }

        html {
            scroll-behavior: smooth;
        }

        body {

            font-family:
                -apple-system,
                BlinkMacSystemFont,
                "SF Pro Text",
                "SF Pro Display",
                "Segoe UI",
                "Helvetica Neue",
                Arial,
                sans-serif;

            background: var(--bg);
            color: var(--label);

            -webkit-font-smoothing: antialiased;

            letter-spacing: -.006em;

            padding-bottom: 50px;

            overflow-x: hidden;

            position: relative;

            isolation: isolate;
        }

        a {
            color: inherit;
        }

        :focus-visible {
            outline: 3px solid var(--accent-solid);
            outline-offset: 2px;
        }


        /* =========================================================
           AURORA BACKGROUND
           ========================================================= */

        .aqua {

            position: fixed;

            inset: 0;

            z-index: -1;

            overflow: hidden;

            pointer-events: none;
        }

        .aqua i {

            position: absolute;

            display: block;

            filter: blur(72px);

            opacity: .6;

            will-change: transform;

            border-radius:
                42% 58% 63% 37% /
                45% 40% 60% 55%;

            animation:
                flow 24s ease-in-out infinite alternate,
                morph 15s ease-in-out infinite;
        }

        .aqua i:nth-child(1) {

            width: 56vmax;
            height: 56vmax;

            left: -16vmax;
            top: -22vmax;

            background:
                radial-gradient(
                    circle at 35% 35%,
                    var(--a1),
                    transparent 66%
                );
        }

        .aqua i:nth-child(2) {

            width: 50vmax;
            height: 50vmax;

            right: -18vmax;
            top: -12vmax;

            background:
                radial-gradient(
                    circle at 60% 40%,
                    var(--a2),
                    transparent 66%
                );

            animation-delay: -7s;
        }

        .aqua i:nth-child(3) {

            width: 54vmax;
            height: 54vmax;

            left: -20vmax;
            bottom: -26vmax;

            background:
                radial-gradient(
                    circle,
                    var(--t1),
                    transparent 66%
                );

            animation-delay: -12s;

            opacity: .48;
        }

        .aqua i:nth-child(4) {

            width: 46vmax;
            height: 46vmax;

            right: -14vmax;
            bottom: -18vmax;

            background:
                radial-gradient(
                    circle,
                    var(--t2),
                    transparent 66%
                );

            animation-delay: -4s;

            opacity: .46;
        }

        @media (prefers-color-scheme: dark) {

            .aqua i {
                opacity: .4;
            }

            .aqua i:nth-child(3),
            .aqua i:nth-child(4) {
                opacity: .32;
            }
        }


        /* =========================================================
           NAVBAR
           ========================================================= */

        .navbar {

            position: sticky;

            top: 0;

            z-index: 100;

            padding: 10px 14px 0;
        }

        .nav-inner {

            width: 100%;

            max-width: 1250px;

            margin: 0 auto;

            height: 60px;

            padding: 0 10px 0 16px;

            border-radius: 24px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            transition: box-shadow .3s ease;
        }

        .navbar.scrolled .nav-inner {

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }

        .brand {

            display: flex;

            align-items: center;

            gap: 10px;

            text-decoration: none;

            position: relative;

            z-index: 3;
        }

        .brand-mark {

            position: relative;

            overflow: hidden;

            width: 34px;

            height: 34px;

            border-radius: 12px;

            background: var(--accent-gradient);

            color: #fff;

            font-size: 16px;

            font-weight: 800;

            display: flex;

            align-items: center;

            justify-content: center;

            box-shadow:
                0 7px 16px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6),
                inset 0 -3px 6px rgba(120,0,40,.25);
        }

        .brand-mark::before {

            content: "";

            position: absolute;

            inset: 0;

            background: var(--gloss);

            border-radius: inherit;
        }

        .brand-name {

            font-size: 18px;

            font-weight: 700;

            letter-spacing: -.015em;
        }

        .nav-links {

            display: flex;

            align-items: center;

            gap: 4px;

            position: relative;

            z-index: 3;
        }

        .nav-link,
        .cart-nav {

            position: relative;

            isolation: isolate;

            display: inline-flex;

            align-items: center;

            gap: 7px;

            text-decoration: none;

            color: var(--label-2);

            font-size: 14.5px;

            font-weight: 600;

            padding: 8px 15px;

            border-radius: var(--r-full);

            transition:
                color .2s ease,
                background .25s ease,
                transform .3s var(--spring);
        }

        .nav-link:hover,
        .cart-nav:hover {

            color: var(--label);

            background: var(--hover);
        }

        .nav-link:active,
        .cart-nav:active {

            transform: scale(.94);
        }

        .nav-link.is-active {

            color: var(--label);
        }

        .nav-link.nav-link-cta {

            overflow: hidden;

            color: #fff;

            background: var(--accent-gradient);

            box-shadow: var(--shadow-accent);
        }

        .nav-link.nav-link-cta:hover {

            filter: brightness(1.08);

            background: var(--accent-gradient);
        }

        .cart-nav svg {

            width: 21px;
            height: 21px;

            flex-shrink: 0;
        }

        .cart-badge {

            min-width: 18px;

            height: 18px;

            padding: 0 5px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border-radius: 999px;

            background: var(--accent-gradient);

            color: #fff;

            font-size: 10px;

            font-weight: 800;

            line-height: 1;

            box-shadow:
                0 3px 8px var(--accent-glow),
                inset 0 1px 0 rgba(255,255,255,.5);
        }
        
        
        .profile-nav {
    width: 40px;
    height: 40px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    margin-left: 5px;

    border-radius: 50%;

    text-decoration: none;

    color: var(--label-2);

    background: var(--glass-strong);

    border: 1px solid var(--glass-border);

    box-shadow: var(--glass-inset),
                0 4px 12px rgba(60, 40, 120, .12);

    transition:
        transform .25s var(--spring),
        color .2s ease,
        background .25s ease,
        box-shadow .25s ease;
}

.profile-nav svg {
    width: 21px;
    height: 21px;
}

.profile-nav:hover {
    color: #fff;

    background: var(--accent-gradient);

    box-shadow: var(--shadow-accent);

    transform: scale(1.08);
}

.profile-nav:active {
    transform: scale(.94);
}
	
        .cart-nav.is-current {

            color: var(--label);

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                0 3px 10px rgba(60,40,120,.12);
        }


        /* =========================================================
           WAVES
           ========================================================= */

        .wave {

            position: absolute;

            left: 0;
            right: 0;

            bottom: 0;

            height: 36px;

            opacity: .5;

            pointer-events: none;

            background:
                linear-gradient(
                    90deg,
                    var(--a1),
                    var(--a2),
                    var(--a3),
                    var(--t2),
                    var(--t1),
                    var(--a1)
                );

            background-size: 200% 100%;

            -webkit-mask:
                var(--wave) repeat-x 0 100% / 1200px 100%;

            mask:
                var(--wave) repeat-x 0 100% / 1200px 100%;

            animation:
                waveX 16s linear infinite,
                waveBg 10s linear infinite;
        }

        .wave.b {

            height: 28px;

            bottom: 8px;

            opacity: .26;

            animation-duration: 24s,14s;

            animation-direction: reverse,normal;
        }


        /* =========================================================
           MOBILE TAB BAR
           ========================================================= */

        .tab-bar {
            display: none;
        }

        .tab-item {

            position: relative;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            gap: 3px;

            text-decoration: none;

            color: var(--label-3);

            font-size: 10.5px;

            font-weight: 600;

            min-width: 62px;

            height: 50px;

            border-radius: 20px;

            transition:
                color .25s ease,
                transform .35s var(--spring);
        }

        .tab-item:active {
            transform: scale(.9);
        }

        .tab-item.is-active {

            color: var(--accent-solid);

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60,40,120,.14);
        }

        .tab-cart-wrap {
            position: relative;
        }

        .tab-cart-badge {

            position: absolute;

            top: -5px;

            right: -10px;

            min-width: 16px;

            height: 16px;

            display: grid;

            place-items: center;

            padding: 0 4px;

            border-radius: 999px;

            background: var(--accent-gradient);

            color: #fff;

            font-size: 8px;

            font-weight: 800;

            box-shadow: 0 0 0 2px var(--bg);
        }


        /* =========================================================
           KEYFRAMES
           ========================================================= */

        @keyframes flow {

            to {

                transform:
                    translate3d(
                        7vmax,
                        5vmax,
                        0
                    )
                    rotate(38deg)
                    scale(1.14);
            }
        }

        @keyframes morph {

            50% {

                border-radius:
                    60% 40% 32% 68% /
                    58% 32% 68% 42%;
            }
        }

        @keyframes titleFlow {

            to {
                background-position: -260% 0;
            }
        }

        @keyframes waveX {

            to {

                -webkit-mask-position: 1200px 100%;

                mask-position: 1200px 100%;
            }
        }

        @keyframes waveBg {

            to {
                background-position: -200% 0;
            }
        }

        @keyframes barIn {

            from {

                opacity: 0;

                transform:
                    translateX(-50%)
                    translateY(40px)
                    scale(.9);
            }
        }


        /* =========================================================
           GLASS SURFACES
           ========================================================= */

        .glass-card,
        .empty-card,
        .nav-inner,
        .tab-bar {

            background:
                linear-gradient(
                    135deg,
                    var(--glass-strong),
                    var(--glass) 55%,
                    var(--glass-soft)
                );

            -webkit-backdrop-filter: var(--blur);

            backdrop-filter: var(--blur);

            border: 1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow);
        }

        .glass-card::before,
        .empty-card::before,
        .nav-inner::before,
        .tab-bar::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            z-index: 2;

            background:
                linear-gradient(
                    115deg,
                    rgba(255,255,255,.32) 0%,
                    rgba(255,255,255,0) 32%
                );

            opacity: .7;
        }

        .glass-card,
        .empty-card,
        .nav-inner,
        .tab-bar {

            position: relative;
        }


        /* =========================================================
           GLOSSY BUTTONS
           ========================================================= */

        .checkout-btn,
        .browse-btn,
        .nav-link-cta {

            position: relative;

            overflow: hidden;

            background: var(--accent-gradient);

            color: #fff;

            box-shadow: var(--shadow-accent);
        }

        .checkout-btn::before,
        .browse-btn::before,
        .nav-link-cta::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            background: var(--gloss);
        }

        .checkout-btn::after,
        .browse-btn::after,
        .nav-link-cta::after {

            content: "";

            position: absolute;

            top: -20%;
            bottom: -20%;

            left: -60%;

            width: 40%;

            pointer-events: none;

            transform: skewX(-22deg);

            background:
                linear-gradient(
                    90deg,
                    transparent,
                    rgba(255,255,255,.55),
                    transparent
                );

            transition: left .7s var(--ease);
        }

        .checkout-btn:hover::after,
        .browse-btn:hover::after,
        .nav-link-cta:hover::after {

            left: 130%;
        }


        /* =========================================================
           PAGE
           ========================================================= */

        .footer {

            margin-top: 50px;

            padding: 30px 20px;

            text-align: center;

            color: var(--label-3);

            font-size: 13px;
        }

        .cart-header {

            position: relative;

            padding: 44px 0 64px;

            overflow: hidden;
        }

        .cart-header-inner {

            position: relative;

            z-index: 1;

            width: 88%;

            max-width: 1250px;

            margin: 0 auto;
        }

        .cart-kicker {

            color: var(--accent-solid);

            font-size: 13px;

            font-weight: 800;

            letter-spacing: .08em;

            text-transform: uppercase;

            margin-bottom: 8px;
        }

        .cart-title {

            display: inline-block;

            font-size: 42px;

            font-weight: 800;

            letter-spacing: -.03em;

            margin-bottom: 7px;

            background:
                linear-gradient(
                    100deg,
                    var(--a1),
                    var(--a2),
                    var(--a3),
                    var(--t2),
                    var(--a2),
                    var(--a1)
                );

            background-size: 260% 100%;

            -webkit-background-clip: text;

            background-clip: text;

            -webkit-text-fill-color: transparent;

            animation: titleFlow 9s linear infinite;
        }

        .cart-subtitle {

            color: var(--label-2);

            font-size: 15.5px;

            line-height: 1.5;
        }

        .container {

            width: 88%;

            max-width: 1250px;

            margin: 0 auto;
        }

        .back-row {
            margin-bottom: 20px;
        }

        .back-link {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            text-decoration: none;

            color: var(--accent-solid);

            font-size: 14px;

            font-weight: 600;

            transition: opacity .2s ease;
        }

        .back-link:hover {
            opacity: .75;
        }

        .cart-layout {

            display: grid;

            grid-template-columns:
                minmax(0,1.65fr)
                minmax(310px,.75fr);

            gap: 22px;

            align-items: start;
        }

        .glass-card {

            border-radius: var(--r-xl);

            overflow: hidden;
        }

        .card-header {

            position: relative;

            z-index: 1;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            padding: 21px 22px;

            border-bottom: .5px solid var(--separator);
        }

        .card-title {

            font-size: 19px;

            font-weight: 750;

            letter-spacing: -.015em;
        }

        .item-count {

            padding: 5px 11px;

            border-radius: var(--r-full);

            background: var(--accent-tint);

            color: var(--accent-solid);

            font-size: 11.5px;

            font-weight: 750;

            border: 1px solid rgba(255,46,99,.16);

            box-shadow:
                inset 0 1px 0 rgba(255,255,255,.5);
        }

        .item-list {

            position: relative;

            z-index: 1;

            display: flex;

            flex-direction: column;

            gap: 12px;

            padding: 18px;
        }

        .cart-item {

            display: flex;

            align-items: center;

            gap: 16px;

            padding: 14px;

            border-radius: 20px;

            background: var(--glass-soft);

            border: 1px solid var(--glass-border);

            box-shadow: var(--glass-inset);

            transition:
                transform .45s var(--spring),
                box-shadow .3s ease,
                background .3s ease;
        }

        .cart-item:hover {

            transform: translateY(-2px);

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow);
        }

        .item-thumb {

            width: 74px;

            height: 74px;

            flex-shrink: 0;

            border-radius: 18px;

            overflow: hidden;

            background: var(--accent-tint);

            box-shadow:
                0 6px 16px rgba(60,40,120,.18),
                inset 0 0 0 1px rgba(255,255,255,.4);
        }

        .item-thumb img {

            width: 100%;

            height: 100%;

            display: block;

            object-fit: cover;
        }

        .item-main {

            flex: 1;

            min-width: 0;
        }

        .item-name {

            font-size: 15.5px;

            font-weight: 700;

            margin-bottom: 5px;

            overflow: hidden;

            text-overflow: ellipsis;

            white-space: nowrap;
        }

        .item-price {

            color: var(--label-2);

            font-size: 13px;
        }

        .item-price strong {

            color: var(--label);

            font-weight: 700;
        }

        .quantity-form {

            display: flex;

            align-items: center;

            flex-shrink: 0;
        }

        .stepper {

            display: inline-flex;

            align-items: center;

            overflow: hidden;

            border-radius: 14px;

            background: var(--accent-tint);

            border: 1px solid rgba(255,46,99,.2);

            box-shadow:
                inset 0 1px 0 rgba(255,255,255,.5);
        }

        .step-btn {

            width: 36px;

            height: 36px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border: none;

            background: transparent;

            color: var(--accent-solid);

            cursor: pointer;

            font-size: 18px;

            font-weight: 700;

            transition:
                background .18s ease,
                color .18s ease;
        }

        .step-btn:hover {

            color: #fff;

            background: var(--accent-gradient);
        }

        .step-value {

            width: 32px;

            border: none;

            outline: none;

            background: transparent;

            text-align: center;

            color: var(--label);

            font-size: 13px;

            font-weight: 800;
        }

        .item-total {

            min-width: 82px;

            text-align: right;

            font-size: 15px;

            font-weight: 800;
        }

        .remove-btn {

            width: 36px;

            height: 36px;

            flex-shrink: 0;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border-radius: 11px;

            color: var(--danger);

            background: var(--danger-bg);

            border: 1px solid var(--glass-border);

            box-shadow: var(--glass-inset);

            text-decoration: none;

            transition:
                transform .35s var(--spring),
                filter .18s ease;
        }

        .remove-btn:hover {

            transform: translateY(-1px) scale(1.06);

            filter: brightness(.97);
        }

        .items-footer {

            position: relative;

            z-index: 1;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            padding: 18px 22px;

            border-top: .5px solid var(--separator);
        }

        .continue-link {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            color: var(--accent-solid);

            text-decoration: none;

            font-size: 13.5px;

            font-weight: 700;
        }

        .clear-link {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            color: var(--danger);

            text-decoration: none;

            font-size: 13.5px;

            font-weight: 650;
        }


        /* =========================================================
           SUMMARY
           ========================================================= */

        .summary-card {

            position: sticky;

            top: 84px;

            padding: 22px;
        }

        .summary-card > * {

            position: relative;

            z-index: 1;
        }

        .summary-title {

            font-size: 20px;

            font-weight: 800;

            letter-spacing: -.018em;

            margin-bottom: 22px;
        }

        .summary-row {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            padding: 10px 0;

            color: var(--label-2);

            font-size: 14px;
        }

        .summary-row strong {

            color: var(--label);

            font-weight: 700;
        }

        .summary-divider {

            height: 1px;

            background: var(--separator);

            margin: 8px 0;
        }

        .summary-total {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            padding: 18px 0 20px;
        }

        .summary-total span:first-child {

            font-size: 16px;

            font-weight: 750;
        }

        .summary-total span:last-child {

            font-size: 26px;

            font-weight: 850;

            letter-spacing: -.025em;

            background: var(--accent-gradient);

            -webkit-background-clip: text;

            background-clip: text;

            -webkit-text-fill-color: transparent;
        }

        .checkout-btn {

            width: 100%;

            min-height: 52px;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            border-radius: 16px;

            text-decoration: none;

            font-size: 15px;

            font-weight: 750;

            transition:
                transform .35s var(--spring),
                filter .2s ease;
        }

        .checkout-btn:hover {

            filter: brightness(1.07);

            transform: translateY(-1px);
        }

        .checkout-btn svg {

            position: relative;
        }

        .secure-note {

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 6px;

            margin-top: 15px;

            color: var(--label-3);

            font-size: 11.5px;
        }


        /* =========================================================
           EMPTY CART
           ========================================================= */

        .empty-card {

            width: 88%;

            max-width: 760px;

            margin: 15px auto 70px;

            padding: 70px 25px;

            text-align: center;

            border-radius: 34px;
        }

        .empty-card > * {

            position: relative;

            z-index: 1;
        }

        .empty-icon {

            width: 76px;

            height: 76px;

            margin: 0 auto 20px;

            display: grid;

            place-items: center;

            border-radius: 24px;

            color: #fff;

            background: var(--accent-gradient);

            box-shadow: var(--shadow-accent);
        }

        .empty-card h2 {

            font-size: 25px;

            font-weight: 800;

            margin-bottom: 8px;
        }

        .empty-card p {

            max-width: 430px;

            margin: 0 auto 24px;

            color: var(--label-2);

            font-size: 14.5px;

            line-height: 1.55;
        }

        .browse-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            min-height: 48px;

            padding: 0 20px;

            border-radius: 15px;

            text-decoration: none;

            font-size: 14px;

            font-weight: 750;
        }


        /* =========================================================
           RESPONSIVE - TABLET
           ========================================================= */

        @media (max-width: 900px) {

            .cart-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }

            .nav-links .nav-link:not(.nav-link-cta),
            .nav-links .cart-nav {
                display: none;
            }

            .nav-links .nav-link-cta {
                display: inline-flex;
            }
        }


        /* =========================================================
           RESPONSIVE - MOBILE
           ========================================================= */

        @media (max-width: 650px) {

            body {
                padding-bottom: 104px;
            }

            .navbar {
                padding: 8px 10px 0;
            }

            .nav-inner {

                padding: 0 8px 0 14px;

                height: 54px;
            }

            .container,
            .cart-header-inner {

                width: 90%;
            }

            .cart-header {

                padding: 30px 0 54px;
            }

            .cart-title {

                font-size: 33px;
            }

            .cart-subtitle {

                font-size: 14px;
            }

            .cart-layout {

                gap: 16px;
            }

            .item-list {

                padding: 12px;
            }

            .cart-item {

                display: grid;

                grid-template-columns:
                    58px minmax(0,1fr);

                gap: 12px;

                align-items: center;
            }

            .item-thumb {

                width: 58px;

                height: 58px;
            }

            .quantity-form {

                grid-column: 1 / -1;

                justify-content: space-between;

                width: 100%;

                padding-top: 8px;

                border-top: .5px solid var(--separator);
            }

            .item-total {

                margin-left: auto;

                min-width: auto;
            }

            .remove-btn {

                grid-column: 2;

                justify-self: end;

                margin-top: -45px;
            }

            .items-footer {

                flex-direction: column;

                align-items: stretch;
            }

            .continue-link,
            .clear-link {

                justify-content: center;
            }

            .summary-card {

                padding: 19px;
            }

            .empty-card {

                width: 90%;

                padding: 55px 20px;

                border-radius: 26px;
            }

            .aqua i:nth-child(4) {
                display: none;
            }

            .tab-bar {

                display: flex;

                justify-content: space-around;

                align-items: center;

                position: fixed;

                left: 12px;

                right: 12px;

                z-index: 100;

                height: 64px;

                padding: 0 6px;

                bottom:
                    calc(
                        10px +
                        env(safe-area-inset-bottom,0px)
                    );

                border-radius: 30px;
            }
        }


        /* =========================================================
           REDUCED MOTION
           ========================================================= */

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {

                animation-duration: .01ms !important;

                animation-iteration-count: 1 !important;

                transition-duration: .01ms !important;

                scroll-behavior: auto !important;
            }

            .aqua i {
                animation: none !important;
            }
        }

    </style>

</head>


<body>


<!-- =========================================================
     AURORA BACKGROUND
     ========================================================= -->

<div class="aqua" aria-hidden="true">

    <i></i>
    <i></i>
    <i></i>
    <i></i>

</div>


<!-- =========================================================
     NAVBAR
     ========================================================= -->

<header class="navbar">

    <div class="nav-inner">

        <a href="restaurant" class="brand">

            <span class="brand-mark">F</span>

            <span class="brand-name">
                Foodwala
            </span>

        </a>


        <nav class="nav-links">

            <a
                href="restaurant"
                class="nav-link"
            >
                Restaurants
            </a>


            <a
                href="orders.jsp"
                class="nav-link"
            >
                Orders
            </a>


            <a
                href="cart?action=view"
                class="cart-nav is-current"
            >

                <svg
                    width="17"
                    height="17"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="1.9"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >

                    <path d="M6 8h12l1 13H5L6 8z"></path>

                    <path d="M9 8a3 3 0 0 1 6 0"></path>

                </svg>

                Cart

                <% if (totalItems > 0) { %>

                    <span class="cart-badge">
                        <%= totalItems %>
                    </span>

                <% } %>

            </a>


            <%
    if (loggedInUserId != null) {
%>

    <a href="profile"
       class="profile-nav"
       aria-label="My Profile"
       title="My Profile">

        <svg viewBox="0 0 24 24"
             fill="none"
             stroke="currentColor"
             stroke-width="2"
             stroke-linecap="round"
             stroke-linejoin="round">

            <circle cx="12" cy="8" r="4"></circle>

            <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"></path>

        </svg>

    </a>

<%
    } else {
%>

    <a href="login.jsp"
       class="nav-link nav-link-cta">
        Login
    </a>

<%
    }
%>

        </nav>

    </div>

</header>


<!-- =========================================================
     CART HEADER
     ========================================================= -->

<section class="cart-header">

    <div class="cart-header-inner">

        <div class="cart-kicker">
            YOUR ORDER
        </div>

        <h1 class="cart-title">
            Your Cart
        </h1>

        <p class="cart-subtitle">
            Review your favourite dishes before checkout.
        </p>

    </div>


    <div
        class="wave b"
        aria-hidden="true"
    ></div>


    <div
        class="wave"
        aria-hidden="true"
    ></div>

</section>


<%

if (cart == null || cart.isEmpty()) {

%>


<!-- =========================================================
     EMPTY CART
     ========================================================= -->

<section class="empty-card">

    <div class="empty-icon">

        <svg
            width="38"
            height="38"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="1.7"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <path d="M6 8h12l1 13H5L6 8z"></path>

            <path d="M9 8a3 3 0 0 1 6 0"></path>

        </svg>

    </div>


    <h2>
        Your cart is empty
    </h2>


    <p>
        Discover delicious dishes from our restaurants
        and start building your order.
    </p>


    <a
        href="restaurant"
        class="browse-btn"
    >

        <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <path d="M5 12h14"></path>

            <polyline points="13 6 19 12 13 18"></polyline>

        </svg>

        Browse Restaurants

    </a>

</section>


<%

} else {

%>


<!-- =========================================================
     CART CONTENT
     ========================================================= -->

<main class="container">


    <div class="back-row">

        <a
            href="restaurant"
            class="back-link"
        >

            <svg
                width="15"
                height="15"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2.4"
                stroke-linecap="round"
                stroke-linejoin="round"
            >

                <polyline points="15 18 9 12 15 6"></polyline>

            </svg>

            Continue Shopping

        </a>

    </div>


    <div class="cart-layout">


        <!-- =====================================================
             ITEMS
             ===================================================== -->

        <section class="glass-card items-card">


            <div class="card-header">

                <div class="card-title">
                    Your Items
                </div>


                <div class="item-count">

                    <%= totalItems %>

                    <%= totalItems == 1 ? "Item" : "Items" %>

                </div>

            </div>


            <div class="item-list">

                <%

                for (CartItem item : cart) {

                %>


                <div class="cart-item">


                    <!-- ITEM IMAGE -->

                    <div class="item-thumb">

                        <img
                            src="<%= esc(item.getImagePath()) %>"
                            alt="<%= esc(item.getItemName()) %>"
                            loading="lazy"
                        >

                    </div>


                    <!-- ITEM DETAILS -->

                    <div class="item-main">

                        <div class="item-name">

                            <%= esc(item.getItemName()) %>

                        </div>


                        <div class="item-price">

                            ₹<%= String.format("%.2f", item.getPrice()) %>

                            ×

                            <strong>
                                <%= item.getQuantity() %>
                            </strong>

                        </div>

                    </div>


                    <!-- =================================================
                         QUANTITY
                         ================================================= -->

                    <form
                        action="cart"
                        method="get"
                        class="quantity-form"
                    >

                        <input
                            type="hidden"
                            name="action"
                            value="update"
                        >


                        <input
                            type="hidden"
                            name="menuId"
                            value="<%= item.getMenuId() %>"
                        >


                        <div class="stepper">

                            <button
                                type="button"
                                class="step-btn"
                                onclick="stepQty(this, -1)"
                                aria-label="Decrease quantity"
                            >
                                −
                            </button>


                            <input
                                type="text"
                                class="step-value"
                                name="quantity"
                                value="<%= item.getQuantity() %>"
                                readonly
                            >


                            <button
                                type="button"
                                class="step-btn"
                                onclick="stepQty(this, 1)"
                                aria-label="Increase quantity"
                            >
                                +
                            </button>

                        </div>

                    </form>


                    <!-- =================================================
                         TOTAL
                         ================================================= -->

                    <div class="item-total">

                        ₹<%= String.format("%.2f", item.getTotalAmount()) %>

                    </div>


                    <!-- =================================================
                         REMOVE
                         ================================================= -->

                    <a
                        href="cart?action=remove&menuId=<%= item.getMenuId() %>"
                        class="remove-btn"
                        aria-label="Remove item"
                    >

                        <svg
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                        >

                            <polyline points="3 6 5 6 21 6"></polyline>

                            <path d="M19 6l-1 14H6L5 6"></path>

                            <path d="M10 11v6"></path>

                            <path d="M14 11v6"></path>

                            <path d="M9 6V4h6v2"></path>

                        </svg>

                    </a>


                </div>


                <%

                }

                %>

            </div>


            <!-- =====================================================
                 ITEMS FOOTER
                 ===================================================== -->

            <div class="items-footer">


                <a
                    href="restaurant"
                    class="continue-link"
                >

                    <svg
                        width="15"
                        height="15"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2.3"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >

                        <line
                            x1="19"
                            y1="12"
                            x2="5"
                            y2="12"
                        ></line>

                        <polyline points="12 19 5 12 12 5"></polyline>

                    </svg>

                    Add more items

                </a>


                <a
                    href="cart?action=clear"
                    class="clear-link"
                    onclick="return confirmClearCart();"
                >

                    <svg
                        width="15"
                        height="15"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >

                        <polyline points="3 6 5 6 21 6"></polyline>

                        <path d="M19 6l-1 14H6L5 6"></path>

                    </svg>

                    Clear Cart

                </a>

            </div>


        </section>


        <!-- =====================================================
             SUMMARY
             ===================================================== -->

        <aside class="glass-card summary-card">


            <div class="summary-title">
                Order Summary
            </div>


            <div class="summary-row">

                <span>
                    Items
                </span>

                <strong>
                    <%= totalItems %>
                </strong>

            </div>


            <div class="summary-row">

                <span>
                    Subtotal
                </span>

                <strong>
                    ₹<%= String.format("%.2f", subtotal) %>
                </strong>

            </div>


            <div class="summary-row">

                <span>
                    Delivery
                </span>

                <strong>
                    Free
                </strong>

            </div>


            <div class="summary-divider"></div>


            <div class="summary-total">

                <span>
                    Total
                </span>

                <span>
                    ₹<%= String.format("%.2f", grandTotal) %>
                </span>

            </div>


            <a
                href="checkout"
                class="checkout-btn"
            >

                Proceed to Checkout


                <svg
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2.5"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >

                    <path d="M5 12h14"></path>

                    <polyline points="13 6 19 12 13 18"></polyline>

                </svg>

            </a>


            <div class="secure-note">

                <svg
                    width="13"
                    height="13"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >

                    <rect
                        x="5"
                        y="10"
                        width="14"
                        height="11"
                        rx="2"
                    ></rect>

                    <path d="M8 10V7a4 4 0 0 1 8 0v3"></path>

                </svg>

                Secure checkout

            </div>

        </aside>


    </div>

</main>


<%

}

%>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<footer class="footer">

    © 2026 Foodwala. All rights reserved.

</footer>


<!-- =========================================================
     MOBILE TAB BAR
     ========================================================= -->

<nav class="tab-bar">


    <!-- HOME -->

    <a
        href="restaurant"
        class="tab-item"
    >

        <svg
            width="22"
            height="22"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <path d="M3 10.5 12 3l9 7.5"></path>

            <path d="M5 9.5V21h14V9.5"></path>

        </svg>

        Home

    </a>


    <!-- RESTAURANTS -->

    <a
        href="restaurant"
        class="tab-item"
    >

        <svg
            width="22"
            height="22"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <path d="M3 3v7a2 2 0 0 0 2 2h1v9"></path>

            <path d="M9 3v18"></path>

            <path d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9"></path>

        </svg>

        Restaurants

    </a>


    <!-- CART -->

    <a
        href="cart?action=view"
        class="tab-item is-active"
    >

        <span class="tab-cart-wrap">

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="1.9"
                stroke-linecap="round"
                stroke-linejoin="round"
            >

                <path d="M6 8h12l1 13H5L6 8z"></path>

                <path d="M9 8a3 3 0 0 1 6 0"></path>

            </svg>


            <% if (totalItems > 0) { %>

                <span class="tab-cart-badge">
                    <%= totalItems %>
                </span>

            <% } %>

        </span>

        Cart

    </a>


    <!-- LOGIN -->

    <a
        href="#"
        class="tab-item"
    >

        <svg
            width="22"
            height="22"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <circle
                cx="12"
                cy="8"
                r="4"
            ></circle>

            <path d="M4 21c0-4 3.5-7 8-7s8 3 8 7"></path>

        </svg>

        Login

    </a>


</nav>


<script>

    /* =========================================================
       CART QUANTITY
       ========================================================= */

    function stepQty(button, delta) {

        var form =
            button.closest(".quantity-form");

        if (!form) {
            return;
        }


        var input =
            form.querySelector(".step-value");

        if (!input) {
            return;
        }


        var current =
            parseInt(input.value, 10);

        if (isNaN(current)) {
            current = 1;
        }


        var next =
            current + delta;


        if (next < 1) {

            var cartItem =
                button.closest(".cart-item");

            var removeLink =
                cartItem
                    ? cartItem.querySelector(".remove-btn")
                    : null;


            if (removeLink) {

                window.location.href =
                    removeLink.getAttribute("href");
            }

            return;
        }


        input.value = next;

        form.submit();
    }


    /* =========================================================
       CLEAR CART
       ========================================================= */

    function confirmClearCart() {

        return confirm(
            "Are you sure you want to clear your cart?"
        );
    }


    /* =========================================================
       NAVBAR SCROLL EFFECT
       ========================================================= */

    window.addEventListener("scroll", function () {

        var navbar =
            document.querySelector(".navbar");

        if (!navbar) {
            return;
        }

        if (window.scrollY > 12) {

            navbar.classList.add("scrolled");

        } else {

            navbar.classList.remove("scrolled");
        }

    });


    /* =========================================================
       SIMPLE BUTTON PRESS
       ========================================================= */

    document.addEventListener(
        "click",
        function(event) {

            var target =
                event.target.closest(
                    ".checkout-btn, .browse-btn, .continue-link"
                );

            if (!target) {
                return;
            }


            target.style.transform =
                "scale(0.985)";


            setTimeout(function() {

                target.style.transform = "";

            }, 100);

        }
    );

</script>


</body>

</html>