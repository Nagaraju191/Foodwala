<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.CartItem" %>

<%
    Integer loggedInUserId =
            (Integer) session.getAttribute("userId");
%>
<%!
    private static String esc(Object value) {
        if (value == null) {
            return "";
        }

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

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0, viewport-fit=cover"
    >

    <meta name="color-scheme" content="light dark">

    <meta
        name="theme-color"
        content="#F3EEFA"
        media="(prefers-color-scheme: light)"
    >

    <meta
        name="theme-color"
        content="#07060D"
        media="(prefers-color-scheme: dark)"
    >

    <title>Foodwala - Menu</title>


    <style>

        /* =========================================================
           FOODWALA - GLOSSY LIQUID GLASS
           ========================================================= */

        :root {
            --bg: #F3EEFA;

            --label: #1B1726;
            --label-2: #5A5468;
            --label-3: #75708A;

            --separator: rgba(60, 50, 90, .14);
            --hover: rgba(255, 255, 255, .6);

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

            --gold-gradient:
                linear-gradient(
                    135deg,
                    #FFE066 0%,
                    #FFB300 55%,
                    #FF8A00 100%
                );

            --accent-solid: #D61F52;
            --accent-tint: rgba(255, 46, 99, .12);
            --accent-glow: rgba(255, 46, 99, .38);

            --success: #0F8A45;
            --success-bg: rgba(20, 170, 90, .16);

            --danger: #E0342B;
            --danger-bg: rgba(255, 59, 48, .13);

            --glass: rgba(255, 255, 255, .52);
            --glass-strong: rgba(255, 255, 255, .78);
            --glass-soft: rgba(255, 255, 255, .28);

            --glass-border: rgba(255, 255, 255, .85);

            --glass-inset:
                inset 0 1.5px 0 rgba(255, 255, 255, 1),
                inset 0 -1px 0 rgba(255, 255, 255, .3),
                inset 0 0 22px rgba(255, 255, 255, .35);

            --glass-shadow:
                0 10px 34px rgba(60, 40, 120, .12),
                0 2px 6px rgba(60, 40, 120, .06);

            --glass-shadow-hover:
                0 22px 56px rgba(60, 40, 120, .2),
                0 4px 12px rgba(60, 40, 120, .08);

            --blur: blur(28px) saturate(200%);

            --toast-bg: rgba(27, 23, 38, .88);
            --toast-fg: #fff;

            --gloss:
                linear-gradient(
                    180deg,
                    rgba(255, 255, 255, .55) 0%,
                    rgba(255, 255, 255, .12) 48%,
                    rgba(255, 255, 255, 0) 50%
                );

            --shadow-accent:
                0 12px 26px var(--accent-glow),
                inset 0 1.5px 0 rgba(255, 255, 255, .6),
                inset 0 -3px 6px rgba(120, 0, 40, .22);

            --r-xl: 28px;
            --r-lg: 18px;
            --r-md: 14px;
            --r-full: 999px;

            --spring: cubic-bezier(.34, 1.56, .64, 1);
            --ease: cubic-bezier(.22, .61, .36, 1);

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

                --separator: rgba(255, 255, 255, .12);
                --hover: rgba(255, 255, 255, .1);

                --accent-solid: #FF7391;
                --accent-tint: rgba(255, 115, 145, .17);

                --success: #34D67A;
                --success-bg: rgba(52, 214, 122, .17);

                --danger: #FF7168;
                --danger-bg: rgba(255, 113, 104, .17);

                --glass: rgba(40, 36, 58, .5);
                --glass-strong: rgba(48, 43, 68, .76);
                --glass-soft: rgba(255, 255, 255, .06);

                --glass-border: rgba(255, 255, 255, .17);

                --glass-inset:
                    inset 0 1.5px 0 rgba(255, 255, 255, .22),
                    inset 0 -1px 0 rgba(255, 255, 255, .04),
                    inset 0 0 22px rgba(255, 255, 255, .04);

                --glass-shadow:
                    0 10px 34px rgba(0, 0, 0, .55),
                    0 2px 6px rgba(0, 0, 0, .3);

                --glass-shadow-hover:
                    0 22px 56px rgba(0, 0, 0, .65),
                    0 4px 12px rgba(0, 0, 0, .35);

                --toast-bg: rgba(246, 244, 251, .92);
                --toast-fg: #1B1726;

                --gloss:
                    linear-gradient(
                        180deg,
                        rgba(255, 255, 255, .34) 0%,
                        rgba(255, 255, 255, .08) 48%,
                        rgba(255, 255, 255, 0) 50%
                    );
            }
        }


        /* =========================================================
           FALLBACK
           ========================================================= */

        @supports not (
            (backdrop-filter: blur(1px))
            or (-webkit-backdrop-filter: blur(1px))
        ) {

            :root {
                --glass: rgba(255, 255, 255, .95);
                --glass-strong: #FFFFFF;
            }
        }

        @media (prefers-color-scheme: dark) {

            @supports not (
                (backdrop-filter: blur(1px))
                or (-webkit-backdrop-filter: blur(1px))
            ) {

                :root {
                    --glass: rgba(34, 31, 48, .96);
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

            padding-bottom: 110px;

            overflow-x: hidden;

            position: relative;
            isolation: isolate;
        }

        a {
            color: inherit;
        }

        button,
        input {
            font: inherit;
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
                42% 58% 63% 37%;

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

            position: relative;

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

        .nav-inner::before {
            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            z-index: 2;

            background:
                linear-gradient(
                    115deg,
                    rgba(255, 255, 255, .32) 0%,
                    rgba(255, 255, 255, 0) 32%
                );

            opacity: .7;
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
                inset 0 1.5px 0 rgba(255, 255, 255, .6),
                inset 0 -3px 6px rgba(120, 0, 40, .25);
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

            background: var(--glass-strong);

            box-shadow:
                var(--glass-inset),
                0 3px 10px rgba(60, 40, 120, .12);
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
                inset 0 1px 0 rgba(255, 255, 255, .5);
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


        /* =========================================================
           CART WARNING
           ========================================================= */

        .cart-warning {
            position: fixed;

            top: 88px;
            left: 50%;

            transform: translateX(-50%);

            z-index: 1000;

            width: min(650px, calc(100% - 30px));

            min-height: 76px;

            display: flex;

            align-items: center;

            gap: 14px;

            padding: 14px 16px;

            border-radius: 22px;

            background:
                linear-gradient(
                    135deg,
                    rgba(255, 248, 220, .92),
                    rgba(255, 239, 198, .78)
                );

            -webkit-backdrop-filter: blur(28px) saturate(180%);
            backdrop-filter: blur(28px) saturate(180%);

            border: 1px solid rgba(255, 184, 0, .38);

            box-shadow:
                0 18px 50px rgba(120, 80, 0, .18),
                inset 0 1.5px 0 rgba(255, 255, 255, .9);

            animation: cartWarningIn .45s var(--spring);

            color: #4A3200;
        }

        .cart-warning-icon {
            width: 44px;
            height: 44px;

            flex-shrink: 0;

            display: grid;
            place-items: center;

            border-radius: 15px;

            font-size: 21px;

            background:
                linear-gradient(
                    135deg,
                    #FFE066,
                    #FFB300
                );

            box-shadow:
                0 8px 20px rgba(255, 160, 0, .28),
                inset 0 1.5px 0 rgba(255, 255, 255, .8);
        }

        .cart-warning-content {
            flex: 1;
            min-width: 0;
        }

        .cart-warning-title {
            font-size: 14px;
            font-weight: 800;

            margin-bottom: 3px;
        }

        .cart-warning-text {
            font-size: 13px;
            line-height: 1.45;

            color: #6B4A00;
        }

        .cart-warning-close {
            width: 32px;
            height: 32px;

            flex-shrink: 0;

            border: none;

            border-radius: 50%;

            display: grid;
            place-items: center;

            cursor: pointer;

            font-size: 22px;
            line-height: 1;

            color: #6B4A00;

            background: rgba(255, 255, 255, .48);

            transition:
                transform .25s var(--spring),
                background .2s ease;
        }

        .cart-warning-close:hover {
            transform: scale(1.1);

            background: rgba(255, 255, 255, .75);
        }

        @keyframes cartWarningIn {
            from {
                opacity: 0;
                transform: translate(-50%, -20px) scale(.95);
            }

            to {
                opacity: 1;
                transform: translate(-50%, 0) scale(1);
            }
        }

        @media (prefers-color-scheme: dark) {

            .cart-warning {
                background:
                    linear-gradient(
                        135deg,
                        rgba(70, 55, 25, .94),
                        rgba(58, 43, 22, .9)
                    );

                border-color: rgba(255, 190, 0, .32);

                box-shadow:
                    0 20px 55px rgba(0, 0, 0, .5),
                    inset 0 1.5px 0 rgba(255, 255, 255, .16);

                color: #FFE9A3;
            }

            .cart-warning-text {
                color: #E9D38B;
            }

            .cart-warning-close {
                color: #FFE9A3;
                background: rgba(255, 255, 255, .08);
            }

            .cart-warning-close:hover {
                background: rgba(255, 255, 255, .14);
            }
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

            animation-duration: 24s, 14s;

            animation-direction: reverse, normal;
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
                0 4px 12px rgba(60, 40, 120, .14);
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

            box-shadow:
                0 0 0 2px var(--bg);
        }


        /* =========================================================
           KEYFRAMES
           ========================================================= */

        @keyframes flow {

            to {
                transform:
                    translate3d(7vmax, 5vmax, 0)
                    rotate(38deg)
                    scale(1.14);
            }
        }

        @keyframes morph {

            50% {
                border-radius:
                    60% 40% 32% 68%;
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

        @keyframes breathe {

            50% {
                transform: scale(1.35);
                opacity: .7;
            }
        }


        /* =========================================================
           GLASS SURFACES
           ========================================================= */

        .menu-card,
        .empty-message {

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

            position: relative;
        }

        .menu-card::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            z-index: 2;

            background:
                linear-gradient(
                    115deg,
                    rgba(255, 255, 255, .32) 0%,
                    rgba(255, 255, 255, 0) 32%
                );

            opacity: .7;
        }


        /* =========================================================
           GLOSSY BUTTONS
           ========================================================= */

        .add-button,
        .spotlight-tag {

            position: relative;

            overflow: hidden;

            background: var(--accent-gradient);

            color: #fff;

            box-shadow: var(--shadow-accent);
        }

        .add-button::before,
        .spotlight-tag::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            background: var(--gloss);
        }

        .add-button::after,
        .spotlight-tag::after {

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
                    rgba(255, 255, 255, .55),
                    transparent
                );

            transition: left .7s var(--ease);
        }

        .add-button:hover::after,
        .spotlight-tag:hover::after {
            left: 130%;
        }


        /* =========================================================
           PAGE HEADER
           ========================================================= */

        .footer {

            margin-top: 50px;

            padding: 28px 20px;

            text-align: center;

            color: var(--label-3);

            font-size: 13px;
        }

        .menu-header {

            position: relative;

            padding: 44px 0 64px;

            overflow: hidden;
        }

        .menu-header-inner {

            position: relative;

            z-index: 1;

            width: 88%;

            max-width: 1250px;

            margin: 0 auto;
        }

        .menu-kicker {

            color: var(--accent-solid);

            font-size: 13px;

            font-weight: 800;

            letter-spacing: .08em;

            text-transform: uppercase;

            margin-bottom: 8px;
        }

        .menu-title {

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

        .menu-subtitle {

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


        /* =========================================================
           SPOTLIGHT
           ========================================================= */

        .spotlight-label {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            font-size: 12px;

            font-weight: 800;

            letter-spacing: .08em;

            text-transform: uppercase;

            color: var(--accent-solid);

            margin-bottom: 10px;
        }

        .spotlight-label::before {

            content: "";

            width: 8px;

            height: 8px;

            border-radius: 50%;

            background: var(--accent-gradient);

            box-shadow:
                0 0 0 5px var(--accent-tint);

            animation: breathe 2.6s ease-in-out infinite;
        }

        .spotlight-card {

            position: relative;

            display: block;

            width: 100%;

            height: 290px;

            border-radius: 32px;

            overflow: hidden;

            margin-bottom: 44px;

            text-decoration: none;

            background: #221B2E;

            border: 1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);

            transition:
                transform .6s var(--spring),
                box-shadow .4s ease;
        }

        .spotlight-card:hover {

            transform: translateY(-5px);
        }

        .spotlight-image {

            width: 100%;

            height: 100%;

            object-fit: cover;

            display: block;

            transition: transform .7s var(--ease);
        }

        .spotlight-card:hover .spotlight-image {
            transform: scale(1.05);
        }

        .spotlight-overlay {

            position: absolute;

            inset: 0;

            display: flex;

            flex-direction: column;

            justify-content: flex-end;

            padding: 28px 32px;

            background:
                linear-gradient(
                    0deg,
                    rgba(20, 8, 30, .85) 0%,
                    rgba(20, 8, 30, .28) 58%,
                    rgba(255, 255, 255, .1) 100%
                );
        }

        .spotlight-tag {

            display: inline-flex;

            align-self: flex-start;

            padding: 7px 13px;

            border-radius: var(--r-full);

            font-size: 11.5px;

            font-weight: 800;

            margin-bottom: 10px;
        }

        .spotlight-name {

            color: #fff;

            font-size: 32px;

            line-height: 1.05;

            font-weight: 800;

            letter-spacing: -.03em;

            margin-bottom: 8px;
        }

        .spotlight-price {

            display: inline-flex;

            align-self: flex-start;

            padding: 6px 14px;

            border-radius: var(--r-full);

            color: #4A2A00;

            font-size: 15px;

            font-weight: 800;

            background: var(--gold-gradient);

            box-shadow:
                0 6px 14px rgba(255, 150, 0, .4),
                inset 0 1.5px 0 rgba(255, 255, 255, .7);
        }


        /* =========================================================
           SECTION
           ========================================================= */

        .section-header {

            display: flex;

            align-items: baseline;

            justify-content: space-between;

            gap: 15px;

            margin-bottom: 18px;
        }

        .section-title {

            font-size: 24px;

            font-weight: 800;

            letter-spacing: -.02em;
        }

        .menu-count {

            color: var(--label-3);

            font-size: 13.5px;
        }


        /* =========================================================
           MENU LIST
           ========================================================= */

        .menu-list {

            display: grid;

            grid-template-columns:
                repeat(
                    auto-fill,
                    minmax(300px, 1fr)
                );

            gap: 22px;

            padding-bottom: 35px;
        }

        .menu-card {

            display: flex;

            flex-direction: column;

            overflow: hidden;

            border-radius: var(--r-xl);

            transition:
                transform .55s var(--spring),
                box-shadow .35s ease,
                border-color .3s ease;
        }

        .menu-card:hover {

            transform:
                translateY(-7px)
                scale(1.012);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }

        .menu-card.in-cart {

            border-color:
                rgba(255, 46, 99, .4);

            box-shadow:
                var(--glass-inset),
                0 0 0 3px var(--accent-tint),
                var(--glass-shadow);
        }

        .menu-image-wrap {

            position: relative;

            height: 205px;

            overflow: hidden;

            margin: 8px 8px 0;

            border-radius: 21px;

            background:
                linear-gradient(
                    135deg,
                    var(--accent-tint),
                    rgba(99, 102, 241, .14)
                );

            box-shadow:
                inset 0 0 0 1px rgba(255, 255, 255, .35);
        }

        .menu-image-wrap::after {

            content: "";

            position: absolute;

            inset: 0;

            pointer-events: none;

            background:
                linear-gradient(
                    180deg,
                    rgba(255, 255, 255, .22),
                    transparent 38%,
                    rgba(0, 0, 0, .14)
                );
        }

        .menu-image {

            width: 100%;

            height: 100%;

            display: block;

            object-fit: cover;

            transition: transform .7s var(--ease);
        }

        .menu-card:hover .menu-image {
            transform: scale(1.08);
        }

        .menu-content {

            position: relative;

            z-index: 3;

            display: flex;

            flex-direction: column;

            flex: 1;

            padding: 16px 18px 18px;
        }

        .menu-top {

            display: flex;

            align-items: flex-start;

            justify-content: space-between;

            gap: 10px;

            margin-bottom: 10px;
        }

        .menu-name {

            flex: 1;

            min-width: 0;

            font-size: 18px;

            line-height: 1.2;

            font-weight: 750;

            letter-spacing: -.012em;
        }

        .avail-pill {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            flex-shrink: 0;

            padding: 5px 10px;

            border-radius: var(--r-full);

            font-size: 11px;

            font-weight: 750;

            border: 1px solid var(--glass-border);

            box-shadow: var(--glass-inset);
        }

        .avail-pill .dot {

            width: 6px;

            height: 6px;

            border-radius: 50%;
        }

        .avail-pill.is-available {

            color: var(--success);

            background: var(--success-bg);
        }

        .avail-pill.is-available .dot {

            background: var(--success);

            box-shadow:
                0 0 0 3px var(--success-bg);

            animation:
                breathe 2.4s ease-in-out infinite;
        }

        .avail-pill.is-unavailable {

            color: var(--danger);

            background: var(--danger-bg);
        }

        .avail-pill.is-unavailable .dot {

            background: var(--danger);

            box-shadow:
                0 0 0 3px var(--danger-bg);
        }

        .menu-description {

            color: var(--label-2);

            font-size: 13.5px;

            line-height: 1.55;

            min-height: 42px;

            display: -webkit-box;

            -webkit-line-clamp: 2;

            -webkit-box-orient: vertical;

            overflow: hidden;

            margin-bottom: 17px;
        }

        .menu-bottom {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 12px;

            margin-top: auto;

            padding-top: 14px;

            border-top: .5px solid var(--separator);
        }

        .menu-price {

            font-size: 20px;

            font-weight: 800;

            letter-spacing: -.015em;
        }

        .add-button {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 6px;

            min-width: 96px;

            padding: 11px 16px;

            border-radius: var(--r-md);

            text-decoration: none;

            font-size: 13.5px;

            font-weight: 750;

            transition:
                transform .35s var(--spring),
                filter .2s ease;
        }

        .add-button:hover {

            filter: brightness(1.07);

            transform: translateY(-1px);
        }

        .add-button:active {
            transform: scale(.95);
        }

        .quantity-control {

            display: inline-flex;

            align-items: center;

            overflow: hidden;

            border-radius: var(--r-md);

            background: var(--accent-tint);

            border: 1px solid rgba(255, 46, 99, .2);

            box-shadow:
                inset 0 1px 0 rgba(255, 255, 255, .5);
        }

        .quantity-btn {

            width: 36px;

            height: 36px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            text-decoration: none;

            color: var(--accent-solid);

            font-size: 18px;

            font-weight: 700;

            transition:
                background .18s ease,
                color .18s ease;
        }

        .quantity-btn:hover {

            color: #fff;

            background: var(--accent-gradient);
        }

        .quantity-value {

            min-width: 32px;

            text-align: center;

            font-size: 13px;

            font-weight: 800;
        }

        .disabled-button {

            border: none;

            padding: 11px 15px;

            border-radius: var(--r-md);

            color: var(--label-3);

            background: rgba(120, 120, 140, .18);

            box-shadow:
                inset 0 1px 0 rgba(255, 255, 255, .4);

            font-size: 13px;

            font-weight: 700;

            cursor: not-allowed;
        }


        /* =========================================================
           EMPTY MENU
           ========================================================= */

        .empty-message {

            text-align: center;

            padding: 70px 25px;

            border-radius: var(--r-xl);

            margin-bottom: 45px;

            color: var(--label-2);
        }

        .empty-icon {

            width: 66px;

            height: 66px;

            margin: 0 auto 17px;

            display: grid;

            place-items: center;

            border-radius: 22px;

            color: var(--accent-solid);

            background: var(--accent-tint);

            box-shadow:
                0 8px 22px var(--accent-glow),
                inset 0 1px 0 rgba(255, 255, 255, .5);
        }

        .empty-message h2 {

            color: var(--label);

            font-size: 23px;

            margin-bottom: 8px;
        }

        .empty-message p {

            font-size: 14px;

            line-height: 1.5;
        }


        /* =========================================================
           FLOATING CART
           ========================================================= */

        .cart-float-bar {

            position: fixed;

            left: 50%;

            bottom: 28px;

            transform: translateX(-50%);

            z-index: 90;

            width: min(520px, calc(100% - 32px));

            min-height: 68px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 18px;

            padding: 10px 12px 10px 20px;

            text-decoration: none;

            color: var(--label);

            border-radius: 24px;

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
                0 18px 45px rgba(20, 15, 40, .22);

            transition:
                transform .35s var(--spring),
                box-shadow .3s ease;
        }

        .cart-float-bar::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            background:
                linear-gradient(
                    115deg,
                    rgba(255, 255, 255, .35) 0%,
                    rgba(255, 255, 255, 0) 35%
                );

            opacity: .75;
        }

        .cart-float-bar:hover {

            transform:
                translateX(-50%)
                translateY(-4px);

            box-shadow:
                var(--glass-inset),
                0 24px 55px rgba(20, 15, 40, .28);
        }

        .cart-float-bar:active {

            transform:
                translateX(-50%)
                scale(.97);
        }

        .cart-float-info {

            position: relative;

            z-index: 2;

            display: flex;

            flex-direction: column;

            gap: 3px;

            min-width: 0;
        }

        .cart-float-count {

            color: var(--label);

            font-size: 14px;

            font-weight: 750;

            line-height: 1.2;
        }

        .cart-float-total {

            color: var(--accent-solid);

            font-size: 16px;

            font-weight: 850;

            line-height: 1.2;
        }

        .cart-float-btn {

            position: relative;

            z-index: 2;

            flex-shrink: 0;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            min-height: 44px;

            padding: 0 17px;

            border-radius: var(--r-md);

            color: #fff;

            background: var(--accent-gradient);

            box-shadow: var(--shadow-accent);

            font-size: 13.5px;

            font-weight: 750;

            transition:
                transform .3s var(--spring),
                filter .2s ease;
        }

        .cart-float-btn:hover {

            filter: brightness(1.08);

            transform: translateY(-1px);
        }

        .cart-float-btn svg {
            flex-shrink: 0;
        }


        /* =========================================================
           RESPONSIVE - TABLET
           ========================================================= */

        @media (max-width: 850px) {

            .nav-links .nav-link:not(.nav-link-cta),
            .nav-links .cart-nav {
                display: none;
            }

            .nav-links .nav-link-cta {
                display: inline-flex;
            }

            .menu-list {

                grid-template-columns:
                    repeat(
                        2,
                        minmax(0, 1fr)
                    );
            }

            .spotlight-card {
                height: 260px;
            }
        }


        /* =========================================================
           RESPONSIVE - MOBILE
           ========================================================= */

        @media (max-width: 650px) {

            body {
                padding-bottom: 130px;
            }

            .navbar {
                padding: 8px 10px 0;
            }

            .nav-inner {
                padding: 0 8px 0 14px;
                height: 54px;
            }

            .menu-header {
                padding: 30px 0 54px;
            }

            .menu-title {
                font-size: 33px;
            }

            .menu-subtitle {
                font-size: 14px;
            }

            .container,
            .menu-header-inner {
                width: 90%;
            }

            .menu-list {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .spotlight-card {
                height: 235px;
                border-radius: 24px;
            }

            .spotlight-overlay {
                padding: 22px;
            }

            .spotlight-name {
                font-size: 26px;
            }

            .menu-image-wrap {
                height: 215px;
            }

            .aqua i:nth-child(4) {
                display: none;
            }

            /* Warning on mobile */

            .cart-warning {
                top: 72px;

                width: calc(100% - 22px);

                min-height: auto;

                padding: 12px;

                border-radius: 19px;

                gap: 10px;
            }

            .cart-warning-icon {
                width: 39px;
                height: 39px;

                border-radius: 13px;

                font-size: 18px;
            }

            .cart-warning-title {
                font-size: 13px;
            }

            .cart-warning-text {
                font-size: 12px;
            }

            .cart-warning-close {
                width: 29px;
                height: 29px;

                font-size: 20px;
            }

            /* Floating cart above mobile navigation */

            .cart-float-bar {

                width: calc(100% - 24px);

                bottom: 88px;

                min-height: 62px;

                padding: 9px 10px 9px 16px;

                border-radius: 21px;
            }

            .cart-float-count {
                font-size: 13px;
            }

            .cart-float-total {
                font-size: 15px;
            }

            .cart-float-btn {

                min-height: 42px;

                padding: 0 14px;

                font-size: 12.5px;
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
                        env(safe-area-inset-bottom, 0px)
                    );

                border-radius: 30px;

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
                    var(--glass-shadow-hover);
            }

            .tab-bar::before {

                content: "";

                position: absolute;

                inset: 0;

                border-radius: inherit;

                pointer-events: none;

                background:
                    linear-gradient(
                        115deg,
                        rgba(255, 255, 255, .32),
                        transparent 32%
                    );

                opacity: .7;
            }

            .tab-item {

                position: relative;

                z-index: 2;
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


<%
    /* =========================================================
       CART DATA
       ========================================================= */

    @SuppressWarnings("unchecked")
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

    int cartCount = 0;
    double cartSubtotal = 0.0;

    if (cart != null) {

        for (CartItem item : cart) {

            cartCount += item.getQuantity();

            cartSubtotal += item.getTotalAmount();
        }
    }


    /* =========================================================
       MENU DATA
       ========================================================= */

    @SuppressWarnings("unchecked")
    List<Menu> menuList =
        (List<Menu>) request.getAttribute("allMenus");

    int currentRestaurantId = -1;

    String restaurantIdParam =
        request.getParameter("restaurantId");

    if (restaurantIdParam != null) {

        try {

            currentRestaurantId =
                Integer.parseInt(restaurantIdParam);

        } catch (NumberFormatException e) {

            currentRestaurantId = -1;
        }

    } else if (menuList != null && !menuList.isEmpty()) {

        currentRestaurantId =
            menuList.get(0).getRestaurantId();
    }


    /* =========================================================
       CART WARNING MESSAGE
       ========================================================= */

    String cartMessage =
        (String) session.getAttribute("cartMessage");

    String cartMessageType =
        (String) session.getAttribute("cartMessageType");
%>


<!-- =========================================================
     CART WARNING
     ========================================================= -->

<% if (cartMessage != null && !cartMessage.trim().isEmpty()) { %>

    <div class="cart-warning" id="cartWarning">

        <div class="cart-warning-icon">
            ⚠️
        </div>

        <div class="cart-warning-content">

            <div class="cart-warning-title">
                Different Restaurant
            </div>

            <div class="cart-warning-text">
                <%= esc(cartMessage) %>
            </div>

        </div>

        <button
            type="button"
            class="cart-warning-close"
            onclick="closeCartWarning()"
            aria-label="Close warning"
        >
            ×
        </button>

    </div>

<%
    /*
     * Remove the flash message after displaying it.
     * It will therefore appear only once after the redirect.
     */

    session.removeAttribute("cartMessage");
    session.removeAttribute("cartMessageType");
%>

<% } %>


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

<!-- =========================================================
     NAVBAR
     ========================================================= -->
<header class="navbar">

    <div class="nav-inner">

        <a href="restaurant" class="brand">
            <span class="brand-mark">
                F
            </span>

            <span class="brand-name">
                Foodwala
            </span>
        </a>


        <nav class="nav-links">

            <!-- RESTAURANTS -->
            <a
                href="restaurant"
                class="nav-link is-active"
            >
                Restaurants
            </a>


            <!-- ORDERS -->
            <a href="orders" class="nav-link">Orders</a>


            <!-- CART -->
            <a
                href="cart?action=view"
                class="cart-nav"
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

                <span>
                    Cart
                </span>

                <% if (cartCount > 0) { %>
                    <span class="cart-badge">
                        <%= cartCount %>
                    </span>
                <% } %>

            </a>


           <!-- LOGIN / PROFILE -->

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
     MENU HEADER
     ========================================================= -->

<section class="menu-header">

    <div class="menu-header-inner">

        <div class="menu-kicker">
            FOODWALA MENU
        </div>


        <h1 class="menu-title">
            Explore the Menu
        </h1>


        <p class="menu-subtitle">
            Choose your favourite dishes and build your order.
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


<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<main class="container">


    <!-- BACK TO RESTAURANTS -->

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

                <polyline
                    points="15 18 9 12 15 6"
                ></polyline>

            </svg>

            Back to Restaurants

        </a>

    </div>


<%

    if (menuList != null && !menuList.isEmpty()) {

        Menu spotlight = menuList.get(0);

%>


    <!-- =====================================================
         CHEF'S SPECIAL
         ===================================================== -->

    <div class="spotlight-label">
        CHEF'S SPECIAL
    </div>


    <a
        class="spotlight-card"
        href="cart?action=add&menuId=<%= spotlight.getMenuId() %>&restaurantId=<%= spotlight.getRestaurantId() %>&source=menu"
    >

        <img
            class="spotlight-image"
            src="<%= esc(spotlight.getImagePath()) %>"
            alt="<%= esc(spotlight.getItemName()) %>"
            loading="eager"
        >


        <div class="spotlight-overlay">

            <span class="spotlight-tag">
                Most Loved
            </span>


            <div class="spotlight-name">
                <%= esc(spotlight.getItemName()) %>
            </div>


            <div class="spotlight-price">
                ₹<%= String.format("%.2f", spotlight.getPrice()) %>
            </div>

        </div>

    </a>


    <!-- =====================================================
         POPULAR DISHES
         ===================================================== -->

    <div class="section-header">

        <h2 class="section-title">
            Popular Dishes
        </h2>


        <span class="menu-count">

            <%= menuList.size() %>

            <%= menuList.size() == 1 ? "dish" : "dishes" %>

        </span>

    </div>


    <!-- =====================================================
         MENU LIST
         ===================================================== -->

    <div class="menu-list">


<%

        for (Menu menu : menuList) {

            int cartQuantity = 0;


            if (cart != null) {

                for (CartItem item : cart) {

                    if (item.getMenuId() == menu.getMenuId()) {

                        cartQuantity =
                            item.getQuantity();

                        break;
                    }
                }
            }

%>


        <div
            class="menu-card <%= cartQuantity > 0 ? "in-cart" : "" %>"
        >


            <!-- IMAGE -->

            <div class="menu-image-wrap">

                <img
                    class="menu-image"
                    src="<%= esc(menu.getImagePath()) %>"
                    alt="<%= esc(menu.getItemName()) %>"
                    loading="lazy"
                >

            </div>


            <!-- CONTENT -->

            <div class="menu-content">


                <!-- TOP -->

                <div class="menu-top">


                    <div class="menu-name">

                        <%= esc(menu.getItemName()) %>

                    </div>


                    <% if (menu.isAvailable()) { %>

                        <span class="avail-pill is-available">

                            <span class="dot"></span>

                            Available

                        </span>

                    <% } else { %>

                        <span class="avail-pill is-unavailable">

                            <span class="dot"></span>

                            Sold out

                        </span>

                    <% } %>


                </div>


                <!-- DESCRIPTION -->

                <div class="menu-description">

                    <%= esc(menu.getDescription()) %>

                </div>


                <!-- BOTTOM -->

                <div class="menu-bottom">


                    <!-- PRICE -->

                    <div class="menu-price">

                        ₹<%= String.format("%.2f", menu.getPrice()) %>

                    </div>


                    <% if (menu.isAvailable()) { %>


                        <% if (cartQuantity == 0) { %>


                            <!-- ADD -->

                            <a
                                href="cart?action=add&menuId=<%= menu.getMenuId() %>&restaurantId=<%= menu.getRestaurantId() %>&source=menu"
                                class="add-button"
                            >

                                <svg
                                    width="13"
                                    height="13"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="2.6"
                                    stroke-linecap="round"
                                >

                                    <line
                                        x1="12"
                                        y1="5"
                                        x2="12"
                                        y2="19"
                                    ></line>

                                    <line
                                        x1="5"
                                        y1="12"
                                        x2="19"
                                        y2="12"
                                    ></line>

                                </svg>

                                Add

                            </a>


                        <% } else { %>


                            <!-- =================================================
                                 QUANTITY CONTROL
                                 ================================================= -->


                            <div class="quantity-control">


                                <!-- MINUS -->

                                <a
                                    href="cart?action=update&menuId=<%= menu.getMenuId() %>&quantity=<%= cartQuantity - 1 %>&restaurantId=<%= menu.getRestaurantId() %>&source=menu"
                                    class="quantity-btn"
                                    aria-label="Decrease quantity"
                                >
                                    −
                                </a>


                                <!-- CURRENT QUANTITY -->

                                <span class="quantity-value">

                                    <%= cartQuantity %>

                                </span>


                                <!-- PLUS -->

                                <a
                                    href="cart?action=add&menuId=<%= menu.getMenuId() %>&restaurantId=<%= menu.getRestaurantId() %>&source=menu"
                                    class="quantity-btn"
                                    aria-label="Increase quantity"
                                >
                                    +
                                </a>


                            </div>


                        <% } %>


                    <% } else { %>


                        <!-- UNAVAILABLE -->

                        <button
                            class="disabled-button"
                            type="button"
                            disabled
                        >
                            Unavailable
                        </button>


                    <% } %>


                </div>

            </div>

        </div>


<%

        }

%>


    </div>


<%

    } else {

%>


    <!-- =====================================================
         EMPTY MENU
         ===================================================== -->

    <div class="empty-message">


        <div class="empty-icon">

            <svg
                width="30"
                height="30"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="1.8"
                stroke-linecap="round"
                stroke-linejoin="round"
            >

                <path d="M6 8h12l1 13H5L6 8z"></path>

                <path d="M9 8a3 3 0 0 1 6 0"></path>

            </svg>

        </div>


        <h2>
            No menu items available
        </h2>


        <p>
            This restaurant currently has no available menu items.
        </p>


    </div>


<%

    }

%>


</main>


<!-- =========================================================
     FLOATING CART
     ========================================================= -->

<% if (cartCount > 0) { %>


<a
    href="cart?action=view"
    class="cart-float-bar"
>


    <div class="cart-float-info">


        <span class="cart-float-count">

            <%= cartCount %>

            <%= cartCount == 1 ? "item" : "items" %>

            added

        </span>


        <span class="cart-float-total">

            ₹<%= String.format("%.2f", cartSubtotal) %>

        </span>


    </div>


    <span class="cart-float-btn">

        View Cart


        <svg
            width="14"
            height="14"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2.6"
            stroke-linecap="round"
            stroke-linejoin="round"
        >

            <path d="M5 12h14"></path>

            <polyline
                points="13 6 19 12 13 18"
            ></polyline>

        </svg>

    </span>


</a>


<% } %>


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
        class="tab-item is-active"
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
        class="tab-item"
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


            <% if (cartCount > 0) { %>

                <span class="tab-cart-badge">

                    <%= cartCount %>

                </span>

            <% } %>


        </span>


        Cart

    </a>


    <!-- LOGIN -->

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


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>

    function closeCartWarning() {

        const warning =
            document.getElementById("cartWarning");

        if (warning) {

            warning.style.opacity = "0";

            warning.style.transform =
                "translate(-50%, -20px) scale(0.96)";

            setTimeout(function () {

                warning.remove();

            }, 250);
        }
    }


    /*
     * Automatically hide the warning after 7 seconds.
     */

    document.addEventListener("DOMContentLoaded", function () {

        const warning =
            document.getElementById("cartWarning");

        if (warning) {

            setTimeout(function () {

                closeCartWarning();

            }, 7000);
        }
    });

</script>


</body>

</html>