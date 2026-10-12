<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>

<%!
    // =========================================================
    // HTML ESCAPE
    // =========================================================
    private static String esc(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    // =========================================================
    // MONEY FORMAT
    // =========================================================
    private static String money(double value) {
        return String.format(java.util.Locale.US, "%.2f", value);
    }

    // =========================================================
    // STATUS CLASS
    // =========================================================
    private static String statusClass(String status) {

        if (status == null) {
            return "status-default";
        }

        String s = status.trim().toLowerCase();

        if (s.contains("deliver")) {
            return "status-delivered";
        }

        if (s.contains("cancel")) {
            return "status-cancelled";
        }

        if (s.contains("pending")) {
            return "status-pending";
        }

        if (s.contains("confirm")) {
            return "status-confirmed";
        }

        if (s.contains("prepar")) {
            return "status-preparing";
        }

        if (s.contains("out")) {
            return "status-out";
        }

        return "status-default";
    }

    // =========================================================
    // STATUS ICON
    // =========================================================
    private static String statusIcon(String status) {

        if (status == null) {
            return "•";
        }

        String s = status.trim().toLowerCase();

        if (s.contains("deliver")) {
            return "✓";
        }

        if (s.contains("cancel")) {
            return "×";
        }

        if (s.contains("pending")) {
            return "◷";
        }

        if (s.contains("confirm")) {
            return "✓";
        }

        if (s.contains("prepar")) {
            return "◌";
        }

        if (s.contains("out")) {
            return "→";
        }

        return "•";
    }
%>

<%
    // =========================================================
    // CONTEXT PATH
    // =========================================================
    String contextPath = request.getContextPath();


    // =========================================================
    // ORDERS
    // =========================================================
    @SuppressWarnings("unchecked")
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");


    // =========================================================
    // LOGGED-IN USER
    // =========================================================
    User user =
        (User) session.getAttribute("loggedInUser");


    // =========================================================
    // CART
    // =========================================================
    @SuppressWarnings("unchecked")
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

    int cartCount = 0;

    if (cart != null) {

        for (CartItem item : cart) {

            if (item != null) {
                cartCount += item.getQuantity();
            }
        }
    }


    // =========================================================
    // ORDER COUNT
    // =========================================================
    int orderCount = orders != null ? orders.size() : 0;
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0,
                   viewport-fit=cover">

    <meta name="color-scheme"
          content="light dark">

    <title>My Orders | Foodwala</title>


    <style>

        /* =====================================================
           ROOT VARIABLES
           SAME VISUAL SYSTEM AS CHECKOUT.JSP
        ===================================================== */

        :root {

            --bg: #F3EEFA;

            --label: #1B1726;
            --label-2: #5A5468;
            --label-3: #75708A;

            --separator: rgba(60, 50, 90, .14);

            --hover: rgba(255,255,255,.60);

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

            --accent-tint:
                rgba(255,46,99,.12);

            --accent-glow:
                rgba(255,46,99,.30);

            --success: #0F8A45;

            --glass:
                rgba(255,255,255,.52);

            --glass-strong:
                rgba(255,255,255,.78);

            --glass-soft:
                rgba(255,255,255,.28);

            --glass-border:
                rgba(255,255,255,.85);

            --glass-inset:
                inset 0 1.5px 0 rgba(255,255,255,1),
                inset 0 -1px 0 rgba(255,255,255,.3),
                inset 0 0 22px rgba(255,255,255,.25);

            --glass-shadow:
                0 10px 34px rgba(60,40,120,.12),
                0 2px 6px rgba(60,40,120,.06);

            --glass-shadow-hover:
                0 22px 56px rgba(60,40,120,.20),
                0 4px 12px rgba(60,40,120,.08);

            --blur:
                blur(28px) saturate(200%);

            --r-xl: 28px;
            --r-lg: 20px;
            --r-md: 14px;

            --r-full: 999px;

            --spring:
                cubic-bezier(.34,1.56,.64,1);
        }


        /* =====================================================
           DARK MODE
        ===================================================== */

        @media (prefers-color-scheme: dark) {

            :root {

                --bg: #07060D;

                --label: #F6F4FB;
                --label-2: #A6A2B6;
                --label-3: #8F8BA2;

                --separator:
                    rgba(255,255,255,.12);

                --hover:
                    rgba(255,255,255,.10);

                --accent-solid:
                    #FF7391;

                --accent-tint:
                    rgba(255,115,145,.17);

                --success:
                    #34D67A;

                --glass:
                    rgba(40,36,58,.50);

                --glass-strong:
                    rgba(48,43,68,.76);

                --glass-soft:
                    rgba(255,255,255,.06);

                --glass-border:
                    rgba(255,255,255,.17);

                --glass-inset:
                    inset 0 1.5px 0 rgba(255,255,255,.22),
                    inset 0 -1px 0 rgba(255,255,255,.04),
                    inset 0 0 22px rgba(255,255,255,.04);

                --glass-shadow:
                    0 10px 34px rgba(0,0,0,.55),
                    0 2px 6px rgba(0,0,0,.30);

                --glass-shadow-hover:
                    0 22px 56px rgba(0,0,0,.65),
                    0 4px 12px rgba(0,0,0,.35);
            }
        }


        /* =====================================================
           RESET
        ===================================================== */

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            min-height: 100vh;

            color: var(--label);

            background: var(--bg);

            font-family:
                -apple-system,
                BlinkMacSystemFont,
                "SF Pro Text",
                "Segoe UI",
                Arial,
                sans-serif;

            letter-spacing: -.006em;

            -webkit-font-smoothing: antialiased;

            overflow-x: hidden;

            isolation: isolate;
        }


        a {
            color: inherit;
            text-decoration: none;
        }


        button {
            font: inherit;
            cursor: pointer;
        }


        :focus-visible {

            outline:
                3px solid var(--accent-solid);

            outline-offset: 3px;
        }


        /* =====================================================
           LIQUID AURORA BACKGROUND
        ===================================================== */

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

            width: 52vmax;
            height: 52vmax;

            filter: blur(72px);

            opacity: .48;

            border-radius:
                45% 55% 60% 40% /
                45% 40% 60% 55%;

            animation:
                flow 24s ease-in-out infinite alternate,
                morph 15s ease-in-out infinite;
        }


        .aqua i:nth-child(1) {

            left: -17vmax;
            top: -22vmax;

            background:
                radial-gradient(
                    circle at 35% 35%,
                    var(--a1),
                    transparent 66%
                );
        }


        .aqua i:nth-child(2) {

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

            left: -20vmax;
            bottom: -27vmax;

            background:
                radial-gradient(
                    circle,
                    var(--t1),
                    transparent 66%
                );

            animation-delay: -12s;

            opacity: .34;
        }


        .aqua i:nth-child(4) {

            right: -15vmax;
            bottom: -20vmax;

            background:
                radial-gradient(
                    circle,
                    var(--t2),
                    transparent 66%
                );

            animation-delay: -4s;

            opacity: .34;
        }


        @keyframes flow {

            from {
                transform:
                    translate3d(-2%,0,0)
                    rotate(0deg);
            }

            to {
                transform:
                    translate3d(4%,5%,0)
                    rotate(14deg);
            }
        }


        @keyframes morph {

            0%,100% {
                border-radius:
                    45% 55% 60% 40% /
                    45% 40% 60% 55%;
            }

            50% {
                border-radius:
                    60% 40% 40% 60% /
                    55% 60% 40% 45%;
            }
        }


        /* =====================================================
           GLASS SYSTEM
        ===================================================== */

        .glass,
        .nav-inner,
        .order-card,
        .stat-card,
        .empty-card {

            background:
                linear-gradient(
                    135deg,
                    var(--glass-strong),
                    var(--glass) 55%,
                    var(--glass-soft)
                );

            -webkit-backdrop-filter:
                var(--blur);

            backdrop-filter:
                var(--blur);

            border:
                1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow);
        }


        .glass,
        .order-card,
        .empty-card {

            position: relative;

            overflow: hidden;

            border-radius:
                var(--r-xl);
        }


        .glass::before,
        .nav-inner::before,
        .order-card::before,
        .empty-card::before {

            content: "";

            position: absolute;

            inset: 0;

            border-radius: inherit;

            pointer-events: none;

            background:
                linear-gradient(
                    115deg,
                    rgba(255,255,255,.30),
                    transparent 36%
                );

            opacity: .75;
        }


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            position: sticky;

            top: 0;

            z-index: 100;

            padding:
                10px 14px 0;
        }


        .nav-inner {

            position: relative;

            width: 100%;

            max-width: 1250px;

            height: 62px;

            margin: 0 auto;

            padding:
                0 12px 0 17px;

            border-radius: 24px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 16px;
        }


        /* =====================================================
           BRAND
        ===================================================== */

        .brand {

            display: inline-flex;

            align-items: center;

            gap: 10px;

            position: relative;

            z-index: 2;

            white-space: nowrap;
        }


        .brand-mark {

            width: 35px;
            height: 35px;

            display: grid;

            place-items: center;

            border-radius: 12px;

            color: white;

            font-size: 17px;

            background:
                var(--accent-gradient);

            box-shadow:
                0 7px 16px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6);
        }


        .brand-name {

            font-size: 18px;

            font-weight: 800;

            letter-spacing: -.025em;
        }


        /* =====================================================
           NAV LINKS
        ===================================================== */

        .nav-links {

            display: flex;

            align-items: center;

            gap: 4px;

            position: relative;

            z-index: 2;
        }


        .nav-link {

            position: relative;

            padding:
                9px 14px;

            border-radius:
                var(--r-full);

            color:
                var(--label-2);

            font-size: 14px;

            font-weight: 650;

            transition:
                .2s ease;
        }


        .nav-link:hover {

            color:
                var(--label);

            background:
                var(--hover);
        }


        .nav-link.active {

            color:
                var(--accent-solid);

            background:
                var(--accent-tint);

            font-weight: 800;
        }


        .nav-link.active::after {

            content: "";

            position: absolute;

            left: 50%;

            bottom: 3px;

            width: 18px;

            height: 3px;

            border-radius: 99px;

            transform:
                translateX(-50%);

            background:
                var(--accent-gradient);
        }


.navbar {
    position: sticky;
    top: 18px;
    z-index: 1000;

    width: calc(100% - 40px);
    max-width: 1400px;
    margin: 18px auto;

    padding: 14px 22px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);

    border: 1px solid rgba(255, 255, 255, 0.6);
    border-radius: 22px;

    box-shadow:
        0 12px 35px rgba(31, 38, 135, 0.12),
        inset 0 1px 0 rgba(255, 255, 255, 0.7);
}

/* Logo stays on the LEFT */
.nav-brand {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-shrink: 0;
}

/* Navigation links move to the RIGHT */
.nav-links {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;

    margin-left: auto;
}

/* Individual links */
.nav-links a {
    display: flex;
    align-items: center;
    gap: 7px;

    padding: 10px 15px;

    text-decoration: none;
    color: #333;

    font-size: 14px;
    font-weight: 600;

    border-radius: 14px;

    transition: all 0.3s ease;
}

.nav-links a:hover {
    color: #ff4f81;

    background: rgba(255, 255, 255, 0.65);

    transform: translateY(-2px);
}

/* Active link */
.nav-links a.active {
    color: #fff;

    background: linear-gradient(
        135deg,
        #ff7a45,
        #ff3d71,
        #8d5cff
    );

    box-shadow:
        0 8px 20px rgba(255, 61, 113, 0.25);
}

/* Cart */
.cart-nav {
    position: relative;
}

.cart-badge {
    position: absolute;

    top: 2px;
    right: 2px;

    min-width: 17px;
    height: 17px;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 0 4px;

    font-size: 10px;
    font-weight: 700;

    color: white;

    background: linear-gradient(
        135deg,
        #ff4f81,
        #8d5cff
    );

    border-radius: 50%;
}

/* Profile icon */
.profile-nav {
    width: 42px;
    height: 42px;

    display: flex !important;
    align-items: center;
    justify-content: center;

    padding: 0 !important;

    border-radius: 50% !important;

    background: rgba(255, 255, 255, 0.75);
    border: 1px solid rgba(255, 255, 255, 0.7);
}

.profile-nav:hover {
    background: linear-gradient(
        135deg,
        #ff7a45,
        #ff3d71
    );

    color: white !important;
}

        /* =====================================================
           PROFILE ICON
        ===================================================== */

        .profile-nav {

            width: 41px;

            height: 41px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            color:
                var(--label-2);

            background:
                var(--glass-strong);

            border:
                1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60,40,120,.12);

            transition:
                .25s var(--spring);
        }


        .profile-icon {

            width: 20px;

            height: 20px;

            stroke:
                currentColor;

            stroke-width: 1.8;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        .profile-nav:hover {

            color: white;

            background:
                var(--accent-gradient);

            transform:
                translateY(-2px);
        }


        /* =====================================================
           LOGIN BUTTON
        ===================================================== */

        .login-btn {

            padding:
                11px 17px;

            color: #fff;

            font-size: 13px;

            font-weight: 750;

            border-radius: 99px;

            background:
                var(--accent-gradient);

            box-shadow:
                0 8px 20px var(--accent-glow);

            transition:
                .2s ease;
        }


        .login-btn:hover {

            transform:
                translateY(-2px);

            filter:
                brightness(1.05);
        }


        /* =====================================================
           MAIN PAGE
        ===================================================== */

        .page {

            width:
                min(1180px, calc(100% - 34px));

            margin:
                38px auto 80px;
        }


        /* =====================================================
           HERO
        ===================================================== */

        .hero {

            position: relative;

            padding:
                25px 0 32px;
        }


        .eyebrow {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding:
                8px 13px;

            border:
                1px solid var(--glass-border);

            border-radius:
                99px;

            color:
                var(--accent-solid);

            background:
                var(--glass);

            font-size: 11px;

            font-weight: 800;

            letter-spacing: .08em;

            text-transform: uppercase;

            box-shadow:
                var(--glass-shadow);
        }


        .eyebrow-dot {

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background:
                var(--accent-gradient);
        }


        h1 {

            margin-top: 15px;

            font-size:
                clamp(34px,5vw,51px);

            line-height: 1.05;

            font-weight: 850;

            letter-spacing: -.045em;
        }


        .gradient-text {

            background:
                linear-gradient(
                    100deg,
                    var(--a1),
                    var(--a2),
                    var(--a3),
                    var(--t2),
                    var(--a2)
                );

            background-size:
                240% 100%;

            -webkit-background-clip: text;

            background-clip: text;

            -webkit-text-fill-color: transparent;

            animation:
                titleFlow 9s linear infinite;
        }


        @keyframes titleFlow {

            to {
                background-position:
                    240% 0;
            }
        }


        .hero p {

            margin-top: 12px;

            max-width: 650px;

            color:
                var(--label-2);

            font-size: 15px;

            line-height: 1.7;
        }


        /* =====================================================
           HERO STATS
        ===================================================== */

        .hero-stats {

            display: flex;

            flex-wrap: wrap;

            gap: 10px;

            margin-top: 22px;
        }


        .stat-card {

            display: flex;

            align-items: center;

            gap: 10px;

            padding:
                10px 14px;

            border-radius:
                99px;
        }


        .stat-icon {

            width: 27px;

            height: 27px;

            display: grid;

            place-items: center;

            border-radius: 50%;

            color: white;

            background:
                var(--accent-gradient);

            font-size: 12px;

            font-weight: 800;
        }


        .stat-text {

            color:
                var(--label-2);

            font-size: 12px;

            font-weight: 650;
        }


        .stat-text strong {

            color:
                var(--label);

            margin-right: 3px;
        }


        /* =====================================================
           ORDER LIST
        ===================================================== */

        .orders-list {

            display: grid;

            gap: 20px;
        }


        /* =====================================================
           ORDER CARD
        ===================================================== */

        .order-card {

            transition:
                transform .28s var(--spring),
                box-shadow .28s ease;
        }


        .order-card:hover {

            transform:
                translateY(-5px);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }


        .order-content {

            position: relative;

            z-index: 1;

            padding:
                clamp(20px,3vw,28px);
        }


        /* =====================================================
           ORDER HEADER
        ===================================================== */

        .order-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 16px;

            padding-bottom: 20px;

            border-bottom:
                1px solid var(--separator);
        }


        .order-heading {

            display: flex;

            align-items: center;

            gap: 13px;

            min-width: 0;
        }


        .order-icon {

            width: 48px;

            height: 48px;

            flex: 0 0 48px;

            display: grid;

            place-items: center;

            border-radius: 15px;

            color: white;

            background:
                var(--accent-gradient);

            box-shadow:
                0 9px 22px var(--accent-glow);
        }


        .order-icon svg {

            width: 22px;

            height: 22px;

            stroke:
                currentColor;

            stroke-width: 1.8;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        .order-title {

            min-width: 0;
        }


        .order-id {

            font-size: 16px;

            font-weight: 850;

            letter-spacing: -.02em;

            overflow-wrap: anywhere;
        }


        .order-date {

            margin-top: 5px;

            color:
                var(--label-2);

            font-size: 12px;
        }


        /* =====================================================
           STATUS
        ===================================================== */

        .status {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            flex: 0 0 auto;

            padding:
                8px 12px;

            border-radius:
                99px;

            font-size: 11px;

            font-weight: 800;

            white-space: nowrap;

            border:
                1px solid transparent;
        }


        .status-dot {

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background:
                currentColor;
        }


        .status-delivered {

            color: #08783B;

            background:
                rgba(22,163,74,.11);

            border-color:
                rgba(22,163,74,.18);
        }


        .status-confirmed {

            color: #4056C7;

            background:
                rgba(99,102,241,.11);

            border-color:
                rgba(99,102,241,.18);
        }


        .status-preparing {

            color: #B25D00;

            background:
                rgba(255,138,61,.12);

            border-color:
                rgba(255,138,61,.20);
        }


        .status-out {

            color: #7A43B5;

            background:
                rgba(192,38,211,.10);

            border-color:
                rgba(192,38,211,.18);
        }


        .status-pending {

            color: #B34700;

            background:
                rgba(255,138,61,.12);

            border-color:
                rgba(255,138,61,.20);
        }


        .status-cancelled {

            color: #C2293D;

            background:
                rgba(255,60,80,.10);

            border-color:
                rgba(255,60,80,.18);
        }


        .status-default {

            color:
                var(--label-2);

            background:
                var(--glass-soft);

            border-color:
                var(--separator);
        }


        /* =====================================================
           ORDER DETAILS GRID
        ===================================================== */

        .details-grid {

            display: grid;

            grid-template-columns:
                repeat(2,minmax(0,1fr));

            gap:
                13px;

            margin-top: 20px;
        }


        .detail-box {

            min-width: 0;

            padding:
                15px;

            border-radius:
                16px;

            border:
                1px solid var(--separator);

            background:
                var(--glass-soft);

            transition:
                .2s ease;
        }


        .detail-box:hover {

            background:
                var(--glass-strong);

            transform:
                translateY(-1px);
        }


        .detail-label {

            display: flex;

            align-items: center;

            gap: 7px;

            color:
                var(--label-3);

            font-size: 10px;

            font-weight: 800;

            letter-spacing: .06em;

            text-transform: uppercase;
        }


        .detail-label-icon {

            width: 25px;

            height: 25px;

            display: grid;

            place-items: center;

            border-radius: 8px;

            color:
                var(--accent-solid);

            background:
                var(--accent-tint);
        }


        .detail-label-icon svg {

            width: 14px;

            height: 14px;

            stroke:
                currentColor;

            stroke-width: 1.8;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        .detail-value {

            margin-top: 8px;

            color:
                var(--label);

            font-size: 13px;

            font-weight: 700;

            line-height: 1.5;

            overflow-wrap: anywhere;
        }


        .detail-box.address {

            grid-column:
                1 / -1;
        }


        /* =====================================================
           ORDER FOOTER
        ===================================================== */

        .order-footer {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            margin-top: 20px;

            padding-top: 18px;

            border-top:
                1px solid var(--separator);
        }


        .payment-info {

            display: flex;

            align-items: center;

            gap: 9px;

            color:
                var(--label-2);

            font-size: 12px;
        }


        .payment-mini-icon {

            width: 32px;

            height: 32px;

            display: grid;

            place-items: center;

            border-radius: 10px;

            color:
                var(--accent-solid);

            background:
                var(--accent-tint);

            font-size: 14px;
        }


        .payment-info strong {

            display: block;

            color:
                var(--label);

            margin-bottom: 2px;

            font-size: 12px;
        }


        .footer-actions {

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .view-details {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            min-height: 42px;

            padding:
                0 16px;

            border-radius:
                13px;

            color:
                var(--label-2);

            background:
                var(--glass);

            border:
                1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset);

            font-size: 12px;

            font-weight: 800;

            transition:
                .22s var(--spring);
        }


        .view-details:hover {

            color: white;

            background:
                var(--accent-gradient);

            transform:
                translateY(-2px);
        }


        .view-details svg {

            width: 15px;

            height: 15px;

            stroke:
                currentColor;

            stroke-width: 2;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        .order-total {

            text-align: right;
        }


        .total-label {

            color:
                var(--label-3);

            font-size: 10px;

            font-weight: 800;

            letter-spacing: .06em;

            text-transform: uppercase;
        }


        .total-value {

            margin-top: 3px;

            font-size: 20px;

            font-weight: 900;

            letter-spacing: -.035em;

            background:
                var(--accent-gradient);

            -webkit-background-clip: text;

            background-clip: text;

            -webkit-text-fill-color:
                transparent;
        }


        /* =====================================================
           EMPTY ORDERS
        ===================================================== */

        .empty-card {

            text-align: center;

            padding:
                55px 25px;
        }


        .empty-icon {

            width: 78px;

            height: 78px;

            margin:
                0 auto 20px;

            display: grid;

            place-items: center;

            border-radius: 25px;

            color: white;

            background:
                var(--accent-gradient);

            box-shadow:
                0 16px 32px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.55);
        }


        .empty-icon svg {

            width: 36px;

            height: 36px;

            stroke:
                currentColor;

            stroke-width: 1.6;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        .empty-card h2 {

            font-size: 25px;

            font-weight: 850;

            letter-spacing: -.035em;
        }


        .empty-card p {

            max-width: 480px;

            margin:
                10px auto 0;

            color:
                var(--label-2);

            font-size: 13px;

            line-height: 1.7;
        }


        .browse-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-height: 50px;

            margin-top: 24px;

            padding:
                0 22px;

            color: white;

            border-radius:
                15px;

            background:
                var(--accent-gradient);

            box-shadow:
                0 12px 26px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6);

            font-size: 13px;

            font-weight: 850;

            transition:
                .25s var(--spring);
        }


        .browse-btn:hover {

            transform:
                translateY(-3px);

            filter:
                brightness(1.06);
        }


        .browse-btn svg {

            width: 17px;

            height: 17px;

            stroke:
                currentColor;

            stroke-width: 2;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        /* =====================================================
           FOOTER
        ===================================================== */

        .footer {

            text-align: center;

            padding:
                28px 12px 0;

            color:
                var(--label-3);

            font-size: 11px;
        }


        /* =====================================================
           MOBILE BOTTOM NAV
        ===================================================== */

        .mobile-nav {

            display: none;

            position: fixed;

            left: 10px;

            right: 10px;

            bottom: 10px;

            z-index: 200;

            padding:
                8px;

            border-radius:
                22px;

            background:
                var(--glass-strong);

            -webkit-backdrop-filter:
                var(--blur);

            backdrop-filter:
                var(--blur);

            border:
                1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                0 12px 35px rgba(40,20,80,.20);
        }


        .mobile-nav a {

            position: relative;

            flex: 1;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            gap: 3px;

            min-height: 48px;

            border-radius:
                15px;

            color:
                var(--label-3);

            font-size: 9px;

            font-weight: 750;

            transition:
                .2s ease;
        }


        .mobile-nav a.active {

            color:
                var(--accent-solid);

            background:
                var(--accent-tint);
        }


        .mobile-nav svg {

            width: 18px;

            height: 18px;

            stroke:
                currentColor;

            stroke-width: 1.8;

            fill: none;

            stroke-linecap: round;

            stroke-linejoin: round;
        }


        /* =====================================================
           TABLET
        ===================================================== */

        @media (max-width: 900px) {

            .order-content {

                padding:
                    21px;
            }

            .order-footer {

                align-items:
                    flex-start;
            }
        }


        /* =====================================================
           MOBILE
        ===================================================== */

        @media (max-width: 700px) {

            .navbar {

                padding:
                    8px 9px 0;
            }


            .nav-inner {

                height:
                    57px;

                padding:
                    0 9px 0 12px;

                gap:
                    7px;
            }


            .brand-name {

                font-size:
                    16px;
            }


            .brand-mark {

                width:
                    32px;

                height:
                    32px;
            }


            .nav-links {

                display:
                    none;
            }


            .nav-actions {

                gap:
                    6px;
            }


            .cart-nav {

                min-width:
                    38px;

                width:
                    38px;

                height:
                    35px;

                padding:
                    0;

                font-size:
                    0;
            }


            .cart-icon {

                width:
                    17px;

                height:
                    17px;
            }


            .profile-nav {

                width:
                    35px;

                height:
                    35px;
            }


            .login-btn {

                padding:
                    9px 12px;

                font-size:
                    11px;
            }


            .page {

                width:
                    calc(100% - 22px);

                margin-top:
                    25px;

                margin-bottom:
                    95px;
            }


            .hero {

                padding-top:
                    15px;
            }


            h1 {

                font-size:
                    clamp(32px,10vw,43px);
            }


            .hero p {

                font-size:
                    13px;
            }


            .hero-stats {

                gap:
                    7px;
            }


            .stat-card {

                padding:
                    8px 10px;
            }


            .stat-text {

                font-size:
                    10px;
            }


            .order-header {

                align-items:
                    flex-start;

                flex-direction:
                    column;
            }


            .status {

                align-self:
                    flex-start;
            }


            .details-grid {

                grid-template-columns:
                    1fr;

                gap:
                    10px;
            }


            .detail-box.address {

                grid-column:
                    auto;
            }


            .order-footer {

                flex-direction:
                    column;

                align-items:
                    stretch;
            }


            .footer-actions {

                width:
                    100%;

                justify-content:
                    space-between;
            }


            .view-details {

                flex:
                    1;
            }


            .order-total {

                text-align:
                    left;
            }


            .empty-card {

                padding:
                    45px 18px;
            }


            .mobile-nav {

                display:
                    flex;
            }


            .footer {

                padding-bottom:
                    15px;
            }
        }


        /* =====================================================
           SMALL MOBILE
        ===================================================== */

        @media (max-width: 420px) {

            .order-content {

                padding:
                    17px 14px;
            }


            .order-heading {

                gap:
                    10px;
            }


            .order-icon {

                width:
                    43px;

                height:
                    43px;

                flex-basis:
                    43px;
            }


            .order-id {

                font-size:
                    14px;
            }


            .order-date {

                font-size:
                    11px;
            }


            .detail-box {

                padding:
                    13px;
            }


            .payment-info {

                width:
                    100%;
            }


            .footer-actions {

                flex-direction:
                    column;
            }


            .view-details {

                width:
                    100%;
            }
        }


        /* =====================================================
           REDUCED MOTION
        ===================================================== */

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {

                animation-duration:
                    .01ms !important;

                animation-iteration-count:
                    1 !important;

                scroll-behavior:
                    auto !important;

                transition-duration:
                    .01ms !important;
            }
        }

    </style>

</head>


<body>


<!-- =========================================================
     LIQUID AURORA BACKGROUND
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

    <nav class="nav-inner"
         aria-label="Main navigation">


        <!-- BRAND -->

        <a class="brand"
           href="<%= contextPath %>/restaurant">

            <span class="brand-mark">
                🍴
            </span>

            <span class="brand-name">
                Foodwala
            </span>

        </a>


        <!-- NAV LINKS -->

        <div class="nav-links">

            <a class="nav-link"
               href="<%= contextPath %>/restaurant">

                Home

            </a>


            <a class="nav-link"
               href="<%= contextPath %>/restaurant">

                Restaurants

            </a>


            <a class="nav-link active"
               href="<%= contextPath %>/orders">

                My Orders

            </a>

        </div>


        <!-- NAV ACTIONS -->

        <div class="nav-actions">


            <!-- CART -->

            <a class="cart-nav"
               href="<%= contextPath %>/cart?action=view"
               aria-label="Cart"
               title="Cart">


                <svg class="cart-icon"
                     viewBox="0 0 24 24"
                     aria-hidden="true">

                    <path d="M3 4h2l2.4 11.2a2 2 0 0 0 2 1.6h7.8a2 2 0 0 0 1.9-1.4L21 8H6"/>

                    <circle cx="10" cy="20" r="1.3"/>

                    <circle cx="18" cy="20" r="1.3"/>

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


            <!-- PROFILE / LOGIN -->

            <% if (user != null) { %>

                <a class="profile-nav"
                   href="<%= contextPath %>/profile"
                   aria-label="My profile"
                   title="My profile">


                    <svg class="profile-icon"
                         viewBox="0 0 24 24"
                         aria-hidden="true">

                        <circle cx="12"
                                cy="8"
                                r="3.2"/>

                        <path d="M5.5 20c.7-3.2 2.9-5 6.5-5s5.8 1.8 6.5 5"/>

                    </svg>

                </a>

            <% } else { %>

                <a class="login-btn"
                   href="<%= contextPath %>/login">

                    Login

                </a>

            <% } %>

        </div>

    </nav>

</header>


<!-- =========================================================
     MAIN
========================================================= -->

<main class="page">


    <!-- =====================================================
         HERO
    ===================================================== -->

    <section class="hero">


        <span class="eyebrow">

            <span class="eyebrow-dot"></span>

            Your Food Journey

        </span>


        <h1>

            My
            <span class="gradient-text">
                Orders
            </span>

        </h1>


        <p>
            Track your Foodwala orders, check delivery details,
            and revisit everything you've ordered from your
            favourite restaurants.
        </p>


        <div class="hero-stats">


            <div class="stat-card">

                <span class="stat-icon">
                    ✓
                </span>

                <span class="stat-text">

                    <strong>
                        <%= orderCount %>
                    </strong>

                    Order<%= orderCount == 1 ? "" : "s" %>

                </span>

            </div>


            <div class="stat-card">

                <span class="stat-icon">
                    ♡
                </span>

                <span class="stat-text">
                    Made for food lovers
                </span>

            </div>


            <div class="stat-card">

                <span class="stat-icon">
                    ⚡
                </span>

                <span class="stat-text">
                    Fast &amp; easy tracking
                </span>

            </div>

        </div>

    </section>


    <!-- =====================================================
         ORDERS
    ===================================================== -->

    <% if (orders == null || orders.isEmpty()) { %>


        <!-- =================================================
             EMPTY ORDERS
        ================================================= -->

        <section class="empty-card">


            <div class="empty-icon">

                <svg viewBox="0 0 24 24"
                     aria-hidden="true">

                    <path d="M6 8h12l1 12H5L6 8Z"/>

                    <path d="M9 8a3 3 0 0 1 6 0"/>

                    <path d="M9 12h.01"/>

                    <path d="M15 12h.01"/>

                </svg>

            </div>


            <h2>
                No orders yet
            </h2>


            <p>
                Your delicious Foodwala journey starts here.
                Explore restaurants, choose your favourite
                dishes, and place your first order.
            </p>


            <a class="browse-btn"
               href="<%= contextPath %>/restaurant">

                Browse Restaurants


                <svg viewBox="0 0 24 24"
                     aria-hidden="true">

                    <path d="M5 12h14"/>

                    <path d="m13 6 6 6-6 6"/>

                </svg>

            </a>

        </section>


    <% } else { %>


        <!-- =================================================
             ORDER LIST
        ================================================= -->

        <section class="orders-list">


            <% for (Order order : orders) {

                if (order == null) {
                    continue;
                }

                String status =
                    order.getStatus() != null
                    ? order.getStatus()
                    : "Unknown";

                String statusClassValue =
                    statusClass(status);

                String statusIconValue =
                    statusIcon(status);
            %>


                <!-- =========================================
                     ORDER CARD
                ========================================== -->

                <article class="order-card">


                    <div class="order-content">


                        <!-- =================================
                             ORDER HEADER
                        ================================== -->

                        <div class="order-header">


                            <div class="order-heading">


                                <div class="order-icon">

                                    <svg viewBox="0 0 24 24"
                                         aria-hidden="true">

                                        <path d="M6 3h12v18H6z"/>

                                        <path d="M9 7h6"/>

                                        <path d="M9 11h6"/>

                                        <path d="M9 15h4"/>

                                    </svg>

                                </div>


                                <div class="order-title">


                                    <div class="order-id">

                                        Order #
                                        <%= esc(order.getOrderId()) %>

                                    </div>


                                    <div class="order-date">

                                        <%= esc(order.getOrderDate()) %>

                                    </div>

                                </div>

                            </div>


                            <!-- STATUS -->

                            <div class="status <%= statusClassValue %>">

                                <span class="status-dot"></span>

                                <span>
                                    <%= statusIconValue %>
                                    &nbsp;
                                    <%= esc(status) %>
                                </span>

                            </div>

                        </div>


                        <!-- =================================
                             DETAILS
                        ================================== -->

                        <div class="details-grid">


                            <!-- RESTAURANT -->

                            <div class="detail-box">


                                <div class="detail-label">

                                    <span class="detail-label-icon">

                                        <svg viewBox="0 0 24 24">

                                            <path d="M4 10h16"/>

                                            <path d="M6 10v9h12v-9"/>

                                            <path d="M5 10 7 5h10l2 5"/>

                                            <path d="M9 14h6"/>

                                        </svg>

                                    </span>

                                    Restaurant

                                </div>


                                <div class="detail-value">

                                    Restaurant
                                    #<%= esc(order.getRestaurantId()) %>

                                </div>

                            </div>


                            <!-- PAYMENT -->

                            <div class="detail-box">


                                <div class="detail-label">

                                    <span class="detail-label-icon">

                                        <svg viewBox="0 0 24 24">

                                            <rect x="3"
                                                  y="5"
                                                  width="18"
                                                  height="14"
                                                  rx="2"/>

                                            <path d="M3 10h18"/>

                                            <path d="M7 15h4"/>

                                        </svg>

                                    </span>

                                    Payment Method

                                </div>


                                <div class="detail-value">

                                    <%= esc(order.getPaymentMode()) %>

                                </div>

                            </div>


                            <!-- CUSTOMER -->

                            <div class="detail-box">


                                <div class="detail-label">

                                    <span class="detail-label-icon">

                                        <svg viewBox="0 0 24 24">

                                            <circle cx="12"
                                                    cy="8"
                                                    r="3"/>

                                            <path d="M5 20c.8-3.2 3.1-5 7-5s6.2 1.8 7 5"/>

                                        </svg>

                                    </span>

                                    Customer

                                </div>


                                <div class="detail-value">

                                    <%= esc(order.getUserId()) %>

                                </div>

                            </div>


                            <!-- DELIVERY ADDRESS -->

                            <div class="detail-box address">


                                <div class="detail-label">

                                    <span class="detail-label-icon">

                                        <svg viewBox="0 0 24 24">

                                            <path d="M12 21s7-6.1 7-12a7 7 0 1 0-14 0c0 5.9 7 12 7 12Z"/>

                                            <circle cx="12"
                                                    cy="9"
                                                    r="2.5"/>

                                        </svg>

                                    </span>

                                    Delivery Address

                                </div>


                                <div class="detail-value">

                                    <%= esc(order.getDeliveryAddress()) %>

                                </div>

                            </div>


                        </div>


                        <!-- =================================
                             ORDER FOOTER
                        ================================== -->

                        <div class="order-footer">


                            <!-- PAYMENT INFO -->

                            <div class="payment-info">


                                <span class="payment-mini-icon">

                                    ₹

                                </span>


                                <div>

                                    <strong>
                                        Payment
                                    </strong>

                                    <span>
                                        <%= esc(order.getPaymentMode()) %>
                                    </span>

                                </div>

                            </div>


                            <!-- ACTIONS -->

                            <div class="footer-actions">


                                <a class="view-details"
                                   href="<%= contextPath %>/order-details?orderId=<%= order.getOrderId() %>">

                                    View Details


                                    <svg viewBox="0 0 24 24"
                                         aria-hidden="true">

                                        <path d="M5 12h14"/>

                                        <path d="m13 6 6 6-6 6"/>

                                    </svg>

                                </a>


                                <div class="order-total">

                                    <div class="total-label">
                                        Total
                                    </div>

                                    <div class="total-value">

                                        ₹<%= money(order.getTotalAmount()) %>

                                    </div>

                                </div>

                            </div>

                        </div>


                    </div>

                </article>


            <% } %>


        </section>


    <% } %>


    <!-- =====================================================
         FOOTER
    ===================================================== -->

    <footer class="footer">

        Made with ♥ for food lovers · Foodwala

    </footer>


</main>


<!-- =========================================================
     MOBILE BOTTOM NAVIGATION
========================================================= -->

<nav class="mobile-nav"
     aria-label="Mobile navigation">


    <!-- HOME -->

    <a href="<%= contextPath %>/restaurant">

        <svg viewBox="0 0 24 24">

            <path d="m3 11 9-7 9 7"/>

            <path d="M5 10v10h14V10"/>

            <path d="M9 20v-6h6v6"/>

        </svg>

        <span>
            Home
        </span>

    </a>


    <!-- RESTAURANTS -->

    <a href="<%= contextPath %>/restaurant">

        <svg viewBox="0 0 24 24">

            <path d="M4 10h16"/>

            <path d="M6 10v9h12v-9"/>

            <path d="M5 10 7 5h10l2 5"/>

        </svg>

        <span>
            Restaurants
        </span>

    </a>


    <!-- CART -->

    <a href="<%= contextPath %>/cart?action=view">

        <svg viewBox="0 0 24 24">

            <path d="M3 4h2l2.4 11.2a2 2 0 0 0 2 1.6h7.8a2 2 0 0 0 1.9-1.4L21 8H6"/>

            <circle cx="10" cy="20" r="1.3"/>

            <circle cx="18" cy="20" r="1.3"/>

        </svg>

        <span>
            Cart
        </span>

    </a>


    <!-- ORDERS -->

    <a class="active"
       href="<%= contextPath %>/orders">

        <svg viewBox="0 0 24 24">

            <path d="M6 3h12v18H6z"/>

            <path d="M9 7h6"/>

            <path d="M9 11h6"/>

            <path d="M9 15h4"/>

        </svg>

        <span>
            Orders
        </span>

    </a>


    <!-- PROFILE / LOGIN -->

    <% if (user != null) { %>

        <a href="<%= contextPath %>/profile">

            <svg viewBox="0 0 24 24">

                <circle cx="12"
                        cy="8"
                        r="3.2"/>

                <path d="M5.5 20c.7-3.2 2.9-5 6.5-5s5.8 1.8 6.5 5"/>

            </svg>

            <span>
                Profile
            </span>

        </a>

    <% } else { %>

        <a href="<%= contextPath %>/login">

            <svg viewBox="0 0 24 24">

                <circle cx="12"
                        cy="8"
                        r="3.2"/>

                <path d="M5.5 20c.7-3.2 2.9-5 6.5-5s5.8 1.8 6.5 5"/>

            </svg>

            <span>
                Login
            </span>

        </a>

    <% } %>

</nav>


</body>

</html>