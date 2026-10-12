<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.CartItem" %>

<%!
    private static String esc(Object value) {

        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    private static String money(double value) {

        return String.format(
            java.util.Locale.US,
            "%.2f",
            value
        );
    }
%>

<%
    /* =========================================================
       ORDER DATA
       ========================================================= */

    Order order = (Order) request.getAttribute("order");

    if (order == null) {

        response.sendRedirect("restaurant");
        return;
    }

    String contextPath = request.getContextPath();


    /* =========================================================
       USER
       ========================================================= */

    User user = (User) request.getAttribute("user");

    if (user == null) {

        user = (User) session.getAttribute("loggedInUser");
    }


    /* =========================================================
       CART COUNT
       ========================================================= */

    int cartCount = 0;

    @SuppressWarnings("unchecked")
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

    if (cart != null) {

        for (CartItem item : cart) {

            if (item != null) {

                cartCount += item.getQuantity();
            }
        }
    }


    /* =========================================================
       ORDER VALUES
       ========================================================= */

    String orderStatus =
        order.getStatus() != null
        ? order.getStatus()
        : "PLACED";

    String orderDate =
        order.getOrderDate() != null
        ? String.valueOf(order.getOrderDate())
        : "Not available";

    String restaurantId =
        String.valueOf(order.getRestaurantId());

    String paymentMode =
        order.getPaymentMode() != null
        ? order.getPaymentMode()
        : "Not available";

    String deliveryAddress =
        order.getDeliveryAddress() != null
        ? order.getDeliveryAddress()
        : "Delivery address not available";

    double totalAmount =
        order.getTotalAmount();

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, viewport-fit=cover">

    <meta name="color-scheme"
          content="light dark">

    <meta name="theme-color"
          content="#F3EEFA"
          media="(prefers-color-scheme: light)">

    <meta name="theme-color"
          content="#07060D"
          media="(prefers-color-scheme: dark)">

    <title>Order Confirmed | Foodwala</title>


    <style>

        /* =========================================================
           FOODWALA
           SHARED GLOSSY LIQUID GLASS THEME
           ========================================================= */

        :root {

            --bg: #F3EEFA;

            --label: #1B1726;
            --label-2: #5A5468;
            --label-3: #75708A;

            --separator: rgba(60, 50, 90, .14);

            --hover: rgba(255,255,255,.60);

            /* FOODWALA GRADIENT */

            --a1: #FF8A3D;
            --a2: #FF2E63;
            --a3: #C026D3;

            /* COOL COLORS */

            --t1: #22D3C5;
            --t2: #6366F1;

            /* MAIN GRADIENT */

            --accent-gradient:
                linear-gradient(
                    135deg,
                    var(--a1) 0%,
                    var(--a2) 55%,
                    var(--a3) 115%
                );

            /* COOL GRADIENT */

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

            /* SUCCESS */

            --success: #0F8A45;

            --success-bright: #22C55E;

            --success-bg:
                rgba(20,170,90,.13);

            /* GLASS */

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


        /* =========================================================
           DARK MODE
           ========================================================= */

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

                --accent-glow:
                    rgba(255,115,145,.30);

                --success:
                    #34D67A;

                --success-bg:
                    rgba(52,214,122,.14);

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


        /* =========================================================
           RESET
           ========================================================= */

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


        /* =========================================================
           AURORA BACKGROUND
           ========================================================= */

        .aqua {

            position: fixed;

            inset: 0;

            z-index: -2;

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


        /* =========================================================
           SUBTLE BACKGROUND GRID
           ========================================================= */

        body::before {

            content: "";

            position: fixed;

            inset: 0;

            z-index: -1;

            pointer-events: none;

            opacity: .28;

            background-image:

                linear-gradient(
                    rgba(120,100,160,.05) 1px,
                    transparent 1px
                ),

                linear-gradient(
                    90deg,
                    rgba(120,100,160,.05) 1px,
                    transparent 1px
                );

            background-size: 45px 45px;

            mask-image:
                linear-gradient(
                    to bottom,
                    black,
                    transparent 85%
                );
        }


        /* =========================================================
           COMMON GLASS
           ========================================================= */

        .glass,
        .nav-inner,
        .summary-card,
        .detail-card,
        .mini-card {

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

        .glass {

            position: relative;

            overflow: hidden;

            border-radius:
                var(--r-xl);
        }

        .glass::before,
        .nav-inner::before,
        .detail-card::before,
        .summary-card::before {

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


        /* =========================================================
           NAVBAR
           ========================================================= */

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

            gap: 16px;
        }


        /* =========================================================
           BRAND
           ========================================================= */

        .brand {

            display: inline-flex;

            align-items: center;

            gap: 10px;

            position: relative;

            z-index: 2;

            white-space: nowrap;

            flex-shrink: 0;
        }

        .brand-mark {

            width: 35px;

            height: 35px;

            display: grid;

            place-items: center;

            border-radius: 12px;

            color: white;

            font-size: 17px;

            font-weight: 900;

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


        /* =========================================================
           NAV LINKS
           
           IMPORTANT:
           margin-left:auto pushes all navigation links
           to the RIGHT SIDE exactly like restaurant.jsp
           ========================================================= */

        .nav-links {

            display: flex;

            align-items: center;

            gap: 4px;

            position: relative;

            z-index: 2;

            margin-left: auto;
        }

        .nav-link {

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

            white-space: nowrap;
        }

        .nav-link:hover {

            color:
                var(--label);

            background:
                var(--hover);
        }

        .nav-link.active {

            color: white;

            background:
                var(--accent-gradient);

            box-shadow:
                0 7px 18px var(--accent-glow),
                inset 0 1px 0 rgba(255,255,255,.45);
        }


        /* =========================================================
           NAV ACTIONS
           ========================================================= */

        .nav-actions {

            display: flex;

            align-items: center;

            gap: 8px;

            position: relative;

            z-index: 2;

            flex-shrink: 0;
        }


        /* =========================================================
           CART NAV
           
           NOW SHOWS:
           🛍 CART
           
           instead of only the cart icon
           ========================================================= */

        .cart-nav {

            position: relative;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-width: 78px;

            height: 41px;

            padding: 0 13px;

            border-radius: 14px;

            color: var(--label-2);

            background:
                var(--glass-strong);

            border:
                1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60,40,120,.12);

            transition:
                .25s var(--spring);

            font-size: 14px;

            font-weight: 650;

            white-space: nowrap;
        }

        .cart-nav:hover {

            color: white;

            background:
                var(--accent-gradient);

            transform:
                translateY(-2px);
        }

        .cart-icon {

            width: 18px;

            height: 18px;

            display: block;

            flex-shrink: 0;
        }

        .cart-badge {

            position: absolute;

            top: -5px;

            right: -5px;

            min-width: 19px;

            height: 19px;

            padding:
                0 5px;

            display: inline-flex;

            justify-content: center;

            align-items: center;

            border-radius: 99px;

            background:
                var(--accent-gradient);

            color: white;

            font-size: 10px;

            font-weight: 800;

            border:
                2px solid var(--bg);
        }


        /* =========================================================
           PROFILE ICON
           
           NOW SHOWS A REAL PERSON / PROFILE ICON
           instead of the user's initial
           ========================================================= */

        .profile-nav {

            position: relative;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            width: 41px;

            height: 41px;

            border-radius: 50%;

            color: var(--label-2);

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

        .profile-nav:hover {

            color: white;

            background:
                var(--accent-gradient);

            transform:
                translateY(-2px);
        }

        .profile-icon {

            width: 21px;

            height: 21px;

            display: block;
        }


        /* =========================================================
           LOGIN
           ========================================================= */

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
        }


        /* =========================================================
           PAGE
           ========================================================= */

        .page {

            width:
                min(1180px, calc(100% - 34px));

            margin:
                38px auto 80px;
        }


        /* =========================================================
           HERO
           ========================================================= */

        .hero {

            position: relative;

            padding:
                24px 0 45px;

            text-align: center;
        }

        .eyebrow {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding:
                8px 14px;

            border:
                1px solid var(--glass-border);

            border-radius: 99px;

            color:
                var(--success);

            background:
                var(--glass);

            font-size: 11px;

            font-weight: 850;

            letter-spacing: .08em;

            text-transform: uppercase;

            box-shadow:
                var(--glass-shadow);
        }

        .eyebrow-dot {

            width: 8px;

            height: 8px;

            border-radius: 50%;

            background:
                var(--success-bright);

            box-shadow:
                0 0 0 5px
                rgba(34,197,94,.12),
                0 0 14px
                rgba(34,197,94,.45);
        }

        h1 {

            margin-top: 18px;

            font-size:
                clamp(36px, 5.5vw, 58px);

            line-height:
                1.04;

            font-weight:
                850;

            letter-spacing:
                -.05em;
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

            -webkit-background-clip:
                text;

            background-clip:
                text;

            -webkit-text-fill-color:
                transparent;

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

            max-width:
                680px;

            margin:
                15px auto 0;

            color:
                var(--label-2);

            font-size:
                15px;

            line-height:
                1.7;
        }


        /* =========================================================
           DECORATIVE WAVE
           ========================================================= */

        .wave-area {

            position: absolute;

            left: 50%;

            bottom: 0;

            width: 100vw;

            height: 75px;

            transform:
                translateX(-50%);

            overflow: hidden;

            pointer-events: none;

            opacity: .8;
        }

        .wave {

            position: absolute;

            left: -10%;

            width: 120%;

            height: 70px;

            border-radius:
                50% 50% 0 0;

            background:
                linear-gradient(
                    135deg,
                    rgba(255,138,61,.13),
                    rgba(255,46,99,.10),
                    rgba(99,102,241,.13)
                );

            filter:
                blur(1px);

            animation:
                waveMove 10s ease-in-out infinite alternate;
        }

        .wave.two {

            top: 16px;

            opacity: .5;

            animation-duration:
                15s;

            animation-delay:
                -4s;
        }

        @keyframes waveMove {

            from {

                transform:
                    translateX(-3%)
                    rotate(-1deg);
            }

            to {

                transform:
                    translateX(3%)
                    rotate(1deg);
            }
        }


        /* =========================================================
           SUCCESS MAIN CARD
           ========================================================= */

        .success-card {

            position: relative;

            overflow: hidden;

            border-radius:
                34px;

            padding:
                clamp(22px, 4vw, 42px);

            background:
                linear-gradient(
                    135deg,
                    var(--glass-strong),
                    var(--glass) 50%,
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
                var(--glass-shadow-hover);
        }

        .success-card::before {

            content: "";

            position: absolute;

            width: 360px;

            height: 360px;

            top: -180px;

            right: -130px;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(255,46,99,.17),
                    transparent 68%
                );

            filter:
                blur(12px);

            pointer-events: none;
        }

        .success-card::after {

            content: "";

            position: absolute;

            width: 300px;

            height: 300px;

            bottom: -180px;

            left: -120px;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(34,211,197,.16),
                    transparent 68%
                );

            filter:
                blur(15px);

            pointer-events: none;
        }


        /* =========================================================
           SUCCESS ICON
           ========================================================= */

        .success-top {

            position: relative;

            z-index: 2;

            text-align: center;
        }

        .success-icon-wrap {

            width: 104px;

            height: 104px;

            margin:
                0 auto 20px;

            display: grid;

            place-items: center;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(34,197,94,.18),
                    rgba(34,197,94,.07) 55%,
                    transparent 70%
                );
        }

        .success-icon {

            width: 72px;

            height: 72px;

            display: grid;

            place-items: center;

            border-radius: 50%;

            color: white;

            font-size: 32px;

            font-weight: 900;

            background:
                linear-gradient(
                    135deg,
                    #20C76A,
                    #0F8A45
                );

            box-shadow:
                0 14px 35px
                rgba(15,138,69,.28),
                inset 0 1.5px 0
                rgba(255,255,255,.7);

            animation:
                successPop .75s var(--spring);
        }

        @keyframes successPop {

            0% {

                opacity: 0;

                transform:
                    scale(.55)
                    rotate(-12deg);
            }

            70% {

                transform:
                    scale(1.08)
                    rotate(2deg);
            }

            100% {

                opacity: 1;

                transform:
                    scale(1)
                    rotate(0);
            }
        }

        .success-top h2 {

            font-size:
                clamp(25px, 4vw, 34px);

            font-weight:
                850;

            letter-spacing:
                -.04em;
        }

        .success-top p {

            max-width:
                650px;

            margin:
                10px auto 0;

            color:
                var(--label-2);

            font-size:
                14px;

            line-height:
                1.7;
        }


        /* =========================================================
           ORDER HIGHLIGHT
           ========================================================= */

        .order-highlight {

            position: relative;

            z-index: 2;

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 12px;

            margin:
                30px 0 24px;
        }

        .highlight-item {

            position: relative;

            overflow: hidden;

            padding:
                17px;

            border-radius:
                18px;

            border:
                1px solid var(--separator);

            background:
                linear-gradient(
                    135deg,
                    rgba(255,255,255,.35),
                    rgba(255,255,255,.13)
                );

            box-shadow:
                inset 0 1px 0
                rgba(255,255,255,.5);

            transition:
                .25s var(--spring);
        }

        .highlight-item:hover {

            transform:
                translateY(-3px);

            box-shadow:
                var(--glass-shadow-hover);
        }

        .highlight-label {

            color:
                var(--label-3);

            font-size:
                10px;

            font-weight:
                800;

            letter-spacing:
                .08em;

            text-transform:
                uppercase;
        }

        .highlight-value {

            display: block;

            margin-top:
                7px;

            font-size:
                15px;

            font-weight:
                850;

            overflow-wrap:
                anywhere;
        }

        .highlight-value.amount {

            background:
                var(--accent-gradient);

            -webkit-background-clip:
                text;

            background-clip:
                text;

            -webkit-text-fill-color:
                transparent;

            font-size:
                19px;
        }


        /* =========================================================
           ORDER DETAILS
           ========================================================= */

        .details-section {

            position: relative;

            z-index: 2;

            margin-top:
                10px;
        }

        .details-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            margin-bottom:
                15px;
        }

        .details-title {

            display: flex;

            align-items: center;

            gap: 11px;
        }

        .details-icon {

            width: 42px;

            height: 42px;

            display: grid;

            place-items: center;

            border-radius: 13px;

            color: white;

            background:
                var(--accent-gradient);

            box-shadow:
                0 8px 20px
                var(--accent-glow);
        }

        .details-title h3 {

            font-size:
                18px;

            font-weight:
                850;
        }

        .details-title p {

            margin-top:
                3px;

            color:
                var(--label-2);

            font-size:
                11px;
        }

        .status-pill {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding:
                8px 12px;

            border-radius:
                999px;

            color:
                var(--success);

            background:
                var(--success-bg);

            border:
                1px solid
                rgba(34,197,94,.20);

            font-size:
                11px;

            font-weight:
                850;

            text-transform:
                uppercase;
        }

        .status-dot {

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background:
                var(--success-bright);

            box-shadow:
                0 0 10px
                rgba(34,197,94,.55);
        }


        /* =========================================================
           DETAIL GRID
           ========================================================= */

        .details-grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0,1fr));

            gap: 12px;
        }

        .detail-card {

            position: relative;

            min-height:
                88px;

            overflow: hidden;

            padding:
                16px;

            border-radius:
                18px;

            transition:
                .25s var(--spring);
        }

        .detail-card:hover {

            transform:
                translateY(-3px);

            box-shadow:
                var(--glass-shadow-hover);
        }

        .detail-card.full {

            grid-column:
                1 / -1;
        }

        .detail-inner {

            position: relative;

            z-index: 2;

            display: flex;

            align-items: flex-start;

            gap: 12px;
        }

        .detail-symbol {

            flex:
                0 0 38px;

            width: 38px;

            height: 38px;

            display: grid;

            place-items: center;

            border-radius: 12px;

            color:
                var(--accent-solid);

            background:
                linear-gradient(
                    135deg,
                    rgba(255,138,61,.14),
                    rgba(255,46,99,.10),
                    rgba(99,102,241,.10)
                );

            border:
                1px solid
                rgba(255,46,99,.10);
        }

        .detail-label {

            color:
                var(--label-3);

            font-size:
                10px;

            font-weight:
                800;

            letter-spacing:
                .07em;

            text-transform:
                uppercase;
        }

        .detail-value {

            margin-top:
                5px;

            color:
                var(--label);

            font-size:
                13px;

            font-weight:
                750;

            line-height:
                1.55;

            overflow-wrap:
                anywhere;
        }


        /* =========================================================
           TOTAL
           ========================================================= */

        .total-card {

            position: relative;

            z-index: 2;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            margin-top:
                16px;

            padding:
                18px 20px;

            border-radius:
                19px;

            background:
                linear-gradient(
                    135deg,
                    rgba(255,138,61,.12),
                    rgba(255,46,99,.10),
                    rgba(192,38,211,.08),
                    rgba(99,102,241,.10)
                );

            border:
                1px solid
                rgba(255,255,255,.65);

            box-shadow:
                inset 0 1px 0
                rgba(255,255,255,.75);
        }

        .total-label {

            color:
                var(--label-2);

            font-size:
                12px;

            font-weight:
                700;
        }

        .total-sub {

            margin-top:
                3px;

            color:
                var(--label-3);

            font-size:
                10px;
        }

        .total-value {

            font-size:
                26px;

            font-weight:
                900;

            letter-spacing:
                -.04em;

            background:
                var(--accent-gradient);

            -webkit-background-clip:
                text;

            background-clip:
                text;

            -webkit-text-fill-color:
                transparent;

            white-space:
                nowrap;
        }


        /* =========================================================
           ACTION BUTTONS
           ========================================================= */

        .actions {

            position: relative;

            z-index: 2;

            display: grid;

            grid-template-columns:
                1fr 1fr;

            gap: 13px;

            margin-top:
                25px;
        }

        .action-btn {

            position: relative;

            overflow: hidden;

            min-height:
                53px;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            border-radius:
                15px;

            font-size:
                13px;

            font-weight:
                850;

            transition:
                transform .25s var(--spring),
                filter .2s ease;
        }

        .action-btn:hover {

            transform:
                translateY(-2px);

            filter:
                brightness(1.05);
        }

        .primary-action {

            color:
                white;

            background:
                var(--accent-gradient);

            box-shadow:
                0 12px 26px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6),
                inset 0 -3px 6px rgba(120,0,40,.2);
        }

        .primary-action::before {

            content: "";

            position: absolute;

            inset: 0;

            background:
                linear-gradient(
                    180deg,
                    rgba(255,255,255,.45),
                    transparent 52%
                );

            pointer-events: none;
        }

        .secondary-action {

            color:
                var(--label);

            background:
                var(--glass-strong);

            border:
                1px solid
                var(--glass-border);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow);
        }

        .secondary-action:hover {

            color:
                white;

            background:
                var(--cool-gradient);
        }


        /* =========================================================
           SECURITY MESSAGE
           ========================================================= */

        .secure-note {

            position: relative;

            z-index: 2;

            display: flex;

            align-items: flex-start;

            gap: 10px;

            margin-top:
                18px;

            padding:
                13px 15px;

            border-radius:
                15px;

            background:
                rgba(34,211,197,.08);

            border:
                1px solid
                rgba(34,211,197,.13);

            color:
                var(--label-2);

            font-size:
                11px;

            line-height:
                1.55;
        }

        .secure-icon {

            flex:
                0 0 25px;

            width: 25px;

            height: 25px;

            display: grid;

            place-items: center;

            border-radius:
                8px;

            color:
                white;

            background:
                var(--cool-gradient);

            font-size:
                11px;

            font-weight:
                900;
        }

        .secure-note strong {

            color:
                var(--label);
        }


        /* =========================================================
           FLOATING MINI CARD
           ========================================================= */

        .mini-card {

            position: absolute;

            right:
                25px;

            top:
                18px;

            z-index: 3;

            display: flex;

            align-items: center;

            gap: 9px;

            padding:
                10px 13px;

            border-radius:
                15px;

            animation:
                floatMini 4s ease-in-out infinite;
        }

        .mini-icon {

            width: 31px;

            height: 31px;

            display: grid;

            place-items: center;

            border-radius:
                10px;

            color:
                white;

            background:
                var(--cool-gradient);
        }

        .mini-text strong {

            display: block;

            font-size:
                11px;

            font-weight:
                850;
        }

        .mini-text span {

            display: block;

            margin-top:
                2px;

            color:
                var(--label-3);

            font-size:
                9px;
        }

        @keyframes floatMini {

            0%,100% {

                transform:
                    translateY(0);
            }

            50% {

                transform:
                    translateY(-6px);
            }
        }


        /* =========================================================
           FOOTER
           ========================================================= */

        .footer {

            text-align:
                center;

            padding:
                25px 12px 0;

            color:
                var(--label-3);

            font-size:
                11px;
        }


        /* =========================================================
           TABLET
           ========================================================= */

        @media (max-width: 850px) {

            .mini-card {
                display: none;
            }

            .page {

                margin-top:
                    28px;
            }

            .success-card {

                border-radius:
                    28px;
            }
        }


        /* =========================================================
           MOBILE
           ========================================================= */

        @media (max-width: 640px) {

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

                margin-left:
                    auto;
            }

            .cart-nav {

                min-width:
                    67px;

                height:
                    35px;

                padding:
                    0 10px;

                gap:
                    5px;

                font-size:
                    12px;
            }

            .cart-icon {

                width:
                    16px;

                height:
                    16px;
            }

            .profile-nav {

                width:
                    35px;

                height:
                    35px;
            }

            .profile-icon {

                width:
                    19px;

                height:
                    19px;
            }

            .login-btn {

                padding:
                    9px 11px;

                font-size:
                    11px;
            }

            .page {

                width:
                    calc(100% - 22px);

                margin-top:
                    22px;

                margin-bottom:
                    35px;
            }

            .hero {

                padding:
                    12px 0 35px;
            }

            h1 {

                font-size:
                    35px;
            }

            .hero p {

                font-size:
                    13px;
            }

            .success-card {

                padding:
                    20px 15px;

                border-radius:
                    24px;
            }

            .success-icon-wrap {

                width:
                    90px;

                height:
                    90px;
            }

            .success-icon {

                width:
                    64px;

                height:
                    64px;

                font-size:
                    28px;
            }

            .success-top h2 {

                font-size:
                    25px;
            }

            .success-top p {

                font-size:
                    13px;
            }

            .order-highlight {

                grid-template-columns:
                    1fr;

                gap:
                    9px;

                margin-top:
                    24px;
            }

            .highlight-item {

                min-height:
                    auto;

                padding:
                    14px;
            }

            .details-header {

                align-items:
                    flex-start;

                flex-direction:
                    column;
            }

            .status-pill {

                align-self:
                    flex-start;
            }

            .details-grid {

                grid-template-columns:
                    1fr;
            }

            .detail-card.full {

                grid-column:
                    auto;
            }

            .total-card {

                align-items:
                    flex-start;

                flex-direction:
                    column;

                gap:
                    7px;
            }

            .total-value {

                font-size:
                    24px;
            }

            .actions {

                grid-template-columns:
                    1fr;

                gap:
                    10px;
            }

            .wave-area {

                height:
                    55px;
            }
        }


        /* =========================================================
           SMALL MOBILE
           ========================================================= */

        @media (max-width: 430px) {

            .brand-name {

                font-size:
                    15px;
            }

            .cart-nav {

                min-width:
                    63px;

                padding:
                    0 8px;
            }

            .success-card {

                padding:
                    18px 13px;
            }

            .detail-card {

                padding:
                    14px;
            }

            .detail-symbol {

                width:
                    35px;

                height:
                    35px;

                flex-basis:
                    35px;
            }
        }


        /* =========================================================
           REDUCED MOTION
           ========================================================= */

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

    <nav class="nav-inner"
         aria-label="Main navigation">


        <!-- BRAND -->

        <a class="brand"
           href="<%= contextPath %>/restaurant">

            <span class="brand-mark">
                F
            </span>

            <span class="brand-name">
                Foodwala
            </span>

        </a>


        <!-- =====================================================
             NAV LINKS

             margin-left:auto in CSS pushes these links
             to the RIGHT side.
             ===================================================== -->

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

                Orders

            </a>

        </div>


        <!-- =====================================================
             NAV ACTIONS
             ===================================================== -->

        <div class="nav-actions">


            <!-- CART WITH TEXT -->

            <a class="cart-nav"
               href="<%= contextPath %>/cart?action=view"
               aria-label="Cart"
               title="Cart">


                <!-- Shopping bag SVG -->

                <svg class="cart-icon"
                     viewBox="0 0 24 24"
                     fill="none"
                     xmlns="http://www.w3.org/2000/svg"
                     aria-hidden="true">

                    <path
                        d="M6.5 8.5H17.5L19 21H5L6.5 8.5Z"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linejoin="round"/>

                    <path
                        d="M9 9V6.5C9 4.567 10.343 3 12 3C13.657 3 15 4.567 15 6.5V9"
                        stroke="currentColor"
                        stroke-width="1.8"
                        stroke-linecap="round"/>

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


            <!-- =================================================
                 PROFILE ICON
                 ================================================= -->

            <% if (user != null) { %>

                <a class="profile-nav"
                   href="<%= contextPath %>/profile"
                   aria-label="My profile"
                   title="My profile">


                    <!-- Person/Profile SVG -->

                    <svg class="profile-icon"
                         viewBox="0 0 24 24"
                         fill="none"
                         xmlns="http://www.w3.org/2000/svg"
                         aria-hidden="true">

                        <!-- Head -->

                        <circle
                            cx="12"
                            cy="8"
                            r="3.2"
                            stroke="currentColor"
                            stroke-width="1.8"/>


                        <!-- Body -->

                        <path
                            d="M5.5 20C6.1 16.7 8.25 14.8 12 14.8C15.75 14.8 17.9 16.7 18.5 20"
                            stroke="currentColor"
                            stroke-width="1.8"
                            stroke-linecap="round"/>

                    </svg>

                </a>


            <% } else { %>


                <!-- LOGIN -->

                <a class="login-btn"
                   href="<%= contextPath %>/login">

                    Login

                </a>


            <% } %>


        </div>

    </nav>

</header>


<!-- =========================================================
     MAIN PAGE
     ========================================================= -->

<main class="page">


    <!-- =====================================================
         HERO
         ===================================================== -->

    <section class="hero">


        <span class="eyebrow">

            <span class="eyebrow-dot"></span>

            Order Confirmed

        </span>


        <h1>

            Order Placed

            <span class="gradient-text">

                Successfully!

            </span>

        </h1>


        <p>

            Your delicious food is on its way.
            Your order has been received successfully
            and all the details are available below.

        </p>


        <div class="wave-area"
             aria-hidden="true">

            <div class="wave"></div>

            <div class="wave two"></div>

        </div>

    </section>


    <!-- =====================================================
         SUCCESS CARD
         ===================================================== -->

    <section class="success-card">


        <!-- FLOATING CARD -->

        <div class="mini-card">

            <div class="mini-icon">

                ✓

            </div>

            <div class="mini-text">

                <strong>
                    Order Confirmed
                </strong>

                <span>
                    Foodwala has received your order
                </span>

            </div>

        </div>


        <!-- =================================================
             SUCCESS HEADER
             ================================================= -->

        <div class="success-top">


            <div class="success-icon-wrap">

                <div class="success-icon">

                    ✓

                </div>

            </div>


            <h2>

                Thank You for Ordering!

            </h2>


            <p>

                Your order has been placed successfully.
                Sit back, relax and get ready for something delicious.

            </p>

        </div>


        <!-- =================================================
             QUICK ORDER SUMMARY
             ================================================= -->

        <div class="order-highlight">


            <div class="highlight-item">

                <span class="highlight-label">

                    Order ID

                </span>

                <span class="highlight-value">

                    #<%= order.getOrderId() %>

                </span>

            </div>


            <div class="highlight-item">

                <span class="highlight-label">

                    Payment

                </span>

                <span class="highlight-value">

                    <%= esc(paymentMode) %>

                </span>

            </div>


            <div class="highlight-item">

                <span class="highlight-label">

                    Total Paid

                </span>

                <span class="highlight-value amount">

                    ₹<%= money(totalAmount) %>

                </span>

            </div>


        </div>


        <!-- =================================================
             ORDER DETAILS
             ================================================= -->

        <div class="details-section">


            <div class="details-header">


                <div class="details-title">


                    <div class="details-icon">

                        🧾

                    </div>


                    <div>

                        <h3>

                            Order Details

                        </h3>

                        <p>

                            Complete information about your order

                        </p>

                    </div>


                </div>


                <div class="status-pill">

                    <span class="status-dot"></span>

                    <%= esc(orderStatus) %>

                </div>


            </div>


            <!-- DETAILS GRID -->

            <div class="details-grid">


                <!-- ORDER ID -->

                <div class="detail-card">

                    <div class="detail-inner">

                        <div class="detail-symbol">

                            #

                        </div>

                        <div>

                            <div class="detail-label">

                                Order ID

                            </div>

                            <div class="detail-value">

                                #<%= order.getOrderId() %>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- ORDER DATE -->

                <div class="detail-card">

                    <div class="detail-inner">

                        <div class="detail-symbol">

                            📅

                        </div>

                        <div>

                            <div class="detail-label">

                                Order Date

                            </div>

                            <div class="detail-value">

                                <%= esc(orderDate) %>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- RESTAURANT -->

                <div class="detail-card">

                    <div class="detail-inner">

                        <div class="detail-symbol">

                            🍽

                        </div>

                        <div>

                            <div class="detail-label">

                                Restaurant ID

                            </div>

                            <div class="detail-value">

                                <%= esc(restaurantId) %>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- PAYMENT -->

                <div class="detail-card">

                    <div class="detail-inner">

                        <div class="detail-symbol">

                            💳

                        </div>

                        <div>

                            <div class="detail-label">

                                Payment Method

                            </div>

                            <div class="detail-value">

                                <%= esc(paymentMode) %>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- DELIVERY ADDRESS -->

                <div class="detail-card full">

                    <div class="detail-inner">

                        <div class="detail-symbol">

                            📍

                        </div>

                        <div>

                            <div class="detail-label">

                                Delivery Address

                            </div>

                            <div class="detail-value">

                                <%= esc(deliveryAddress) %>

                            </div>

                        </div>

                    </div>

                </div>


            </div>


            <!-- =================================================
                 TOTAL
                 ================================================= -->

            <div class="total-card">


                <div>

                    <div class="total-label">

                        Total Order Amount

                    </div>

                    <div class="total-sub">

                        Including your selected payment method

                    </div>

                </div>


                <div class="total-value">

                    ₹<%= money(totalAmount) %>

                </div>


            </div>


        </div>


        <!-- =================================================
             SECURITY MESSAGE
             ================================================= -->

        <div class="secure-note">


            <div class="secure-icon">

                ✓

            </div>


            <div>

                <strong>

                    Your order is safe with us

                </strong>

                <br>

                Your order information has been recorded
                securely by Foodwala.

            </div>


        </div>


        <!-- =================================================
             ACTION BUTTONS
             ================================================= -->

        <div class="actions">


            <a class="action-btn primary-action"
               href="<%= contextPath %>/orders">

                <span>
                    📦
                </span>

                View My Orders

            </a>


            <a class="action-btn secondary-action"
               href="<%= contextPath %>/restaurant">

                <span>
                    🍴
                </span>

                Continue Ordering

            </a>


        </div>


    </section>


    <!-- =====================================================
         FOOTER
         ===================================================== -->

    <footer class="footer">

        Made with ♥ for food lovers · Foodwala

    </footer>


</main>


</body>

</html>