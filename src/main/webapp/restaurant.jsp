<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.model.CartItem"%>




<%
    Integer loggedInUserId =
            (Integer) session.getAttribute("userId");
%>

<%!/** HTML escape helper for XSS protection */
	private static String esc(Object o) {
		if (o == null)
			return "";

		String s = String.valueOf(o);
		StringBuilder b = new StringBuilder(s.length() + 16);

		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);

			switch (c) {
				case '&' :
					b.append("&amp;");
					break;
				case '<' :
					b.append("&lt;");
					break;
				case '>' :
					b.append("&gt;");
					break;
				case '"' :
					b.append("&quot;");
					break;
				case '\'' :
					b.append("&#39;");
					break;
				default :
					b.append(c);
			}
		}

		return b.toString();
	}%>

<%
@SuppressWarnings("unchecked")
List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

int cartCount = 0;
double cartSubtotal = 0.0;

if (cart != null) {
	for (CartItem item : cart) {
		cartCount += item.getQuantity();
		cartSubtotal += item.getTotalAmount();
	}
}

@SuppressWarnings("unchecked")
List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

boolean hasRestaurants = restaurants != null && !restaurants.isEmpty();

/*
 * Featured restaurant:
 * Highest-rated OPEN restaurant.
 * If no restaurant is open, first restaurant is used.
 */
Restaurant featured = null;

java.util.Set<String> cuisines = new java.util.LinkedHashSet<String>();

if (hasRestaurants) {

	for (Restaurant r : restaurants) {

		if (r.isActive() && (featured == null || r.getRating() > featured.getRating())) {

	featured = r;
		}

		String c = r.getCuisineType();

		if (c != null && !c.trim().isEmpty()) {
	cuisines.add(c.trim());
		}
	}

	if (featured == null) {
		featured = restaurants.get(0);
	}
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0, viewport-fit=cover">

<meta name="color-scheme" content="light dark">

<meta name="theme-color" content="#F3EEFA"
	media="(prefers-color-scheme: light)">

<meta name="theme-color" content="#07060D"
	media="(prefers-color-scheme: dark)">

<title>Foodwala - Restaurants</title>

<script>
document.documentElement.className += ' js';
</script>

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
	/* saffron -> ruby -> orchid */
	--t1: #22D3C5;
	--t2: #6366F1;
	/* teal -> indigo */
	--accent-gradient: linear-gradient(135deg, var(--a1) 0%, var(--a2) 55%,
		var(--a3) 115%);
	--cool-gradient: linear-gradient(135deg, var(--t1), var(--t2));
	--gold-gradient: linear-gradient(135deg, #FFE066 0%, #FFB300 55%, #FF8A00 100%);
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
	--glass-inset: inset 0 1.5px 0 rgba(255, 255, 255, 1), inset 0 -1px 0
		rgba(255, 255, 255, .3), inset 0 0 22px rgba(255, 255, 255, .35);
	--glass-shadow: 0 10px 34px rgba(60, 40, 120, .12), 0 2px 6px
		rgba(60, 40, 120, .06);
	--glass-shadow-hover: 0 22px 56px rgba(60, 40, 120, .2), 0 4px 12px
		rgba(60, 40, 120, .08);
	--blur: blur(28px) saturate(200%);
	--skel-a: rgba(255, 255, 255, .35);
	--skel-b: rgba(255, 255, 255, .85);
	--toast-bg: rgba(27, 23, 38, .88);
	--toast-fg: #fff;
	--gloss: linear-gradient(180deg, rgba(255, 255, 255, .55) 0%,
		rgba(255, 255, 255, .12) 48%, rgba(255, 255, 255, 0) 50%);
	--shadow-accent: 0 12px 26px var(--accent-glow), inset 0 1.5px 0
		rgba(255, 255, 255, .6), inset 0 -3px 6px rgba(120, 0, 40, .22);
	--r-xl: 28px;
	--r-lg: 18px;
	--r-md: 14px;
	--r-full: 999px;
	--spring: cubic-bezier(.34, 1.56, .64, 1);
	--ease: cubic-bezier(.22, .61, .36, 1);
	--wave:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 60' preserveAspectRatio='none'%3E%3Cpath d='M0 34 C200 6 400 62 600 34 S1000 6 1200 34 V60 H0Z'/%3E%3C/svg%3E");
}

@media ( prefers-color-scheme :dark) {
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
		--glass-inset: inset 0 1.5px 0 rgba(255, 255, 255, .22), inset 0 -1px 0
			rgba(255, 255, 255, .04), inset 0 0 22px rgba(255, 255, 255, .04);
		--glass-shadow: 0 10px 34px rgba(0, 0, 0, .55), 0 2px 6px
			rgba(0, 0, 0, .3);
		--glass-shadow-hover: 0 22px 56px rgba(0, 0, 0, .65), 0 4px 12px
			rgba(0, 0, 0, .35);
		--skel-a: rgba(255, 255, 255, .06);
		--skel-b: rgba(255, 255, 255, .17);
		--toast-bg: rgba(246, 244, 251, .92);
		--toast-fg: #1B1726;
		--gloss: linear-gradient(180deg, rgba(255, 255, 255, .34) 0%,
			rgba(255, 255, 255, .08) 48%, rgba(255, 255, 255, 0) 50%);
	}
}

@
supports not ((backdrop-filter:blur(1px)) or (-webkit-backdrop-filter:blur(1px)))
	{ :root { --glass:rgba(255, 255, 255, .95);
	--glass-strong: #fff;
}

@media ( prefers-color-scheme :dark) {
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
	font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text",
		"SF Pro Display", "Segoe UI", "Helvetica Neue", Arial, sans-serif;
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
	border-radius: 42% 58% 63% 37%/45% 40% 60% 55%;
	animation: flow 24s ease-in-out infinite alternate, morph 15s
		ease-in-out infinite;
}

.aqua i:nth-child(1) {
	width: 56vmax;
	height: 56vmax;
	left: -16vmax;
	top: -22vmax;
	background: radial-gradient(circle at 35% 35%, var(--a1), transparent
		66%);
}

.aqua i:nth-child(2) {
	width: 50vmax;
	height: 50vmax;
	right: -18vmax;
	top: -12vmax;
	background: radial-gradient(circle at 60% 40%, var(--a2), transparent
		66%);
	animation-delay: -7s;
}

.aqua i:nth-child(3) {
	width: 54vmax;
	height: 54vmax;
	left: -20vmax;
	bottom: -26vmax;
	background: radial-gradient(circle, var(--t1), transparent 66%);
	animation-delay: -12s;
	opacity: .48;
}

.aqua i:nth-child(4) {
	width: 46vmax;
	height: 46vmax;
	right: -14vmax;
	bottom: -18vmax;
	background: radial-gradient(circle, var(--t2), transparent 66%);
	animation-delay: -4s;
	opacity: .46;
}

@media ( prefers-color-scheme :dark) {
	.aqua i {
		opacity: .4;
	}
	.aqua i:nth-child(3), .aqua i:nth-child(4) {
		opacity: .32;
	}
}

/* =========================================================
   GLASS SURFACES (+ specular gloss)
   ========================================================= */
.restaurant-card, .featured-card, .search-bar, .empty-message,
	.nav-inner, .tab-bar, .cart-float-bar {
	background: linear-gradient(135deg, var(--glass-strong), var(--glass)
		55%, var(--glass-soft));
	-webkit-backdrop-filter: var(--blur);
	backdrop-filter: var(--blur);
	border: 1px solid var(--glass-border);
	box-shadow: var(--glass-inset), var(--glass-shadow);
}

.restaurant-card::before, .featured-card::before, .nav-inner::before,
	.tab-bar::before, .cart-float-bar::before {
	content: "";
	position: absolute;
	inset: 0;
	border-radius: inherit;
	pointer-events: none;
	z-index: 2;
	background: linear-gradient(115deg, rgba(255, 255, 255, .32) 0%,
		rgba(255, 255, 255, 0) 32%);
	opacity: .7;
}

.restaurant-card, .featured-card, .nav-inner, .tab-bar {
	position: relative;
}

.sheen {
	position: relative;
}

.sheen::after {
	content: "";
	position: absolute;
	inset: 0;
	border-radius: inherit;
	pointer-events: none;
	z-index: 3;
	opacity: 0;
	transition: opacity .35s ease;
	background: radial-gradient(380px circle at var(--mx, 50%)
		var(--my, -30%), rgba(255, 255, 255, .55), transparent 60%);
}

@media ( hover :hover) and (pointer:fine) {
	.sheen:hover::after {
		opacity: .6;
	}
}

@media ( prefers-color-scheme :dark) {
	@media ( hover :hover) {
		.sheen:hover::after {
			opacity: .24;
		}
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
	box-shadow: var(--glass-inset), var(--glass-shadow-hover);
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
	box-shadow: 0 7px 16px var(--accent-glow), inset 0 1.5px 0
		rgba(255, 255, 255, .6), inset 0 -3px 6px rgba(120, 0, 40, .25);
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

.nav-link, .cart-nav {
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
	transition: color .2s ease, background .25s ease, transform .3s
		var(--spring);
}

.nav-link:hover, .cart-nav:hover {
	color: var(--label);
	background: var(--hover);
}

.nav-link:active, .cart-nav:active {
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
	box-shadow: var(--glass-inset), 0 3px 10px rgba(60, 40, 120, .12);
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
	box-shadow: 0 3px 8px var(--accent-glow), inset 0 1px 0
		rgba(255, 255, 255, .5);
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
   GLOSSY BUTTON BASE (gloss + sweeping shine)
   ========================================================= */
.menu-btn, .featured-cta, .cart-float-btn {
	position: relative;
	overflow: hidden;
	background: var(--accent-gradient);
	color: #fff;
	box-shadow: var(--shadow-accent);
}

.menu-btn::before, .featured-cta::before, .cart-float-btn::before,
	.nav-link-cta::before {
	content: "";
	position: absolute;
	inset: 0;
	border-radius: inherit;
	pointer-events: none;
	background: var(--gloss);
}

.menu-btn::after, .featured-cta::after, .cart-float-btn::after,
	.nav-link-cta::after {
	content: "";
	position: absolute;
	top: -20%;
	bottom: -20%;
	left: -60%;
	width: 40%;
	pointer-events: none;
	transform: skewX(-22deg);
	background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .55),
		transparent);
	transition: left .7s var(--ease);
}

.menu-btn:hover::after, .featured-card:hover .featured-cta::after,
	.cart-float-bar:hover .cart-float-btn::after, .nav-link-cta:hover::after
	{
	left: 130%;
}

/* =========================================================
   HERO
   ========================================================= */
.title-header {
	position: relative;
	padding: 44px 0 64px;
	overflow: hidden;
}

.title-inner {
	position: relative;
	z-index: 1;
	width: 88%;
	max-width: 1250px;
	margin: 0 auto;
}

.large-title {
	display: inline-block;
	font-size: 42px;
	font-weight: 800;
	letter-spacing: -.03em;
	margin-bottom: 6px;
	background: linear-gradient(100deg, var(--a1), var(--a2), var(--a3),
		var(--t2), var(--a2), var(--a1));
	background-size: 260% 100%;
	-webkit-background-clip: text;
	background-clip: text;
	-webkit-text-fill-color: transparent;
	animation: titleFlow 9s linear infinite;
}

.title-subtitle {
	color: var(--label-2);
	font-size: 15.5px;
	margin-bottom: 22px;
}

.wave {
	position: absolute;
	left: 0;
	right: 0;
	bottom: 0;
	height: 36px;
	opacity: .5;
	pointer-events: none;
	background: linear-gradient(90deg, var(--a1), var(--a2), var(--a3),
		var(--t2), var(--t1), var(--a1));
	background-size: 200% 100%;
	-webkit-mask: var(--wave) repeat-x 0 100%/1200px 100%;
	mask: var(--wave) repeat-x 0 100%/1200px 100%;
	animation: waveX 16s linear infinite, waveBg 10s linear infinite;
}

.wave.b {
	height: 28px;
	bottom: 8px;
	opacity: .26;
	animation-duration: 24s, 14s;
	animation-direction: reverse, normal;
}

/* =========================================================
   SEARCH
   ========================================================= */
.search-bar {
	display: flex;
	align-items: center;
	gap: 8px;
	height: 52px;
	padding: 0 16px;
	border-radius: var(--r-lg);
	max-width: 470px;
	transition: box-shadow .3s ease, border-color .3s ease, transform .4s
		var(--spring);
}

.search-bar:focus-within {
	transform: scale(1.015);
	border-color: var(--a2);
	box-shadow: var(--glass-inset), 0 0 0 4px var(--accent-tint),
		var(--glass-shadow-hover);
}

.search-bar svg.search-icon {
	flex-shrink: 0;
	color: var(--accent-solid);
}

.search-bar input {
	flex: 1;
	min-width: 0;
	border: none;
	outline: none;
	background: transparent;
	font-family: inherit;
	font-size: 15px;
	color: var(--label);
}

.search-bar input::placeholder {
	color: var(--label-3);
}

.search-clear {
	position: relative;
	overflow: hidden;
	display: none;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	width: 26px;
	height: 26px;
	border-radius: 50%;
	border: none;
	background: rgba(120, 120, 140, .22);
	color: var(--label-2);
	cursor: pointer;
}

.search-bar.has-value .search-clear {
	display: flex;
}

/* =========================================================
   CHIPS
   ========================================================= */
.chip-row {
	display: flex;
	gap: 8px;
	margin-top: 16px;
	padding: 4px 2px 10px;
	overflow-x: auto;
	scrollbar-width: none;
}

.chip-row::-webkit-scrollbar {
	display: none;
}

.chip {
	position: relative;
	overflow: hidden;
	flex-shrink: 0;
	cursor: pointer;
	font-family: inherit;
	font-size: 13.5px;
	font-weight: 650;
	padding: 9px 17px;
	border-radius: var(--r-full);
	color: var(--label-2);
	background: linear-gradient(135deg, var(--glass-strong), var(--glass));
	border: 1px solid var(--glass-border);
	-webkit-backdrop-filter: var(--blur);
	backdrop-filter: var(--blur);
	box-shadow: var(--glass-inset), 0 4px 14px rgba(60, 40, 120, .08);
	transition: color .2s ease, transform .35s var(--spring), box-shadow .3s
		ease;
}

.chip:hover {
	color: var(--label);
	transform: translateY(-1px);
}

.chip:active {
	transform: scale(.94);
}

.chip.is-active {
	background: var(--accent-gradient);
	color: #fff;
	border-color: transparent;
	box-shadow: var(--shadow-accent);
}

.chip.is-active::before {
	content: "";
	position: absolute;
	inset: 0;
	border-radius: inherit;
	background: var(--gloss);
	pointer-events: none;
}

#openToggle.is-active {
	background: var(--cool-gradient);
	box-shadow: 0 10px 22px rgba(99, 102, 241, .4), inset 0 1.5px 0
		rgba(255, 255, 255, .6), inset 0 -3px 6px rgba(20, 20, 120, .25);
}

.chip-sep {
	flex-shrink: 0;
	width: 1px;
	background: var(--separator);
	margin: 6px 2px;
}

/* =========================================================
   IMAGE LOADING
   ========================================================= */
.skeleton {
	position: relative;
}

.js .skeleton:not(.img-ready):not(.img-fail) {
	background: linear-gradient(90deg, var(--skel-a) 25%, var(--skel-b) 40%,
		var(--skel-a) 60%);
	background-size: 300% 100%;
	animation: shimmer 1.4s linear infinite;
}

.fade-img {
	transition: opacity .6s ease, transform .7s var(--ease), filter .6s ease;
}

.js .fade-img:not(.loaded) {
	opacity: 0;
	filter: blur(14px);
	transform: scale(1.06);
}

.img-fail {
	background: var(--accent-tint);
}

.img-fail img {
	display: none;
}

.img-fail::after {
	content: "\1F37D";
	position: absolute;
	inset: 0;
	display: grid;
	place-items: center;
	font-size: 30px;
	opacity: .55;
}

/* =========================================================
   REVEAL
   ========================================================= */
.js .reveal:not(.in) {
	opacity: 0;
	transform: translateY(26px) scale(.97);
}

.reveal.in {
	animation: reveal .8s var(--spring) backwards;
	animation-delay: calc(min(var(--i, 0), 10)*45ms);
}

/* =========================================================
   FEATURED
   ========================================================= */
.featured-wrap {
	width: 88%;
	max-width: 1250px;
	margin: 26px auto 54px;
}

.featured-heading-row {
	margin-bottom: 20px;
}

.featured-label {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	font-size: 13px;
	font-weight: 700;
	color: var(--accent-solid);
	margin-bottom: 7px;
}

.featured-label::before {
	content: "";
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background: var(--accent-gradient);
	box-shadow: 0 0 0 5px var(--accent-tint);
	animation: breathe 2.6s ease-in-out infinite;
}

.featured-heading {
	font-size: clamp(27px, 3vw, 38px);
	line-height: 1.08;
	letter-spacing: -.035em;
	font-weight: 800;
}

.featured-subtitle {
	margin-top: 8px;
	color: var(--label-2);
	font-size: 15px;
	line-height: 1.5;
	max-width: 560px;
}

.featured-card {
	overflow: hidden;
	display: grid;
	grid-template-columns: minmax(0, 1.12fr) minmax(380px, .88fr);
	min-height: 430px;
	border-radius: 36px;
	text-decoration: none;
	transition: transform .6s var(--spring), box-shadow .4s ease;
}

.featured-card:hover {
	transform: translateY(-6px);
	box-shadow: var(--glass-inset), var(--glass-shadow-hover);
}

.featured-media {
	position: relative;
	min-height: 430px;
	overflow: hidden;
	border-radius: 36px 0 0 36px;
}

.featured-image {
	width: 100%;
	height: 100%;
	min-height: 430px;
	display: block;
	object-fit: cover;
}

.featured-card:hover .featured-image {
	transform: scale(1.05);
}

.featured-media::after {
	content: "";
	position: absolute;
	inset: 0;
	pointer-events: none;
	background: linear-gradient(90deg, transparent 60%, rgba(0, 0, 0, .16));
}

.featured-content {
	display: flex;
	flex-direction: column;
	justify-content: center;
	padding: 46px 48px;
	position: relative;
	z-index: 1;
}

.featured-tag {
	align-self: flex-start;
	padding: 8px 14px;
	border-radius: var(--r-full);
	margin-bottom: 18px;
	font-size: 12.5px;
	font-weight: 750;
	color: var(--accent-solid);
	background: var(--accent-tint);
	border: 1px solid rgba(255, 46, 99, .2);
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, .5);
}

.featured-name {
	font-size: clamp(30px, 3.2vw, 44px);
	line-height: 1.04;
	font-weight: 800;
	letter-spacing: -.04em;
	margin-bottom: 16px;
}

.featured-description {
	margin-bottom: 22px;
	color: var(--label-2);
	font-size: 15px;
	line-height: 1.65;
	max-width: 500px;
}

.featured-meta {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: 8px;
	margin-bottom: 28px;
}

.featured-chip {
	display: inline-flex;
	align-items: center;
	gap: 5px;
	padding: 8px 13px;
	border-radius: var(--r-full);
	font-size: 12.5px;
	font-weight: 650;
	color: var(--label-2);
	background: var(--glass-soft);
	border: 1px solid var(--glass-border);
	box-shadow: var(--glass-inset);
}

.featured-chip.is-rating {
	background: var(--gold-gradient);
	border-color: rgba(255, 255, 255, .5);
	color: #4A2A00;
	font-weight: 800;
	box-shadow: 0 6px 14px rgba(255, 150, 0, .35), inset 0 1.5px 0
		rgba(255, 255, 255, .7);
}

.featured-cta {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 9px;
	align-self: flex-start;
	min-height: 52px;
	padding: 0 24px;
	border-radius: 18px;
	font-size: 15px;
	font-weight: 700;
	transition: transform .4s var(--spring), box-shadow .3s ease;
}

.featured-card:hover .featured-cta {
	transform: translateY(-2px) scale(1.03);
}

.featured-cta svg {
	position: relative;
	transition: transform .35s var(--spring);
}

.featured-card:hover .featured-cta svg {
	transform: translateX(4px);
}

/* =========================================================
   GRID
   ========================================================= */
.container {
	width: 88%;
	max-width: 1250px;
	margin: 8px auto 0;
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	margin-bottom: 18px;
}

.section-header h2 {
	font-size: 22px;
	font-weight: 800;
	letter-spacing: -.014em;
}

.restaurant-count {
	color: var(--label-3);
	font-size: 13.5px;
}

.restaurant-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
	gap: 22px;
}

.restaurant-card {
	overflow: hidden;
	border-radius: var(--r-xl);
	transition: transform .55s var(--spring), box-shadow .35s ease;
}

.restaurant-card:hover {
	transform: translateY(-7px) scale(1.012);
	box-shadow: var(--glass-inset), var(--glass-shadow-hover);
}

.card-media {
	position: relative;
	height: 178px;
	overflow: hidden;
	margin: 8px 8px 0;
	border-radius: 21px;
	box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .35);
}

.card-media::after {
	content: "";
	position: absolute;
	inset: 0;
	pointer-events: none;
	z-index: 1;
	background: linear-gradient(180deg, rgba(255, 255, 255, .22),
		transparent 38%, rgba(0, 0, 0, .14));
}

.restaurant-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

.restaurant-card:hover .restaurant-image {
	transform: scale(1.09);
}

/* =========================================================
   status + rating
   ========================================================= */
.status-pill {
	position: absolute;
	top: 10px;
	left: 10px;
	z-index: 2;
	display: flex;
	align-items: center;
	gap: 6px;
	padding: 6px 11px;
	border-radius: var(--r-full);
	font-size: 12px;
	font-weight: 700;
	background: var(--glass-strong);
	border: 1px solid var(--glass-border);
	-webkit-backdrop-filter: blur(14px) saturate(180%);
	backdrop-filter: blur(14px) saturate(180%);
	box-shadow: var(--glass-inset);
}

.status-pill .dot {
	width: 7px;
	height: 7px;
	border-radius: 50%;
}

.status-pill.is-open {
	color: var(--success);
}

.status-pill.is-open .dot {
	background: var(--success);
	box-shadow: 0 0 0 3px var(--success-bg);
	animation: breathe 2.4s ease-in-out infinite;
}

.status-pill.is-closed {
	color: var(--danger);
}

.status-pill.is-closed .dot {
	background: var(--danger);
	box-shadow: 0 0 0 3px var(--danger-bg);
}

.rating-pill {
	position: absolute;
	top: 10px;
	right: 10px;
	z-index: 2;
	display: flex;
	align-items: center;
	gap: 3px;
	padding: 6px 11px;
	border-radius: var(--r-full);
	font-size: 12.5px;
	font-weight: 800;
	color: #4A2A00;
	background: var(--gold-gradient);
	box-shadow: 0 6px 14px rgba(255, 150, 0, .4), inset 0 1.5px 0
		rgba(255, 255, 255, .7), inset 0 -2px 4px rgba(180, 90, 0, .25);
}

/* =========================================================
   body
   ========================================================= */
.card-body {
	padding: 16px 18px 18px;
	position: relative;
	z-index: 1;
}

.card-top-row {
	margin-bottom: 10px;
}

.restaurant-name {
	font-size: 18px;
	font-weight: 700;
	letter-spacing: -.012em;
	margin-bottom: 7px;
}

.cuisine-tag {
	display: inline-block;
	padding: 4px 12px;
	border-radius: var(--r-full);
	background: var(--accent-tint);
	color: var(--accent-solid);
	font-size: 12px;
	font-weight: 700;
	border: 1px solid rgba(255, 46, 99, .14);
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, .5);
}

.meta-row {
	display: flex;
	flex-direction: column;
	gap: 8px;
	margin-bottom: 16px;
	padding-top: 12px;
	border-top: .5px solid var(--separator);
}

.meta-item {
	display: flex;
	align-items: center;
	gap: 7px;
	font-size: 13.5px;
	color: var(--label-2);
}

.meta-item svg {
	flex-shrink: 0;
	color: var(--accent-solid);
}

.meta-item span {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.menu-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
	width: 100%;
	padding: 13px;
	border: none;
	border-radius: var(--r-md);
	font-size: 15px;
	font-weight: 700;
	text-decoration: none;
	cursor: pointer;
	transition: filter .2s ease, transform .35s var(--spring), box-shadow
		.3s ease;
}

.menu-btn:hover {
	filter: brightness(1.07);
}

.menu-btn:active {
	transform: scale(.95);
}

.menu-btn svg {
	position: relative;
	transition: transform .35s var(--spring);
}

.menu-btn:hover svg {
	transform: translateX(3px);
}

/* =========================================================
   closed
   ========================================================= */
.restaurant-card.is-closed .restaurant-image {
	filter: grayscale(1) brightness(.92);
}

.restaurant-card.is-closed .restaurant-name {
	color: var(--label-2);
}

.menu-btn.is-disabled {
	background: rgba(120, 120, 140, .2);
	color: var(--label-3);
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, .4);
	cursor: not-allowed;
	pointer-events: none;
}

.menu-btn.is-disabled::before, .menu-btn.is-disabled::after {
	display: none;
}

/* =========================================================
   empty + footer
   ========================================================= */
.empty-message {
	text-align: center;
	padding: 70px 30px;
	border-radius: var(--r-xl);
	color: var(--label-2);
}

.empty-message h3 {
	font-size: 19px;
	font-weight: 700;
	color: var(--label);
	margin-bottom: 6px;
}

.empty-message p {
	font-size: 14.5px;
}

footer {
	margin-top: 56px;
	text-align: center;
	padding: 24px;
	color: var(--label-3);
	font-size: 12.5px;
}

/* =========================================================
   FLOATING CART
   ========================================================= */
.cart-float-bar {
	position: fixed;
	left: 50%;
	bottom: 24px;
	z-index: 95;
	transform: translateX(-50%);
	overflow: hidden;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;
	width: 88%;
	max-width: 470px;
	padding: 10px 10px 10px 24px;
	border-radius: var(--r-full);
	color: var(--label);
	text-decoration: none;
	animation: barIn .7s var(--spring);
}

.cart-float-info {
	display: flex;
	flex-direction: column;
	gap: 1px;
	min-width: 0;
	position: relative;
	z-index: 3;
}

.cart-float-count {
	font-size: 11.5px;
	font-weight: 650;
	color: var(--label-2);
	white-space: nowrap;
}

.cart-float-total {
	font-size: 17px;
	font-weight: 800;
	letter-spacing: -.01em;
}

.cart-float-btn {
	display: flex;
	align-items: center;
	gap: 6px;
	flex-shrink: 0;
	padding: 12px 20px;
	border-radius: var(--r-full);
	font-size: 14px;
	font-weight: 750;
	white-space: nowrap;
	z-index: 3;
}

.cart-float-btn svg {
	position: relative;
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
	box-shadow: 0 14px 34px rgba(0, 0, 0, .26), inset 0 1px 0
		rgba(255, 255, 255, .2);
	animation: toastIn .55s var(--spring);
}

.toast.out {
	opacity: 0;
	transform: translateY(-10px) scale(.96);
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
	background: radial-gradient(circle, rgba(255, 255, 255, .7),
		rgba(255, 255, 255, 0) 68%);
	animation: rip .75s ease-out forwards;
}

.rip.dark {
	background: radial-gradient(circle, rgba(255, 46, 99, .28),
		rgba(255, 46, 99, 0) 68%);
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
	transition: color .25s ease, transform .35s var(--spring);
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
	box-shadow: var(--glass-inset), 0 4px 12px rgba(60, 40, 120, .14);
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
@
keyframes flow {to { transform:translate3d(7vmax, 5vmax, 0)rotate(38deg)scale(1.14);
	
}

}
@
keyframes morph { 50% {
	border-radius: 60% 40% 32% 68%/58% 32% 68% 42%;
}

}
@
keyframes titleFlow {to { background-position:-260%0;
	
}

}
@
keyframes waveX {to { -webkit-mask-position:1200px100 %;
	mask-position: 1200px 100%;
}

}
@
keyframes waveBg {to { background-position:-200%0;
	
}

}
@
keyframes shimmer {to { background-position:-300%0;
	
}

}
@
keyframes reveal {from { opacity:0;
	transform: translateY(26px) scale(.97);
	filter: blur(6px);
}

}
@
keyframes breathe { 50% {
	transform: scale(1.35);
	opacity: .7;
}

}
@
keyframes barIn {from { opacity:0;
	transform: translateX(-50%) translateY(40px) scale(.9);
}

}
@
keyframes toastIn {from { opacity:0;
	transform: translateY(-16px) scale(.9);
	filter: blur(6px);
}

}
@
keyframes rip {to { transform:scale(1);
	opacity: 0;
}

}

/* =========================================================
   RESPONSIVE
   ========================================================= */
@media ( max-width :900px) {
	.featured-card {
		grid-template-columns: 1fr;
		min-height: 0;
		border-radius: 28px;
	}
	.featured-media, .featured-image {
		min-height: 245px;
		height: 245px;
	}
	.featured-media {
		border-radius: 28px 28px 0 0;
	}
	.featured-content {
		padding: 26px 24px 28px;
	}
	.featured-cta {
		width: 100%;
	}
}

@media ( max-width :650px) {
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
	.container, .title-inner, .featured-wrap {
		width: 90%;
	}
	.large-title {
		font-size: 32px;
	}
	.title-header {
		padding: 30px 0 54px;
	}
	.search-bar {
		max-width: none;
	}
	.featured-wrap {
		margin-top: 18px;
		margin-bottom: 42px;
	}
	.featured-heading {
		font-size: 28px;
	}
	.featured-subtitle {
		font-size: 14px;
	}
	.featured-name {
		font-size: 29px;
	}
	.featured-description {
		margin-bottom: 18px;
	}
	.featured-meta {
		margin-bottom: 22px;
	}
	.restaurant-grid {
		grid-template-columns: 1fr;
	}
	.aqua i:nth-child(4) {
		display: none;
	}
	.cart-float-bar {
		width: calc(100% - 24px);
		bottom: calc(92px + env(safe-area-inset-bottom, 0px));
		padding: 9px 9px 9px 20px;
	}
	.cart-float-total {
		font-size: 16px;
	}
	.cart-float-btn {
		padding: 11px 16px;
		font-size: 13px;
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
		bottom: calc(10px + env(safe-area-inset-bottom, 0px));
		border-radius: 30px;
		view-transition-name: tabbar;
	}
}

@media ( prefers-reduced-motion :reduce) {
	*, *::before, *::after {
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


	<div class="aqua" aria-hidden="true">
		<i></i><i></i><i></i><i></i>
	</div>

	<!-- =====================================================
     NAVBAR
     ===================================================== -->
	<header class="navbar" id="navbar">
		<div class="nav-inner">
			<a href="restaurant" class="brand"> <span class="brand-mark">F</span>
				<span class="brand-name">Foodwala</span>
			</a>
			<nav class="nav-links" aria-label="Primary">
				<a href="#" class="nav-link" data-soon>Home</a> <a href="restaurant"
					class="nav-link is-active"><span class="nav-pill"></span>Restaurants</a>
				<a href="orders" class="nav-link">Orders</a> <a
					href="cart?action=view" class="cart-nav" aria-label="Cart"> <svg
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						aria-hidden="true">
                    <path d="M6 8h12l1 13H5L6 8z" />
                    <path d="M9 8a3 3 0 0 1 6 0" />
                </svg> <span class="cart-text">Cart</span> <%
 if (cartCount > 0) {
 %><span class="cart-badge"><%=cartCount%></span> <%
 }
 %>
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

	<!-- =====================================================
     TITLE / SEARCH
     ===================================================== -->
	<section class="title-header">
		<div class="title-inner">
			<h1 class="large-title">Restaurants</h1>
			<p class="title-subtitle">Discover great food, delivered to your
				door</p>

			<div class="search-bar" id="searchBar">
				<svg class="search-icon" width="16" height="16" viewBox="0 0 24 24"
					fill="none" stroke="currentColor" stroke-width="2"
					stroke-linecap="round" aria-hidden="true">
                <circle cx="11" cy="11" r="7" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
				<input type="search" id="restaurantSearch"
					placeholder="Search restaurants or cuisines" autocomplete="off"
					aria-label="Search restaurants or cuisines">
				<button type="button" class="search-clear" id="searchClear"
					aria-label="Clear search">
					<svg width="11" height="11" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2.6" stroke-linecap="round"
						aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18" />
                    <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
				</button>
			</div>

			<%
			if (hasRestaurants) {
			%>
			<div class="chip-row" id="chipRow" role="group"
				aria-label="Filter restaurants">
				<button type="button" class="chip is-active" data-cuisine="">All</button>
				<button type="button" class="chip" id="openToggle"
					aria-pressed="false">Open now</button>
				<%
				if (!cuisines.isEmpty()) {
				%><span class="chip-sep" aria-hidden="true"></span>
				<%
				}
				%>
				<%
				for (String c : cuisines) {
				%>
				<button type="button" class="chip"
					data-cuisine="<%=esc(c.toLowerCase())%>"><%=esc(c)%></button>
				<%
				}
				%>
			</div>
			<%
			}
			%>
		</div>
		<div class="wave b" aria-hidden="true"></div>
		<div class="wave" aria-hidden="true"></div>
	</section>

	<!-- =====================================================
     FEATURED
     ===================================================== -->
	<%
	if (hasRestaurants) {
	%>
	<div class="featured-wrap reveal">
		<div class="featured-heading-row">
			<div class="featured-label">Featured pick</div>
			<h2 class="featured-heading">Curated just for you</h2>
			<p class="featured-subtitle">A standout restaurant worth
				discovering today.</p>
		</div>

		<a class="featured-card sheen"
			href="menu?restaurantId=<%=featured.getRestaurantId()%>">
			<div class="featured-media skeleton">
				<img class="featured-image fade-img"
					src="<%=esc(featured.getImagePath())%>"
					alt="<%=esc(featured.getName())%>">
			</div>
			<div class="featured-content">
				<span class="featured-tag"><%=featured.isActive() ? "Top rated & open now" : "Featured"%></span>
				<div class="featured-name"><%=esc(featured.getName())%></div>
				<p class="featured-description">Carefully selected dishes and
					great flavours, ready for your next order.</p>
				<div class="featured-meta">
					<span class="featured-chip is-rating">&#9733; <%=featured.getRating()%></span>
					<span class="featured-chip"><%=esc(featured.getCuisineType())%></span>
					<span class="featured-chip"><%=esc(featured.getDeliveryTime())%></span>
				</div>
				<span class="featured-cta">Explore menu <svg width="18"
						height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"
						aria-hidden="true">
                    <path d="M5 12h13" />
                    <path d="m13 6 6 6-6 6" />
                </svg>
				</span>
			</div>
		</a>
	</div>
	<%
	}
	%>

	<!-- =====================================================
     ALL RESTAURANTS
     ===================================================== -->
	<main class="container">
		<div class="section-header">
			<h2>All restaurants</h2>
			<%
			if (hasRestaurants) {
			%>
			<span class="restaurant-count" id="restaurantCount"
				aria-live="polite"> <%=restaurants.size()%> <%=restaurants.size() == 1 ? "restaurant available" : "restaurants available"%>
			</span>
			<%
			}
			%>
		</div>

		<%
		if (hasRestaurants) {
		%>
		<div class="restaurant-grid" id="restaurantGrid">
			<%
			int i = 0;
			%>
			<%
			for (Restaurant restaurant : restaurants) {
			%>
			<div
				class="restaurant-card sheen reveal<%=restaurant.isActive() ? "" : " is-closed"%>"
				style="--i:<%=i++%>" data-name="<%=esc(restaurant.getName())%>"
				data-cuisine="<%=esc(restaurant.getCuisineType())%>"
				data-open="<%=restaurant.isActive() ? "1" : "0"%>">

				<div class="card-media skeleton">
					<img class="restaurant-image fade-img"
						src="<%=esc(restaurant.getImagePath())%>"
						alt="<%=esc(restaurant.getName())%>" loading="lazy">
					<%
					if (restaurant.isActive()) {
					%>
					<span class="status-pill is-open"><span class="dot"></span>Open</span>
					<%
					} else {
					%>
					<span class="status-pill is-closed"><span class="dot"></span>Closed</span>
					<%
					}
					%>
					<span class="rating-pill">&#9733; <%=restaurant.getRating()%></span>
				</div>

				<div class="card-body">
					<div class="card-top-row">
						<h3 class="restaurant-name"><%=esc(restaurant.getName())%></h3>
						<span class="cuisine-tag"><%=esc(restaurant.getCuisineType())%></span>
					</div>

					<div class="meta-row">
						<div class="meta-item">
							<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round" aria-hidden="true">
                            <circle cx="12" cy="12" r="9" />
                            <polyline points="12 7 12 12 15.5 14" />
                        </svg>
							<span><%=esc(restaurant.getDeliveryTime())%></span>
						</div>
						<div class="meta-item">
							<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round" aria-hidden="true">
                            <path
									d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z" />
                            <circle cx="12" cy="10" r="3" />
                        </svg>
							<span><%=esc(restaurant.getAddress())%></span>
						</div>
					</div>

					<%
					if (restaurant.isActive()) {
					%>
					<a href="menu?restaurantId=<%=restaurant.getRestaurantId()%>"
						class="menu-btn">View menu <svg width="14" height="14"
							viewBox="0 0 24 24" fill="none" stroke="currentColor"
							stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"
							aria-hidden="true">
                        <polyline points="9 6 15 12 9 18" />
                    </svg>
					</a>
					<%
					} else {
					%>
					<span class="menu-btn is-disabled" aria-disabled="true">Closed
						right now</span>
					<%
					}
					%>
				</div>
			</div>
			<%
			}
			%>
		</div>

		<div class="empty-message" id="searchEmptyMessage" hidden>
			<h3>No matches found</h3>
			<p>Try a different name or cuisine, or clear the filters.</p>
		</div>

		<%
		} else {
		%>
		<div class="empty-message">
			<h3>No restaurants available</h3>
			<p>Please check again later.</p>
		</div>
		<%
		}
		%>
	</main>

	<footer>&copy; 2026 Foodwala. All rights reserved.</footer>

	<!-- =====================================================
     FLOATING CART
     ===================================================== -->
	<%
	if (cartCount > 0) {
	%>
	<a href="cart?action=view" class="cart-float-bar">
		<div class="cart-float-info">
			<span class="cart-float-count"><%=cartCount%> <%=cartCount == 1 ? "item" : "items"%>
				in your cart</span> <span class="cart-float-total">&#8377;<%=String.format("%.2f", cartSubtotal)%></span>
		</div> <span class="cart-float-btn">View Cart <svg width="14"
				height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
				stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"
				aria-hidden="true">
            <path d="M5 12h14" />
            <polyline points="13 6 19 12 13 18" />
        </svg>
	</span>
	</a>
	<%
	}
	%>

	<!-- =====================================================
     MOBILE TAB BAR
     ===================================================== -->
	<nav class="tab-bar" aria-label="Mobile">
		<a href="#" class="tab-item" data-soon> <svg width="22"
				height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
				stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
				aria-hidden="true">
            <path d="M3 10.5 12 3l9 7.5" />
            <path d="M5 9.5V21h14V9.5" />
        </svg>Home
		</a> <a href="restaurant" class="tab-item is-active"><span
			class="tab-pill"></span> <svg width="22" height="22"
				viewBox="0 0 24 24" fill="none" stroke="currentColor"
				stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
				aria-hidden="true">
            <path d="M3 3v7a2 2 0 0 0 2 2h1v9" />
            <path d="M9 3v18" />
            <path d="M15 3c-1.5 0-3 1.5-3 4.5S13.5 12 15 12v9" />
        </svg>Restaurants </a> <a href="cart?action=view" class="tab-item"> <%
 if (cartCount > 0) {
 %><span class="tab-badge"><%=cartCount%></span> <%
 }
 %> <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
				stroke="currentColor" stroke-width="2" stroke-linecap="round"
				stroke-linejoin="round" aria-hidden="true">
            <path d="M6 8h12l1 13H5L6 8z" />
            <path d="M9 8a3 3 0 0 1 6 0" />
        </svg>Cart
		</a> <a href="#" class="tab-item" data-soon> <svg width="22"
				height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
				stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
				aria-hidden="true">
            <path d="M20 21a8 8 0 0 0-16 0" />
            <circle cx="12" cy="7" r="4" />
        </svg>Login
		</a>
	</nav>


	<script>

(function() {

    /* =====================================================
       TOAST
       ===================================================== */

    function toast(msg) {
        var host = document.getElementById('toastHost');
        if (!host) {
            host = document.createElement('div');
            host.id = 'toastHost';
            host.className = 'toast-host';
            host.setAttribute('role', 'status');
            host.setAttribute('aria-live', 'polite');
            document.body.appendChild(host);
        }
        var t = document.createElement('div');
        t.className = 'toast';
        t.textContent = msg;
        host.appendChild(t);
        setTimeout(function() {
            t.classList.add('out');
            setTimeout(function() {
                t.remove();
            }, 360);
        }, 2200);
    }

    /* =====================================================
       COMING SOON LINKS
       ===================================================== */

    document.addEventListener('click', function(e) {
        var a = e.target.closest('a[data-soon]');
        if (a) {
            e.preventDefault();
            toast('Coming soon');
        }
    });

    /* =====================================================
       RIPPLE
       ===================================================== */

    document.addEventListener('pointerdown', function(e) {
        var t = e.target.closest('.menu-btn, .chip, .nav-link-cta, .search-clear, .cart-float-bar');
        if (!t || t.classList.contains('is-disabled')) return;
        var r = t.getBoundingClientRect();
        var s = Math.max(r.width, r.height) * 2.4;
        var sp = document.createElement('span');
        sp.className = 'rip' + (t.classList.contains('chip') && !t.classList.contains('is-active') ? ' dark' : '');
        sp.style.cssText = 'width:' + s + 'px;height:' + s + 'px;left:' + (e.clientX - r.left - s / 2) + 'px;top:' + (e.clientY - r.top - s / 2) + 'px';
        t.appendChild(sp);
        setTimeout(function() {
            sp.remove();
        }, 800);
    });

    /* =====================================================
       CURSOR SHEEN
       ===================================================== */

    var raf = 0;
    document.addEventListener('pointermove', function(e) {
        if (e.pointerType !== 'mouse' || raf) return;
        var c = e.target.closest('.sheen');
        if (!c) return;
        raf = requestAnimationFrame(function() {
            raf = 0;
            var r = c.getBoundingClientRect();
            c.style.setProperty('--mx', (e.clientX - r.left) + 'px');
            c.style.setProperty('--my', (e.clientY - r.top) + 'px');
        });
    });

    /* =====================================================
       NAVBAR SCROLL
       ===================================================== */

    var nav = document.getElementById('navbar');

    function onScroll() {
        if (nav) nav.classList.toggle('scrolled', window.scrollY > 8);
    }
    window.addEventListener('scroll', onScroll, {
        passive: true
    });
    onScroll();

    /* =====================================================
       IMAGE LOADING
       ===================================================== */

    document.querySelectorAll('img.fade-img').forEach(function(img) {
        var box = img.parentNode;

        function ok() {
            img.classList.add('loaded');
            box.classList.add('img-ready');
        }

        function bad() {
            img.classList.add('loaded');
            box.classList.add('img-fail');
        }
        if (img.complete) {
            img.naturalWidth > 0 ? ok() : bad();
        } else {
            img.addEventListener('load', ok);
            img.addEventListener('error', bad);
        }
    });

    /* =====================================================
       SCROLL REVEAL
       ===================================================== */

    var io = ('IntersectionObserver' in window) ?
        new IntersectionObserver(function(entries) {
            entries.forEach(function(en) {
                if (en.isIntersecting) {
                    en.target.classList.add('in');
                    io.unobserve(en.target);
                }
            });
        }, {
            threshold: 0.08,
            rootMargin: '0px 0px -6% 0px'
        }) :
        null;
    document.querySelectorAll('.reveal').forEach(function(el) {
        if (io) io.observe(el);
        else el.classList.add('in');
    });

    /* =====================================================
       SEARCH / FILTER
       ===================================================== */

    var searchBar = document.getElementById('searchBar');
    var searchInput = document.getElementById('restaurantSearch');
    var clearBtn = document.getElementById('searchClear');
    var grid = document.getElementById('restaurantGrid');
    var countEl = document.getElementById('restaurantCount');
    var emptyMsg = document.getElementById('searchEmptyMessage');
    var chipRow = document.getElementById('chipRow');
    var openToggle = document.getElementById('openToggle');

    if (!searchInput || !grid) return;

    var cards = Array.prototype.slice.call(grid.querySelectorAll('.restaurant-card'));
    var total = cards.length;
    var cuisine = '';
    var openOnly = false;

    function applyFilter() {
        var q = searchInput.value.trim().toLowerCase();
        searchBar.classList.toggle('has-value', q.length > 0);
        var visible = 0;

        cards.forEach(function(card) {
            var name = (card.getAttribute('data-name') || '').toLowerCase();
            var cui = (card.getAttribute('data-cuisine') || '').toLowerCase();
            var ok = (q === '' || name.indexOf(q) !== -1 || cui.indexOf(q) !== -1) &&
                (cuisine === '' || cui === cuisine) &&
                (!openOnly || card.getAttribute('data-open') === '1');
            card.hidden = !ok;
            if (ok) {
                visible++;
                card.classList.add('in');
            }
        });

        var filtered = q !== '' || cuisine !== '' || openOnly;

        if (countEl) {
            countEl.textContent = filtered ?
                visible + (visible === 1 ? ' restaurant found' : ' restaurants found') :
                total + (total === 1 ? ' restaurant available' : ' restaurants available');
        }
        if (emptyMsg) emptyMsg.hidden = !(visible === 0 && filtered);
        grid.hidden = (visible === 0 && filtered);
    }

    searchInput.addEventListener('input', applyFilter);

    if (clearBtn) {
        clearBtn.addEventListener('click', function() {
            searchInput.value = '';
            applyFilter();
            searchInput.focus();
        });
    }

    if (chipRow) {
        chipRow.addEventListener('click', function(e) {
            var chip = e.target.closest('.chip');
            if (!chip) return;

            if (chip === openToggle) {
                openOnly = !openOnly;
                chip.classList.toggle('is-active', openOnly);
                chip.setAttribute('aria-pressed', String(openOnly));
            } else {
                cuisine = chip.getAttribute('data-cuisine') || '';
                chipRow.querySelectorAll('.chip[data-cuisine]').forEach(function(c) {
                    c.classList.toggle('is-active', c === chip);
                });
            }
            applyFilter();
        });
    }
})();

</script>


</body>
</html>
