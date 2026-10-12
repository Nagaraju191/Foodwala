<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Order Details - Foodwala</title>

    <style>

        /* =====================================================
           GLOBAL
        ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {

            --bg: #f4f1f8;

            --glass: rgba(255, 255, 255, 0.72);

            --glass-strong: rgba(255, 255, 255, 0.88);

            --border: rgba(255, 255, 255, 0.70);

            --orange: #ff7a45;

            --pink: #ff3d71;

            --purple: #8d5cff;

            --gradient:
                linear-gradient(
                    135deg,
                    #ff7a45 0%,
                    #ff3d71 48%,
                    #8d5cff 100%
                );

            --text: #24212b;

            --muted: #77727f;

            --green: #16a34a;

            --shadow:
                0 20px 55px rgba(71, 48, 92, 0.11);

            --soft-shadow:
                0 10px 30px rgba(71, 48, 92, 0.07);
        }

        html {
            scroll-behavior: smooth;
        }

        body {

            min-height: 100vh;

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            color: var(--text);

            background:

                radial-gradient(
                    circle at 5% 10%,
                    rgba(255, 122, 69, 0.14),
                    transparent 28%
                ),

                radial-gradient(
                    circle at 95% 15%,
                    rgba(141, 92, 255, 0.15),
                    transparent 30%
                ),

                radial-gradient(
                    circle at 50% 100%,
                    rgba(255, 61, 113, 0.09),
                    transparent 30%
                ),

                var(--bg);

            overflow-x: hidden;
        }

        a {
            text-decoration: none;
        }


        /* =====================================================
           BACKGROUND DECORATIONS
        ===================================================== */

        .background-shape {

            position: fixed;

            border-radius: 50%;

            pointer-events: none;

            z-index: -1;

            filter: blur(5px);

            animation:
                floating 9s ease-in-out infinite;
        }

        .shape-one {

            width: 230px;

            height: 230px;

            left: -100px;

            top: 130px;

            background:
                rgba(255, 122, 69, 0.16);
        }

        .shape-two {

            width: 300px;

            height: 300px;

            right: -120px;

            top: 300px;

            background:
                rgba(141, 92, 255, 0.14);

            animation-delay: -3s;
        }

        .shape-three {

            width: 180px;

            height: 180px;

            left: 38%;

            bottom: -90px;

            background:
                rgba(255, 61, 113, 0.10);

            animation-delay: -6s;
        }

        @keyframes floating {

            0%,
            100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-25px);
            }
        }


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            position: sticky;

            top: 18px;

            z-index: 100;

            width: calc(100% - 40px);

            max-width: 1200px;

            min-height: 70px;

            margin: 18px auto 0;

            padding: 10px 18px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            background:
                rgba(255, 255, 255, 0.68);

            backdrop-filter: blur(20px);

            -webkit-backdrop-filter: blur(20px);

            border:
                1px solid var(--border);

            border-radius: 22px;

            box-shadow:
                0 12px 35px rgba(50, 30, 70, 0.10);
        }


        /* =====================================================
           LOGO
        ===================================================== */

        .logo {

            display: flex;

            align-items: center;

            gap: 10px;

            color: var(--text);

            font-size: 25px;

            font-weight: 800;

            letter-spacing: -0.5px;
        }

        .logo-icon {

            width: 40px;

            height: 40px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            background: var(--gradient);

            color: white;

            font-size: 20px;

            box-shadow:
                0 8px 18px rgba(255, 61, 113, 0.25);
        }

        .logo-text {

            background: var(--gradient);

            -webkit-background-clip: text;

            -webkit-text-fill-color: transparent;

            background-clip: text;
        }


        /* =====================================================
           NAV LINKS
        ===================================================== */

        .nav-links {

            display: flex;

            align-items: center;

            gap: 8px;
        }

        .nav-links a {

            padding: 11px 14px;

            border-radius: 13px;

            color: #4d4854;

            font-size: 14px;

            font-weight: 600;

            transition: 0.25s ease;

            display: inline-flex;

            align-items: center;

            justify-content: center;
        }

        .nav-links a:hover {

            color: var(--pink);

            background:
                rgba(255, 255, 255, 0.85);

            transform:
                translateY(-1px);
        }


        /* =====================================================
           PROFILE BUTTON
        ===================================================== */

        .profile-nav {

            width: 44px;

            height: 44px;

            padding: 0 !important;

            display: inline-flex !important;

            align-items: center;

            justify-content: center;

            border-radius: 13px !important;

            color: white !important;

            background: var(--gradient) !important;

            border: none !important;

            box-shadow:
                0 8px 20px rgba(255, 61, 113, 0.20);

            transition: 0.25s ease;

            flex-shrink: 0;
        }

        .profile-nav svg {

            width: 21px;

            height: 21px;

            display: block;
        }

        .profile-nav:hover {

            color: white !important;

            background: var(--gradient) !important;

            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px rgba(255, 61, 113, 0.28);
        }


        /* =====================================================
           LOGIN BUTTON
        ===================================================== */

        .nav-link-cta {

            color: white !important;

            background: var(--gradient) !important;

            box-shadow:
                0 8px 20px rgba(255, 61, 113, 0.20);

            border-radius: 13px;

            padding: 11px 18px !important;
        }

        .nav-link-cta:hover {

            color: white !important;

            background: var(--gradient) !important;

            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px rgba(255, 61, 113, 0.28);
        }


        /* =====================================================
           MAIN CONTAINER
        ===================================================== */

        .container {

            width: 100%;

            max-width: 1100px;

            margin: 45px auto;

            padding:
                0 20px 40px;
        }


        /* =====================================================
           BACK LINK
        ===================================================== */

        .back-link {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-bottom: 18px;

            padding:
                10px 14px;

            border-radius: 12px;

            color: #7048d9;

            background:
                rgba(255, 255, 255, 0.55);

            border:
                1px solid rgba(255, 255, 255, 0.7);

            font-size: 13px;

            font-weight: 700;

            transition:
                0.25s ease;
        }

        .back-link:hover {

            background:
                rgba(255, 255, 255, 0.9);

            transform:
                translateX(-3px);
        }


        /* =====================================================
           PAGE TITLE
        ===================================================== */

        .page-heading {

            display: flex;

            align-items: flex-end;

            justify-content: space-between;

            gap: 20px;

            margin-bottom: 25px;
        }

        .page-title {

            font-size: 34px;

            font-weight: 800;

            letter-spacing: -0.9px;

            color: var(--text);
        }

        .page-subtitle {

            margin-top: 7px;

            color: var(--muted);

            font-size: 14px;
        }


        /* =====================================================
           ORDER SUMMARY
        ===================================================== */

        .order-summary {

            position: relative;

            overflow: hidden;

            padding: 27px;

            margin-bottom: 22px;

            background:
                var(--glass);

            backdrop-filter: blur(22px);

            -webkit-backdrop-filter: blur(22px);

            border:
                1px solid var(--border);

            border-radius: 25px;

            box-shadow: var(--shadow);
        }

        .order-summary::before {

            content: "";

            position: absolute;

            width: 240px;

            height: 240px;

            top: -170px;

            right: -100px;

            border-radius: 50%;

            background:
                rgba(141, 92, 255, 0.10);

            pointer-events: none;
        }

        .order-header {

            position: relative;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            flex-wrap: wrap;

            margin-bottom: 23px;
        }

        .order-id {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            font-size: 21px;

            font-weight: 800;
        }

        .order-id::before {

            content: "🧾";

            width: 37px;

            height: 37px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 11px;

            background:
                rgba(141, 92, 255, 0.10);

            font-size: 17px;
        }

        .status {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding:
                9px 15px;

            border-radius: 50px;

            background:
                #dcfce7;

            color:
                #15803d;

            font-size: 12px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 0.35px;
        }

        .status::before {

            content: "";

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background:
                #22c55e;

            box-shadow:
                0 0 0 4px
                rgba(34, 197, 94, 0.12);
        }


        /* =====================================================
           DETAIL GRID
        ===================================================== */

        .details-grid {

            position: relative;

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 15px;
        }

        .detail-box {

            padding: 18px;

            border-radius: 17px;

            background:
                rgba(255, 255, 255, 0.55);

            border:
                1px solid
                rgba(255, 255, 255, 0.72);

            transition:
                0.25s ease;
        }

        .detail-box:hover {

            background:
                rgba(255, 255, 255, 0.80);

            transform:
                translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(50, 30, 70, 0.06);
        }

        .detail-label {

            display: flex;

            align-items: center;

            gap: 7px;

            margin-bottom: 8px;

            color: var(--muted);

            font-size: 12px;

            font-weight: 600;
        }

        .detail-value {

            color: var(--text);

            font-size: 15px;

            font-weight: 750;
        }


        /* =====================================================
           ITEMS SECTION
        ===================================================== */

        .items-section {

            position: relative;

            overflow: hidden;

            padding: 27px;

            background:
                var(--glass);

            backdrop-filter: blur(22px);

            -webkit-backdrop-filter: blur(22px);

            border:
                1px solid var(--border);

            border-radius: 25px;

            box-shadow: var(--shadow);
        }

        .section-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            margin-bottom: 10px;
        }

        .section-title {

            font-size: 22px;

            font-weight: 800;

            letter-spacing: -0.3px;
        }

        .section-badge {

            padding:
                7px 11px;

            border-radius: 50px;

            background:
                rgba(255, 61, 113, 0.08);

            color:
                var(--pink);

            font-size: 11px;

            font-weight: 800;
        }


        /* =====================================================
           ORDER ITEM
        ===================================================== */

        .item {

            display: flex;

            align-items: center;

            gap: 18px;

            padding:
                18px 4px;

            border-bottom:
                1px solid
                rgba(0, 0, 0, 0.055);

            transition:
                0.25s ease;
        }

        .item:last-child {
            border-bottom: none;
        }

        .item:hover {

            transform:
                translateX(3px);
        }

        .item-image {

            flex-shrink: 0;

            width: 88px;

            height: 88px;

            object-fit: cover;

            border-radius: 18px;

            background:
                linear-gradient(
                    135deg,
                    #eee9f5,
                    #f8f6fa
                );

            border:
                1px solid
                rgba(255, 255, 255, 0.8);

            box-shadow:
                0 8px 18px
                rgba(50, 30, 70, 0.08);
        }

        .item-placeholder {

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 28px;

            color: #a59eae;
        }

        .item-info {

            flex: 1;

            min-width: 0;
        }

        .item-name {

            font-size: 17px;

            font-weight: 800;

            margin-bottom: 7px;

            color: var(--text);
        }

        .item-price {

            color: var(--muted);

            font-size: 13px;
        }

        .item-quantity {

            display: inline-flex;

            align-items: center;

            margin-top: 9px;

            padding:
                6px 10px;

            border-radius: 9px;

            background:
                rgba(141, 92, 255, 0.07);

            color:
                #7048d9;

            font-size: 12px;

            font-weight: 650;
        }

        .item-total {

            flex-shrink: 0;

            font-size: 17px;

            font-weight: 800;

            color: var(--text);
        }


        /* =====================================================
           EMPTY STATE
        ===================================================== */

        .empty {

            padding:
                45px 20px;

            text-align: center;

            color: var(--muted);
        }

        .empty-icon {

            width: 65px;

            height: 65px;

            margin:
                0 auto 15px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 20px;

            background:
                rgba(141, 92, 255, 0.08);

            font-size: 28px;
        }


        /* =====================================================
           TOTAL SECTION
        ===================================================== */

        .total-section {

            margin-top: 22px;

            padding-top: 21px;

            border-top:
                1px solid
                rgba(0, 0, 0, 0.07);
        }

        .total-row {

            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 20px;

            margin-bottom: 11px;

            color: #625d68;

            font-size: 14px;
        }

        .total-row span:last-child {

            color: var(--text);

            font-weight: 650;
        }

        .grand-total {

            margin-top: 17px;

            padding-top: 16px;

            border-top:
                1px dashed
                rgba(0, 0, 0, 0.10);

            color: var(--text) !important;

            font-size: 21px;

            font-weight: 800;
        }

        .grand-total span:last-child {

            font-size: 23px;

            background:
                var(--gradient);

            -webkit-background-clip: text;

            -webkit-text-fill-color: transparent;

            background-clip: text;
        }


        /* =====================================================
           BUTTON
        ===================================================== */

        .action-area {

            display: flex;

            justify-content: center;

            margin-top: 25px;
        }

        .btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-width: 190px;

            padding:
                14px 24px;

            border-radius: 15px;

            color: white;

            background:
                var(--gradient);

            font-size: 14px;

            font-weight: 750;

            box-shadow:
                0 10px 25px
                rgba(255, 61, 113, 0.20);

            transition:
                0.25s ease;
        }

        .btn:hover {

            color: white;

            transform:
                translateY(-3px);

            box-shadow:
                0 15px 30px
                rgba(255, 61, 113, 0.28);
        }


        /* =====================================================
           RESPONSIVE - TABLET
        ===================================================== */

        @media (max-width: 800px) {

            .navbar {

                top: 10px;

                width:
                    calc(100% - 24px);

                margin-top: 10px;
            }

            .nav-links {

                gap: 4px;
            }

            .nav-links a {

                padding:
                    9px 10px;

                font-size: 13px;
            }

            .container {

                margin-top: 32px;
            }

            .details-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }
        }


        /* =====================================================
           RESPONSIVE - MOBILE
        ===================================================== */

        @media (max-width: 600px) {

            .navbar {

                min-height: 62px;

                padding:
                    9px 12px;

                border-radius: 18px;
            }

            .logo {

                font-size: 20px;
            }

            .logo-icon {

                width: 35px;

                height: 35px;

                font-size: 17px;

                border-radius: 11px;
            }

            /*
             * IMPORTANT:
             * Do NOT hide .profile-nav here.
             * The previous selector:
             * .nav-links a:not(.cart-btn)
             * also hid the profile icon.
             */

            .nav-links > a:first-child {

                display: none;
            }

            .profile-nav {

                display: inline-flex !important;

                width: 40px;

                height: 40px;
            }

            .profile-nav svg {

                width: 19px;

                height: 19px;
            }

            .nav-link-cta {

                display: inline-flex !important;

                padding:
                    10px 14px !important;

                font-size: 13px !important;
            }

            .container {

                margin-top: 25px;

                padding:
                    0 12px 30px;
            }

            .back-link {

                margin-bottom: 14px;
            }

            .page-heading {

                display: block;

                margin-bottom: 20px;
            }

            .page-title {

                font-size: 27px;
            }

            .page-subtitle {

                font-size: 13px;
            }

            .order-summary,
            .items-section {

                padding:
                    21px 17px;

                border-radius: 21px;
            }

            .order-id {

                font-size: 18px;
            }

            .details-grid {

                grid-template-columns: 1fr;

                gap: 10px;
            }

            .detail-box {

                padding:
                    15px;
            }

            .item {

                align-items: flex-start;

                gap: 13px;

                padding:
                    16px 0;

                flex-wrap: wrap;
            }

            .item-image {

                width: 72px;

                height: 72px;

                border-radius: 15px;
            }

            .item-info {

                min-width:
                    calc(100% - 90px);
            }

            .item-name {

                font-size: 15px;
            }

            .item-total {

                width: 100%;

                margin-left: 85px;

                font-size: 16px;
            }

            .section-title {

                font-size: 20px;
            }

            .total-row {

                font-size: 13px;
            }

            .grand-total {

                font-size: 19px;
            }

            .grand-total span:last-child {

                font-size: 21px;
            }

            .btn {

                width: 100%;

                min-width: unset;
            }
        }

    </style>

</head>


<body>


    <!-- =====================================================
         BACKGROUND DECORATIONS
    ===================================================== -->

    <div class="background-shape shape-one"></div>

    <div class="background-shape shape-two"></div>

    <div class="background-shape shape-three"></div>


    <!-- =====================================================
         NAVBAR
    ===================================================== -->

    <nav class="navbar">

        <!-- LOGO -->

        <a href="restaurant" class="logo">

            <span class="logo-icon">
                🍔
            </span>

            <span class="logo-text">
                Foodwala
            </span>

        </a>


        <!-- NAVIGATION -->

        <div class="nav-links">

            <a href="restaurant">
                Restaurants
            </a>


            <%

                /*
                 * LoginController stores the complete User object
                 * inside the session using "loggedInUser".
                 *
                 * Therefore this is the safest way to determine
                 * whether the user is logged in.
                 */

                User loggedInUser =
                    (User) session.getAttribute("loggedInUser");

                if (loggedInUser != null) {

            %>

                <!-- =================================================
                     LOGGED IN
                     SHOW PROFILE ICON
                ================================================== -->

                <a href="profile"
                   class="profile-nav"
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


            <%

                } else {

            %>

                <!-- =================================================
                     NOT LOGGED IN
                     SHOW LOGIN BUTTON
                ================================================== -->

                <a href="login"
                   class="nav-link-cta">

                    Login

                </a>


            <%

                }

            %>

        </div>

    </nav>



    <!-- =====================================================
         MAIN
    ===================================================== -->

    <div class="container">


        <!-- BACK -->

        <a href="orders" class="back-link">

            ← Back to My Orders

        </a>


        <!-- PAGE HEADING -->

        <div class="page-heading">

            <div>

                <h1 class="page-title">

                    Order Details

                </h1>

                <p class="page-subtitle">

                    View your order information and items

                </p>

            </div>

        </div>



        <%

            Order order =
                (Order) request.getAttribute("order");

            List<OrderItem> orderItems =
                (List<OrderItem>)
                request.getAttribute("orderItems");

            Map<Integer, Menu> menuMap =
                (Map<Integer, Menu>)
                request.getAttribute("menuMap");

        %>



        <!-- =================================================
             ORDER SUMMARY
        ================================================= -->

        <div class="order-summary">


            <div class="order-header">

                <div class="order-id">

                    Order #<%= order.getOrderId() %>

                </div>


                <div class="status">

                    <%= order.getStatus() %>

                </div>

            </div>



            <div class="details-grid">


                <!-- ORDER DATE -->

                <div class="detail-box">

                    <div class="detail-label">

                        📅 Order Date

                    </div>

                    <div class="detail-value">

                        <%= order.getOrderDate() %>

                    </div>

                </div>



                <!-- PAYMENT -->

                <div class="detail-box">

                    <div class="detail-label">

                        💳 Payment Method

                    </div>

                    <div class="detail-value">

                        <%= order.getPaymentMode() %>

                    </div>

                </div>



                <!-- RESTAURANT -->

                <div class="detail-box">

                    <div class="detail-label">

                        🍽️ Restaurant ID

                    </div>

                    <div class="detail-value">

                        <%= order.getRestaurantId() %>

                    </div>

                </div>


            </div>

        </div>



        <!-- =================================================
             ORDER ITEMS
        ================================================= -->

        <div class="items-section">


            <div class="section-header">

                <h2 class="section-title">

                    Items Ordered

                </h2>

                <span class="section-badge">

                    Foodwala Order

                </span>

            </div>



            <%

                if (orderItems != null &&
                    !orderItems.isEmpty()) {

                    for (OrderItem item : orderItems) {

                        Menu menu =
                            menuMap.get(item.getMenuId());

            %>


            <div class="item">


                <!-- FOOD IMAGE -->

                <%

                    if (menu != null &&
                        menu.getImagePath() != null &&
                        !menu.getImagePath()
                            .trim()
                            .isEmpty()) {

                %>

                    <img
                        src="<%= menu.getImagePath() %>"
                        class="item-image"
                        alt="<%= menu.getItemName() %>"
                    >

                <%

                    } else {

                %>

                    <div class="item-image item-placeholder">

                        🍽️

                    </div>

                <%

                    }

                %>



                <!-- FOOD INFORMATION -->

                <div class="item-info">


                    <div class="item-name">

                        <%

                            if (menu != null) {

                        %>

                            <%= menu.getItemName() %>

                        <%

                            } else {

                        %>

                            Menu Item #<%= item.getMenuId() %>

                        <%

                            }

                        %>

                    </div>



                    <%

                        if (menu != null) {

                    %>

                        <div class="item-price">

                            ₹<%= String.format(
                                "%.2f",
                                menu.getPrice()
                            ) %>

                            each

                        </div>

                    <%

                        }

                    %>



                    <div class="item-quantity">

                        Quantity:

                        <strong>

                            &nbsp;<%= item.getQuantity() %>

                        </strong>

                    </div>


                </div>



                <!-- ITEM TOTAL -->

                <div class="item-total">

                    ₹<%= String.format(
                        "%.2f",
                        item.getTotalAmount()
                    ) %>

                </div>


            </div>


            <%

                    }

                } else {

            %>


                <!-- EMPTY -->

                <div class="empty">

                    <div class="empty-icon">

                        🍽️

                    </div>

                    <div>

                        No items found for this order.

                    </div>

                </div>


            <%

                }

            %>



            <!-- =================================================
                 TOTAL
            ================================================= -->

            <div class="total-section">


                <div class="total-row">

                    <span>

                        Items Total

                    </span>

                    <span>

                        ₹<%= String.format(
                            "%.2f",
                            order.getTotalAmount() - 40.00
                        ) %>

                    </span>

                </div>



                <div class="total-row">

                    <span>

                        Delivery Fee

                    </span>

                    <span>

                        ₹40.00

                    </span>

                </div>



                <div class="total-row grand-total">

                    <span>

                        Total Paid

                    </span>

                    <span>

                        ₹<%= String.format(
                            "%.2f",
                            order.getTotalAmount()
                        ) %>

                    </span>

                </div>


            </div>



            <!-- =================================================
                 ACTION
            ================================================= -->

            <div class="action-area">

                <a href="orders"
                   class="btn">

                    📦 View My Orders

                </a>

            </div>


        </div>


    </div>


</body>

</html>