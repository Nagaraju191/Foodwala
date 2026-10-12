<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.CartItem" %>

<%!
    /*
     * HTML escape helper
     */
    private static String esc(Object o) {

        if (o == null) {
            return "";
        }

        String s = String.valueOf(o);

        StringBuilder b =
                new StringBuilder(s.length() + 16);

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
    /*
     * =========================================================
     * SESSION
     * =========================================================
     */

    Integer loggedInUserId =
            (Integer) session.getAttribute("userId");


    /*
     * =========================================================
     * CART COUNT
     * =========================================================
     */

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


    /*
     * =========================================================
     * USER
     * =========================================================
     */

    User user =
            (User) request.getAttribute("user");

    if (user == null) {

        response.sendRedirect("restaurant");
        return;
    }


    /*
     * =========================================================
     * USER DETAILS
     * =========================================================
     */

    String username =
            user.getUsername() != null
                    ? user.getUsername()
                    : "User";

    String email =
            user.getEmail() != null
                    ? user.getEmail()
                    : "Not provided";

    String phone =
            user.getPhone() != null
                    ? user.getPhone()
                    : "Not provided";

    String role =
            user.getRole() != null
                    ? user.getRole()
                    : "Customer";


    /*
     * =========================================================
     * SAVED ADDRESS
     *
     * Expected format:
     *
     * House No, Street, City, State - Pincode,
     * Landmark: Landmark
     *
     * Example:
     *
     * 10, btm-layout, bengaluru, karnataka - 123456,
     * Landmark: Near near metro
     * =========================================================
     */

    String address =
            user.getAddress() != null
                    ? user.getAddress().trim()
                    : "";

    String houseNo = "";
    String street = "";
    String city = "";
    String state = "";
    String pincode = "";
    String landmark = "";


    if (!address.isEmpty()) {

        try {

            String[] parts =
                    address.split(",", 5);


            /*
             * House
             * Street
             * City
             * State - PIN
             * Landmark
             */

            if (parts.length >= 4) {

                houseNo =
                        parts[0].trim();

                street =
                        parts[1].trim();

                city =
                        parts[2].trim();


                /*
                 * STATE + PIN
                 */

                String statePin =
                        parts[3].trim();

                if (statePin.contains("-")) {

                    String[] stateParts =
                            statePin.split("-", 2);

                    state =
                            stateParts[0].trim();

                    pincode =
                            stateParts[1].trim();

                } else {

                    state =
                            statePin;
                }


                /*
                 * LANDMARK
                 */

                if (parts.length == 5) {

                    landmark =
                            parts[4].trim();

                    if (landmark.startsWith("Landmark:")) {

                        landmark =
                                landmark
                                        .substring(
                                                "Landmark:".length()
                                        )
                                        .trim();
                    }
                }
            }

        } catch (Exception e) {

            /*
             * Keep fields empty if an old address
             * format cannot be parsed.
             */
        }
    }


    String displayAddress =
            address.isEmpty()
                    ? "No delivery address added"
                    : address;


    /*
     * =========================================================
     * AVATAR
     * =========================================================
     */

    String firstLetter =
            username.trim().isEmpty()
                    ? "U"
                    : username.trim()
                            .substring(0, 1)
                            .toUpperCase();


    /*
     * =========================================================
     * ACTIVE NAV
     * =========================================================
     */

    String navActive = "profile";
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

    <title>Foodwala - My Profile</title>


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

            --field-bg:
                rgba(255, 255, 255, .6);

            --r-xl: 28px;
            --r-lg: 18px;
            --r-md: 14px;
            --r-full: 999px;

            --spring:
                cubic-bezier(.34, 1.56, .64, 1);

            --ease:
                cubic-bezier(.22, .61, .36, 1);
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

                --field-bg:
                    rgba(255, 255, 255, .06);
            }
        }


        /* =========================================================
           FALLBACK
        ========================================================= */

        @supports not (
            (backdrop-filter: blur(1px))
            or
            (-webkit-backdrop-filter: blur(1px))
        ) {

            :root {

                --glass:
                    rgba(255, 255, 255, .95);

                --glass-strong:
                    #fff;
            }

            @media (prefers-color-scheme: dark) {

                :root {

                    --glass:
                        rgba(34, 31, 48, .96);

                    --glass-strong:
                        #292539;
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

            outline:
                3px solid var(--accent-solid);

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
           GLASS SURFACES
        ========================================================= */

        .glass,
        .nav-inner,
        .tab-bar,
        .empty-message {

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

            transition:
                box-shadow .3s ease;
        }

        .navbar.scrolled .nav-inner {

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }


        /* =========================================================
           BRAND
        ========================================================= */

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


        /* =========================================================
           NAV LINKS
        ========================================================= */

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


        /* =========================================================
           PROFILE NAV
        ========================================================= */

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
           PAGE LAYOUT
        ========================================================= */

        .page {

            width: 88%;

            max-width: 1000px;

            margin: 34px auto 0;
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

            animation:
                titleFlow 9s linear infinite;
        }

        .title-subtitle {

            color: var(--label-2);

            font-size: 15.5px;
        }


        /* =========================================================
           CARD
        ========================================================= */

        .card {

            border-radius: var(--r-xl);

            padding: 32px;
        }

        .card-title {

            font-size: 20px;

            font-weight: 800;

            letter-spacing: -.014em;
        }

        .card-sub {

            color: var(--label-3);

            font-size: 13.5px;

            margin-top: 4px;
        }

        .section-gap {

            margin-top: 30px;
        }


        /* =========================================================
           PROFILE
        ========================================================= */

        .profile-hero {

            display: flex;

            align-items: center;

            gap: 20px;

            flex-wrap: wrap;

            margin-bottom: 26px;

            padding-bottom: 26px;

            border-bottom:
                .5px solid var(--separator);
        }

        .avatar {

            position: relative;

            overflow: hidden;

            width: 76px;

            height: 76px;

            flex-shrink: 0;

            border-radius: 24px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: var(--accent-gradient);

            color: #fff;

            font-size: 32px;

            font-weight: 800;

            box-shadow: var(--shadow-accent);
        }

        .avatar::before {

            content: "";

            position: absolute;

            inset: 0;

            background: var(--gloss);
        }

        .hero-text {

            min-width: 0;

            flex: 1;
        }

        .hero-text h2 {

            font-size: 26px;

            font-weight: 800;

            letter-spacing: -.03em;

            word-break: break-word;
        }

        .hero-text p {

            color: var(--label-2);

            font-size: 14px;

            margin-top: 3px;

            word-break: break-word;
        }

        .pill {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding: 6px 12px;

            border-radius: var(--r-full);

            font-size: 12px;

            font-weight: 700;

            background: var(--success-bg);

            color: var(--success);

            border: 1px solid var(--glass-border);
        }

        .pill .dot {

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background: var(--success);

            box-shadow:
                0 0 0 3px var(--success-bg);

            animation:
                breathe 2.4s ease-in-out infinite;
        }


        /* =========================================================
           DETAILS
        ========================================================= */

        .details-grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 14px;

            margin-top: 20px;
        }

        .detail {

            padding: 16px 18px;

            border-radius: var(--r-lg);

            background: var(--glass-soft);

            border: 1px solid var(--glass-border);

            box-shadow: var(--glass-inset);

            transition:
                transform .45s var(--spring);
        }

        .detail:hover {

            transform: translateY(-3px);
        }

        .detail.full {

            grid-column: 1 / -1;
        }

        .detail-label {

            display: flex;

            align-items: center;

            gap: 7px;

            color: var(--label-3);

            font-size: 12.5px;

            font-weight: 650;

            margin-bottom: 6px;
        }

        .detail-label svg {

            color: var(--accent-solid);

            flex-shrink: 0;
        }

        .detail-value {

            font-size: 15px;

            font-weight: 650;

            line-height: 1.5;

            word-break: break-word;
        }

        .tag {

            display: inline-block;

            padding: 4px 12px;

            border-radius: var(--r-full);

            background: var(--accent-tint);

            color: var(--accent-solid);

            font-size: 12px;

            font-weight: 700;

            border:
                1px solid rgba(255,46,99,.14);

            box-shadow:
                inset 0 1px 0 rgba(255,255,255,.5);

            text-transform: capitalize;
        }


        /* =========================================================
           ADDRESS FORM
        ========================================================= */

        .address-form {

            width: 100%;
        }

        .address-grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 18px;

            width: 100%;

            margin-top: 4px;
        }

        .form-group {

            display: flex;

            flex-direction: column;

            align-items: stretch;

            gap: 8px;

            width: 100%;
        }

        .form-group label {

            display: block;

            color: var(--label);

            font-size: 13px;

            font-weight: 700;

            line-height: 1.4;
        }

        .form-group input {

            display: block;

            width: 100%;

            min-height: 46px;

            padding: 12px 15px;

            border: 1px solid var(--glass-border);

            border-radius: 13px;

            outline: none;

            background: var(--field-bg);

            color: var(--label);

            font-family: inherit;

            font-size: 14px;

            font-weight: 550;

            box-shadow:
                var(--glass-inset),
                0 4px 12px rgba(60, 40, 120, .08);

            transition:
                border-color .25s ease,
                box-shadow .25s ease,
                transform .25s ease,
                background .25s ease;
        }

        .form-group input::placeholder {

            color: var(--label-3);

            opacity: .8;
        }

        .form-group input:focus {

            border-color: var(--accent-solid);

            background: var(--glass-strong);

            box-shadow:
                0 0 0 3px var(--accent-tint),
                var(--glass-inset),
                0 6px 18px rgba(60, 40, 120, .12);

            transform: translateY(-1px);
        }

        .save-address-btn {

            position: relative;

            overflow: hidden;

            margin-top: 22px;

            padding: 13px 22px;

            border: none;

            border-radius: var(--r-full);

            background: var(--accent-gradient);

            color: #fff;

            font-size: 14px;

            font-weight: 700;

            cursor: pointer;

            box-shadow: var(--shadow-accent);

            transition:
                transform .25s var(--spring),
                filter .2s ease,
                box-shadow .25s ease;
        }

        .save-address-btn:hover {

            filter: brightness(1.08);

            transform: translateY(-2px);
        }

        .save-address-btn:active {

            transform: scale(.96);
        }

        .saved-address-preview {

            margin-top: 22px;

            padding: 18px 20px;

            border-radius: var(--r-lg);

            background:
                linear-gradient(
                    135deg,
                    var(--glass-strong),
                    var(--glass)
                );

            border: 1px solid var(--glass-border);

            box-shadow:
                var(--glass-inset),
                0 8px 24px rgba(60, 40, 120, .10);
        }

        .saved-address-preview .detail-label {

            margin-bottom: 8px;
        }

        .saved-address-preview .detail-value {

            color: var(--label);

            font-size: 15px;

            font-weight: 700;

            line-height: 1.6;
        }


        /* =========================================================
           QUICK ACTIONS
        ========================================================= */

        .actions {

            display: grid;

            grid-template-columns:
                repeat(auto-fit, minmax(140px, 1fr));

            gap: 12px;

            margin-top: 20px;
        }

        .action {

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            gap: 9px;

            min-height: 96px;

            padding: 14px;

            border-radius: var(--r-lg);

            text-decoration: none;

            text-align: center;

            font-size: 13.5px;

            font-weight: 700;

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
                0 4px 14px rgba(60,40,120,.08);

            transition:
                transform .45s var(--spring),
                box-shadow .3s ease;
        }

        .action:hover {

            transform: translateY(-4px);

            box-shadow:
                var(--glass-inset),
                var(--glass-shadow-hover);
        }

        .action-icon {

            position: relative;

            overflow: hidden;

            width: 40px;

            height: 40px;

            border-radius: 13px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: var(--accent-gradient);

            color: #fff;

            box-shadow:
                0 6px 14px var(--accent-glow),
                inset 0 1.5px 0 rgba(255,255,255,.6);
        }

        .action-icon::before {

            content: "";

            position: absolute;

            inset: 0;

            background: var(--gloss);
        }

        .action-icon svg {

            position: relative;
        }

        .action.danger {

            color: var(--danger);
        }

        .action.danger .action-icon {

            background:
                linear-gradient(
                    135deg,
                    #FF6B5E,
                    #E0342B
                );

            box-shadow:
                0 6px 14px rgba(224,52,43,.35),
                inset 0 1.5px 0 rgba(255,255,255,.6);
        }


        /* =========================================================
           NOTE
        ========================================================= */

        .note {

            display: flex;

            gap: 10px;

            align-items: flex-start;

            margin-top: 26px;

            padding: 14px 16px;

            border-radius: var(--r-lg);

            background: var(--accent-tint);

            color: var(--label-2);

            font-size: 13.5px;

            line-height: 1.5;
        }

        .note svg {

            flex-shrink: 0;

            color: var(--accent-solid);

            margin-top: 1px;
        }


        /* =========================================================
           FOOTER
        ========================================================= */

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

            animation:
                toastIn .55s var(--spring);
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

            animation:
                rip .75s ease-out forwards;
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

            box-shadow:
                0 0 0 2px var(--bg);
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
                    60% 40% 32% 68%;
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

        @keyframes breathe {

            50% {

                transform: scale(1.35);

                opacity: .7;
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

            .details-grid {

                grid-template-columns: 1fr;
            }

            .detail.full {

                grid-column: auto;
            }

            .hero-text h2 {

                font-size: 22px;
            }

            .avatar {

                width: 64px;

                height: 64px;

                font-size: 27px;

                border-radius: 20px;
            }

            .address-grid {

                grid-template-columns: 1fr;
            }

            .save-address-btn {

                width: 100%;
            }

            .aqua i:nth-child(4) {

                display: none;
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

                bottom:
                    calc(
                        10px +
                        env(safe-area-inset-bottom, 0px)
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
    ========================================================== -->

    <div class="aqua" aria-hidden="true">

        <i></i>
        <i></i>
        <i></i>
        <i></i>

    </div>


    <!-- =========================================================
         NAVBAR
    ========================================================== -->

    <header class="navbar" id="navbar">

        <div class="nav-inner">


            <!-- BRAND -->

            <a href="restaurant" class="brand">

                <span class="brand-mark">
                    F
                </span>

                <span class="brand-name">
                    Foodwala
                </span>

            </a>


            <!-- DESKTOP NAVIGATION -->

            <nav class="nav-links" aria-label="Primary">


                <!-- HOME -->

                <a href="restaurant"
                   class="nav-link">

                    Home

                </a>


                <!-- RESTAURANTS -->

                <a href="restaurant"
                   class="nav-link <%= "restaurants".equals(navActive) ? "is-active" : "" %>">

                    <% if ("restaurants".equals(navActive)) { %>

                        <span class="nav-pill"></span>

                    <% } %>

                    Restaurants

                </a>


                <!-- ORDERS -->

                <a href="orders"
                   class="nav-link <%= "orders".equals(navActive) ? "is-active" : "" %>">

                    <% if ("orders".equals(navActive)) { %>

                        <span class="nav-pill"></span>

                    <% } %>

                    Orders

                </a>


                <!-- CART -->

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


                <!-- PROFILE / LOGIN -->

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

                            <circle
                                cx="12"
                                cy="8"
                                r="4">
                            </circle>

                            <path
                                d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7">
                            </path>

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


    <!-- =========================================================
         MAIN
    ========================================================== -->

    <main class="page">


        <!-- PAGE HEADER -->

        <div class="page-head reveal">

            <h1 class="large-title">
                My profile
            </h1>

            <p class="title-subtitle">
                Manage your account details and delivery address
            </p>

        </div>


        <!-- =====================================================
             PROFILE CARD
        ====================================================== -->

        <section
            class="card glass reveal"
            style="--i:1">


            <!-- PROFILE HERO -->

            <div class="profile-hero">


                <!-- AVATAR -->

                <div class="avatar">

                    <%= esc(firstLetter) %>

                </div>


                <!-- USER INFO -->

                <div class="hero-text">

                    <h2>

                        <%= esc(username) %>

                    </h2>

                    <p>

                        <%= esc(email) %>

                    </p>

                </div>


                <!-- STATUS -->

                <span class="pill">

                    <span class="dot"></span>

                    Active account

                </span>

            </div>


            <!-- =================================================
                 ACCOUNT INFORMATION
            ================================================== -->

            <div class="card-title">

                Account information

            </div>

            <div class="card-sub">

                The details linked to your Foodwala account.

            </div>


            <div class="details-grid">


                <!-- USERNAME -->

                <div class="detail">

                    <div class="detail-label">

                        <svg
                            width="15"
                            height="15"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round">

                            <circle
                                cx="12"
                                cy="8"
                                r="4"/>

                            <path
                                d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"/>

                        </svg>

                        Username

                    </div>

                    <div class="detail-value">

                        <%= esc(username) %>

                    </div>

                </div>


                <!-- EMAIL -->

                <div class="detail">

                    <div class="detail-label">

                        <svg
                            width="15"
                            height="15"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round">

                            <rect
                                x="3"
                                y="5"
                                width="18"
                                height="14"
                                rx="3"/>

                            <path
                                d="m4 7 8 6 8-6"/>

                        </svg>

                        Email

                    </div>

                    <div class="detail-value">

                        <%= esc(email) %>

                    </div>

                </div>


                <!-- PHONE -->

                <div class="detail">

                    <div class="detail-label">

                        <svg
                            width="15"
                            height="15"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round">

                            <rect
                                x="7"
                                y="2"
                                width="10"
                                height="20"
                                rx="3"/>

                            <path d="M11 18h2"/>

                        </svg>

                        Phone

                    </div>

                    <div class="detail-value">

                        <%= esc(phone) %>

                    </div>

                </div>


                <!-- ACCOUNT TYPE -->

                <div class="detail">

                    <div class="detail-label">

                        <svg
                            width="15"
                            height="15"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round">

                            <path
                                d="m12 3 2.6 5.6 6.1.7-4.5 4.2 1.2 6-5.4-3-5.4 3 1.2-6L3.3 9.3l6.1-.7L12 3z"/>

                        </svg>

                        Account type

                    </div>

                    <div class="detail-value">

                        <span class="tag">

                            <%= esc(role) %>

                        </span>

                    </div>

                </div>


                <!-- =================================================
                     DELIVERY ADDRESS
                ================================================== -->

                <div class="detail full">

                    <div class="detail-label">

                        <svg
                            width="15"
                            height="15"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            aria-hidden="true">

                            <path
                                d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>

                            <circle
                                cx="12"
                                cy="10"
                                r="3"/>

                        </svg>

                        Delivery address

                    </div>


                    <div class="card-sub"
                         style="margin-bottom:18px;">

                        Add your complete delivery address
                        for faster and safer delivery.

                    </div>


                    <!-- ADDRESS FORM -->

                    <form
                        action="profile"
                        method="post"
                        class="address-form">


                        <div class="address-grid">


                            <!-- HOUSE -->

                            <div class="form-group">

                                <label for="houseNo">
                                    House / Flat No.
                                </label>

                                <input
                                    type="text"
                                    id="houseNo"
                                    name="houseNo"
                                    value="<%= esc(houseNo) %>"
                                    placeholder="e.g. 12-45"
                                    required>

                            </div>


                            <!-- STREET -->

                            <div class="form-group">

                                <label for="street">
                                    Street / Area
                                </label>

                                <input
                                    type="text"
                                    id="street"
                                    name="street"
                                    value="<%= esc(street) %>"
                                    placeholder="e.g. BTM Layout"
                                    required>

                            </div>


                            <!-- CITY -->

                            <div class="form-group">

                                <label for="city">
                                    City
                                </label>

                                <input
                                    type="text"
                                    id="city"
                                    name="city"
                                    value="<%= esc(city) %>"
                                    placeholder="e.g. Bengaluru"
                                    required>

                            </div>


                            <!-- STATE -->

                            <div class="form-group">

                                <label for="state">
                                    State
                                </label>

                                <input
                                    type="text"
                                    id="state"
                                    name="state"
                                    value="<%= esc(state) %>"
                                    placeholder="e.g. Karnataka"
                                    required>

                            </div>


                            <!-- PIN -->

                            <div class="form-group">

                                <label for="pincode">
                                    PIN Code
                                </label>

                                <input
                                    type="text"
                                    id="pincode"
                                    name="pincode"
                                    value="<%= esc(pincode) %>"
                                    placeholder="e.g. 560076"
                                    maxlength="6"
                                    pattern="[0-9]{6}"
                                    inputmode="numeric"
                                    required>

                            </div>


                            <!-- LANDMARK -->

                            <div class="form-group">

                                <label for="landmark">
                                    Landmark
                                </label>

                                <input
                                    type="text"
                                    id="landmark"
                                    name="landmark"
                                    value="<%= esc(landmark) %>"
                                    placeholder="e.g. Near Metro Station">

                            </div>

                        </div>


                        <!-- SAVE ADDRESS -->

                        <button
                            type="submit"
                            class="save-address-btn">

                            Save Address

                        </button>

                    </form>


                    <!-- SAVED ADDRESS -->

                    <div class="saved-address-preview">

                        <div class="detail-label">

                            <svg
                                width="15"
                                height="15"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>

                                <circle
                                    cx="12"
                                    cy="10"
                                    r="3"/>

                            </svg>

                            Saved address

                        </div>

                        <div class="detail-value">

                            <%= esc(displayAddress) %>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 QUICK ACTIONS
            ================================================== -->

            <div class="section-gap">

                <div class="card-title">

                    Quick actions

                </div>


                <div class="actions">


                    <!-- EDIT PROFILE -->

                    <a href="edit-profile"
                       class="action">

                        <span class="action-icon">

                            <svg
                                width="19"
                                height="19"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path d="M12 20h9"/>

                                <path
                                    d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/>

                            </svg>

                        </span>

                        Edit profile

                    </a>


                    <!-- ORDERS -->

                    <a href="orders"
                       class="action">

                        <span class="action-icon">

                            <svg
                                width="19"
                                height="19"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M21 8 12 3 3 8v8l9 5 9-5V8z"/>

                                <path
                                    d="m3 8 9 5 9-5M12 13v8"/>

                            </svg>

                        </span>

                        My orders

                    </a>


                    <!-- CART -->

                    <a href="cart?action=view"
                       class="action">

                        <span class="action-icon">

                            <svg
                                width="19"
                                height="19"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M6 8h12l1 13H5L6 8z"/>

                                <path
                                    d="M9 8a3 3 0 0 1 6 0"/>

                            </svg>

                        </span>

                        View cart

                    </a>


                    <!-- RESTAURANTS -->

                    <a href="restaurant"
                       class="action">

                        <span class="action-icon">

                            <svg
                                width="19"
                                height="19"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M3 3v7a2 2 0 0 0 2 2h1v9"/>

                                <path d="M9 3v18"/>

                                <path
                                    d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9"/>

                            </svg>

                        </span>

                        Restaurants

                    </a>


                    <!-- LOGOUT -->

                    <a href="logout"
                       class="action danger">

                        <span class="action-icon">

                            <svg
                                width="19"
                                height="19"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>

                                <path
                                    d="m16 17 5-5-5-5M21 12H9"/>

                            </svg>

                        </span>

                        Log out

                    </a>

                </div>

            </div>


            <!-- =================================================
                 NOTE
            ================================================== -->

            <div class="note">

                <svg
                    width="18"
                    height="18"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    aria-hidden="true">

                    <circle
                        cx="12"
                        cy="12"
                        r="9"/>

                    <path
                        d="M12 8h.01M11 12h1v4h1"/>

                </svg>

                <span>

                    Keep your phone number and address up to date
                    so your orders reach you without delays.

                </span>

            </div>


        </section>

    </main>


    <!-- =========================================================
         FOOTER
    ========================================================== -->

    <footer>

        &copy; 2026 Foodwala. All rights reserved.

    </footer>


    <!-- =========================================================
         MOBILE TAB BAR
    ========================================================== -->

    <nav class="tab-bar" aria-label="Mobile">


        <!-- HOME -->

        <a href="restaurant"
           class="tab-item">

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round">

                <path d="M3 10.5 12 3l9 7.5"/>

                <path d="M5 9.5V21h14V9.5"/>

            </svg>

            Home

        </a>


        <!-- RESTAURANTS -->

        <a href="restaurant"
           class="tab-item">

            <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round">

                <path
                    d="M3 3v7a2 2 0 0 0 2 2h1v9"/>

                <path d="M9 3v18"/>

                <path
                    d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9"/>

            </svg>

            Restaurants

        </a>


        <!-- CART -->

        <a href="cart?action=view"
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
                stroke-linejoin="round">

                <path
                    d="M6 8h12l1 13H5L6 8z"/>

                <path
                    d="M9 8a3 3 0 0 1 6 0"/>

            </svg>

            Cart

        </a>


        <!-- PROFILE / LOGIN -->

        <a
            href="<%= loggedInUserId != null ? "profile" : "login.jsp" %>"
            class="tab-item <%= ("profile".equals(navActive) || "login".equals(navActive)) ? "is-active" : "" %>">

            <% if ("profile".equals(navActive)
                    || "login".equals(navActive)) { %>

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
                stroke-linejoin="round">

                <path
                    d="M20 21a8 8 0 0 0-16 0"/>

                <circle
                    cx="12"
                    cy="7"
                    r="4"/>

            </svg>

            <%= loggedInUserId != null ? "Profile" : "Login" %>

        </a>

    </nav>


    <!-- =========================================================
         JAVASCRIPT
    ========================================================== -->

    <script>

        (function () {


            /* =====================================================
               TOAST
            ====================================================== */

            function toast(msg) {

                var host =
                    document.getElementById("toastHost");

                if (!host) {

                    host =
                        document.createElement("div");

                    host.id = "toastHost";

                    host.className = "toast-host";

                    host.setAttribute(
                        "role",
                        "status"
                    );

                    host.setAttribute(
                        "aria-live",
                        "polite"
                    );

                    document.body.appendChild(host);
                }


                var t =
                    document.createElement("div");

                t.className = "toast";

                t.textContent = msg;

                host.appendChild(t);


                setTimeout(function () {

                    t.classList.add("out");

                    setTimeout(function () {

                        t.remove();

                    }, 360);

                }, 2200);
            }


            window.fwToast = toast;


            /* =====================================================
               RIPPLE EFFECT
            ====================================================== */

            document.addEventListener(
                "pointerdown",
                function (e) {

                    var t =
                        e.target.closest(
                            ".btn, .nav-link-cta, .save-address-btn"
                        );

                    if (!t) {
                        return;
                    }


                    var r =
                        t.getBoundingClientRect();

                    var s =
                        Math.max(
                            r.width,
                            r.height
                        ) * 2.4;


                    var sp =
                        document.createElement("span");

                    sp.className = "rip";


                    sp.style.cssText =
                        "width:" + s + "px;" +
                        "height:" + s + "px;" +
                        "left:" +
                        (e.clientX - r.left - s / 2) +
                        "px;" +
                        "top:" +
                        (e.clientY - r.top - s / 2) +
                        "px";


                    t.appendChild(sp);


                    setTimeout(function () {

                        sp.remove();

                    }, 800);

                }
            );


            /* =====================================================
               NAVBAR SCROLL
            ====================================================== */

            var nav =
                document.getElementById("navbar");


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


            /* =====================================================
               REVEAL ANIMATION
            ====================================================== */

            var io =
                ("IntersectionObserver" in window)
                    ? new IntersectionObserver(
                        function (entries) {

                            entries.forEach(
                                function (en) {

                                    if (
                                        en.isIntersecting
                                    ) {

                                        en.target.classList.add(
                                            "in"
                                        );

                                        io.unobserve(
                                            en.target
                                        );
                                    }

                                }
                            );

                        },
                        {
                            threshold: 0.08,

                            rootMargin:
                                "0px 0px -6% 0px"
                        }
                    )
                    : null;


            document
                .querySelectorAll(".reveal")
                .forEach(
                    function (el) {

                        if (io) {

                            io.observe(el);

                        } else {

                            el.classList.add("in");
                        }

                    }
                );


        })();

    </script>


</body>

</html>