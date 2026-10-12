<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.User" %>

<%
    User admin = (User) request.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(
            request.getContextPath() + "/login"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard - Foodwala</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;

            background:
                linear-gradient(
                    135deg,
                    #fff4ef,
                    #f6f0ff
                );

            color: #24202b;
        }

        /* ================= NAVBAR ================= */

        .navbar {
            height: 76px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 45px;

            background: rgba(255,255,255,0.88);

            backdrop-filter: blur(14px);

            border-bottom: 1px solid rgba(0,0,0,0.06);

            position: sticky;
            top: 0;
            z-index: 100;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-logo {
            width: 44px;
            height: 44px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 13px;

            background:
                linear-gradient(
                    135deg,
                    #ff4d6d,
                    #8b4de8
                );

            color: white;

            font-size: 22px;
            font-weight: 800;

            box-shadow:
                0 7px 20px rgba(255,77,109,0.25);
        }

        .brand-name {
            font-size: 23px;
            font-weight: 800;
        }

        .admin-label {
            color: #ff4d6d;
        }

        .admin-user {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .admin-avatar {
            width: 40px;
            height: 40px;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #201b2d;

            color: white;

            font-weight: bold;
        }

        .admin-name {
            font-size: 14px;
            font-weight: 600;
        }

        .logout-btn {
            margin-left: 10px;

            padding: 9px 16px;

            border-radius: 20px;

            text-decoration: none;

            color: #555;

            background: #f3f3f3;

            font-size: 13px;
            font-weight: 600;

            transition: 0.2s ease;
        }

        .logout-btn:hover {
            background: #ff4d6d;
            color: white;
        }

        /* ================= MAIN ================= */

        .container {
            width: 90%;
            max-width: 1250px;

            margin: 45px auto;
        }

        .welcome {
            margin-bottom: 35px;
        }

        .welcome-label {
            color: #ff4d6d;

            font-size: 13px;

            font-weight: 800;

            letter-spacing: 2px;

            text-transform: uppercase;

            margin-bottom: 8px;
        }

        .welcome h1 {
            font-size: 38px;

            margin-bottom: 8px;
        }

        .welcome p {
            color: #777;

            font-size: 16px;
        }

        /* ================= STATS ================= */

        .stats-grid {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 20px;

            margin-bottom: 35px;
        }

        .stat-card {
            background: rgba(255,255,255,0.92);

            border-radius: 18px;

            padding: 24px;

            border: 1px solid rgba(0,0,0,0.05);

            box-shadow:
                0 8px 30px rgba(0,0,0,0.06);

            transition: 0.25s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);

            box-shadow:
                0 14px 35px rgba(0,0,0,0.10);
        }

        .stat-icon {
            width: 45px;
            height: 45px;

            border-radius: 12px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 21px;

            background: #fff0f2;

            margin-bottom: 18px;
        }

        .stat-title {
            color: #777;

            font-size: 13px;

            margin-bottom: 7px;
        }

        .stat-value {
            font-size: 29px;

            font-weight: 800;
        }

        .stat-note {
            margin-top: 7px;

            color: #999;

            font-size: 12px;
        }

        /* ================= QUICK ACTIONS ================= */

        .section-title {
            font-size: 22px;

            margin-bottom: 18px;
        }

        .actions-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 20px;
        }

        .action-card {
            background: white;

            border-radius: 18px;

            padding: 25px;

            text-decoration: none;

            color: inherit;

            border: 1px solid #eee;

            box-shadow:
                0 7px 25px rgba(0,0,0,0.05);

            transition: 0.25s ease;
        }

        .action-card:hover {
            transform: translateY(-4px);

            border-color: #ff4d6d;

            box-shadow:
                0 12px 30px rgba(255,77,109,0.12);
        }

        .action-icon {
            width: 50px;
            height: 50px;

            border-radius: 14px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #f7f1ff;

            font-size: 23px;

            margin-bottom: 18px;
        }

        .action-card h3 {
            font-size: 18px;

            margin-bottom: 7px;
        }

        .action-card p {
            color: #777;

            font-size: 13px;

            line-height: 1.5;
        }

        .arrow {
            display: block;

            margin-top: 18px;

            color: #ff4d6d;

            font-weight: 700;

            font-size: 13px;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 950px) {

            .stats-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

            .actions-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

        }

        @media (max-width: 650px) {

            .navbar {
                padding: 15px 20px;

                height: auto;
            }

            .admin-name {
                display: none;
            }

            .container {
                width: 92%;

                margin: 30px auto;
            }

            .welcome h1 {
                font-size: 30px;
            }

            .stats-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>


    <!-- ================= NAVBAR ================= -->

    <header class="navbar">

        <div class="brand">

            <div class="brand-logo">
                F
            </div>

            <div class="brand-name">
                Foodwala
                <span class="admin-label">
                    Admin
                </span>
            </div>

        </div>


        <div class="admin-user">

            <div class="admin-avatar">

                <%= admin.getUsername()
                    .substring(0, 1)
                    .toUpperCase() %>

            </div>

            <span class="admin-name">

                <%= admin.getUsername() %>

            </span>

            <a href="logout"
               class="logout-btn">

                Logout

            </a>

        </div>

    </header>


    <!-- ================= MAIN ================= -->

    <main class="container">


        <!-- WELCOME -->

        <section class="welcome">

            <div class="welcome-label">

                ADMIN DASHBOARD

            </div>

            <h1>

                Welcome,
                <%= admin.getUsername() %> 👋

            </h1>

            <p>

                Manage your Foodwala platform
                from one place.

            </p>

        </section>


        <!-- ================= STAT CARDS ================= -->

        <section class="stats-grid">


            <div class="stat-card">

                <div class="stat-icon">
                    🏪
                </div>

                <div class="stat-title">
                    Total Restaurants
                </div>

                <div class="stat-value">
				    <%= request.getAttribute("totalRestaurants") %>
				</div>

                <div class="stat-note">
                    Will connect to database
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    🍽️
                </div>

                <div class="stat-title">
                    Menu Items
                </div>

                <div class="stat-value">
                    —
                </div>

                <div class="stat-note">
                    Will connect to database
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    📦
                </div>

                <div class="stat-title">
                    Total Orders
                </div>

                <div class="stat-value">
                    —
                </div>

                <div class="stat-note">
                    Will connect to database
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    👥
                </div>

                <div class="stat-title">
                    Customers
                </div>

                <div class="stat-value">
                    —
                </div>

                <div class="stat-note">
                    Will connect to database
                </div>

            </div>

        </section>


        <!-- ================= QUICK ACTIONS ================= -->

        <h2 class="section-title">

            Management

        </h2>


        <section class="actions-grid">


            <!-- RESTAURANTS -->

            <a href="admin-restaurants"
               class="action-card">

                <div class="action-icon">
                    🏪
                </div>

                <h3>
                    Restaurant Management
                </h3>

                <p>
                    Add, edit, delete and manage
                    restaurants on Foodwala.
                </p>

                <span class="arrow">
                    Manage Restaurants →
                </span>

            </a>


            <!-- MENU -->

            <a href="admin-menu"
               class="action-card">

                <div class="action-icon">
                    🍽️
                </div>

                <h3>
                    Menu Management
                </h3>

                <p>
                    Manage menu items, prices,
                    descriptions and availability.
                </p>

                <span class="arrow">
                    Manage Menu →
                </span>

            </a>


            <!-- ORDERS -->

            <a href="admin-orders"
               class="action-card">

                <div class="action-icon">
                    📦
                </div>

                <h3>
                    Order Management
                </h3>

                <p>
                    View customer orders and
                    update their delivery status.
                </p>

                <span class="arrow">
                    Manage Orders →
                </span>

            </a>


            <!-- USERS -->

            <a href="admin-users"
               class="action-card">

                <div class="action-icon">
                    👥
                </div>

                <h3>
                    User Management
                </h3>

                <p>
                    View and manage Foodwala
                    customers and administrators.
                </p>

                <span class="arrow">
                    Manage Users →
                </span>

            </a>


            <!-- REPORTS -->

            <a href="admin-reports"
               class="action-card">

                <div class="action-icon">
                    📊
                </div>

                <h3>
                    Reports
                </h3>

                <p>
                    View order, revenue and
                    platform performance reports.
                </p>

                <span class="arrow">
                    View Reports →
                </span>

            </a>


            <!-- SETTINGS -->

            <a href="admin-settings"
               class="action-card">

                <div class="action-icon">
                    ⚙️
                </div>

                <h3>
                    Admin Settings
                </h3>

                <p>
                    Manage administrator account
                    and platform settings.
                </p>

                <span class="arrow">
                    Open Settings →
                </span>

            </a>

        </section>

    </main>

</body>

</html>