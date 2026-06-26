<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 | MarryView</title>

    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
        :root {
            --primary: #ff4d6d;
            --primary-dark: #e83f60;
            --primary-soft: #fff0f3;
            --primary-pale: #fff7f9;
            --ink: #2f2930;
            --muted: #857a80;
            --line: #f0e5e9;
            --white: #ffffff;
            --success: #38a169;
            --shadow: 0 18px 50px rgba(115, 55, 72, 0.10);
            --side-width: clamp(150px, calc((100vw - 1040px) / 2 - 34px), 230px);
            --side-gap: 34px;
        }

        * { box-sizing: border-box; }
        [v-cloak] { display: none !important; }

        body {
            min-height: 100vh;
            margin: 0;
            background:
                radial-gradient(circle at 8% 4%, rgba(255, 184, 198, .28), transparent 24rem),
                radial-gradient(circle at 95% 24%, rgba(255, 220, 228, .52), transparent 28rem),
                var(--primary-pale);
            color: var(--ink);
            font-family: "Pretendard", "Noto Sans KR", Arial, sans-serif;
        }

        button, select { font: inherit; }

        button:focus-visible, select:focus-visible, .notification-page-item:focus-visible {
            outline: 3px solid rgba(255, 77, 109, .22);
            outline-offset: 2px;
        }

        .page-shell {
            width: min(960px, calc(100% - 32px));
            margin: 0 auto;
            padding: 56px 0 72px;
        }

        .side-visual {
            position: fixed;
            top: 50%;
            z-index: 0;
            display: none;
            width: var(--side-width);
            height: min(55vh, 520px);
            min-height: 360px;
            overflow: hidden;
            border: 7px solid rgba(255, 255, 255, .82);
            border-radius: 120px 120px 28px 28px;
            background-color: #f8dfe5;
            background-position: center;
            background-size: cover;
            box-shadow: 0 24px 60px rgba(115, 55, 72, .13);
            transform: translateY(-50%);
        }

        .side-visual::before {
            position: absolute;
            z-index: 2;
            inset: 0;
            background:
                linear-gradient(180deg, rgba(90, 38, 54, .42) 0, rgba(90, 38, 54, .16) 23%, transparent 43%),
                linear-gradient(0deg, rgba(80, 34, 47, .42) 0, rgba(80, 34, 47, .08) 23%, transparent 42%);
            pointer-events: none;
            content: "";
        }

        .side-visual::after {
            position: absolute;
            z-index: 3;
            top: 14px;
            left: 50%;
            width: 34px;
            height: 1px;
            background: rgba(255, 255, 255, .72);
            content: "";
            transform: translateX(-50%);
        }

        .side-visual--left {
            left: calc(50% - 480px - var(--side-width) - var(--side-gap));
            background-image: linear-gradient(145deg, #f5d9e0, #efc5d0);
        }

        .side-video {
            position: absolute;
            z-index: 1;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        .video-ornament {
            position: absolute;
            right: 13px;
            left: 13px;
            z-index: 4;
            color: rgba(255, 255, 255, .96);
            pointer-events: none;
            text-align: center;
            text-shadow: 0 2px 12px rgba(62, 27, 38, .32);
        }

        .video-ornament--top {
            top: 27px;
            font: 700 9px/1 Georgia, serif;
            letter-spacing: .2em;
        }

        .video-ornament--bottom { bottom: 25px; }

        .video-ornament-title {
            display: block;
            margin-bottom: 6px;
            font: italic 400 clamp(16px, 1.5vw, 22px)/1.1 Georgia, serif;
        }

        .video-ornament-copy {
            display: block;
            font-size: 8px;
            font-weight: 700;
            letter-spacing: .1em;
        }

        .product-ad-rail {
            position: fixed;
            top: calc(50% + min(27.5vh, 260px) + 14px);
            left: calc(50% - 480px - var(--side-width) - var(--side-gap));
            z-index: 1;
            display: none;
            width: var(--side-width);
        }

        .product-ad-card {
            position: relative;
            overflow: hidden;
            min-height: 172px;
            padding: 15px;
            border: 1px solid rgba(255, 77, 109, .14);
            border-radius: 22px;
            background: rgba(255, 255, 255, .96);
            box-shadow: 0 18px 44px rgba(115, 55, 72, .12);
        }

        .product-ad-topline {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .product-ad-label {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--primary-dark);
            font-size: 8px;
            font-weight: 900;
            letter-spacing: .08em;
        }

        .product-ad-label::before {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 77, 109, .10);
            content: "";
        }

        .product-ad-number { color: #b6a8ad; font: 700 8px/1 Georgia, serif; }

        .product-ad-body {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: 62px minmax(0, 1fr);
            gap: 11px;
            align-items: center;
        }

        .product-ad-visual {
            display: grid;
            width: 62px;
            height: 72px;
            place-items: center;
            border-radius: 17px;
            background: linear-gradient(145deg, #ffe9ee, #fff8fa);
            color: var(--primary-dark);
            font-size: 28px;
            box-shadow: inset 0 0 0 1px rgba(255, 77, 109, .10);
        }

        .product-ad-visual.gold { background: linear-gradient(145deg, #fff3d9, #fffaf0); color: #ba8025; }
        .product-ad-visual.lilac { background: linear-gradient(145deg, #efe9ff, #faf8ff); color: #8065c7; }

        .product-ad-company {
            overflow: hidden;
            margin-bottom: 5px;
            color: #a29298;
            font-size: 8px;
            font-weight: 800;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .product-ad-name {
            display: -webkit-box;
            overflow: hidden;
            min-height: 30px;
            margin: 0;
            color: #4d4146;
            font-size: 11px;
            font-weight: 900;
            line-height: 1.45;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
        }

        .product-ad-price { display: flex; align-items: baseline; gap: 5px; margin-top: 7px; }
        .product-ad-discount { color: var(--primary); font-size: 10px; font-weight: 900; }
        .product-ad-amount { color: #4d4146; font-size: 10px; font-weight: 900; }

        .product-ad-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 12px;
        }

        .product-ad-dots { display: flex; gap: 4px; }
        .product-ad-dot { width: 4px; height: 4px; border-radius: 50%; background: #e7dce0; transition: width .18s ease, background .18s ease; }
        .product-ad-dot.active { width: 12px; border-radius: 99px; background: var(--primary); }

        .product-ad-actions { display: flex; align-items: center; gap: 5px; }

        .product-ad-arrow,
        .product-ad-link {
            display: grid;
            height: 24px;
            place-items: center;
            border: 1px solid rgba(255, 77, 109, .13);
            background: #fff;
            color: var(--primary-dark);
            cursor: pointer;
        }

        .product-ad-arrow { width: 24px; padding: 0; border-radius: 50%; font-size: 12px; }
        .product-ad-link { padding: 0 9px; border-radius: 99px; font-size: 8px; font-weight: 900; }
        .product-ad-arrow:hover, .product-ad-link:hover { background: var(--primary-soft); }

        .wedding-celebration-rail {
            position: fixed;
            top: calc(50% + 24px);
            right: calc(50% - 480px - var(--side-width) - var(--side-gap));
            z-index: 0;
            display: none;
            width: var(--side-width);
            max-height: calc(100vh - 64px);
            overflow-y: auto;
            padding: 2px;
            scrollbar-width: none;
            transform: translateY(-50%);
        }

        .wedding-celebration-rail::-webkit-scrollbar { display: none; }

        .celebration-card {
            position: relative;
            min-height: 430px;
            overflow: hidden;
            padding: 26px 20px 20px;
            border: 1px solid rgba(255, 77, 109, .16);
            border-radius: 30px;
            background:
                radial-gradient(circle at 100% 0, rgba(255, 205, 215, .78), transparent 42%),
                linear-gradient(155deg, rgba(255,255,255,.98), rgba(255,241,245,.96));
            box-shadow: 0 24px 60px rgba(115, 55, 72, .14);
            text-align: center;
        }

        .celebration-card::before,
        .celebration-card::after {
            position: absolute;
            border: 1px solid rgba(255, 77, 109, .13);
            border-radius: 50%;
            content: "";
        }

        .celebration-card::before { top: -45px; right: -55px; width: 145px; height: 145px; }
        .celebration-card::after { bottom: -54px; left: -62px; width: 160px; height: 160px; }

        .celebration-topline {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .celebration-label {
            color: var(--primary);
            font: 700 9px/1 Georgia, serif;
            letter-spacing: .16em;
        }

        .celebration-dday {
            padding: 5px 8px;
            border-radius: 99px;
            background: var(--primary);
            color: #fff;
            font-size: 9px;
            font-weight: 900;
            box-shadow: 0 6px 14px rgba(255, 77, 109, .21);
        }

        .celebration-rings {
            position: relative;
            z-index: 1;
            width: 74px;
            height: 49px;
            margin: 28px auto 15px;
        }

        .celebration-rings span {
            position: absolute;
            top: 5px;
            width: 42px;
            height: 42px;
            border: 2px solid #e1b05d;
            border-radius: 50%;
            box-shadow: inset 0 0 0 2px rgba(255,255,255,.75), 0 5px 12px rgba(183,126,47,.12);
        }

        .celebration-rings span:first-child { left: 4px; transform: rotate(-12deg); }
        .celebration-rings span:last-child { right: 4px; transform: rotate(12deg); }

        .celebration-kicker {
            position: relative;
            z-index: 1;
            margin: 0 0 8px;
            color: #a48b70;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .08em;
        }

        .celebration-names {
            position: relative;
            z-index: 1;
            margin: 0;
            color: #4d3a41;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(19px, 1.7vw, 25px);
            font-style: italic;
            font-weight: 400;
            line-height: 1.25;
        }

        .celebration-date {
            position: relative;
            z-index: 1;
            margin-top: 9px;
            color: var(--muted);
            font: 700 10px/1.4 Georgia, serif;
            letter-spacing: .08em;
        }

        .celebration-divider {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 19px 0 15px;
            color: var(--primary);
            font-size: 10px;
        }

        .celebration-divider::before,
        .celebration-divider::after { flex: 1; height: 1px; background: #efdde2; content: ""; }

        .celebration-message {
            position: relative;
            z-index: 1;
            min-height: 61px;
            margin: 0;
            color: #77676d;
            font-size: 11px;
            line-height: 1.75;
            word-break: keep-all;
        }

        .celebration-bottom {
            position: relative;
            z-index: 1;
            margin-top: 17px;
            padding: 12px 10px;
            border: 1px solid rgba(255, 77, 109, .13);
            border-radius: 14px;
            background: rgba(255,255,255,.72);
            color: var(--primary-dark);
            font-size: 10px;
            font-weight: 800;
            line-height: 1.5;
        }

        .celebration-bottom.is-mine { background: linear-gradient(135deg, #fff0f3, #ffe4ea); }

        .celebration-nav {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 12px;
        }

        .celebration-arrow {
            display: grid;
            width: 27px;
            height: 27px;
            padding: 0;
            place-items: center;
            border: 1px solid rgba(255, 77, 109, .15);
            border-radius: 50%;
            background: rgba(255,255,255,.82);
            color: var(--primary);
            cursor: pointer;
            transition: background .18s ease, transform .18s ease;
        }

        .celebration-arrow:hover { background: var(--primary-soft); transform: translateY(-1px); }
        .celebration-position { min-width: 34px; color: var(--muted); font: 700 9px/1 Georgia, serif; text-align: center; }

        .popular-feed {
            margin-top: 16px;
            overflow: hidden;
            border: 1px solid rgba(255, 77, 109, .13);
            border-radius: 22px;
            background: rgba(255, 255, 255, .94);
            box-shadow: 0 18px 42px rgba(115, 55, 72, .11);
        }

        .popular-feed-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 16px 10px;
        }

        .popular-feed-title {
            display: flex;
            align-items: center;
            gap: 7px;
            margin: 0;
            color: #4d3a41;
            font-size: 12px;
            font-weight: 900;
        }

        .popular-live-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: var(--primary);
            box-shadow: 0 0 0 4px rgba(255, 77, 109, .10);
        }

        .popular-feed-caption { color: #aa9ba1; font-size: 8px; font-weight: 700; letter-spacing: .06em; }

        .popular-tabs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            margin: 0 12px 5px;
            padding: 3px;
            border-radius: 11px;
            background: #f8f3f5;
        }

        .popular-tab {
            padding: 7px 5px;
            border: 0;
            border-radius: 8px;
            background: transparent;
            color: #9b8d93;
            cursor: pointer;
            font-size: 10px;
            font-weight: 800;
            transition: background .18s ease, color .18s ease, box-shadow .18s ease;
        }

        .popular-tab.active {
            background: #fff;
            color: var(--primary-dark);
            box-shadow: 0 4px 12px rgba(115, 55, 72, .08);
        }

        .popular-list { margin: 0; padding: 5px 12px 10px; list-style: none; }

        .popular-item {
            display: grid;
            grid-template-columns: 20px minmax(0, 1fr);
            gap: 8px;
            width: 100%;
            padding: 10px 4px;
            border: 0;
            border-bottom: 1px solid #f4eaed;
            background: transparent;
            color: inherit;
            text-align: left;
            cursor: pointer;
        }

        .popular-item:last-child { border-bottom: 0; }
        .popular-item:hover .popular-item-title { color: var(--primary-dark); }

        .popular-rank {
            color: var(--primary);
            font: italic 700 14px/1.3 Georgia, serif;
            text-align: center;
        }

        .popular-item-title {
            display: block;
            overflow: hidden;
            color: #51464a;
            font-size: 10px;
            font-weight: 800;
            line-height: 1.45;
            text-overflow: ellipsis;
            transition: color .18s ease;
            white-space: nowrap;
        }

        .popular-item-meta {
            display: flex;
            gap: 8px;
            margin-top: 4px;
            color: #aa9da2;
            font-size: 8px;
            font-weight: 700;
        }

        .page-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 22px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin: 0 0 19px;
            padding: 0;
            border: 0;
            background: transparent;
            color: var(--muted);
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
            transition: color .18s ease, transform .18s ease;
        }

        .back-button:hover { color: var(--primary); transform: translateX(-2px); }
        .back-button svg { width: 17px; height: 17px; }

        .eyebrow {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: var(--primary);
            font-size: 13px;
            font-weight: 800;
            letter-spacing: .08em;
            text-transform: uppercase;
        }

        .eyebrow::before {
            width: 22px;
            height: 2px;
            border-radius: 99px;
            background: currentColor;
            content: "";
        }

        h1 {
            margin: 0;
            font-size: clamp(30px, 5vw, 44px);
            line-height: 1.12;
            letter-spacing: -.045em;
        }

        .header-copy {
            margin: 10px 0 0;
            color: var(--muted);
            font-size: 15px;
        }

        .user-chip {
            flex: 0 0 auto;
            padding: 10px 14px;
            border: 1px solid rgba(255, 77, 109, .14);
            border-radius: 999px;
            background: rgba(255, 255, 255, .78);
            color: var(--muted);
            font-size: 13px;
            box-shadow: 0 8px 24px rgba(115, 55, 72, .06);
            backdrop-filter: blur(10px);
        }

        .user-chip strong { color: var(--ink); }

        .notification-card {
            overflow: hidden;
            border: 1px solid rgba(255, 77, 109, .13);
            border-radius: 24px;
            background: rgba(255, 255, 255, .93);
            box-shadow: var(--shadow);
            backdrop-filter: blur(12px);
        }

        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 20px 22px;
            border-bottom: 1px solid var(--line);
        }

        .summary {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .bell-box {
            position: relative;
            display: grid;
            width: 42px;
            height: 42px;
            place-items: center;
            border-radius: 13px;
            background: var(--primary-soft);
            color: var(--primary);
        }

        .bell-box svg { width: 21px; height: 21px; }

        .count-badge {
            position: absolute;
            top: -6px;
            right: -7px;
            display: grid;
            min-width: 21px;
            height: 21px;
            padding: 0 5px;
            place-items: center;
            border: 2px solid var(--white);
            border-radius: 999px;
            background: var(--primary);
            color: var(--white);
            font-size: 10px;
            font-weight: 800;
        }

        .summary-title { font-size: 15px; font-weight: 800; }
        .summary-text { margin-top: 3px; color: var(--muted); font-size: 12px; }

        .toolbar-actions { display: flex; align-items: center; gap: 8px; }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 40px;
            padding: 0 14px;
            border: 0;
            border-radius: 11px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 800;
            transition: transform .18s ease, background .18s ease, box-shadow .18s ease;
        }

        .btn:hover { transform: translateY(-1px); }
        .btn:active { transform: translateY(0); }
        .btn:disabled { cursor: not-allowed; opacity: .55; transform: none; }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
            box-shadow: 0 7px 18px rgba(255, 77, 109, .22);
        }

        .btn-primary:hover { background: var(--primary-dark); }
        .btn-ghost { background: var(--primary-soft); color: var(--primary-dark); }
        .btn-ghost:hover { background: #ffe4ea; }
        .btn svg { width: 16px; height: 16px; }

        .filter-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 22px;
            border-bottom: 1px solid var(--line);
            background: #fffdfd;
        }

        .filters { display: flex; gap: 6px; }

        .filter-btn {
            padding: 8px 13px;
            border: 0;
            border-radius: 999px;
            background: transparent;
            color: var(--muted);
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
            transition: color .18s ease, background .18s ease, box-shadow .18s ease, transform .18s ease;
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #ff6f89, var(--primary));
            color: var(--white);
            box-shadow: 0 6px 16px rgba(255, 77, 109, .22);
        }

        .filter-btn:not(.active):hover {
            background: var(--primary-soft);
            color: var(--primary-dark);
            box-shadow: 0 5px 14px rgba(255, 77, 109, .12);
            transform: translateY(-1px);
        }

        .list-status { color: var(--muted); font-size: 12px; }

        .notification-list { min-height: 250px; }

        .notification-page-item {
            position: relative;
            display: grid;
            grid-template-columns: 44px minmax(0, 1fr) auto;
            gap: 14px;
            align-items: start;
            width: 100%;
            padding: 19px 22px;
            border: 0;
            border-bottom: 1px solid var(--line);
            background: var(--white);
            color: inherit;
            text-align: left;
            cursor: pointer;
            transition: background .18s ease;
        }

        .notification-page-item:last-child { border-bottom: 0; }
        .notification-page-item:hover { background: #fff9fa; }
        .notification-page-item.unread { background: linear-gradient(90deg, #fff4f6 0, #fff 44%); }
        .notification-page-item.unread:hover { background: #fff4f6; }

        .notification-page-item.unread::before {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            width: 3px;
            background: var(--primary);
            content: "";
        }

        .type-icon {
            display: grid;
            width: 44px;
            height: 44px;
            place-items: center;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 20px;
        }

        .notification-page-item:not(.unread) .type-icon {
            background: #edf8f1;
            color: var(--success);
            font-weight: 900;
        }

        .item-head { display: flex; align-items: center; gap: 8px; margin: 1px 0 5px; }
        .item-type { font-size: 12px; font-weight: 800; color: var(--primary-dark); }

        .new-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--primary);
            box-shadow: 0 0 0 4px rgba(255, 77, 109, .10);
        }

        .notification-page-content {
            margin: 0;
            color: #453e42;
            font-size: 14px;
            line-height: 1.58;
            word-break: keep-all;
        }

        .notification-meta { margin-top: 7px; color: #a0959a; font-size: 11px; }

        .read-label {
            align-self: center;
            padding: 6px 9px;
            border-radius: 999px;
            background: #f6f3f4;
            color: #9d9297;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .notification-page-item.unread .read-label { background: var(--primary-soft); color: var(--primary); }

        .state-view {
            display: grid;
            min-height: 320px;
            padding: 44px 20px;
            place-items: center;
            text-align: center;
        }

        .state-icon {
            display: grid;
            width: 68px;
            height: 68px;
            margin: 0 auto 16px;
            place-items: center;
            border-radius: 22px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 29px;
        }

        .state-title { margin: 0 0 7px; font-size: 16px; }
        .state-copy { margin: 0; color: var(--muted); font-size: 13px; line-height: 1.6; }

        .loading-dots { display: flex; justify-content: center; gap: 6px; }
        .loading-dots span {
            width: 8px; height: 8px; border-radius: 50%; background: var(--primary);
            animation: bounce 1s infinite ease-in-out;
        }
        .loading-dots span:nth-child(2) { animation-delay: .12s; }
        .loading-dots span:nth-child(3) { animation-delay: .24s; }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); opacity: .4; }
            50% { transform: translateY(-6px); opacity: 1; }
        }

        .developer-panel { margin-top: 16px; }
        .developer-panel details {
            overflow: hidden;
            border: 1px solid rgba(255, 77, 109, .12);
            border-radius: 14px;
            background: rgba(255, 255, 255, .72);
        }
        .developer-panel summary {
            padding: 13px 16px;
            color: var(--muted);
            cursor: pointer;
            font-size: 12px;
            font-weight: 700;
        }
        .response-box {
            max-height: 260px;
            margin: 0;
            padding: 16px;
            overflow: auto;
            border-top: 1px solid var(--line);
            background: #2d282b;
            color: #d7f6de;
            font: 12px/1.6 Consolas, monospace;
            white-space: pre-wrap;
            word-break: break-all;
        }
        .response-box.error { color: #ffb3be; }

        .brand-message {
            position: relative;
            margin: 0 auto 36px;
            padding: 6px 28px 0;
            text-align: center;
        }

        .brand-message::before {
            display: block;
            width: 54px;
            height: 1px;
            margin: 0 auto 26px;
            background: linear-gradient(90deg, transparent, var(--primary), transparent);
            content: "";
        }

        .brand-slogan {
            margin: 0;
            color: #5a424b;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(26px, 4vw, 38px);
            font-style: italic;
            font-weight: 400;
            letter-spacing: -.025em;
        }

        .brand-slogan .accent { color: var(--primary); }

        .brand-copy {
            max-width: 560px;
            margin: 14px auto 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.8;
            word-break: keep-all;
        }

        .brand-signature {
            margin-top: 17px;
            color: var(--primary);
            font: 700 11px/1 Georgia, serif;
            letter-spacing: .2em;
        }

        .toast {
            position: fixed;
            top: 50%;
            left: 50%;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 230px;
            height: 205px;
            padding: 38px 35px 25px;
            background: linear-gradient(145deg, #ff6f89, var(--primary));
            color: var(--white);
            clip-path: polygon(
                50% 96%, 40% 86%, 18% 65%, 8% 52%, 3% 39%,
                4% 25%, 11% 13%, 22% 6%, 35% 6%, 44% 11%,
                50% 19%, 56% 11%, 65% 6%, 78% 6%, 89% 13%,
                96% 25%, 97% 39%, 92% 52%, 82% 65%, 60% 86%
            );
            filter: drop-shadow(0 16px 22px rgba(255, 77, 109, .32));
            font-size: 15px;
            font-weight: 800;
            line-height: 1.55;
            opacity: 0;
            pointer-events: none;
            text-align: center;
            transform: translate(-50%, -44%) scale(.78);
            transition: opacity .22s ease, transform .28s cubic-bezier(.2, .8, .2, 1);
        }
        .toast.show { opacity: 1; transform: translate(-50%, -50%) scale(1); }

        .page-header {
            animation: pageFadeUp .72s cubic-bezier(.2, .75, .25, 1) both;
        }

        .notification-card {
            animation: pageFadeUp .78s .11s cubic-bezier(.2, .75, .25, 1) both;
        }

        .developer-panel {
            animation: pageFadeUp .72s .2s cubic-bezier(.2, .75, .25, 1) both;
        }

        .brand-message {
            animation: pageFadeUp .76s .26s cubic-bezier(.2, .75, .25, 1) both;
        }

        .side-visual--left {
            animation: sideFadeLeft .9s .2s cubic-bezier(.2, .75, .25, 1) both;
        }

        .product-ad-rail {
            animation: productAdFadeUp .82s .34s cubic-bezier(.2, .75, .25, 1) both;
        }

        .wedding-celebration-rail {
            animation: sideFadeRight .9s .28s cubic-bezier(.2, .75, .25, 1) both;
        }

        @keyframes pageFadeUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes sideFadeLeft {
            from { opacity: 0; transform: translate(-16px, -47%) scale(.97); }
            to { opacity: 1; transform: translate(0, -50%) scale(1); }
        }

        @keyframes sideFadeRight {
            from { opacity: 0; transform: translate(16px, -47%) scale(.97); }
            to { opacity: 1; transform: translate(0, -50%) scale(1); }
        }

        @keyframes productAdFadeUp {
            from { opacity: 0; transform: translateY(14px) scale(.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        @media (max-width: 680px) {
            .page-shell { width: min(100% - 20px, 960px); padding: 34px 0 50px; }
            .page-header { align-items: flex-start; flex-direction: column; gap: 14px; }
            .toolbar { align-items: flex-start; flex-direction: column; padding: 18px; }
            .toolbar-actions { width: 100%; }
            .toolbar-actions .btn { flex: 1; }
            .filter-row { padding: 12px 18px; }
            .notification-page-item { grid-template-columns: 40px minmax(0, 1fr); padding: 17px 18px; }
            .type-icon { width: 40px; height: 40px; border-radius: 13px; }
            .read-label { display: none; }
            .toast { width: 205px; height: 183px; padding: 34px 30px 22px; font-size: 14px; }
            .brand-message { margin-top: 34px; padding-right: 12px; padding-left: 12px; }
            .brand-copy br { display: none; }
        }

        @media (min-width: 1380px) {
            .side-visual { display: block; }
            .product-ad-rail { display: block; }
            .wedding-celebration-rail { display: block; }
        }

        @media (prefers-reduced-motion: reduce) {
            .page-header,
            .notification-card,
            .developer-panel,
            .brand-message,
            .side-visual--left,
            .product-ad-rail,
            .wedding-celebration-rail {
                animation: none;
            }

            *, *::before, *::after {
                scroll-behavior: auto !important;
                transition-duration: .01ms !important;
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
            }
        }
    </style>
</head>
<body class="${sessionScope.sessionRole eq 'ADMIN' ? 'admin-notification-page' : ''}">
<jsp:include page="/WEB-INF/common/header.jsp" />
<div id="app" v-cloak
    data-api-base="${pageContext.request.contextPath}/api/notification"
    data-context-path="${pageContext.request.contextPath}">
<!-- 영상 파일 경로: /video/wedding-side.mp4
     선택 사항인 첫 화면 이미지: /images/wedding-video-cover.jpg -->
<aside class="side-visual side-visual--left" aria-hidden="true">
    <video class="side-video"
           id="weddingSideVideo"
           data-src="${pageContext.request.contextPath}/img/weddinggirlmovie.mp4"
           data-poster="${pageContext.request.contextPath}/img/weddingPic.png"
           autoplay muted loop playsinline preload="none"></video>
    <span class="video-ornament video-ornament--top">MARRYVIEW FILM</span>
    <span class="video-ornament video-ornament--bottom">
        <span class="video-ornament-title">Our beautiful days</span>
        <span class="video-ornament-copy">MARRY DAY, MERRY DAYS</span>
    </span>
</aside>
<aside class="product-ad-rail" aria-label="메리뷰 입점 업체 추천 상품">
    <article class="product-ad-card">
        <div class="product-ad-topline">
            <span class="product-ad-label">MARRYVIEW PICK</span>
            <span class="product-ad-number">{{ productAdNumber }}</span>
        </div>
        <div class="product-ad-body">
            <div class="product-ad-visual" :class="currentProductAd.tone" aria-hidden="true">{{ currentProductAd.symbol }}</div>
            <div>
                <div class="product-ad-company">{{ currentProductAd.company }}</div>
                <h2 class="product-ad-name">{{ currentProductAd.name }}</h2>
                <div class="product-ad-price">
                    <span class="product-ad-discount">{{ currentProductAd.discount }}</span>
                    <span class="product-ad-amount">{{ currentProductAd.amount }}</span>
                </div>
            </div>
        </div>
        <div class="product-ad-bottom">
            <div class="product-ad-dots" aria-hidden="true">
                <span v-for="(_, index) in productAds" :key="index" class="product-ad-dot" :class="{ active: index === productAdIndex }"></span>
            </div>
            <div class="product-ad-actions">
                <button type="button" class="product-ad-arrow" @click="moveProductAd(-1)" aria-label="이전 추천 상품">‹</button>
                <button type="button" class="product-ad-arrow" @click="moveProductAd(1)" aria-label="다음 추천 상품">›</button>
                <button type="button" class="product-ad-link" @click="showToast('상품 상세 연결은 API 연동 시 추가됩니다.')">보러가기</button>
            </div>
        </div>
    </article>
</aside>
<aside class="wedding-celebration-rail" aria-label="메리뷰 회원 결혼 소식">
    <article class="celebration-card">
        <div class="celebration-topline">
            <span class="celebration-label">MARRYVIEW WEDDING</span>
            <span class="celebration-dday">{{ currentWeddingNews.dday }}</span>
        </div>
        <div class="celebration-rings" aria-hidden="true"><span></span><span></span></div>
        <p class="celebration-kicker">{{ currentWeddingNews.kicker }}</p>
        <h2 class="celebration-names">{{ currentWeddingNews.names }}</h2>
        <div class="celebration-date">{{ currentWeddingNews.date }}</div>
        <div class="celebration-divider" aria-hidden="true">♥</div>
        <p class="celebration-message">{{ currentWeddingNews.message }}</p>
        <div class="celebration-bottom" :class="{ 'is-mine': currentWeddingNews.isMine }">{{ currentWeddingNews.bottom }}</div>
    </article>
    <div class="celebration-nav" aria-label="결혼 소식 이동">
        <button type="button" class="celebration-arrow" @click="moveCelebration(-1)" aria-label="이전 결혼 소식">‹</button>
        <span class="celebration-position">{{ celebrationIndex + 1 }} / {{ weddingNews.length }}</span>
        <button type="button" class="celebration-arrow" @click="moveCelebration(1)" aria-label="다음 결혼 소식">›</button>
    </div>

    <section class="popular-feed" aria-labelledby="popularFeedTitle">
        <div class="popular-feed-head">
            <h2 class="popular-feed-title" id="popularFeedTitle">
                <span class="popular-live-dot" aria-hidden="true"></span>
                지금 인기 있어요
            </h2>
            <span class="popular-feed-caption">LIVE PICK</span>
        </div>
        <div class="popular-tabs" role="tablist" aria-label="인기 콘텐츠 종류">
            <button type="button" class="popular-tab" :class="{ active: popularType === 'post' }" @click="popularType = 'post'" role="tab" :aria-selected="popularType === 'post'">인기글</button>
            <button type="button" class="popular-tab" :class="{ active: popularType === 'review' }" @click="popularType = 'review'" role="tab" :aria-selected="popularType === 'review'">인기리뷰</button>
        </div>
        <ol class="popular-list">
            <li v-for="(item, index) in currentPopularItems" :key="item.title">
                <button type="button" class="popular-item" @click="showToast('상세 페이지 연결은 API 연동 시 추가됩니다.')" :aria-label="(index + 1) + '위 ' + item.title">
                    <span class="popular-rank">{{ index + 1 }}</span>
                    <span>
                        <span class="popular-item-title">{{ item.title }}</span>
                        <span class="popular-item-meta"><span>조회 {{ item.views }}</span><span>♥ {{ item.likes }}</span></span>
                    </span>
                </button>
            </li>
        </ol>
    </section>
</aside>

<main class="page-shell">
    <section class="brand-message" aria-label="메리뷰 브랜드 메시지">
        <p class="brand-slogan">Marry Day, <span class="accent">Merry Days.</span></p>
        <p class="brand-copy">
            결혼하는 오늘부터 함께 살아갈 모든 날까지.<br>
            메리뷰가 당신의 행복한 나날과 함께합니다.
        </p>
        <div class="brand-signature">MARRYVIEW</div>
    </section>

    <header class="page-header">
        <div>
            <button type="button" class="back-button" @click="goBack" aria-label="이전 페이지로 돌아가기">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 12H5M11 18l-6-6 6-6"/>
                </svg>
                이전으로
            </button>
            <div class="eyebrow">MarryView</div>
            <h1>알림</h1>
            <p class="header-copy">새로운 소식과 중요한 안내를 한곳에서 확인하세요.</p>
        </div>
        <div class="user-chip">로그인 계정&nbsp; <strong>${sessionScope.sessionId}</strong></div>
    </header>

    <section class="notification-card" aria-labelledby="notificationHeading">
        <div class="toolbar">
            <div class="summary">
                <div class="bell-box" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9"/>
                        <path d="M10 21h4"/>
                    </svg>
                    <span class="count-badge">{{ unreadBadge }}</span>
                </div>
                <div>
                    <div class="summary-title" id="notificationHeading">내 알림</div>
                    <div class="summary-text">{{ summaryText }}</div>
                </div>
            </div>

            <div class="toolbar-actions">
                <button type="button" class="btn btn-ghost" @click="refreshAll(true)" :disabled="refreshing">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 11a8 8 0 1 0-2.3 5.7"/><path d="M20 4v7h-7"/>
                    </svg>
                    새로고침
                </button>
                <button type="button" class="btn btn-primary" @click="readAll" :disabled="refreshing || unreadCount === 0">모두 읽음</button>
            </div>
        </div>

        <div class="filter-row">
            <div class="filters" role="tablist" aria-label="알림 필터">
                <button v-for="filter in filters" :key="filter.value" type="button" class="filter-btn"
                    :class="{ active: currentFilter === filter.value }" @click="currentFilter = filter.value"
                    role="tab" :aria-selected="currentFilter === filter.value">{{ filter.label }}</button>
            </div>
            <span class="list-status">{{ filteredNotifications.length }}개의 알림</span>
        </div>

        <div class="notification-list" aria-live="polite">
            <div v-if="loading" class="state-view">
                <div>
                    <div class="loading-dots" aria-label="알림 불러오는 중"><span></span><span></span><span></span></div>
                </div>
            </div>
            <div v-else-if="errorMessage" class="state-view">
                <div><div class="state-icon">⚠</div><h3 class="state-title">알림을 불러오지 못했어요</h3><p class="state-copy">{{ errorMessage }}</p></div>
            </div>
            <div v-else-if="filteredNotifications.length === 0" class="state-view">
                <div><div class="state-icon">{{ emptyState.icon }}</div><h3 class="state-title">{{ emptyState.title }}</h3><p class="state-copy">{{ emptyState.copy }}</p></div>
            </div>
            <template v-else>
                <button v-for="item in filteredNotifications" :key="item.notificationNo" type="button"
                    class="notification-page-item" :class="{ unread: item.isRead === 'N' }" @click="readNotification(item)"
                    :aria-label="(item.isRead === 'N' ? '읽지 않은 알림: ' : '') + (item.content || '알림 내용 없음')">
                    <span class="type-icon" aria-hidden="true">{{ item.isRead === 'N' ? typeIcon(item.notificationType) : '✓' }}</span>
                    <span>
                        <span class="item-head"><span class="item-type">{{ typeLabel(item.notificationType) }}</span><span v-if="item.isRead === 'N'" class="new-dot" aria-label="새 알림"></span></span>
                        <p class="notification-page-content">{{ item.content || '알림 내용이 없습니다.' }}</p>
                        <span class="notification-meta">{{ formatDate(item.createdAt) }}</span>
                    </span>
                    <span class="read-label">{{ item.isRead === 'N' ? '읽음 처리' : '확인함' }}</span>
                </button>
            </template>
        </div>
    </section>

    <c:if test="${sessionScope.sessionRole eq 'ADMIN' or sessionScope.sessionRole eq '관리자'}">
        <aside class="developer-panel">
            <details>
                <summary>개발자용 API 응답 보기</summary>
                <pre class="response-box" :class="{ error: responseIsError }">{{ responseText }}</pre>
            </details>
        </aside>
    </c:if>

</main>

<div class="toast" :class="{ show: toastVisible }" role="status" aria-live="polite">{{ toastMessage }}</div>
</div>
<script src="${pageContext.request.contextPath}/js/common/notification-page.js"></script>
</body>
</html>
