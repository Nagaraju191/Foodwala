<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.model.User"%>

<%!
    /* =========================================================
       HTML ESCAPE
       ========================================================= */
    private static String esc(Object value) {

        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }


    /* =========================================================
       FIRST LETTER
       ========================================================= */
    private static String firstLetter(String value) {

        if (value == null) {
            return "U";
        }

        value = value.trim();

        if (value.isEmpty()) {
            return "U";
        }

        return value.substring(0, 1).toUpperCase();
    }
%>


<%
    /* =========================================================
       CONTEXT
       ========================================================= */

    String contextPath = request.getContextPath();


    /* =========================================================
       USER
       ========================================================= */

    User user =
            (User) request.getAttribute("user");

    if (user == null) {

        user =
                (User) session.getAttribute("loggedInUser");
    }


    /* =========================================================
       CART
       ========================================================= */

    @SuppressWarnings("unchecked")
    List<CartItem> cart =
            (List<CartItem>) request.getAttribute("cart");

    if (cart == null) {

        @SuppressWarnings("unchecked")
        List<CartItem> sessionCart =
                (List<CartItem>) session.getAttribute("cart");

        cart = sessionCart;
    }


    /* =========================================================
       CART COUNT
       ========================================================= */

    int cartCount = 0;

    if (cart != null) {

        for (CartItem item : cart) {

            if (item != null) {

                cartCount += item.getQuantity();
            }
        }
    }


    /* =========================================================
       TOTAL
       ========================================================= */

    Double totalAmountObj =
            (Double) request.getAttribute("totalAmount");

    double totalAmount =
            totalAmountObj != null
                    ? totalAmountObj
                    : 0.0;


    double deliveryFee =
            totalAmount > 0
                    ? 40.00
                    : 0.00;


    double finalAmount =
            totalAmount + deliveryFee;


    /* =========================================================
       SAVED ADDRESS
       ========================================================= */

    String savedAddress =
            (String) request.getAttribute("savedAddress");

    if (savedAddress == null && user != null) {

        savedAddress =
                user.getAddress();
    }


    /* =========================================================
       ADDRESS VALUES
       ========================================================= */

    String houseNo =
            (String) request.getAttribute("houseNo");

    String street =
            (String) request.getAttribute("street");

    String city =
            (String) request.getAttribute("city");

    String state =
            (String) request.getAttribute("state");

    String pincode =
            (String) request.getAttribute("pincode");

    String landmark =
            (String) request.getAttribute("landmark");


    /* =========================================================
       ERROR
       ========================================================= */

    String errorMessage =
            (String) request.getAttribute("errorMessage");


    /* =========================================================
       USER NAME
       ========================================================= */

    String username = "";

    if (user != null &&
        user.getUsername() != null) {

        username =
                user.getUsername();
    }

    String userInitial =
            firstLetter(username);
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
          content="#F3EEFA">

    <title>Foodwala - Checkout</title>


    <script>
        document.documentElement.className += " js";
    </script>


    <style>

        /* =========================================================
           FOODWALA CHECKOUT
           SAME LIQUID GLASS DESIGN AS RESTAURANT PAGE
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

            --accent-tint:
                rgba(255, 46, 99, .12);

            --accent-glow:
                rgba(255, 46, 99, .38);

            --success: #0F8A45;

            --success-bg:
                rgba(20, 170, 90, .16);

            --danger: #E0342B;

            --danger-bg:
                rgba(255, 59, 48, .13);

            --glass:
                rgba(255, 255, 255, .52);

            --glass-strong:
                rgba(255, 255, 255, .78);

            --glass-soft:
                rgba(255, 255, 255, .28);

            --glass-border:
                rgba(255, 255, 255, .85);

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

            --blur:
                blur(28px) saturate(200%);

            --toast-bg:
                rgba(27, 23, 38, .88);

            --toast-fg:
                #fff;

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

            --spring:
                cubic-bezier(.34, 1.56, .64, 1);

            --ease:
                cubic-bezier(.22, .61, .36, 1);

            --wave:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 60' preserveAspectRatio='none'%3E%3Cpath d='M0 34 C200 6 400 62 600 34 S1000 6 1200 34 V60 H0Z'/%3E%3C/svg%3E");
        }


        @media (prefers-color-scheme: dark) {

            :root {

                --bg: #07060D;

                --label: #F6F4FB;

                --label-2: #A6A2B6;

                --label-3: #8F8BA2;

                --separator:
                    rgba(255, 255, 255, .12);

                --hover:
                    rgba(255, 255, 255, .1);

                --accent-solid:
                    #FF7391;

                --accent-tint:
                    rgba(255, 115, 145, .17);

                --success:
                    #34D67A;

                --success-bg:
                    rgba(52, 214, 122, .17);

                --danger:
                    #FF7168;

                --danger-bg:
                    rgba(255, 113, 104, .17);

                --glass:
                    rgba(40, 36, 58, .5);

                --glass-strong:
                    rgba(48, 43, 68, .76);

                --glass-soft:
                    rgba(255, 255, 255, .06);

                --glass-border:
                    rgba(255, 255, 255, .17);

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

                --toast-bg:
                    rgba(246, 244, 251, .92);

                --toast-fg:
                    #1B1726;

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

            min-height: 100vh;

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

            padding-bottom: 40px;

            overflow-x: hidden;

            position: relative;

            isolation: isolate;
        }


        a {

            color: inherit;
        }


        button,
        input {

            font-family: inherit;
        }


        :focus-visible {

            outline:
                3px solid var(--accent-solid);

            outline-offset: 2px;
        }


        /* =========================================================
           AURORA BACKGROUND
           EXACT RESTAURANT PAGE STYLE
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


        /* =========================================================
           GLASS SURFACES
           ========================================================= */

        .glass,
        .summary-card,
        .nav-inner,
        .address-preview,
        .payment-card,
        .item-card,
        .saved-address,
        .step-card {

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


        .glass::before,
        .summary-card::before,
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


        /* =========================================================
           NAVBAR
           SAME AS RESTAURANT PAGE
           ========================================================= */

        .navbar {

            position: sticky;

            top: 0;

            z-index: 100;

            padding: 10px 14px 0;
        }


        .nav-inner {

            position: relative;

            width: 100%;

            max-width: 1250px;

            margin: 0 auto;

            height: 60px;

            padding: 0 10px 0 16px;

            border-radius: 24px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            transition:
                box-shadow .3s ease;
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

            background:
                var(--accent-gradient);

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
		    margin-left: auto;
		    position: relative;
		    z-index: 3;
		}
		
		.nav-right {
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

            font-size: 13px;

            font-weight: 800;
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


        .login-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            padding: 9px 17px;

            border-radius: var(--r-full);

            text-decoration: none;

            color: #fff;

            background: var(--accent-gradient);

            font-size: 13px;

            font-weight: 750;

            box-shadow: var(--shadow-accent);

            transition:
                transform .3s var(--spring),
                filter .2s ease;
        }


        .login-btn:hover {

            filter: brightness(1.08);

            transform: translateY(-2px);
        }


        /* =========================================================
           PAGE HEADER
           SAME RESTAURANT PAGE STYLE
           ========================================================= */

        .title-header {

            position: relative;

            padding: 44px 0 58px;

            overflow: hidden;
        }


        .title-inner {

            position: relative;

            z-index: 1;

            width: 88%;

            max-width: 1250px;

            margin: 0 auto;
        }


        .eyebrow {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            color: var(--accent-solid);

            font-size: 13px;

            font-weight: 700;

            margin-bottom: 10px;
        }


        .eyebrow::before {

            content: "";

            width: 8px;

            height: 8px;

            border-radius: 50%;

            background: var(--accent-gradient);

            box-shadow:
                0 0 0 5px var(--accent-tint);

            animation:
                breathe 2.6s ease-in-out infinite;
        }


        .large-title {

            display: inline-block;

            font-size: 42px;

            font-weight: 800;

            letter-spacing: -.03em;

            margin-bottom: 8px;

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

            animation:
                titleFlow 9s linear infinite;
        }


        .title-subtitle {

            color: var(--label-2);

            font-size: 15.5px;

            max-width: 680px;

            line-height: 1.6;
        }


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

            animation-duration:
                24s,
                14s;

            animation-direction:
                reverse,
                normal;
        }


        /* =========================================================
           MAIN
           ========================================================= */

        .container {

            width: 88%;

            max-width: 1250px;

            margin: 0 auto 80px;
        }


        /* =========================================================
           ERROR
           ========================================================= */

        .error-message {

            margin-bottom: 22px;

            padding: 14px 17px;

            display: flex;

            align-items: center;

            gap: 11px;

            border-radius: var(--r-lg);

            color: var(--danger);

            background:
                var(--danger-bg);

            border:
                1px solid rgba(255,59,48,.18);

            font-size: 13px;

            font-weight: 650;
        }


        .error-symbol {

            width: 29px;

            height: 29px;

            flex-shrink: 0;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 10px;

            background:
                rgba(255,59,48,.13);

            font-weight: 900;
        }


        /* =========================================================
           CHECKOUT GRID
           ========================================================= */

        .checkout-grid {

            display: grid;

            grid-template-columns:
                minmax(0, 1.55fr)
                minmax(350px, .85fr);

            gap: 22px;

            align-items: start;
        }


        /* =========================================================
           GLASS CARD
           ========================================================= */

        .glass {

            position: relative;

            overflow: hidden;

            border-radius: var(--r-xl);

            padding: 0;
        }


        .card-content {

            position: relative;

            z-index: 3;

            padding: 28px;
        }


        /* =========================================================
           SECTION HEADER
           ========================================================= */

        .section-header {

            display: flex;

            align-items: center;

            gap: 13px;

            margin-bottom: 24px;
        }


        .section-icon {

            width: 48px;

            height: 48px;

            flex-shrink: 0;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 15px;

            color: #fff;

            background:
                var(--accent-gradient);

            box-shadow:
                var(--shadow-accent);

            font-size: 20px;
        }


        .section-header h2 {

            font-size: 21px;

            font-weight: 800;

            letter-spacing: -.02em;
        }


        .section-header p {

            margin-top: 4px;

            color: var(--label-2);

            font-size: 12.5px;
        }


        /* =========================================================
           FORM
           ========================================================= */

        .form-grid {

            display: grid;

            grid-template-columns:
                1fr 1fr;

            gap: 17px;
        }


        .field {

            display: flex;

            flex-direction: column;

            gap: 8px;
        }


        .field.full {

            grid-column: 1 / -1;
        }


        .field label {

            color: var(--label-2);

            font-size: 12px;

            font-weight: 750;
        }


        .required {

            color: var(--accent-solid);
        }


        .input {

            width: 100%;

            height: 51px;

            padding: 0 15px;

            outline: none;

            border-radius: var(--r-md);

            border:
                1px solid rgba(120,110,145,.22);

            color: var(--label);

            background:
                rgba(255,255,255,.38);

            box-shadow:
                inset 0 1px 0 rgba(255,255,255,.65);

            transition:
                border .25s ease,
                box-shadow .25s ease,
                background .25s ease,
                transform .25s ease;
        }


        .input::placeholder {

            color: var(--label-3);
        }


        .input:hover {

            background:
                rgba(255,255,255,.58);

            border-color:
                rgba(255,46,99,.22);
        }


        .input:focus {

            background:
                rgba(255,255,255,.75);

            border-color:
                var(--a2);

            box-shadow:
                var(--glass-inset),
                0 0 0 4px var(--accent-tint),
                0 10px 30px rgba(60,40,120,.10);

            transform:
                translateY(-1px);
        }


        .input.error {

            border-color:
                var(--danger);

            background:
                var(--danger-bg);
        }


        /* =========================================================
           SAVED ADDRESS
           ========================================================= */

        .saved-address {

            margin-top: 22px;

            padding: 16px;

            border-radius: var(--r-lg);

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            position: relative;

            overflow: hidden;
        }


        .saved-address-info {

            position: relative;

            z-index: 3;

            min-width: 0;
        }


        .saved-address-label {

            color: var(--accent-solid);

            font-size: 10px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: .7px;

            margin-bottom: 5px;
        }


        .saved-address-text {

            color: var(--label-2);

            font-size: 11.5px;

            line-height: 1.55;
        }


        .profile-address-btn {

            position: relative;

            z-index: 3;

            flex-shrink: 0;

            padding: 10px 15px;

            border: none;

            border-radius: var(--r-full);

            cursor: pointer;

            color: #fff;

            background: var(--accent-gradient);

            box-shadow: var(--shadow-accent);

            font-size: 11px;

            font-weight: 750;

            transition:
                transform .3s var(--spring),
                filter .2s ease;
        }


        .profile-address-btn:hover {

            filter: brightness(1.08);

            transform:
                translateY(-2px);
        }


        /* =========================================================
           ADDRESS PREVIEW
           ========================================================= */

        .address-preview {

            margin-top: 18px;

            padding: 16px 18px;

            border-radius: var(--r-lg);

            display: flex;

            gap: 12px;

            position: relative;

            overflow: hidden;
        }


        .preview-icon {

            width: 38px;

            height: 38px;

            flex-shrink: 0;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            color: #fff;

            background: var(--cool-gradient);

            box-shadow:
                0 8px 20px rgba(99,102,241,.22);

            font-size: 16px;
        }


        .preview-content {

            position: relative;

            z-index: 3;
        }


        .preview-title {

            color: var(--label);

            font-size: 11px;

            font-weight: 800;

            margin-bottom: 4px;
        }


        .preview-text {

            color: var(--label-2);

            font-size: 11px;

            line-height: 1.55;
        }


        /* =========================================================
           PAYMENT
           ========================================================= */

        .payment-section {

            margin-top: 22px;
        }


        .payment-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 12px;
        }


        .payment-option {

            position: relative;
        }


        .payment-option input {

            position: absolute;

            opacity: 0;

            pointer-events: none;
        }


        .payment-card {

            position: relative;

            overflow: hidden;

            min-height: 132px;

            padding: 16px;

            border-radius: var(--r-lg);

            cursor: pointer;

            transition:
                transform .35s var(--spring),
                box-shadow .3s ease,
                border .25s ease;
        }


        .payment-card:hover {

            transform:
                translateY(-5px);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }


        .payment-option input:checked
        + .payment-card {

            border-color:
                var(--a2);

            box-shadow:
                var(--glass-inset),
                0 15px 35px rgba(255,46,99,.17);
        }


        .payment-card::after {

            content: "";

            position: absolute;

            inset: 0;

            pointer-events: none;

            opacity: 0;

            background:
                linear-gradient(
                    115deg,
                    rgba(255,255,255,.28),
                    transparent 40%
                );

            transition: opacity .3s ease;
        }


        .payment-option input:checked
        + .payment-card::after {

            opacity: 1;
        }


        .payment-icon {

            width: 42px;

            height: 42px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            color: #fff;

            background:
                var(--accent-gradient);

            box-shadow:
                var(--shadow-accent);

            font-size: 17px;

            position: relative;

            z-index: 3;
        }


        .payment-name {

            margin-top: 13px;

            color: var(--label);

            font-size: 13px;

            font-weight: 800;

            position: relative;

            z-index: 3;
        }


        .payment-description {

            margin-top: 4px;

            color: var(--label-3);

            font-size: 10px;

            line-height: 1.45;

            position: relative;

            z-index: 3;
        }


        /* =========================================================
           RIGHT SUMMARY
           ========================================================= */

        .summary-card {

            position: sticky;

            top: 82px;

            border-radius: var(--r-xl);

            overflow: hidden;

            position: sticky;
        }


        .summary-content {

            position: relative;

            z-index: 3;

            padding: 22px;
        }


        .summary-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;

            margin-bottom: 18px;
        }


        .summary-title-wrap {

            display: flex;

            align-items: center;

            gap: 11px;
        }


        .summary-icon {

            width: 42px;

            height: 42px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            color: #fff;

            background:
                var(--cool-gradient);

            box-shadow:
                0 9px 22px rgba(99,102,241,.22);

            font-size: 17px;
        }


        .summary-header h2 {

            font-size: 19px;

            font-weight: 800;
        }


        .summary-header p {

            margin-top: 3px;

            color: var(--label-3);

            font-size: 10px;
        }


        .secure-pill {

            padding: 7px 10px;

            border-radius: var(--r-full);

            color: var(--success);

            background:
                var(--success-bg);

            font-size: 9px;

            font-weight: 800;

            white-space: nowrap;
        }


        /* =========================================================
           ITEMS
           ========================================================= */

        .items {

            display: flex;

            flex-direction: column;

            gap: 10px;

            max-height: 340px;

            overflow-y: auto;

            padding-right: 3px;
        }


        .items::-webkit-scrollbar {

            width: 4px;
        }


        .items::-webkit-scrollbar-thumb {

            border-radius: 10px;

            background:
                rgba(99,102,241,.25);
        }


        .item-card {

            position: relative;

            overflow: hidden;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;

            padding: 10px;

            border-radius: var(--r-md);

            box-shadow:
                inset 0 1px 0 rgba(255,255,255,.65);
        }


        .item-left {

            display: flex;

            align-items: center;

            gap: 10px;

            min-width: 0;
        }


        .food-image {

            width: 53px;

            height: 53px;

            flex-shrink: 0;

            object-fit: cover;

            border-radius: 15px;

            background:
                linear-gradient(
                    135deg,
                    rgba(255,138,61,.16),
                    rgba(192,38,211,.16)
                );

            box-shadow:
                inset 0 0 0 1px rgba(255,255,255,.4);
        }


        .food-fallback {

            width: 53px;

            height: 53px;

            flex-shrink: 0;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 15px;

            color: #fff;

            background:
                var(--accent-gradient);

            font-size: 20px;
        }


        .food-details {

            min-width: 0;
        }


        .food-name {

            max-width: 190px;

            overflow: hidden;

            text-overflow: ellipsis;

            white-space: nowrap;

            font-size: 12px;

            font-weight: 800;

            color: var(--label);
        }


        .food-qty {

            margin-top: 4px;

            color: var(--label-3);

            font-size: 10px;
        }


        .food-price {

            flex-shrink: 0;

            font-size: 12px;

            font-weight: 850;

            color: var(--label);
        }


        /* =========================================================
           PRICE
           ========================================================= */

        .divider {

            height: 1px;

            margin: 18px 0;

            background:
                var(--separator);
        }


        .price-row {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 12px;

            color: var(--label-2);

            font-size: 12px;
        }


        .price-row strong {

            color: var(--label);

            font-weight: 800;
        }


        .grand-total {

            margin-top: 16px;

            padding-top: 16px;

            border-top:
                1px solid var(--separator);

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .grand-total-label {

            font-size: 15px;

            font-weight: 850;
        }


        .grand-total-value {

            font-size: 26px;

            font-weight: 900;

            background:
                var(--accent-gradient);

            -webkit-background-clip: text;

            background-clip: text;

            color: transparent;
        }


        /* =========================================================
           PLACE ORDER
           SAME GLOSSY BUTTON AS RESTAURANT PAGE
           ========================================================= */

        .place-order {

            position: relative;

            overflow: hidden;

            width: 100%;

            height: 55px;

            margin-top: 20px;

            border: none;

            border-radius: var(--r-lg);

            cursor: pointer;

            color: #fff;

            background:
                var(--accent-gradient);

            box-shadow:
                var(--shadow-accent);

            font-size: 14px;

            font-weight: 800;

            transition:
                transform .35s var(--spring),
                filter .2s ease,
                box-shadow .3s ease;
        }


        .place-order::before {

            content: "";

            position: absolute;

            inset: 0;

            background:
                var(--gloss);

            pointer-events: none;
        }


        .place-order::after {

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

            transition:
                left .7s var(--ease);
        }


        .place-order:hover::after {

            left: 130%;
        }


        .place-order:hover {

            transform:
                translateY(-4px);

            filter: brightness(1.07);

            box-shadow:
                0 20px 42px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6);
        }


        .place-order:active {

            transform:
                scale(.97);
        }


        .place-order:disabled {

            opacity: .65;

            cursor: not-allowed;

            transform: none;

            filter: none;
        }


        .secure-text {

            margin-top: 12px;

            text-align: center;

            color: var(--label-3);

            font-size: 9px;

            line-height: 1.6;
        }


        /* =========================================================
           EMPTY CART
           ========================================================= */

        .empty-card {

            padding: 50px 25px;

            text-align: center;

            border-radius: var(--r-xl);

            position: relative;

            overflow: hidden;
        }


        .empty-icon {

            width: 70px;

            height: 70px;

            margin: 0 auto 16px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 22px;

            color: #fff;

            background:
                var(--accent-gradient);

            box-shadow:
                var(--shadow-accent);

            font-size: 27px;
        }


        .empty-card h2 {

            font-size: 21px;

            font-weight: 800;

            margin-bottom: 7px;
        }


        .empty-card p {

            color: var(--label-2);

            font-size: 13px;

            line-height: 1.6;

            margin-bottom: 20px;
        }


        .browse-btn {

            position: relative;

            overflow: hidden;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            padding: 12px 21px;

            border-radius: var(--r-full);

            color: #fff;

            background:
                var(--accent-gradient);

            box-shadow:
                var(--shadow-accent);

            font-size: 12px;

            font-weight: 750;

            text-decoration: none;

            transition:
                transform .35s var(--spring);
        }


        .browse-btn:hover {

            transform:
                translateY(-3px);
        }


        /* =========================================================
           MOBILE NAV
           ========================================================= */

        .tab-bar {

            display: none;
        }


        /* =========================================================
           TOAST
           ========================================================= */

        .toast-host {

            position: fixed;

            top: 84px;

            left: 50%;

            transform:
                translateX(-50%);

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

            padding: 12px 20px;

            border-radius: var(--r-full);

            color: var(--toast-fg);

            background: var(--toast-bg);

            font-size: 13px;

            font-weight: 650;

            -webkit-backdrop-filter:
                var(--blur);

            backdrop-filter:
                var(--blur);

            box-shadow:
                0 14px 34px rgba(0,0,0,.26),
                inset 0 1px 0 rgba(255,255,255,.2);

            animation:
                toastIn .55s var(--spring);
        }


        /* =========================================================
           ANIMATIONS
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

                background-position:
                    -260% 0;
            }
        }


        @keyframes waveX {

            to {

                -webkit-mask-position:
                    1200px 100%;

                mask-position:
                    1200px 100%;
            }
        }


        @keyframes waveBg {

            to {

                background-position:
                    -200% 0;
            }
        }


        @keyframes breathe {

            50% {

                transform:
                    scale(1.35);

                opacity: .7;
            }
        }


        @keyframes toastIn {

            from {

                opacity: 0;

                transform:
                    translateY(-16px)
                    scale(.9);

                filter:
                    blur(6px);
            }
        }


        /* =========================================================
           RESPONSIVE
           ========================================================= */

        @media (max-width: 950px) {

            .checkout-grid {

                grid-template-columns: 1fr;
            }


            .summary-card {

                position: relative;

                top: auto;
            }
        }


        @media (max-width: 700px) {

            body {

                padding-bottom: 100px;
            }


            .navbar {

                padding:
                    8px 10px 0;
            }


            .nav-inner {

                height: 56px;

                padding:
                    0 8px 0 14px;

                border-radius: 20px;
            }


            .brand-name {

                font-size: 17px;
            }


            .nav-links {

                display: none;
            }


            .cart-nav {

                padding:
                    8px 10px;
            }


            .cart-nav .cart-text {

                display: none;
            }


            .profile-nav {

                width: 37px;

                height: 37px;
            }


            .login-btn {

                padding:
                    8px 13px;

                font-size: 12px;
            }


            .title-header {

                padding:
                    30px 0 50px;
            }


            .title-inner {

                width: 90%;
            }


            .large-title {

                font-size: 32px;
            }


            .title-subtitle {

                font-size: 13px;
            }


            .container {

                width: 90%;

                margin-bottom: 100px;
            }


            .card-content {

                padding: 21px;
            }


            .form-grid {

                grid-template-columns: 1fr;
            }


            .field.full {

                grid-column: auto;
            }


            .payment-grid {

                grid-template-columns: 1fr;
            }


            .payment-card {

                min-height: 78px;

                display: flex;

                align-items: center;

                gap: 13px;
            }


            .payment-name {

                margin-top: 0;
            }


            .saved-address {

                align-items: flex-start;

                flex-direction: column;
            }


            .profile-address-btn {

                width: 100%;
            }


            .tab-bar {

                position: fixed;

                left: 12px;

                right: 12px;

                bottom:
                    calc(
                        10px +
                        env(safe-area-inset-bottom, 0px)
                    );

                height: 64px;

                padding: 0 6px;

                display: flex;

                align-items: center;

                justify-content: space-around;

                z-index: 100;

                border-radius: 30px;

                background:
                    linear-gradient(
                        135deg,
                        var(--glass-strong),
                        var(--glass)
                    );

                border:
                    1px solid var(--glass-border);

                box-shadow:
                    var(--glass-inset),
                    var(--glass-shadow);

                -webkit-backdrop-filter:
                    var(--blur);

                backdrop-filter:
                    var(--blur);
            }


            .tab-item {

                position: relative;

                display: flex;

                flex-direction: column;

                align-items: center;

                justify-content: center;

                gap: 3px;

                min-width: 62px;

                height: 50px;

                border-radius: 20px;

                color: var(--label-3);

                text-decoration: none;

                font-size: 10.5px;

                font-weight: 650;
            }


            .tab-item.active {

                color: var(--accent-solid);

                background:
                    var(--accent-tint);
            }


            .tab-icon {

                font-size: 18px;

                line-height: 1;
            }


            .toast-host {

                top: 72px;
            }
        }


        @media (max-width: 420px) {

            .large-title {

                font-size: 29px;
            }


            .glass,
            .summary-card,
            .empty-card {

                border-radius:
                    23px;
            }


            .card-content {

                padding: 18px;
            }


            .section-header h2 {

                font-size: 18px;
            }


            .grand-total-value {

                font-size: 22px;
            }
        }


        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {

                animation-duration:
                    .01ms !important;

                animation-iteration-count:
                    1 !important;

                transition-duration:
                    .01ms !important;

                scroll-behavior:
                    auto !important;
            }


            .aqua i {

                animation: none !important;
            }
        }

    </style>

</head>


<body>


    <!-- =========================================================
         AURORA
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

        <!-- BRAND -->
        <a href="<%= contextPath %>/restaurant"
           class="brand">

            <span class="brand-mark">
                F
            </span>

            <span class="brand-name">
                Foodwala
            </span>

        </a>


        <!-- RIGHT NAVIGATION -->
        <nav class="nav-links" aria-label="Primary">

            <!-- HOME -->
            <a href="<%= contextPath %>/restaurant"
               class="nav-link">

                Home

            </a>


            <!-- RESTAURANTS -->
            <a href="<%= contextPath %>/restaurant"
               class="nav-link">

                Restaurants

            </a>


            <!-- ORDERS -->
            <a href="<%= contextPath %>/orders"
               class="nav-link">

                Orders

            </a>


            <!-- CART -->
            <a href="<%= contextPath %>/cart?action=view"
               class="cart-nav"
               aria-label="Cart">

                <svg viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">

                    <path d="M6 8h12l1 13H5L6 8z">
                    </path>

                    <path d="M9 8a3 3 0 0 1 6 0">
                    </path>

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


            <!-- PROFILE / LOGIN -->
            <% if (user != null) { %>

                <a href="<%= contextPath %>/profile"
                   class="profile-nav"
                   title="Profile">

                    <%= esc(userInitial) %>

                </a>

            <% } else { %>

                <a href="<%= contextPath %>/login"
                   class="login-btn">

                    Login

                </a>

            <% } %>

        </nav>

    </div>

</header>

    <!-- =========================================================
         TITLE
         ========================================================= -->

    <section class="title-header">

        <div class="title-inner">


            <div class="eyebrow">

                Secure Checkout

            </div>


            <h1 class="large-title">

                Complete Your Order

            </h1>


            <p class="title-subtitle">

                Add your delivery details, choose your payment
                method, and get your favourite food delivered
                straight to your doorstep.

            </p>

        </div>


        <div class="wave"></div>

        <div class="wave b"></div>

    </section>


    <!-- =========================================================
         MAIN
         ========================================================= -->

    <main class="container">


        <!-- ERROR -->

        <% if (errorMessage != null &&
               !errorMessage.trim().isEmpty()) { %>

            <div class="error-message">

                <span class="error-symbol">
                    !
                </span>

                <span>
                    <%= esc(errorMessage) %>
                </span>

            </div>

        <% } %>


        <% if (cart == null || cart.isEmpty()) { %>


            <!-- =================================================
                 EMPTY CART
                 ================================================= -->

            <section class="empty-card glass">

                <div class="empty-icon">
                    🛒
                </div>


                <h2>
                    Your cart is empty
                </h2>


                <p>
                    Add some delicious food from our restaurants
                    before continuing to checkout.
                </p>


                <a href="<%= contextPath %>/restaurant"
                   class="browse-btn">

                    Browse Restaurants →

                </a>

            </section>


        <% } else { %>


            <!-- =================================================
                 CHECKOUT FORM
                 ================================================= -->

            <form method="post"
                  action="<%= contextPath %>/checkout"
                  id="checkoutForm"
                  onsubmit="return validateCheckout();">


                <div class="checkout-grid">


                    <!-- =========================================
                         LEFT SIDE
                         ========================================= -->

                    <div>


                        <!-- =====================================
                             DELIVERY ADDRESS
                             ===================================== -->

                        <section class="glass">

                            <div class="card-content">


                                <div class="section-header">

                                    <div class="section-icon">
                                        📍
                                    </div>

                                    <div>

                                        <h2>
                                            Delivery Address
                                        </h2>

                                        <p>
                                            Where should we deliver your order?
                                        </p>

                                    </div>

                                </div>


                                <!-- FORM -->

                                <div class="form-grid">


                                    <!-- HOUSE -->

                                    <div class="field">

                                        <label for="houseNo">

                                            House / Flat No.

                                            <span class="required">
                                                *
                                            </span>

                                        </label>


                                        <input
                                            type="text"
                                            id="houseNo"
                                            name="houseNo"
                                            class="input"
                                            placeholder="e.g. 12-45"
                                            value="<%= esc(houseNo) %>"
                                            autocomplete="address-line1"
                                            required>

                                    </div>


                                    <!-- STREET -->

                                    <div class="field">

                                        <label for="street">

                                            Street / Area

                                            <span class="required">
                                                *
                                            </span>

                                        </label>


                                        <input
                                            type="text"
                                            id="street"
                                            name="street"
                                            class="input"
                                            placeholder="e.g. MG Road"
                                            value="<%= esc(street) %>"
                                            autocomplete="address-line2"
                                            required>

                                    </div>


                                    <!-- CITY -->

                                    <div class="field">

                                        <label for="city">

                                            City

                                            <span class="required">
                                                *
                                            </span>

                                        </label>


                                        <input
                                            type="text"
                                            id="city"
                                            name="city"
                                            class="input"
                                            placeholder="e.g. Vijayawada"
                                            value="<%= esc(city) %>"
                                            autocomplete="address-level2"
                                            required>

                                    </div>


                                    <!-- STATE -->

                                    <div class="field">

                                        <label for="state">

                                            State

                                            <span class="required">
                                                *
                                            </span>

                                        </label>


                                        <input
                                            type="text"
                                            id="state"
                                            name="state"
                                            class="input"
                                            placeholder="e.g. Andhra Pradesh"
                                            value="<%= esc(state) %>"
                                            autocomplete="address-level1"
                                            required>

                                    </div>


                                    <!-- PINCODE -->

                                    <div class="field">

                                        <label for="pincode">

                                            Pincode

                                            <span class="required">
                                                *
                                            </span>

                                        </label>


                                        <input
                                            type="text"
                                            id="pincode"
                                            name="pincode"
                                            class="input"
                                            placeholder="6-digit pincode"
                                            value="<%= esc(pincode) %>"
                                            inputmode="numeric"
                                            maxlength="6"
                                            autocomplete="postal-code"
                                            required>

                                    </div>


                                    <!-- LANDMARK -->

                                    <div class="field">

                                        <label for="landmark">

                                            Landmark

                                        </label>


                                        <input
                                            type="text"
                                            id="landmark"
                                            name="landmark"
                                            class="input"
                                            placeholder="e.g. Near City Mall"
                                            value="<%= esc(landmark) %>"
                                            autocomplete="off">

                                    </div>


                                </div>


                                <!-- SAVED ADDRESS -->

                                <div class="saved-address">

                                    <div class="saved-address-info">

                                        <div class="saved-address-label">

                                            Saved Profile Address

                                        </div>


                                        <div class="saved-address-text">

                                            <% if (savedAddress != null &&
                                                   !savedAddress.trim().isEmpty()) { %>

                                                <%= esc(savedAddress) %>

                                            <% } else { %>

                                                No saved address found
                                                in your profile.

                                            <% } %>

                                        </div>

                                    </div>


                                    <button
                                        type="button"
                                        class="profile-address-btn"
                                        onclick="useProfileAddress();">

                                        ↻ Use Profile Address

                                    </button>

                                </div>


                                <!-- ADDRESS PREVIEW -->

                                <div class="address-preview">

                                    <div class="preview-icon">
                                        📍
                                    </div>

                                    <div class="preview-content">

                                        <div class="preview-title">

                                            Delivery to

                                        </div>


                                        <div class="preview-text"
                                             id="previewText">

                                            Please enter your address details.

                                        </div>

                                    </div>

                                </div>


                            </div>

                        </section>


                        <!-- =====================================
                             PAYMENT
                             ===================================== -->

                        <section class="glass payment-section">

                            <div class="card-content">


                                <div class="section-header">

                                    <div class="section-icon">
                                        💳
                                    </div>

                                    <div>

                                        <h2>
                                            Payment Method
                                        </h2>

                                        <p>
                                            Choose your preferred payment option
                                        </p>

                                    </div>

                                </div>


                                <div class="payment-grid">


                                    <!-- UPI -->

                                    <label class="payment-option">

                                        <input
                                            type="radio"
                                            name="paymentMode"
                                            value="UPI">


                                        <div class="payment-card">

                                            <div class="payment-icon">
                                                ₹
                                            </div>


                                            <div>

                                                <div class="payment-name">
                                                    UPI
                                                </div>

                                                <div class="payment-description">
                                                    Google Pay · PhonePe · Paytm
                                                </div>

                                            </div>

                                        </div>

                                    </label>


                                    <!-- CARD -->

                                    <label class="payment-option">

                                        <input
                                            type="radio"
                                            name="paymentMode"
                                            value="CARD">


                                        <div class="payment-card">

                                            <div class="payment-icon">
                                                💳
                                            </div>


                                            <div>

                                                <div class="payment-name">
                                                    Card
                                                </div>

                                                <div class="payment-description">
                                                    Credit or Debit Card
                                                </div>

                                            </div>

                                        </div>

                                    </label>


                                    <!-- COD -->

                                    <label class="payment-option">

                                        <input
                                            type="radio"
                                            name="paymentMode"
                                            value="COD">


                                        <div class="payment-card">

                                            <div class="payment-icon">
                                                💵
                                            </div>


                                            <div>

                                                <div class="payment-name">
                                                    Cash on Delivery
                                                </div>

                                                <div class="payment-description">
                                                    Pay when your order arrives
                                                </div>

                                            </div>

                                        </div>

                                    </label>


                                </div>

                            </div>

                        </section>


                    </div>


                    <!-- =========================================
                         RIGHT SIDE
                         ========================================= -->

                    <aside class="summary-card">


                        <div class="summary-content">


                            <!-- HEADER -->

                            <div class="summary-header">

                                <div class="summary-title-wrap">

                                    <div class="summary-icon">
                                        🛍
                                    </div>

                                    <div>

                                        <h2>
                                            Your Order
                                        </h2>

                                        <p>
                                            <%= cartCount %>
                                            item<%= cartCount == 1 ? "" : "s" %>
                                        </p>

                                    </div>

                                </div>


                                <div class="secure-pill">

                                    🔒 Secure

                                </div>

                            </div>


                            <!-- ITEMS -->

                            <div class="items">


                                <% for (CartItem item : cart) { %>

                                    <div class="item-card">


                                        <div class="item-left">


                                            <%
                                                String imagePath =
                                                        item.getImagePath();

                                                if (imagePath != null &&
                                                    !imagePath.trim().isEmpty()) {
                                            %>

                                                <img
                                                    src="<%= esc(imagePath) %>"
                                                    alt="<%= esc(item.getItemName()) %>"
                                                    class="food-image"
                                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">


                                                <div class="food-fallback"
                                                     style="display:none;">

                                                    🍽

                                                </div>

                                            <% } else { %>

                                                <div class="food-fallback">

                                                    🍽

                                                </div>

                                            <% } %>


                                            <div class="food-details">

                                                <div class="food-name">

                                                    <%= esc(item.getItemName()) %>

                                                </div>


                                                <div class="food-qty">

                                                    Qty:
                                                    <%= item.getQuantity() %>

                                                </div>

                                            </div>

                                        </div>


                                        <div class="food-price">

                                            ₹<%= String.format(
                                                    "%.2f",
                                                    item.getTotalAmount()
                                                ) %>

                                        </div>


                                    </div>

                                <% } %>


                            </div>


                            <!-- DIVIDER -->

                            <div class="divider"></div>


                            <!-- SUBTOTAL -->

                            <div class="price-row">

                                <span>
                                    Item Total
                                </span>

                                <strong>
                                    ₹<%= String.format(
                                            "%.2f",
                                            totalAmount
                                        ) %>
                                </strong>

                            </div>


                            <!-- DELIVERY -->

                            <div class="price-row">

                                <span>
                                    Delivery Fee
                                </span>

                                <strong>

                                    <% if (deliveryFee > 0) { %>

                                        ₹<%= String.format(
                                                "%.2f",
                                                deliveryFee
                                            ) %>

                                    <% } else { %>

                                        ₹0.00

                                    <% } %>

                                </strong>

                            </div>


                            <!-- GRAND TOTAL -->

                            <div class="grand-total">

                                <span class="grand-total-label">

                                    Total Amount

                                </span>


                                <span class="grand-total-value">

                                    ₹<%= String.format(
                                            "%.2f",
                                            finalAmount
                                        ) %>

                                </span>

                            </div>


                            <!-- PLACE ORDER -->

                            <button
                                type="submit"
                                id="placeOrderBtn"
                                class="place-order">

                                Place Order →
                                
                            </button>


                            <div class="secure-text">

                                🔒 Your order details are securely
                                processed by Foodwala.

                            </div>


                        </div>

                    </aside>


                </div>

            </form>


        <% } %>


    </main>


    <!-- =========================================================
         MOBILE TAB BAR
         ========================================================= -->

    <nav class="tab-bar">


        <a href="<%= contextPath %>/restaurant"
           class="tab-item">

            <span class="tab-icon">
                🏠
            </span>

            Home

        </a>


        <a href="<%= contextPath %>/restaurant"
           class="tab-item">

            <span class="tab-icon">
                🍴
            </span>

            Restaurants

        </a>


        <a href="<%= contextPath %>/cart?action=view"
           class="tab-item active">

            <span class="tab-icon">
                🛒
            </span>

            Cart

        </a>


        <a href="<%= contextPath %>/orders"
           class="tab-item">

            <span class="tab-icon">
                📦
            </span>

            Orders

        </a>


        <% if (user != null) { %>

            <a href="<%= contextPath %>/profile"
               class="tab-item">

                <span class="tab-icon">
                    👤
                </span>

                Profile

            </a>

        <% } else { %>

            <a href="<%= contextPath %>/login"
               class="tab-item">

                <span class="tab-icon">
                    🔐
                </span>

                Login

            </a>

        <% } %>


    </nav>


    <!-- =========================================================
         TOAST
         ========================================================= -->

    <div id="toastHost"
         class="toast-host"></div>


    <!-- =========================================================
         JAVASCRIPT
         ========================================================= -->

    <script>


        /* =========================================================
           ELEMENTS
           ========================================================= */

        const houseNoInput =
            document.getElementById("houseNo");

        const streetInput =
            document.getElementById("street");

        const cityInput =
            document.getElementById("city");

        const stateInput =
            document.getElementById("state");

        const pincodeInput =
            document.getElementById("pincode");

        const landmarkInput =
            document.getElementById("landmark");

        const previewText =
            document.getElementById("previewText");


        /* =========================================================
           TOAST
           ========================================================= */

        function showToast(message) {

            const host =
                document.getElementById("toastHost");

            if (!host) {
                return;
            }


            host.innerHTML = "";


            const toast =
                document.createElement("div");

            toast.className =
                "toast";

            toast.textContent =
                message;


            host.appendChild(toast);


            setTimeout(function () {

                toast.style.opacity = "0";

                toast.style.transform =
                    "translateY(-8px) scale(.96)";

                toast.style.transition =
                    "all .3s ease";

            }, 2500);


            setTimeout(function () {

                if (toast.parentNode) {

                    toast.parentNode.removeChild(toast);
                }

            }, 2900);
        }


        /* =========================================================
           ADDRESS PREVIEW
           ========================================================= */

        function updateAddressPreview() {

            if (!previewText) {
                return;
            }


            const parts = [];


            const house =
                houseNoInput.value.trim();

            const street =
                streetInput.value.trim();

            const city =
                cityInput.value.trim();

            const state =
                stateInput.value.trim();

            const pin =
                pincodeInput.value.trim();

            const landmark =
                landmarkInput.value.trim();


            if (house) {
                parts.push(house);
            }


            if (street) {
                parts.push(street);
            }


            if (city) {
                parts.push(city);
            }


            if (state) {
                parts.push(state);
            }


            if (pin) {
                parts.push(pin);
            }


            let result =
                parts.join(", ");


            if (landmark) {

                if (result) {

                    result +=
                        " • Landmark: " +
                        landmark;

                } else {

                    result =
                        "Landmark: " +
                        landmark;
                }
            }


            if (!result) {

                previewText.textContent =
                    "Please enter your address details.";

            } else {

                previewText.textContent =
                    result;
            }
        }


        /* =========================================================
           PROFILE ADDRESS
           ========================================================= */

        function useProfileAddress() {

            houseNoInput.value =
                houseNoInput.defaultValue;

            streetInput.value =
                streetInput.defaultValue;

            cityInput.value =
                cityInput.defaultValue;

            stateInput.value =
                stateInput.defaultValue;

            pincodeInput.value =
                pincodeInput.defaultValue;

            landmarkInput.value =
                landmarkInput.defaultValue;


            clearErrors();

            updateAddressPreview();

            showToast(
                "Profile address loaded."
            );
        }


        /* =========================================================
           CLEAR ERRORS
           ========================================================= */

        function clearErrors() {

            document
                .querySelectorAll(".input")
                .forEach(function(input) {

                    input.classList.remove("error");

                });
        }


        /* =========================================================
           VALIDATE ADDRESS
           ========================================================= */

        function validateAddress() {

            let valid = true;


            const requiredInputs = [

                houseNoInput,
                streetInput,
                cityInput,
                stateInput,
                pincodeInput

            ];


            requiredInputs.forEach(
                function(input) {

                    input.classList.remove(
                        "error"
                    );


                    if (!input.value.trim()) {

                        input.classList.add(
                            "error"
                        );

                        valid = false;
                    }

                }
            );


            const pin =
                pincodeInput.value.trim();


            if (pin &&
                !/^[0-9]{6}$/.test(pin)) {

                pincodeInput.classList.add(
                    "error"
                );

                valid = false;


                showToast(
                    "Please enter a valid 6-digit pincode."
                );
            }


            return valid;
        }


        /* =========================================================
           VALIDATE CHECKOUT
           ========================================================= */

        function validateCheckout() {


            if (!validateAddress()) {

                showToast(
                    "Please complete your delivery address."
                );

                return false;
            }


            const payment =
                document.querySelector(
                    'input[name="paymentMode"]:checked'
                );


            if (!payment) {

                showToast(
                    "Please select a payment method."
                );

                return false;
            }


            const button =
                document.getElementById(
                    "placeOrderBtn"
                );


            if (button) {

                button.disabled = true;

                button.textContent =
                    "Placing Order...";

            }


            return true;
        }


        /* =========================================================
           PINCODE
           ========================================================= */

        if (pincodeInput) {

            pincodeInput.addEventListener(
                "input",
                function() {

                    this.value =
                        this.value
                            .replace(/[^0-9]/g, "")
                            .slice(0, 6);

                    this.classList.remove(
                        "error"
                    );

                    updateAddressPreview();
                }
            );
        }


        /* =========================================================
           LIVE ADDRESS
           ========================================================= */

        [

            houseNoInput,
            streetInput,
            cityInput,
            stateInput,
            pincodeInput,
            landmarkInput

        ].forEach(function(input) {

            if (!input) {
                return;
            }


            input.addEventListener(
                "input",
                function() {

                    this.classList.remove(
                        "error"
                    );

                    updateAddressPreview();

                }
            );

        });


        /* =========================================================
           PAYMENT EFFECT
           ========================================================= */

        document
            .querySelectorAll(
                'input[name="paymentMode"]'
            )
            .forEach(function(radio) {

                radio.addEventListener(
                    "change",
                    function() {

                        showToast(
                            "Payment method selected."
                        );

                    }
                );

            });


        /* =========================================================
           NAVBAR SCROLL EFFECT
           ========================================================= */

        window.addEventListener(
            "scroll",
            function() {

                const navbar =
                    document.querySelector(
                        ".navbar"
                    );

                if (!navbar) {
                    return;
                }


                if (window.scrollY > 20) {

                    navbar.classList.add(
                        "scrolled"
                    );

                } else {

                    navbar.classList.remove(
                        "scrolled"
                    );
                }

            }
        );


        /* =========================================================
           INITIALIZE
           ========================================================= */

        updateAddressPreview();

    </script>


</body>

</html>