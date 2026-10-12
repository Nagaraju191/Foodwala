<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.CartItem" %>

<%!
    /**
     * HTML escape helper (XSS protection)
     */
    private static String esc(Object o) {

        if (o == null) {
            return "";
        }

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

    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect("profile");
        return;
    }

    String error = request.getParameter("error");

    String username =
            user.getUsername() != null
                    ? user.getUsername()
                    : "";

    String firstLetter =
            username.trim().isEmpty()
                    ? "U"
                    : username.trim()
                        .substring(0, 1)
                        .toUpperCase();

    String navActive = "profile";
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, viewport-fit=cover">

    <meta name="color-scheme" content="light dark">

    <meta name="theme-color"
          content="#F5F3FA"
          media="(prefers-color-scheme: light)">

    <meta name="theme-color"
          content="#0D0B14"
          media="(prefers-color-scheme: dark)">

    <title>Foodwala - Edit Profile</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600;12..96,800&family=Figtree:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <script>
        document.documentElement.className += ' js';
    </script>

    <style>

        /* ================= DESIGN TOKENS ================= */

        :root {

            --bg: #F5F3FA;
            --ink: #181426;
            --ink-2: #5B5670;
            --ink-3: #7A7590;

            --line: rgba(40, 30, 80, .12);

            --chili: #F0364F;
            --saffron: #FF9A3C;
            --plum: #7C3AED;

            --brand:
                linear-gradient(
                    135deg,
                    var(--saffron) 0%,
                    var(--chili) 60%,
                    #D6246E 100%
                );

            --brand-solid: #D92645;
            --brand-tint: rgba(240, 54, 79, .12);
            --brand-glow: rgba(240, 54, 79, .35);

            --ok: #0E8A4A;
            --ok-bg: rgba(20, 170, 90, .14);

            --bad: #D92D2D;
            --bad-bg: rgba(240, 60, 60, .11);

            --surface: rgba(255, 255, 255, .72);
            --surface-solid: #fff;
            --surface-edge: rgba(255, 255, 255, .9);

            --field: rgba(255, 255, 255, .85);

            --shadow:
                0 1px 2px rgba(40, 30, 90, .06),
                0 14px 40px rgba(40, 30, 90, .10);

            --shadow-lg:
                0 24px 60px rgba(40, 30, 90, .18);

            --blur: blur(24px) saturate(180%);

            --font-display:
                "Bricolage Grotesque",
                "Segoe UI",
                system-ui,
                sans-serif;

            --font-body:
                "Figtree",
                -apple-system,
                BlinkMacSystemFont,
                "Segoe UI",
                Roboto,
                Arial,
                sans-serif;

            --r-xl: 28px;
            --r-lg: 20px;
            --r-md: 14px;
            --r-full: 999px;

            --spring: cubic-bezier(.34, 1.4, .64, 1);
            --ease: cubic-bezier(.22, .61, .36, 1);
        }

        @media (prefers-color-scheme: dark) {

            :root {

                --bg: #0D0B14;
                --ink: #F6F4FC;
                --ink-2: #B0ABC4;
                --ink-3: #8D88A3;

                --line: rgba(255, 255, 255, .12);

                --brand-solid: #FF6F88;
                --brand-tint: rgba(255, 111, 136, .16);

                --ok: #3DDC84;
                --ok-bg: rgba(61, 220, 132, .15);

                --bad: #FF7A7A;
                --bad-bg: rgba(255, 122, 122, .15);

                --surface: rgba(34, 29, 52, .62);
                --surface-solid: #221D34;
                --surface-edge: rgba(255, 255, 255, .12);

                --field: rgba(255, 255, 255, .06);

                --shadow:
                    0 1px 2px rgba(0, 0, 0, .4),
                    0 14px 40px rgba(0, 0, 0, .45);

                --shadow-lg:
                    0 24px 60px rgba(0, 0, 0, .6);
            }
        }

        @supports not (
            (backdrop-filter: blur(1px))
            or
            (-webkit-backdrop-filter: blur(1px))
        ) {

            :root {
                --surface: var(--surface-solid);
            }
        }

        /* ================= BASE ================= */

        *,
        *::before,
        *::after {

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

            font-family: var(--font-body);
            background: var(--bg);
            color: var(--ink);

            -webkit-font-smoothing: antialiased;

            min-height: 100vh;

            padding-bottom: 48px;

            overflow-x: hidden;

            position: relative;

            isolation: isolate;
        }

        a {
            color: inherit;
        }

        :focus-visible {

            outline: 3px solid var(--brand-solid);
            outline-offset: 2px;
        }

        /* ================= AMBIENT BACKGROUND ================= */

        .ambient {

            position: fixed;
            inset: 0;
            z-index: -1;

            pointer-events: none;
            overflow: hidden;
        }

        .ambient i {

            position: absolute;
            display: block;

            border-radius: 50%;

            filter: blur(90px);

            opacity: .5;

            will-change: transform;

            animation:
                drift 26s ease-in-out infinite alternate;
        }

        .ambient i:nth-child(1) {

            width: 52vmax;
            height: 52vmax;

            left: -14vmax;
            top: -22vmax;

            background:
                radial-gradient(
                    circle,
                    var(--saffron),
                    transparent 68%
                );
        }

        .ambient i:nth-child(2) {

            width: 46vmax;
            height: 46vmax;

            right: -16vmax;
            top: 6vmax;

            background:
                radial-gradient(
                    circle,
                    var(--chili),
                    transparent 68%
                );

            animation-delay: -9s;

            opacity: .38;
        }

        .ambient i:nth-child(3) {

            width: 50vmax;
            height: 50vmax;

            left: 20vmax;
            bottom: -30vmax;

            background:
                radial-gradient(
                    circle,
                    var(--plum),
                    transparent 68%
                );

            animation-delay: -14s;

            opacity: .32;
        }

        @media (prefers-color-scheme: dark) {

            .ambient i {
                opacity: .28;
            }

            .ambient i:nth-child(n+2) {
                opacity: .2;
            }
        }

        /* ================= GLASS ================= */

        .glass {

            background: var(--surface);

            -webkit-backdrop-filter: var(--blur);
            backdrop-filter: var(--blur);

            border: 1px solid var(--surface-edge);

            box-shadow: var(--shadow);
        }

        /* ================= NAVBAR ================= */

        .navbar {

            position: sticky;
            top: 0;
            z-index: 100;

            padding: 10px 14px 0;
        }

        .nav-inner {

            max-width: 1180px;

            height: 60px;

            margin: 0 auto;

            padding: 0 10px 0 16px;

            border-radius: 22px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            transition: box-shadow .3s ease;
        }

        .navbar.scrolled .nav-inner {
            box-shadow: var(--shadow-lg);
        }

        .brand {

            display: flex;

            align-items: center;

            gap: 10px;

            text-decoration: none;
        }

        .brand-mark {

            width: 34px;
            height: 34px;

            border-radius: 11px;

            background: var(--brand);

            color: #fff;

            display: grid;

            place-items: center;

            font: 800 17px var(--font-display);

            box-shadow:
                0 8px 18px var(--brand-glow),
                inset 0 1.5px 0 rgba(255,255,255,.55);
        }

        .brand-name {

            font: 800 19px var(--font-display);

            letter-spacing: -.02em;
        }

        .nav-links {

            display: flex;

            align-items: center;

            gap: 4px;
        }

        .nav-link,
        .cart-nav {

            position: relative;

            isolation: isolate;

            display: inline-flex;

            align-items: center;

            gap: 7px;

            text-decoration: none;

            color: var(--ink-2);

            font-size: 14.5px;

            font-weight: 600;

            padding: 8px 15px;

            border-radius: var(--r-full);

            transition:
                color .2s,
                background .25s,
                transform .3s var(--spring);
        }

        .nav-link:hover,
        .cart-nav:hover {

            color: var(--ink);

            background: var(--line);
        }

        .nav-link:active,
        .cart-nav:active {

            transform: scale(.95);
        }

        .nav-link.is-active {
            color: var(--ink);
        }

        .nav-pill {

            position: absolute;

            inset: 0;

            z-index: -1;

            border-radius: inherit;

            background: var(--surface-solid);

            box-shadow: var(--shadow);
        }

        .nav-link-cta {

            color: #fff;

            background: var(--brand);

            box-shadow: 0 10px 22px var(--brand-glow);
        }

        .nav-link-cta:hover {

            color: #fff;

            background: var(--brand);

            filter: brightness(1.08);
        }

        .cart-nav svg {

            width: 21px;
            height: 21px;
        }

        .cart-badge {

            min-width: 18px;
            height: 18px;

            padding: 0 5px;

            display: inline-grid;

            place-items: center;

            border-radius: 99px;

            background: var(--brand);

            color: #fff;

            font-size: 10px;

            font-weight: 800;
        }

        .profile-nav {

            width: 40px;
            height: 40px;

            margin-left: 5px;

            border-radius: 50%;

            display: grid;

            place-items: center;

            text-decoration: none;

            color: var(--ink-2);

            background: var(--surface-solid);

            border: 1px solid var(--line);

            transition:
                transform .25s var(--spring),
                background .25s,
                color .2s;
        }

        .profile-nav svg {

            width: 21px;
            height: 21px;
        }

        .profile-nav:hover,
        .profile-nav.is-active {

            color: #fff;

            background: var(--brand);

            border-color: transparent;

            box-shadow: 0 8px 20px var(--brand-glow);
        }

        .profile-nav:hover {

            transform: scale(1.07);
        }

        /* ================= LAYOUT ================= */

        .page {

            width: 90%;

            max-width: 1080px;

            margin: 34px auto 0;
        }

        .crumbs {

            display: flex;

            align-items: center;

            gap: 8px;

            font-size: 13.5px;

            color: var(--ink-3);

            margin-bottom: 14px;
        }

        .crumbs a {

            text-decoration: none;

            font-weight: 600;

            color: var(--ink-2);
        }

        .crumbs a:hover {

            color: var(--brand-solid);
        }

        .page-head {

            margin-bottom: 26px;
        }

        .page-title {

            font:
                800 clamp(34px, 5vw, 50px)/1.02
                var(--font-display);

            letter-spacing: -.035em;

            margin-bottom: 8px;
        }

        .page-sub {

            color: var(--ink-2);

            font-size: 16px;

            max-width: 52ch;
        }

        .layout {

            display: grid;

            grid-template-columns: 320px minmax(0, 1fr);

            gap: 24px;

            align-items: start;
        }

        /* ================= IDENTITY CARD ================= */

        .identity {

            position: sticky;

            top: 92px;

            border-radius: var(--r-xl);

            overflow: hidden;
        }

        .identity-cover {

            height: 112px;

            background: var(--brand);

            position: relative;
        }

        .identity-cover::before {

            content: "";

            position: absolute;

            inset: 0;

            background:
                radial-gradient(
                    circle at 18% 120%,
                    rgba(255,255,255,.35),
                    transparent 45%
                ),
                radial-gradient(
                    circle at 90% -20%,
                    rgba(124,58,237,.55),
                    transparent 55%
                );
        }

        .identity-body {

            padding: 0 24px 26px;

            text-align: center;
        }

        .avatar {

            position: relative;

            width: 92px;
            height: 92px;

            margin: -46px auto 14px;

            border-radius: 30px;

            display: grid;

            place-items: center;

            background: var(--brand);

            color: #fff;

            font: 800 40px var(--font-display);

            border: 4px solid var(--surface-solid);

            box-shadow: 0 14px 30px var(--brand-glow);

            transition: transform .4s var(--spring);
        }

        .avatar.pop {

            transform: scale(1.1) rotate(-4deg);
        }

        .identity h2 {

            font: 800 23px var(--font-display);

            letter-spacing: -.02em;

            word-break: break-word;

            min-height: 1.2em;
        }

        .identity .mail {

            color: var(--ink-3);

            font-size: 14px;

            margin-top: 3px;

            word-break: break-all;
        }

        .chip {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            margin-top: 14px;

            padding: 6px 12px;

            border-radius: var(--r-full);

            font-size: 12.5px;

            font-weight: 700;

            color: var(--ok);

            background: var(--ok-bg);
        }

        .chip::before {

            content: "";

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: currentColor;
        }

        .identity-meta {

            margin-top: 20px;

            padding-top: 18px;

            border-top: 1px solid var(--line);

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 10px;
        }

        .meta-box {

            padding: 12px 8px;

            border-radius: var(--r-md);

            background: var(--field);

            border: 1px solid var(--line);
        }

        .meta-box b {

            display: block;

            font: 800 20px var(--font-display);
        }

        .meta-box span {

            font-size: 12px;

            color: var(--ink-3);
        }

        /* ================= FORM CARD ================= */

        .card {

            border-radius: var(--r-xl);

            padding: 8px 0;
        }

        .section {

            padding: 26px 30px;
        }

        .section + .section {

            border-top: 1px solid var(--line);
        }

        .section-head {

            display: flex;

            align-items: center;

            gap: 14px;

            margin-bottom: 20px;
        }

        .section-ico {

            width: 42px;
            height: 42px;

            border-radius: 14px;

            flex-shrink: 0;

            display: grid;

            place-items: center;

            color: var(--brand-solid);

            background: var(--brand-tint);
        }

        .section-ico svg {

            width: 21px;
            height: 21px;
        }

        .section-head h3 {

            font: 700 18px var(--font-display);

            letter-spacing: -.015em;
        }

        .section-head p {

            color: var(--ink-3);

            font-size: 13.5px;

            margin-top: 2px;
        }

        .grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 18px;
        }

        .full {

            grid-column: 1 / -1;
        }

        .field label {

            display: block;

            margin-bottom: 7px;

            font-size: 13.5px;

            font-weight: 650;

            color: var(--ink-2);
        }

        .input-wrap {

            position: relative;
        }

        .input-wrap > svg {

            position: absolute;

            left: 15px;
            top: 50%;

            width: 18px;
            height: 18px;

            transform: translateY(-50%);

            color: var(--ink-3);

            pointer-events: none;

            transition: color .25s;
        }

        .field input {

            width: 100%;

            padding: 14px 16px 14px 44px;

            border-radius: var(--r-md);

            border: 1.5px solid var(--line);

            background: var(--field);

            color: var(--ink);

            font: 500 15.5px var(--font-body);

            outline: none;

            transition:
                border-color .25s,
                box-shadow .25s,
                background .25s;
        }

        .field input::placeholder {

            color: var(--ink-3);
        }

        .field input:hover {

            border-color: rgba(124, 58, 237, .35);
        }

        .field input:focus {

            border-color: var(--chili);

            box-shadow:
                0 0 0 4px var(--brand-tint);

            background: var(--surface-solid);
        }

        .input-wrap:focus-within > svg {

            color: var(--chili);
        }

        .field input:user-invalid {

            border-color: var(--bad);

            box-shadow:
                0 0 0 4px var(--bad-bg);
        }

        .field input[readonly] {

            color: var(--ink-3);

            background: transparent;

            border-style: dashed;

            cursor: not-allowed;
        }

        .hint {

            display: flex;

            justify-content: space-between;

            gap: 8px;

            margin-top: 6px;

            color: var(--ink-3);

            font-size: 12.5px;
        }

        .hint.err {

            color: var(--bad);
        }

        /* ================= ADDRESS GRID ================= */

        .address-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 18px;
        }

        .address-grid .form-group {

            display: flex;

            flex-direction: column;

            gap: 7px;
        }

        .address-grid .form-group label {

            font-size: 13.5px;

            font-weight: 650;

            color: var(--ink-2);
        }

        .address-grid .form-group input {

            width: 100%;

            padding: 14px 15px;

            border: 1.5px solid var(--line);

            border-radius: var(--r-md);

            outline: none;

            font: 500 15px var(--font-body);

            background: var(--field);

            color: var(--ink);

            transition:
                border-color .25s,
                box-shadow .25s,
                background .25s;
        }

        .address-grid .form-group input::placeholder {

            color: var(--ink-3);
        }

        .address-grid .form-group input:hover {

            border-color: rgba(124, 58, 237, .35);
        }

        .address-grid .form-group input:focus {

            border-color: var(--chili);

            box-shadow:
                0 0 0 4px var(--brand-tint);

            background: var(--surface-solid);
        }

        .address-grid .form-group input:user-invalid {

            border-color: var(--bad);

            box-shadow:
                0 0 0 4px var(--bad-bg);
        }

        .address-help {

            margin-top: 14px;

            padding: 12px 14px;

            border-radius: var(--r-md);

            background: var(--brand-tint);

            color: var(--ink-2);

            font-size: 12.5px;

            line-height: 1.5;
        }

        /* ================= ALERT ================= */

        .alert {

            display: flex;

            gap: 10px;

            align-items: center;

            margin: 22px 30px 0;

            padding: 13px 16px;

            border-radius: var(--r-md);

            background: var(--bad-bg);

            color: var(--bad);

            font-size: 14px;

            font-weight: 600;

            border: 1px solid rgba(240, 60, 60, .22);

            animation: shake .5s var(--ease);
        }

        .alert svg {

            width: 19px;
            height: 19px;

            flex-shrink: 0;
        }

        /* ================= ACTION BAR ================= */

        .actions {

            position: sticky;

            bottom: 16px;

            z-index: 20;

            margin: 8px 18px 14px;

            padding: 12px 12px 12px 20px;

            border-radius: 20px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 12px;

            background: var(--surface-solid);

            border: 1px solid var(--line);

            box-shadow: var(--shadow-lg);
        }

        .state {

            display: flex;

            align-items: center;

            gap: 9px;

            font-size: 13.5px;

            font-weight: 600;

            color: var(--ink-3);
        }

        .state::before {

            content: "";

            width: 9px;
            height: 9px;

            border-radius: 50%;

            background: var(--ink-3);

            opacity: .5;

            transition: all .3s;
        }

        .state.dirty {

            color: var(--ink);
        }

        .state.dirty::before {

            background: var(--saffron);

            opacity: 1;

            box-shadow:
                0 0 0 4px rgba(255, 154, 60, .25);
        }

        .btns {

            display: flex;

            gap: 10px;
        }

        .btn {

            position: relative;

            overflow: hidden;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-height: 48px;

            padding: 0 24px;

            border: 0;

            border-radius: var(--r-md);

            font: 700 15px var(--font-body);

            text-decoration: none;

            cursor: pointer;

            color: #fff;

            background: var(--brand);

            box-shadow:
                0 10px 24px var(--brand-glow);

            transition:
                transform .3s var(--spring),
                filter .2s,
                box-shadow .3s,
                opacity .2s;
        }

        .btn::after {

            content: "";

            position: absolute;

            top: -20%;
            bottom: -20%;

            left: -60%;

            width: 40%;

            transform: skewX(-22deg);

            background:
                linear-gradient(
                    90deg,
                    transparent,
                    rgba(255,255,255,.5),
                    transparent
                );

            transition:
                left .7s var(--ease);

            pointer-events: none;
        }

        .btn:hover:not(:disabled)::after {

            left: 130%;
        }

        .btn:hover:not(:disabled) {

            filter: brightness(1.07);
        }

        .btn:active:not(:disabled) {

            transform: scale(.96);
        }

        .btn:disabled {

            opacity: .45;

            cursor: not-allowed;

            box-shadow: none;

            filter: grayscale(.4);
        }

        .btn-ghost {

            color: var(--ink-2);

            background: transparent;

            border: 1.5px solid var(--line);

            box-shadow: none;
        }

        .btn-ghost::after {

            display: none;
        }

        .btn-ghost:hover {

            color: var(--ink);

            background: var(--line);
        }

        .btn .spin {

            width: 17px;
            height: 17px;

            border-radius: 50%;

            border: 2.5px solid rgba(255,255,255,.4);

            border-top-color: #fff;

            animation: spin .7s linear infinite;
        }

        footer {

            margin-top: 48px;

            text-align: center;

            padding: 24px;

            color: var(--ink-3);

            font-size: 12.5px;
        }

        /* ================= TOAST ================= */

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

            max-width: 92vw;
        }

        .toast {

            background: var(--ink);

            color: var(--bg);

            padding: 12px 20px;

            border-radius: var(--r-full);

            font-size: 14px;

            font-weight: 600;

            box-shadow: var(--shadow-lg);

            animation: toastIn .5s var(--spring);
        }

        .toast.out {

            opacity: 0;

            transform: translateY(-10px) scale(.96);

            transition: all .35s ease;
        }

        .rip {

            position: absolute;

            border-radius: 50%;

            pointer-events: none;

            transform: scale(0);

            background:
                radial-gradient(
                    circle,
                    rgba(255,255,255,.7),
                    transparent 68%
                );

            animation: rip .7s ease-out forwards;
        }

        /* ================= ENTRANCE ================= */

        .js .enter {

            opacity: 0;

            transform: translateY(18px);
        }

        .enter.in {

            animation:
                enter .7s var(--spring) forwards;

            animation-delay:
                calc(var(--i, 0) * 90ms);
        }

        /* ================= MOBILE TAB BAR ================= */

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

            color: var(--ink-3);

            font-size: 10.5px;

            font-weight: 600;

            min-width: 62px;

            height: 50px;

            border-radius: 20px;

            transition:
                color .25s,
                transform .3s var(--spring);
        }

        .tab-item:active {

            transform: scale(.9);
        }

        .tab-item.is-active {

            color: var(--brand-solid);
        }

        .tab-pill {

            position: absolute;

            inset: 0;

            z-index: -1;

            border-radius: inherit;

            background: var(--brand-tint);
        }

        .tab-badge {

            position: absolute;

            top: -3px;

            right: 10px;

            min-width: 17px;

            height: 17px;

            padding: 0 4px;

            border-radius: 99px;

            display: grid;

            place-items: center;

            background: var(--brand);

            color: #fff;

            font-size: 9px;

            font-weight: 800;

            box-shadow:
                0 0 0 2px var(--bg);
        }

        /* ================= KEYFRAMES ================= */

        @keyframes drift {

            to {
                transform:
                    translate3d(6vmax, 5vmax, 0)
                    scale(1.12);
            }
        }

        @keyframes enter {

            to {

                opacity: 1;

                transform: none;
            }
        }

        @keyframes toastIn {

            from {

                opacity: 0;

                transform:
                    translateY(-16px)
                    scale(.9);
            }
        }

        @keyframes rip {

            to {

                transform: scale(1);

                opacity: 0;
            }
        }

        @keyframes spin {

            to {
                transform: rotate(360deg);
            }
        }

        @keyframes shake {

            20%, 60% {
                transform: translateX(-5px);
            }

            40%, 80% {
                transform: translateX(5px);
            }
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 900px) {

            .layout {

                grid-template-columns: 1fr;
            }

            .identity {

                position: static;
            }

            .identity-meta {

                max-width: 360px;

                margin-left: auto;

                margin-right: auto;
            }
        }

        @media (max-width: 650px) {

            body {

                padding-bottom: 110px;
            }

            .navbar {

                padding: 8px 10px 0;
            }

            .nav-inner {

                height: 54px;

                padding: 0 8px 0 14px;
            }

            .nav-links .nav-link:not(.nav-link-cta),
            .cart-text {

                display: none;
            }

            .page {

                margin-top: 20px;
            }

            .section {

                padding: 22px 18px;
            }

            .grid {

                grid-template-columns: 1fr;

                gap: 16px;
            }

            .full {

                grid-column: auto;
            }

            .address-grid {

                grid-template-columns: 1fr;
            }

            .alert {

                margin: 18px 18px 0;
            }

            .actions {

                margin: 8px 10px 12px;

                flex-direction: column;

                align-items: stretch;

                bottom: 92px;

                padding: 14px;
            }

            .state {

                justify-content: center;
            }

            .btns {

                flex-direction: column-reverse;
            }

            .toast-host {

                top: 72px;
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

                border-radius: 30px;

                bottom:
                    calc(
                        10px +
                        env(safe-area-inset-bottom, 0px)
                    );

                background: var(--surface);

                -webkit-backdrop-filter: var(--blur);

                backdrop-filter: var(--blur);

                border: 1px solid var(--surface-edge);

                box-shadow: var(--shadow-lg);
            }
        }

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {

                animation-duration: .01ms !important;

                animation-iteration-count: 1 !important;

                transition-duration: .01ms !important;

                scroll-behavior: auto !important;
            }

            .ambient i {

                animation: none !important;
            }
        }

    </style>

</head>

<body>

    <!-- AMBIENT BACKGROUND -->

    <div class="ambient" aria-hidden="true">

        <i></i>
        <i></i>
        <i></i>

    </div>

    <!-- ================= NAVBAR ================= -->

    <header class="navbar" id="navbar">

        <div class="nav-inner glass">

            <a href="restaurant" class="brand">

                <span class="brand-mark">F</span>

                <span class="brand-name">
                    Foodwala
                </span>

            </a>

            <nav class="nav-links" aria-label="Primary">

                <a href="restaurant"
                   class="nav-link">

                    Home

                </a>

                <a href="restaurant"
                   class="nav-link<%= "restaurants".equals(navActive) ? " is-active" : "" %>">

                    <% if ("restaurants".equals(navActive)) { %>

                        <span class="nav-pill"></span>

                    <% } %>

                    Restaurants

                </a>

                <a href="orders"
                   class="nav-link<%= "orders".equals(navActive) ? " is-active" : "" %>">

                    <% if ("orders".equals(navActive)) { %>

                        <span class="nav-pill"></span>

                    <% } %>

                    Orders

                </a>

                <a href="cart?action=view"
                   class="cart-nav"
                   aria-label="Cart">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         stroke-linecap="round"
                         stroke-linejoin="round"
                         aria-hidden="true">

                        <path d="M6 8h12l1 13H5L6 8z"></path>

                        <path d="M9 8a3 3 0 0 1 6 0"></path>

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

                <% if (loggedInUserId != null) { %>

                    <a href="profile"
                       class="profile-nav<%= "profile".equals(navActive) ? " is-active" : "" %>"
                       aria-label="My Profile"
                       title="My Profile">

                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2"
                             stroke-linecap="round"
                             stroke-linejoin="round">

                            <circle cx="12"
                                    cy="8"
                                    r="4"></circle>

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


    <!-- ================= MAIN ================= -->

    <main class="page">

        <div class="crumbs enter"
             style="--i:0">

            <a href="profile">
                Profile
            </a>

            <span aria-hidden="true">
                /
            </span>

            <span>
                Edit
            </span>

        </div>


        <div class="page-head enter"
             style="--i:1">

            <h1 class="page-title">
                Edit your profile
            </h1>

            <p class="page-sub">
                Keep your details current so your orders reach the right door.
            </p>

        </div>


        <div class="layout">


            <!-- ================= IDENTITY ================= -->

            <aside class="identity glass enter"
                   style="--i:2">

                <div class="identity-cover"></div>

                <div class="identity-body">

                    <div class="avatar"
                         id="avatar">

                        <%= esc(firstLetter) %>

                    </div>

                    <h2 id="liveName">

                        <%= esc(username) %>

                    </h2>

                    <p class="mail"
                       id="liveMail">

                        <%= esc(user.getEmail()) %>

                    </p>

                    <span class="chip">

                        <%= esc(user.getRole()) %> account

                    </span>


                    <div class="identity-meta">

                        <div class="meta-box">

                            <b>
                                <%= cartCount %>
                            </b>

                            <span>
                                In cart
                            </span>

                        </div>


                        <div class="meta-box">

                            <b id="liveDone">
                                0%
                            </b>

                            <span>
                                Profile complete
                            </span>

                        </div>

                    </div>

                </div>

            </aside>


            <!-- ================= FORM ================= -->

            <section class="card glass enter"
                     style="--i:3">


                <% if ("empty".equals(error)) { %>

                    <div class="alert"
                         role="alert">

                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             aria-hidden="true">

                            <circle cx="12"
                                    cy="12"
                                    r="10"></circle>

                            <path d="M12 8v5M12 16.5v.01"></path>

                        </svg>

                        Some fields are empty.
                        Fill in every required field to save your changes.

                    </div>

                <% } %>


                <form action="edit-profile"
                      method="post"
                      id="profileForm"
                      novalidate>


                    <!-- ================= PERSONAL ================= -->

                    <div class="section">

                        <div class="section-head">

                            <span class="section-ico">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">

                                    <circle cx="12"
                                            cy="8"
                                            r="4"></circle>

                                    <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"></path>

                                </svg>

                            </span>


                            <div>

                                <h3>
                                    Personal details
                                </h3>

                                <p>
                                    How you appear on Foodwala.
                                </p>

                            </div>

                        </div>


                        <div class="grid">


                            <div class="field">

                                <label for="username">
                                    Username
                                </label>

                                <div class="input-wrap">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

                                        <circle cx="12"
                                                cy="8"
                                                r="4"></circle>

                                        <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"></path>

                                    </svg>

                                    <input type="text"
                                           id="username"
                                           name="username"
                                           value="<%= esc(user.getUsername()) %>"
                                           autocomplete="name"
                                           maxlength="40"
                                           required>

                                </div>

                            </div>


                            <div class="field">

                                <label for="role">
                                    Account type
                                </label>

                                <div class="input-wrap">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

                                        <rect x="4"
                                              y="11"
                                              width="16"
                                              height="10"
                                              rx="2"></rect>

                                        <path d="M8 11V7a4 4 0 0 1 8 0v4"></path>

                                    </svg>

                                    <input type="text"
                                           id="role"
                                           value="<%= esc(user.getRole()) %>"
                                           readonly>

                                </div>

                                <span class="hint">
                                    Account type can't be changed.
                                </span>

                            </div>

                        </div>

                    </div>


                    <!-- ================= CONTACT ================= -->

                    <div class="section">

                        <div class="section-head">

                            <span class="section-ico">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">

                                    <rect x="3"
                                          y="5"
                                          width="18"
                                          height="14"
                                          rx="3"></rect>

                                    <path d="m4 7 8 6 8-6"></path>

                                </svg>

                            </span>


                            <div>

                                <h3>
                                    Contact
                                </h3>

                                <p>
                                    We use these for order updates.
                                </p>

                            </div>

                        </div>


                        <div class="grid">


                            <div class="field">

                                <label for="email">
                                    Email
                                </label>

                                <div class="input-wrap">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

                                        <rect x="3"
                                              y="5"
                                              width="18"
                                              height="14"
                                              rx="3"></rect>

                                        <path d="m4 7 8 6 8-6"></path>

                                    </svg>

                                    <input type="email"
                                           id="email"
                                           name="email"
                                           value="<%= esc(user.getEmail()) %>"
                                           autocomplete="email"
                                           required>

                                </div>

                            </div>


                            <div class="field">

                                <label for="phone">
                                    Phone number
                                </label>

                                <div class="input-wrap">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

                                        <path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"></path>

                                    </svg>

                                    <input type="tel"
                                           id="phone"
                                           name="phone"
                                           value="<%= esc(user.getPhone()) %>"
                                           pattern="[0-9]{10}"
                                           maxlength="10"
                                           inputmode="numeric"
                                           autocomplete="tel"
                                           required>

                                </div>

                                <span class="hint"
                                      id="phoneHint">

                                    <span>
                                        10 digits, no spaces.
                                    </span>

                                    <span id="phoneCount">
                                        0/10
                                    </span>

                                </span>

                            </div>

                        </div>

                    </div>


                    <!-- ================= DELIVERY ADDRESS ================= -->

                    <div class="section">

                        <div class="section-head">

                            <span class="section-ico">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">

                                    <path d="M12 21s7-6.2 7-11.5A7 7 0 0 0 5 9.5C5 14.8 12 21 12 21z"></path>

                                    <circle cx="12"
                                            cy="9.5"
                                            r="2.5"></circle>

                                </svg>

                            </span>


                            <div>

                                <h3>
                                    Delivery address
                                </h3>

                                <p>
                                    Where we bring your food.
                                </p>

                            </div>

                        </div>


                        <!-- ADDRESS FIELDS -->

                        <div class="address-grid">


                            <!-- HOUSE / FLAT -->

                            <div class="form-group">

                                <label for="houseNo">
                                    House / Flat No.
                                </label>

                                <input type="text"
                                       id="houseNo"
                                       name="houseNo"
                                       placeholder="e.g. 12-45"
                                       maxlength="50"
                                       autocomplete="address-line1"
                                       required>

                            </div>


                            <!-- STREET / AREA -->

                            <div class="form-group">

                                <label for="street">
                                    Street / Area
                                </label>

                                <input type="text"
                                       id="street"
                                       name="street"
                                       placeholder="e.g. BTM Layout"
                                       maxlength="100"
                                       autocomplete="address-line2"
                                       required>

                            </div>


                            <!-- CITY -->

                            <div class="form-group">

                                <label for="city">
                                    City
                                </label>

                                <input type="text"
                                       id="city"
                                       name="city"
                                       placeholder="e.g. Bengaluru"
                                       maxlength="60"
                                       autocomplete="address-level2"
                                       required>

                            </div>


                            <!-- STATE -->

                            <div class="form-group">

                                <label for="state">
                                    State
                                </label>

                                <input type="text"
                                       id="state"
                                       name="state"
                                       placeholder="e.g. Karnataka"
                                       maxlength="60"
                                       autocomplete="address-level1"
                                       required>

                            </div>


                            <!-- PIN CODE -->

                            <div class="form-group">

                                <label for="pincode">
                                    PIN Code
                                </label>

                                <input type="text"
                                       id="pincode"
                                       name="pincode"
                                       placeholder="e.g. 560076"
                                       maxlength="6"
                                       pattern="[0-9]{6}"
                                       inputmode="numeric"
                                       autocomplete="postal-code"
                                       required>

                            </div>


                            <!-- LANDMARK -->

                            <div class="form-group">

                                <label for="landmark">
                                    Landmark
                                </label>

                                <input type="text"
                                       id="landmark"
                                       name="landmark"
                                       placeholder="e.g. Near Metro Station"
                                       maxlength="100"
                                       autocomplete="off">

                            </div>

                        </div>


                        <div class="address-help">

                            Enter your complete delivery address.
                            House/flat number, street/area, city, state
                            and PIN code are required.
                            Landmark is optional but helps the delivery rider
                            find your location easily.

                        </div>

                    </div>


                    <!-- ================= ACTION BAR ================= -->

                    <div class="actions">

                        <div class="state"
                             id="stateStatus"
                             role="status"
                             aria-live="polite">

                            No changes yet

                        </div>


                        <div class="btns">

                            <a href="profile"
                               class="btn btn-ghost">

                                Cancel

                            </a>


                            <button type="submit"
                                    class="btn"
                                    id="saveBtn"
                                    disabled>

                                Save changes

                            </button>

                        </div>

                    </div>

                </form>

            </section>

        </div>

    </main>


    <!-- ================= FOOTER ================= -->

    <footer>

        &copy; 2026 Foodwala. All rights reserved.

    </footer>


    <!-- ================= MOBILE NAVIGATION ================= -->

    <nav class="tab-bar"
         aria-label="Mobile">

        <a href="restaurant"
           class="tab-item">

            <svg width="22"
                 height="22"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 aria-hidden="true">

                <path d="M3 10.5 12 3l9 7.5"></path>

                <path d="M5 9.5V21h14V9.5"></path>

            </svg>

            Home

        </a>


        <a href="restaurant"
           class="tab-item<%= "restaurants".equals(navActive) ? " is-active" : "" %>">

            <% if ("restaurants".equals(navActive)) { %>

                <span class="tab-pill"></span>

            <% } %>

            <svg width="22"
                 height="22"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 aria-hidden="true">

                <path d="M3 3v7a2 2 0 0 0 2 2h1v9"></path>

                <path d="M9 3v18"></path>

                <path d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9"></path>

            </svg>

            Restaurants

        </a>


        <a href="cart?action=view"
           class="tab-item">

            <% if (cartCount > 0) { %>

                <span class="tab-badge">
                    <%= cartCount %>
                </span>

            <% } %>

            <svg width="22"
                 height="22"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 aria-hidden="true">

                <path d="M6 8h12l1 13H5L6 8z"></path>

                <path d="M9 8a3 3 0 0 1 6 0"></path>

            </svg>

            Cart

        </a>


        <a href="<%= loggedInUserId != null ? "profile" : "login.jsp" %>"
           class="tab-item<%= ("profile".equals(navActive) || "login".equals(navActive)) ? " is-active" : "" %>">

            <% if ("profile".equals(navActive) || "login".equals(navActive)) { %>

                <span class="tab-pill"></span>

            <% } %>

            <svg width="22"
                 height="22"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 aria-hidden="true">

                <path d="M20 21a8 8 0 0 0-16 0"></path>

                <circle cx="12"
                        cy="7"
                        r="4"></circle>

            </svg>

            <%= loggedInUserId != null ? "Profile" : "Login" %>

        </a>

    </nav>


    <!-- ================= JAVASCRIPT ================= -->

    <script>

        (function () {

            var $ = function (id) {
                return document.getElementById(id);
            };


            /* ---------- Toast ---------- */

            function toast(msg) {

                var host = $("toastHost");

                if (!host) {

                    host = document.createElement("div");

                    host.id = "toastHost";

                    host.className = "toast-host";

                    host.setAttribute("role", "status");

                    host.setAttribute("aria-live", "polite");

                    document.body.appendChild(host);
                }

                var t = document.createElement("div");

                t.className = "toast";

                t.textContent = msg;

                host.appendChild(t);

                setTimeout(function () {

                    t.classList.add("out");

                    setTimeout(function () {

                        t.remove();

                    }, 360);

                }, 2400);
            }

            window.fwToast = toast;


            /* ---------- Ripple ---------- */

            document.addEventListener(
                "pointerdown",
                function (e) {

                    var target =
                        e.target.closest(
                            ".btn:not(:disabled), .nav-link-cta"
                        );

                    if (!target) {
                        return;
                    }

                    var rect =
                        target.getBoundingClientRect();

                    var size =
                        Math.max(
                            rect.width,
                            rect.height
                        ) * 2.4;

                    var ripple =
                        document.createElement("span");

                    ripple.className = "rip";

                    ripple.style.cssText =
                        "width:" +
                        size +
                        "px;" +
                        "height:" +
                        size +
                        "px;" +
                        "left:" +
                        (
                            e.clientX -
                            rect.left -
                            size / 2
                        ) +
                        "px;" +
                        "top:" +
                        (
                            e.clientY -
                            rect.top -
                            size / 2
                        ) +
                        "px";

                    target.appendChild(ripple);

                    setTimeout(function () {

                        ripple.remove();

                    }, 750);
                }
            );


            /* ---------- Navbar shadow ---------- */

            var nav = $("navbar");

            function onScroll() {

                if (nav) {

                    nav.classList.toggle(
                        "scrolled",
                        window.scrollY > 8
                    );
                }
            }

            window.addEventListener(
                "scroll",
                onScroll,
                {
                    passive: true
                }
            );

            onScroll();


            /* ---------- Entrance animation ---------- */

            document
                .querySelectorAll(".enter")
                .forEach(function (el) {

                    requestAnimationFrame(
                        function () {

                            el.classList.add("in");

                        }
                    );

                });


            /* ---------- Form ---------- */

            var form = $("profileForm");

            var save = $("saveBtn");

            var state = $("stateStatus");


            /*
             * All fields that can be edited.
             */

            var fields = [

                $("username"),

                $("email"),

                $("phone"),

                $("houseNo"),

                $("street"),

                $("city"),

                $("state"),

                $("pincode"),

                $("landmark")

            ];


            var initial = {};


            fields.forEach(function (field) {

                initial[field.id] = field.value;

            });


            /* ---------- Live profile ---------- */

            var avatar = $("avatar");

            var liveName = $("liveName");

            var liveMail = $("liveMail");

            var liveDone = $("liveDone");


            /* ---------- Counters ---------- */

            var phone =
                $("phone");

            var phoneCount =
                $("phoneCount");

            var pincode =
                $("pincode");


            /*
             * Check whether anything changed.
             */

            function isDirty() {

                return fields.some(
                    function (field) {

                        return field.value !==
                               initial[field.id];

                    }
                );
            }


            /*
             * Refresh live preview.
             */

            function refresh() {

                var name =
                    $("username").value.trim();


                liveName.textContent =
                    name || "Your name";


                liveMail.textContent =
                    $("email").value.trim();


                var letter =
                    name
                        ? name.charAt(0).toUpperCase()
                        : "U";


                if (avatar.textContent !== letter) {

                    avatar.textContent = letter;

                    avatar.classList.add("pop");

                    setTimeout(
                        function () {

                            avatar.classList.remove("pop");

                        },
                        220
                    );
                }


                /*
                 * Count all profile fields.
                 */

                var filled =
                    fields.filter(
                        function (field) {

                            return field.value.trim() !== "";

                        }
                    ).length;


                liveDone.textContent =
                    Math.round(
                        filled /
                        fields.length *
                        100
                    ) + "%";


                phoneCount.textContent =
                    phone.value.length + "/10";


                /*
                 * Dirty state.
                 */

                var dirty = isDirty();

                save.disabled = !dirty;

                state.classList.toggle(
                    "dirty",
                    dirty
                );

                state.textContent =
                    dirty
                        ? "You have unsaved changes"
                        : "No changes yet";
            }


            /* ---------- Phone ---------- */

            phone.addEventListener(
                "input",
                function () {

                    phone.value =
                        phone.value
                            .replace(/\D/g, "")
                            .slice(0, 10);

                    refresh();
                }
            );


            /* ---------- PIN Code ---------- */

            pincode.addEventListener(
                "input",
                function () {

                    pincode.value =
                        pincode.value
                            .replace(/\D/g, "")
                            .slice(0, 6);

                    refresh();
                }
            );


            /* ---------- Address fields ---------- */

            fields.forEach(
                function (field) {

                    field.addEventListener(
                        "input",
                        refresh
                    );

                }
            );


            refresh();


            /* ---------- Form submit ---------- */

            form.addEventListener(
                "submit",
                function (e) {

                    var bad =
                        fields.find(
                            function (field) {

                                return !field.checkValidity();

                            }
                        );


                    if (bad) {

                        e.preventDefault();

                        bad.focus();


                        if (bad.id === "phone") {

                            toast(
                                "Enter a valid 10-digit phone number"
                            );

                        } else if (bad.id === "pincode") {

                            toast(
                                "Enter a valid 6-digit PIN code"
                            );

                        } else {

                            toast(
                                "Please fill all required fields"
                            );
                        }

                        return;
                    }


                    save.disabled = true;

                    save.innerHTML =
                        '<span class="spin"></span> Saving';


                    window.__saving = true;

                }
            );


            /* ---------- Warn before leaving ---------- */

            window.addEventListener(
                "beforeunload",
                function (e) {

                    if (
                        isDirty() &&
                        !window.__saving
                    ) {

                        e.preventDefault();

                        e.returnValue = "";
                    }
                }
            );

        })();

    </script>

</body>

</html>