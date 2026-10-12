<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.CartItem"%>

<%!
    /**
     * HTML escape helper (XSS protection)
     */
    private static String esc(Object o) {
        if (o == null) return "";

        String s = String.valueOf(o);
        StringBuilder b = new StringBuilder(s.length() + 16);

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);

            switch (c) {
                case '&':
                    b.append("&amp;");
                    break;
                case '<':
                    b.append("&lt;");
                    break;
                case '>':
                    b.append("&gt;");
                    break;
                case '"':
                    b.append("&quot;");
                    break;
                case '\'':
                    b.append("&#39;");
                    break;
                default:
                    b.append(c);
            }
        }

        return b.toString();
    }
%>

<%
    Integer loggedInUserId = (Integer) session.getAttribute("userId");

    @SuppressWarnings("unchecked")
    List<CartItem> cart =
            (List<CartItem>) session.getAttribute("cart");

    int cartCount = 0;

    if (cart != null) {
        for (CartItem item : cart) {
            cartCount += item.getQuantity();
        }
    }

    String navActive = "login";

    String error = request.getParameter("error");
    String errorText = null;

    if ("empty".equals(error)) {
        errorText = "Please fill in all the fields.";
    } else if ("password".equals(error)) {
        errorText = "Passwords do not match.";
    } else if ("email".equals(error)) {
        errorText = "An account with this email already exists.";
    }
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

    <title>Foodwala - Create Account</title>

    <script>
        document.documentElement.className += ' js';
    </script>

    <style>

        /* =========================================================
           FOODWALA - SHARED GLOSSY LIQUID GLASS
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
                linear-gradient(
                    135deg,
                    var(--t1),
                    var(--t2)
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

            --field-bg: rgba(255,255,255,.6);

            --r-xl: 28px;
            --r-lg: 18px;
            --r-md: 14px;
            --r-full: 999px;

            --spring: cubic-bezier(.34,1.56,.64,1);
            --ease: cubic-bezier(.22,.61,.36,1);
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

                --toast-bg: rgba(246,244,251,.92);
                --toast-fg: #1B1726;

                --gloss:
                    linear-gradient(
                        180deg,
                        rgba(255,255,255,.34) 0%,
                        rgba(255,255,255,.08) 48%,
                        rgba(255,255,255,0) 50%
                    );

                --field-bg: rgba(255,255,255,.06);
            }
        }


        /* =========================================================
           BACKDROP FALLBACK
           ========================================================= */

        @supports not (
            (backdrop-filter: blur(1px)) or
            (-webkit-backdrop-filter: blur(1px))
        ) {

            :root {
                --glass: rgba(255,255,255,.95);
                --glass-strong: #fff;
            }

            @media (prefers-color-scheme: dark) {
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

            min-height: 100vh;
            padding-bottom: 40px;

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
           GLASS SURFACES
           ========================================================= */

        .glass,
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

        .glass,
        .nav-inner,
        .tab-bar {
            position: relative;
        }

        .glass::before,
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

        .nav-link.is-active,
        .cart-nav.is-active {
            color: var(--label);
        }

        .nav-pill {
            position: absolute;
            inset: 0;

            z-index: -1;

            border-radius: inherit;

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                0 3px 10px rgba(60,40,120,.12);
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

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60,40,120,.12);

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

        .profile-nav:hover,
        .profile-nav.is-active {
            color: #fff;
            background: var(--accent-gradient);
            box-shadow: var(--shadow-accent);
        }

        .profile-nav:hover {
            transform: scale(1.08);
        }

        .profile-nav:active {
            transform: scale(.94);
        }


        /* =========================================================
           BUTTONS
           ========================================================= */

        .btn {
            position: relative;
            overflow: hidden;

            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;

            min-height: 50px;
            padding: 0 24px;

            border: none;
            border-radius: var(--r-md);

            font-family: inherit;
            font-size: 15px;
            font-weight: 700;

            text-decoration: none;
            cursor: pointer;

            background: var(--accent-gradient);
            color: #fff;

            box-shadow: var(--shadow-accent);

            transition:
                filter .2s ease,
                transform .35s var(--spring),
                box-shadow .3s ease;
        }

        .btn::before {
            content: "";
            position: absolute;
            inset: 0;

            border-radius: inherit;
            pointer-events: none;

            background: var(--gloss);
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

            background:
                linear-gradient(
                    90deg,
                    transparent,
                    rgba(255,255,255,.55),
                    transparent
                );

            transition: left .7s var(--ease);
        }

        .btn:hover::after {
            left: 130%;
        }

        .btn:hover {
            filter: brightness(1.07);
        }

        .btn:active {
            transform: scale(.96);
        }

        .btn-block {
            width: 100%;
        }


        /* =========================================================
           PAGE
           ========================================================= */

        .page {
            width: 88%;
            max-width: 1000px;
            margin: 34px auto 0;
        }

        .page.narrow {
            max-width: 520px;
        }

        .page-head {
            margin-bottom: 24px;
        }

        .large-title {
            display: inline-block;

            font-size: 42px;
            font-weight: 800;

            letter-spacing: -.03em;

            margin-bottom: 6px;

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

        .title-subtitle {
            color: var(--label-2);
            font-size: 15.5px;
        }

        .card {
            border-radius: var(--r-xl);
            padding: 32px;
        }


        /* =========================================================
           FORM
           ========================================================= */

        .field {
            margin-bottom: 16px;
        }

        .field label {
            display: block;

            margin-bottom: 7px;

            font-size: 13.5px;
            font-weight: 650;

            color: var(--label-2);
        }

        .field input,
        .field textarea {
            width: 100%;

            padding: 14px 16px;

            border-radius: var(--r-md);

            border: 1px solid var(--glass-border);

            background: var(--field-bg);
            color: var(--label);

            font-family: inherit;
            font-size: 15px;

            outline: none;

            -webkit-backdrop-filter: blur(12px);
            backdrop-filter: blur(12px);

            box-shadow: var(--glass-inset);

            transition:
                box-shadow .3s ease,
                border-color .3s ease,
                transform .4s var(--spring);
        }

        .field textarea {
            min-height: 100px;
            resize: vertical;
            line-height: 1.5;
        }

        .field input::placeholder,
        .field textarea::placeholder {
            color: var(--label-3);
        }

        .field input:focus,
        .field textarea:focus {
            border-color: var(--a2);

            box-shadow:
                var(--glass-inset),
                0 0 0 4px var(--accent-tint);
        }


        /* =========================================================
           ALERT
           ========================================================= */

        .alert {
            display: flex;
            gap: 10px;
            align-items: center;

            padding: 13px 16px;

            border-radius: var(--r-md);

            margin-bottom: 18px;

            font-size: 14px;
            font-weight: 600;

            background: var(--danger-bg);
            color: var(--danger);

            border: 1px solid rgba(255,59,48,.18);
        }


        /* =========================================================
           AUTH FOOTER
           ========================================================= */

        .auth-foot {
            text-align: center;

            margin-top: 22px;

            color: var(--label-2);
            font-size: 14px;
        }

        .auth-foot a {
            color: var(--accent-solid);
            font-weight: 700;
            text-decoration: none;
        }

        .auth-foot a:hover {
            text-decoration: underline;
        }

        .back-link {
            display: block;

            text-align: center;

            margin-top: 14px;

            color: var(--label-3);

            font-size: 13px;

            text-decoration: none;
        }

        .back-link:hover {
            color: var(--accent-solid);
        }

        footer {
            margin-top: 56px;

            text-align: center;

            padding: 24px;

            color: var(--label-3);

            font-size: 12.5px;
        }


        /* =========================================================
           TOAST
           ========================================================= */

        .toast-host {
            position: fixed;

            top: 84px;
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

            border-radius: var(--r-full);

            font-size: 14px;
            font-weight: 600;

            -webkit-backdrop-filter: var(--blur);
            backdrop-filter: var(--blur);

            box-shadow:
                0 14px 34px rgba(0,0,0,.26),
                inset 0 1px 0 rgba(255,255,255,.2);

            animation: toastIn .55s var(--spring);
        }

        .toast.out {
            opacity: 0;

            transform:
                translateY(-10px)
                scale(.96);

            filter: blur(4px);

            transition: all .35s ease;
        }


        /* =========================================================
           RIPPLE
           ========================================================= */

        .rip {
            position: absolute;

            border-radius: 50%;

            pointer-events: none;

            transform: scale(0);

            z-index: 1;

            background:
                radial-gradient(
                    circle,
                    rgba(255,255,255,.7),
                    rgba(255,255,255,0) 68%
                );

            animation: rip .75s ease-out forwards;
        }


        /* =========================================================
           REVEAL
           ========================================================= */

        .js .reveal:not(.in) {
            opacity: 0;

            transform:
                translateY(26px)
                scale(.97);
        }

        .reveal.in {
            animation:
                reveal .8s var(--spring) backwards;

            animation-delay:
                calc(min(var(--i,0),10) * 70ms);
        }


        /* =========================================================
           MOBILE TAB BAR
           ========================================================= */

        .tab-bar {
            display: none;
        }

        .tab-item {
            position: relative;
            isolation: isolate;

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
        }

        .tab-pill {
            position: absolute;
            inset: 0;

            z-index: -1;

            border-radius: inherit;

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60,40,120,.14);
        }

        .tab-badge {
            position: absolute;

            top: -3px;
            right: 10px;

            min-width: 17px;
            height: 17px;

            padding: 0 4px;

            border-radius: 999px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: var(--accent-gradient);

            color: #fff;

            font-size: 9px;
            font-weight: 800;

            box-shadow: 0 0 0 2px var(--bg);
        }


        /* =========================================================
           KEYFRAMES
           ========================================================= */

        @keyframes flow {

            to {
                transform:
                    translate3d(7vmax,5vmax,0)
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

        @keyframes reveal {

            from {
                opacity: 0;

                transform:
                    translateY(26px)
                    scale(.97);

                filter: blur(6px);
            }
        }

        @keyframes toastIn {

            from {
                opacity: 0;

                transform:
                    translateY(-16px)
                    scale(.9);

                filter: blur(6px);
            }
        }

        @keyframes rip {

            to {
                transform: scale(1);
                opacity: 0;
            }
        }


        /* =========================================================
           RESPONSIVE
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

            .nav-links .nav-link:not(.nav-link-cta) {
                display: none;
            }

            .cart-text {
                display: none;
            }

            .page {
                width: 90%;
                margin-top: 22px;
            }

            .large-title {
                font-size: 32px;
            }

            .card {
                padding: 22px 18px;
            }

            .toast-host {
                top: 72px;
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


    <!-- =====================================================
         BACKGROUND
         ===================================================== -->

    <div class="aqua" aria-hidden="true">
        <i></i>
        <i></i>
        <i></i>
        <i></i>
    </div>


    <!-- =====================================================
         NAVBAR
         ===================================================== -->

    <header class="navbar" id="navbar">

        <div class="nav-inner">

            <a href="restaurant" class="brand">

                <span class="brand-mark">F</span>

                <span class="brand-name">
                    Foodwala
                </span>

            </a>


            <nav class="nav-links" aria-label="Primary">


                <!-- Home -->

                <a href="#"
                   class="nav-link"
                   data-soon>
                    Home
                </a>


                <!-- Restaurants -->

                <a href="restaurant"
                   class="nav-link <%= "restaurants".equals(navActive) ? "is-active" : "" %>">

                    <% if ("restaurants".equals(navActive)) { %>
                        <span class="nav-pill"></span>
                    <% } %>

                    Restaurants

                </a>


                <!-- Orders -->

                <a href="orders"
                   class="nav-link <%= "orders".equals(navActive) ? "is-active" : "" %>">

                    <% if ("orders".equals(navActive)) { %>
                        <span class="nav-pill"></span>
                    <% } %>

                    Orders

                </a>


                <!-- Cart -->

                <a href="cart?action=view"
                   class="cart-nav"
                   aria-label="Cart">

                    <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        aria-hidden="true">

                        <path d="M6 8h12l1 13H5L6 8z"/>
                        <path d="M9 8a3 3 0 0 1 6 0"/>

                    </svg>

                    <span class="cart-text">
                        Cart
                    </span>

                    <% if (cartCount > 0) { %>

                        <span class="cart-badge">
                            <%= cartCount %>
                        </span>

                    <% } %>

                </a>


                <!-- Profile / Login -->

                <% if (loggedInUserId != null) { %>

                    <a href="profile"
                       class="profile-nav <%= "profile".equals(navActive) ? "is-active" : "" %>"
                       aria-label="My Profile"
                       title="My Profile">

                        <svg
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round">

                            <circle cx="12" cy="8" r="4"></circle>

                            <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"></path>

                        </svg>

                    </a>

                <% } else { %>

                    <a href="login.jsp"
                       class="nav-link nav-link-cta">

                        Login

                    </a>

                <% } %>


            </nav>

        </div>

    </header>


    <!-- =====================================================
         MAIN
         ===================================================== -->

    <main class="page narrow">


        <!-- PAGE HEADER -->

        <div class="page-head reveal">

            <h1 class="large-title">
                Create account
            </h1>

            <p class="title-subtitle">
                Join Foodwala and start ordering great food
            </p>

        </div>


        <!-- REGISTER CARD -->

        <section
            class="card glass reveal"
            style="--i:1">


            <!-- SERVER ERROR -->

            <% if (errorText != null) { %>

                <div class="alert" role="alert">
                    <%= esc(errorText) %>
                </div>

            <% } %>


            <!-- CLIENT ERROR -->

            <div
                class="alert"
                id="clientError"
                role="alert"
                hidden>
            </div>


            <!-- REGISTER FORM -->

            <form
                action="register"
                method="post"
                id="registerForm">


                <!-- USERNAME -->

                <div class="field">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your name"
                        autocomplete="name"
                        required>

                </div>


                <!-- EMAIL -->

                <div class="field">

                    <label for="email">
                        Email
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="you@example.com"
                        autocomplete="email"
                        required>

                </div>


                <!-- PHONE -->

                <div class="field">

                    <label for="phone">
                        Phone number
                    </label>

                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        placeholder="10-digit mobile number"
                        pattern="[0-9]{10}"
                        maxlength="10"
                        inputmode="numeric"
                        autocomplete="tel"
                        required>

                </div>


                <!-- PASSWORD -->

                <div class="field">

                    <label for="password">
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="At least 6 characters"
                        minlength="6"
                        autocomplete="new-password"
                        required>

                </div>


                <!-- CONFIRM PASSWORD -->

                <div class="field">

                    <label for="confirmPassword">
                        Confirm password
                    </label>

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Re-enter your password"
                        minlength="6"
                        autocomplete="new-password"
                        required>

                </div>


                <!-- ADDRESS -->

                <div class="field">

                    <label for="address">
                        Delivery address
                    </label>

                    <textarea
                        id="address"
                        name="address"
                        placeholder="House no., street, area, city"
                        autocomplete="street-address"
                        required></textarea>

                </div>


                <!-- SUBMIT -->

                <button
                    type="submit"
                    class="btn btn-block">

                    Create account

                </button>


            </form>


            <!-- LOGIN LINK -->

            <p class="auth-foot">

                Already have an account?

                <a href="login.jsp">
                    Log in
                </a>

            </p>


            <!-- BACK -->

            <a href="restaurant"
               class="back-link">

                &larr; Back to restaurants

            </a>


        </section>

    </main>


    <!-- =====================================================
         FOOTER
         ===================================================== -->

    <footer>
        &copy; 2026 Foodwala. All rights reserved.
    </footer>


    <!-- =====================================================
         MOBILE NAVIGATION
         ===================================================== -->

    <nav class="tab-bar" aria-label="Mobile">


        <!-- HOME -->

        <a href="#"
           class="tab-item"
           data-soon>

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                aria-hidden="true">

                <path d="M3 10.5 12 3l9 7.5"/>
                <path d="M5 9.5V21h14V9.5"/>

            </svg>

            Home

        </a>


        <!-- RESTAURANTS -->

        <a
            href="restaurant"
            class="tab-item <%= "restaurants".equals(navActive) ? "is-active" : "" %>">

            <% if ("restaurants".equals(navActive)) { %>
                <span class="tab-pill"></span>
            <% } %>

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                aria-hidden="true">

                <path d="M3 3v7a2 2 0 0 0 2 2h1v9"/>
                <path d="M9 3v18"/>
                <path d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9"/>

            </svg>

            Restaurants

        </a>


        <!-- CART -->

        <a
            href="cart?action=view"
            class="tab-item">

            <% if (cartCount > 0) { %>

                <span class="tab-badge">
                    <%= cartCount %>
                </span>

            <% } %>

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                aria-hidden="true">

                <path d="M6 8h12l1 13H5L6 8z"/>
                <path d="M9 8a3 3 0 0 1 6 0"/>

            </svg>

            Cart

        </a>


        <!-- PROFILE / LOGIN -->

        <a
            href="<%= loggedInUserId != null ? "profile" : "login.jsp" %>"
            class="tab-item <%= ("profile".equals(navActive) || "login".equals(navActive)) ? "is-active" : "" %>">

            <% if ("profile".equals(navActive) || "login".equals(navActive)) { %>

                <span class="tab-pill"></span>

            <% } %>

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                aria-hidden="true">

                <path d="M20 21a8 8 0 0 0-16 0"/>
                <circle cx="12" cy="7" r="4"/>

            </svg>

            <%= loggedInUserId != null ? "Profile" : "Login" %>

        </a>


    </nav>


    <!-- =====================================================
         COMMON JAVASCRIPT
         ===================================================== -->

    <script>

        (function () {


            /* =================================================
               TOAST
               ================================================= */

            function toast(msg) {

                var host =
                    document.getElementById('toastHost');

                if (!host) {

                    host = document.createElement('div');

                    host.id = 'toastHost';

                    host.className = 'toast-host';

                    host.setAttribute('role', 'status');

                    host.setAttribute(
                        'aria-live',
                        'polite'
                    );

                    document.body.appendChild(host);
                }


                var t =
                    document.createElement('div');

                t.className = 'toast';

                t.textContent = msg;

                host.appendChild(t);


                setTimeout(function () {

                    t.classList.add('out');

                    setTimeout(function () {

                        t.remove();

                    }, 360);

                }, 2200);
            }


            window.fwToast = toast;


            /* =================================================
               COMING SOON LINKS
               ================================================= */

            document.addEventListener(
                'click',
                function (e) {

                    var a =
                        e.target.closest('a[data-soon]');

                    if (a) {

                        e.preventDefault();

                        toast('Coming soon');
                    }
                }
            );


            /* =================================================
               BUTTON RIPPLE
               ================================================= */

            document.addEventListener(
                'pointerdown',
                function (e) {

                    var t =
                        e.target.closest(
                            '.btn, .nav-link-cta'
                        );

                    if (!t) return;


                    var r =
                        t.getBoundingClientRect();

                    var s =
                        Math.max(
                            r.width,
                            r.height
                        ) * 2.4;


                    var sp =
                        document.createElement('span');

                    sp.className = 'rip';


                    sp.style.cssText =
                        'width:' + s + 'px;' +
                        'height:' + s + 'px;' +
                        'left:' +
                        (e.clientX - r.left - s / 2) +
                        'px;' +
                        'top:' +
                        (e.clientY - r.top - s / 2) +
                        'px';


                    t.appendChild(sp);


                    setTimeout(function () {

                        sp.remove();

                    }, 800);
                }
            );


            /* =================================================
               NAVBAR SCROLL
               ================================================= */

            var nav =
                document.getElementById('navbar');


            function onScroll() {

                if (nav) {

                    nav.classList.toggle(
                        'scrolled',
                        window.scrollY > 8
                    );
                }
            }


            window.addEventListener(
                'scroll',
                onScroll,
                { passive: true }
            );


            onScroll();


            /* =================================================
               REVEAL ANIMATION
               ================================================= */

            var io =
                ('IntersectionObserver' in window)
                ? new IntersectionObserver(
                    function (entries) {

                        entries.forEach(
                            function (en) {

                                if (en.isIntersecting) {

                                    en.target.classList.add('in');

                                    io.unobserve(en.target);
                                }
                            }
                        );
                    },
                    {
                        threshold: 0.08,
                        rootMargin:
                            '0px 0px -6% 0px'
                    }
                )
                : null;


            document
                .querySelectorAll('.reveal')
                .forEach(function (el) {

                    if (io) {
                        io.observe(el);
                    } else {
                        el.classList.add('in');
                    }
                });

        })();

    </script>


    <!-- =====================================================
         REGISTER VALIDATION
         ===================================================== -->

    <script>

        (function () {

            var f =
                document.getElementById('registerForm');

            var box =
                document.getElementById('clientError');


            /* =================================================
               FORM SUBMIT
               ================================================= */

            f.addEventListener(
                'submit',
                function (e) {


                    /* Password match */

                    if (
                        f.password.value !==
                        f.confirmPassword.value
                    ) {

                        e.preventDefault();

                        box.textContent =
                            'Passwords do not match.';

                        box.hidden = false;

                        f.confirmPassword.focus();

                        return;
                    }


                    /* Phone validation */

                    if (
                        !/^[0-9]{10}$/.test(
                            f.phone.value
                        )
                    ) {

                        e.preventDefault();

                        box.textContent =
                            'Please enter a valid 10-digit phone number.';

                        box.hidden = false;

                        f.phone.focus();

                        return;
                    }


                    /* Password length */

                    if (
                        f.password.value.length < 6
                    ) {

                        e.preventDefault();

                        box.textContent =
                            'Password must be at least 6 characters.';

                        box.hidden = false;

                        f.password.focus();

                        return;
                    }


                    box.hidden = true;

                }
            );


            /* =================================================
               PHONE INPUT
               ================================================= */

            f.phone.addEventListener(
                'input',
                function () {

                    this.value =
                        this.value.replace(
                            /\D/g,
                            ''
                        );
                }
            );


            /* =================================================
               CLEAR CLIENT ERROR WHEN USER TYPES
               ================================================= */

            f.addEventListener(
                'input',
                function () {

                    box.hidden = true;

                }
            );

        })();

    </script>


</body>

</html>