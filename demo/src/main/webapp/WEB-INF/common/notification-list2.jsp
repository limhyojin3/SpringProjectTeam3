<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 | MarryView</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

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
        }

        * { box-sizing: border-box; }

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

        button:focus-visible, select:focus-visible, .notification-item:focus-visible {
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
            left: calc(50% - 480px - var(--side-width) - 14px);
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

        .wedding-celebration-rail {
            position: fixed;
            top: 50%;
            right: calc(50% - 480px - var(--side-width) - 14px);
            z-index: 0;
            display: none;
            width: var(--side-width);
            transform: translateY(-50%);
        }

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

        .notification-item {
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

        .notification-item:last-child { border-bottom: 0; }
        .notification-item:hover { background: #fff9fa; }
        .notification-item.unread { background: linear-gradient(90deg, #fff4f6 0, #fff 44%); }
        .notification-item.unread:hover { background: #fff4f6; }

        .notification-item.unread::before {
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

        .notification-item:not(.unread) .type-icon {
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

        .notification-content {
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

        .notification-item.unread .read-label { background: var(--primary-soft); color: var(--primary); }

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
            margin: 48px auto 0;
            padding: 34px 28px 6px;
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

        .header-notification-demo {
            margin-top: 34px;
            padding: 22px;
            border: 1px dashed rgba(255, 77, 109, .24);
            border-radius: 18px;
            background: rgba(255, 255, 255, .58);
        }

        .demo-label {
            margin-bottom: 14px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
        }

        .demo-header-bar {
            display: flex;
            min-height: 64px;
            align-items: center;
            justify-content: flex-end;
            padding: 0 20px;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 9px 28px rgba(115, 55, 72, .09);
        }

        .demo-notification-wrap { position: relative; list-style: none; }

        .demo-notification-wrap::after {
            position: absolute;
            top: 100%;
            right: 0;
            z-index: 4;
            width: 100%;
            height: 8px;
            content: "";
        }

        .demo-notification-btn {
            position: relative;
            display: grid;
            width: 42px;
            height: 42px;
            place-items: center;
            border: 0;
            border-radius: 50%;
            background: var(--primary-soft);
            color: var(--primary);
            cursor: pointer;
            transition: background .18s ease, transform .18s ease;
        }

        .demo-notification-btn:hover { background: #ffe1e8; transform: translateY(-1px); }
        .demo-notification-btn svg { width: 20px; height: 20px; }

        .demo-badge {
            position: absolute;
            top: -4px;
            right: -5px;
            display: grid;
            min-width: 19px;
            height: 19px;
            padding: 0 4px;
            place-items: center;
            border: 2px solid #fff;
            border-radius: 99px;
            background: var(--primary);
            color: #fff;
            font-size: 9px;
            font-weight: 800;
        }

        .demo-notification-dropdown {
            position: absolute;
            top: calc(100% + 4px);
            right: 0;
            z-index: 5;
            width: min(360px, calc(100vw - 52px));
            overflow: hidden;
            border: 1px solid var(--line);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 20px 55px rgba(74, 39, 49, .18);
            opacity: 0;
            pointer-events: none;
            transform: translateY(-7px);
            transition: opacity .18s ease, transform .18s ease;
        }

        .demo-notification-wrap:hover .demo-notification-dropdown,
        .demo-notification-wrap:focus-within .demo-notification-dropdown,
        .demo-notification-wrap.open .demo-notification-dropdown {
            opacity: 1;
            pointer-events: auto;
            transform: translateY(0);
        }

        .demo-dropdown-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 17px;
            border-bottom: 1px solid var(--line);
        }

        .demo-dropdown-title { font-size: 15px; font-weight: 800; }

        .demo-read-all {
            padding: 5px;
            border: 0;
            background: transparent;
            color: var(--primary);
            cursor: pointer;
            font-size: 11px;
            font-weight: 800;
        }

        .demo-dropdown-list { max-height: 310px; overflow-y: auto; }

        .demo-dropdown-item {
            display: block;
            width: 100%;
            padding: 14px 17px;
            border: 0;
            border-bottom: 1px solid var(--line);
            background: #fff;
            color: inherit;
            text-align: left;
            cursor: pointer;
        }

        .demo-dropdown-item:hover { background: #fff7f9; }
        .demo-dropdown-item.unread { background: #fff1f4; }
        .demo-dropdown-item.unread:hover { background: #ffe8ed; }
        .demo-item-content { overflow: hidden; font-size: 13px; line-height: 1.5; text-overflow: ellipsis; white-space: nowrap; }
        .demo-item-date { margin-top: 5px; color: #a0959a; font-size: 10px; }
        .demo-empty { padding: 36px 15px; color: var(--muted); font-size: 12px; text-align: center; }

        .demo-dropdown-footer a {
            display: block;
            padding: 13px;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 800;
            text-align: center;
            text-decoration: none;
        }

        .demo-dropdown-footer a:hover { background: var(--primary-soft); }

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

        .header-notification-demo {
            animation: pageFadeUp .76s .34s cubic-bezier(.2, .75, .25, 1) both;
        }

        .side-visual--left {
            animation: sideFadeLeft .9s .2s cubic-bezier(.2, .75, .25, 1) both;
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

        @media (max-width: 680px) {
            .page-shell { width: min(100% - 20px, 960px); padding: 34px 0 50px; }
            .page-header { align-items: flex-start; flex-direction: column; gap: 14px; }
            .toolbar { align-items: flex-start; flex-direction: column; padding: 18px; }
            .toolbar-actions { width: 100%; }
            .toolbar-actions .btn { flex: 1; }
            .filter-row { padding: 12px 18px; }
            .notification-item { grid-template-columns: 40px minmax(0, 1fr); padding: 17px 18px; }
            .type-icon { width: 40px; height: 40px; border-radius: 13px; }
            .read-label { display: none; }
            .toast { width: 205px; height: 183px; padding: 34px 30px 22px; font-size: 14px; }
            .brand-message { margin-top: 34px; padding-right: 12px; padding-left: 12px; }
            .brand-copy br { display: none; }
            .header-notification-demo { padding: 14px; }
            .demo-header-bar { padding: 0 14px; }
        }

        @media (min-width: 1380px) {
            .side-visual { display: block; }
            .wedding-celebration-rail { display: block; }
        }

        @media (prefers-reduced-motion: reduce) {
            .page-header,
            .notification-card,
            .developer-panel,
            .brand-message,
            .header-notification-demo,
            .side-visual--left,
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
<body>
<aside class="side-visual side-visual--left" aria-hidden="true">
    <video class="side-video"
           id="weddingSideVideo"
           data-src="${pageContext.request.contextPath}/img/weddinggirlmovie.mp4"
           data-poster="${pageContext.request.contextPath}/images/wedding-video-cover.jpg"
           autoplay muted loop playsinline preload="none"></video>
    <span class="video-ornament video-ornament--top">MARRYVIEW FILM</span>
    <span class="video-ornament video-ornament--bottom">
        <span class="video-ornament-title">Our beautiful days</span>
        <span class="video-ornament-copy">MARRY DAY, MERRY DAYS</span>
    </span>
</aside>
<aside class="wedding-celebration-rail" aria-label="메리뷰 회원 결혼 소식">
    <article class="celebration-card">
        <div class="celebration-topline">
            <span class="celebration-label">MARRYVIEW WEDDING</span>
            <span class="celebration-dday" id="celebrationDday">D-DAY</span>
        </div>
        <div class="celebration-rings" aria-hidden="true"><span></span><span></span></div>
        <p class="celebration-kicker" id="celebrationKicker">오늘의 결혼 소식</p>
        <h2 class="celebration-names" id="celebrationNames"></h2>
        <div class="celebration-date" id="celebrationDate"></div>
        <div class="celebration-divider" aria-hidden="true">♥</div>
        <p class="celebration-message" id="celebrationMessage"></p>
        <div class="celebration-bottom" id="celebrationBottom"></div>
    </article>
    <div class="celebration-nav" aria-label="결혼 소식 이동">
        <button type="button" class="celebration-arrow" id="celebrationPrev" aria-label="이전 결혼 소식">‹</button>
        <span class="celebration-position" id="celebrationPosition">1 / 2</span>
        <button type="button" class="celebration-arrow" id="celebrationNext" aria-label="다음 결혼 소식">›</button>
    </div>
</aside>

<main class="page-shell">
    <header class="page-header">
        <div>
            <button type="button" class="back-button" id="btnBack" aria-label="이전 페이지로 돌아가기">
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
                    <span class="count-badge" id="unreadCount">0</span>
                </div>
                <div>
                    <div class="summary-title" id="notificationHeading">내 알림</div>
                    <div class="summary-text" id="summaryText">알림을 불러오는 중입니다.</div>
                </div>
            </div>

            <div class="toolbar-actions">
                <button type="button" class="btn btn-ghost" id="btnRefresh">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 11a8 8 0 1 0-2.3 5.7"/><path d="M20 4v7h-7"/>
                    </svg>
                    새로고침
                </button>
                <button type="button" class="btn btn-primary" id="btnReadAll">모두 읽음</button>
            </div>
        </div>

        <div class="filter-row">
            <div class="filters" role="tablist" aria-label="알림 필터">
                <button type="button" class="filter-btn active" data-filter="all" role="tab" aria-selected="true">전체</button>
                <button type="button" class="filter-btn" data-filter="unread" role="tab" aria-selected="false">읽지 않음</button>
                <button type="button" class="filter-btn" data-filter="read" role="tab" aria-selected="false">읽음</button>
            </div>
            <span class="list-status" id="listStatus"></span>
        </div>

        <div class="notification-list" id="notificationList" aria-live="polite">
            <div class="state-view">
                <div>
                    <div class="loading-dots" aria-label="알림 불러오는 중"><span></span><span></span><span></span></div>
                </div>
            </div>
        </div>
    </section>

    <c:if test="${sessionScope.sessionRole eq 'ADMIN' or sessionScope.sessionRole eq '관리자'}">
        <aside class="developer-panel">
            <details>
                <summary>개발자용 API 응답 보기</summary>
                <pre class="response-box" id="responseBox">아직 응답이 없습니다.</pre>
            </details>
        </aside>
    </c:if>

    <section class="brand-message" aria-label="메리뷰 브랜드 메시지">
        <p class="brand-slogan">Marry Day, <span class="accent">Merry Days.</span></p>
        <p class="brand-copy">
            결혼하는 오늘부터 함께 살아갈 모든 날까지.<br>
            메리뷰가 당신의 행복한 나날과 함께합니다.
        </p>
        <div class="brand-signature">MARRYVIEW</div>
    </section>

    <c:if test="${not empty sessionScope.sessionId}">
        <section class="header-notification-demo" aria-label="헤더 알림 메뉴 테스트">
            <div class="demo-label">헤더 알림 메뉴 테스트 · 종 아이콘에 마우스를 올려보세요</div>
            <div class="demo-header-bar">
                <div class="demo-notification-wrap" id="demoNotificationWrap">
                    <button type="button" class="demo-notification-btn" id="demoNotificationBtn" aria-label="알림 메뉴 열기" aria-expanded="false">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                            <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9"/>
                            <path d="M10 21h4"/>
                        </svg>
                        <span class="demo-badge" id="demoUnreadCount">0</span>
                    </button>

                    <div class="demo-notification-dropdown">
                        <div class="demo-dropdown-head">
                            <span class="demo-dropdown-title">알림</span>
                            <button type="button" class="demo-read-all" id="demoReadAll">모두 읽음</button>
                        </div>
                        <div class="demo-dropdown-list" id="demoDropdownList"></div>
                        <div class="demo-dropdown-footer">
                            <a href="${pageContext.request.contextPath}/api/notification/list.do">전체보기</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </c:if>
</main>

<div class="toast" id="toast" role="status" aria-live="polite"></div>
<script>
$(function () {
    const apiBase = '${pageContext.request.contextPath}/api/notification';
    const $responseBox = $('#responseBox');
    const $notificationList = $('#notificationList');
    let notifications = [];
    let currentFilter = 'all';
    let toastTimer;
    let celebrationIndex = 0;

    // 프론트 화면 확인용 임시 데이터입니다. 추후 API 응답으로 교체하면 됩니다.
    const weddingNews = [
        {
            isMine: true,
            names: '민준 & 서연',
            date: '2026. 06. 27 · SAT',
            dday: 'D-8',
            kicker: '우리의 결혼식',
            message: '두 사람이 함께 그려온 소중한 약속이 곧 아름다운 시작을 맞이합니다.',
            bottom: '메리뷰가 두 분의 결혼을 진심으로 축하해요!'
        },
        {
            isMine: false,
            names: '지훈 & 하은',
            date: '2026. 07. 04 · SAT',
            dday: 'D-15',
            kicker: '메리뷰 회원의 결혼 소식',
            message: '두 사람의 새로운 계절이 사랑과 행복으로 오래도록 빛나기를 바랍니다.',
            bottom: '두 분의 아름다운 시작을 함께 축하해 주세요.'
        },
        {
            isMine: false,
            names: '도윤 & 수아',
            date: '2026. 07. 11 · SAT',
            dday: 'D-22',
            kicker: '메리뷰 회원의 결혼 소식',
            message: '서로의 가장 좋은 친구가 된 두 사람이 이제 평생의 동반자가 됩니다.',
            bottom: '따뜻한 축하의 마음을 함께 전해 주세요.'
        }
    ];

    function showResponse(data) {
        if (!$responseBox.length) return;
        $responseBox.removeClass('error').text(JSON.stringify(data, null, 2));
    }

    function showToast(message) {
        clearTimeout(toastTimer);
        $('#toast').text(message).addClass('show');
        toastTimer = setTimeout(function () { $('#toast').removeClass('show'); }, 2200);
    }

    function renderCelebration() {
        const item = weddingNews[celebrationIndex];
        if (!item || !$('#celebrationNames').length) return;

        $('#celebrationDday').text(item.dday);
        $('#celebrationKicker').text(item.kicker);
        $('#celebrationNames').text(item.names);
        $('#celebrationDate').text(item.date);
        $('#celebrationMessage').text(item.message);
        $('#celebrationBottom').text(item.bottom).toggleClass('is-mine', item.isMine);
        $('#celebrationPosition').text((celebrationIndex + 1) + ' / ' + weddingNews.length);
    }

    function setupSideVideo() {
        const video = document.getElementById('weddingSideVideo');
        if (!video) return;

        const desktopScreen = window.matchMedia('(min-width: 1380px)');

        function syncVideo(event) {
            if (event.matches) {
                if (!video.getAttribute('poster')) video.setAttribute('poster', video.dataset.poster);
                if (!video.getAttribute('src')) {
                    video.setAttribute('src', video.dataset.src);
                    video.load();
                }
                const playPromise = video.play();
                if (playPromise) playPromise.catch(function () {});
            } else {
                video.pause();
                video.removeAttribute('src');
                video.removeAttribute('poster');
                video.load();
            }
        }

        syncVideo(desktopScreen);
        if (desktopScreen.addEventListener) {
            desktopScreen.addEventListener('change', syncVideo);
        } else {
            desktopScreen.addListener(syncVideo);
        }
    }

    function showError(xhr) {
        const message = xhr.responseJSON && xhr.responseJSON.message
            ? xhr.responseJSON.message
            : (xhr.responseText || '잠시 후 다시 시도해 주세요.');

        if ($responseBox.length) {
            $responseBox.addClass('error').text('HTTP 상태: ' + xhr.status + '\n' + message);
        }
        renderState('⚠', '알림을 불러오지 못했어요', '네트워크 상태를 확인한 뒤 새로고침해 주세요.');
    }

    function request(path, data) {
        return $.ajax({
            url: apiBase + path,
            type: 'POST',
            dataType: 'json',
            data: data || {}
        }).done(showResponse).fail(showError);
    }

    function renderState(icon, title, copy) {
        $notificationList.empty().append(
            $('<div>').addClass('state-view').append(
                $('<div>').append(
                    $('<div>').addClass('state-icon').text(icon),
                    $('<h3>').addClass('state-title').text(title),
                    $('<p>').addClass('state-copy').text(copy)
                )
            )
        );
    }

    function typeLabel(type) {
        const labels = {
            MATCH: '매칭', MESSAGE: '메시지', REVIEW: '후기',
            SYSTEM: '안내', RESERVATION: '예약', PAYMENT: '결제'
        };
        return labels[type] || type || '새 소식';
    }

    function typeIcon(type) {
        const icons = {
            MATCH: '♥', MESSAGE: '✉', REVIEW: '★',
            SYSTEM: 'i', RESERVATION: '✓', PAYMENT: '₩'
        };
        return icons[type] || '♥';
    }

    function formatDate(value) {
        if (!value) return '';
        const date = new Date(String(value).replace(' ', 'T'));
        if (isNaN(date.getTime())) return value;

        const diff = Date.now() - date.getTime();
        const minute = 60 * 1000;
        const hour = 60 * minute;
        const day = 24 * hour;

        if (diff < minute) return '방금 전';
        if (diff < hour) return Math.floor(diff / minute) + '분 전';
        if (diff < day) return Math.floor(diff / hour) + '시간 전';
        if (diff < 7 * day) return Math.floor(diff / day) + '일 전';

        return new Intl.DateTimeFormat('ko-KR', {
            year: 'numeric', month: 'short', day: 'numeric'
        }).format(date);
    }

    function updateSummary(unreadCount) {
        const count = Number(unreadCount) || 0;
        $('#unreadCount').text(count > 99 ? '99+' : count);
        $('#demoUnreadCount').text(count > 99 ? '99+' : count).toggle(count > 0);
        $('#summaryText').text(count ? '읽지 않은 알림이 ' + count + '개 있어요.' : '새로운 알림을 모두 확인했어요.');
        $('#btnReadAll').prop('disabled', count === 0);
    }

    function renderHeaderDropdown() {
        const $list = $('#demoDropdownList');
        if (!$list.length) return;

        $list.empty();
        const previewItems = notifications.slice(0, 5);

        if (!previewItems.length) {
            $list.append($('<div>').addClass('demo-empty').text('새로운 알림이 없습니다.'));
            return;
        }

        previewItems.forEach(function (item) {
            $list.append(
                $('<button>', {
                    type: 'button',
                    class: 'demo-dropdown-item' + (item.isRead === 'N' ? ' unread' : ''),
                    'data-notification-no': item.notificationNo
                }).append(
                    $('<div>').addClass('demo-item-content').text(item.content || '알림 내용이 없습니다.'),
                    $('<div>').addClass('demo-item-date').text(formatDate(item.createdAt))
                )
            );
        });
    }

    function renderList() {
        renderHeaderDropdown();
        const filtered = notifications.filter(function (item) {
            if (currentFilter === 'unread') return item.isRead === 'N';
            if (currentFilter === 'read') return item.isRead === 'Y';
            return true;
        });

        $notificationList.empty();
        $('#listStatus').text(filtered.length + '개의 알림');

        if (!filtered.length) {
            if (currentFilter === 'unread') {
                renderState('✓', '모두 확인했어요', '읽지 않은 알림이 없습니다.');
            } else if (currentFilter === 'read') {
                renderState('✓', '확인한 알림이 없어요', '알림을 읽으면 이곳에서 다시 확인할 수 있어요.');
            } else {
                renderState('♡', '아직 알림이 없어요', '새로운 소식이 생기면 이곳에 알려드릴게요.');
            }
            return;
        }

        filtered.forEach(function (item) {
            const unread = item.isRead === 'N';
            const $button = $('<button>', {
                type: 'button',
                class: 'notification-item' + (unread ? ' unread' : ''),
                'data-notification-no': item.notificationNo,
                'aria-label': (unread ? '읽지 않은 알림: ' : '') + (item.content || '알림 내용 없음')
            });

            const $icon = $('<span>')
                .addClass('type-icon')
                .attr('aria-hidden', 'true')
                .text(unread ? typeIcon(item.notificationType) : '✓');
            const $body = $('<span>');
            const $head = $('<span>').addClass('item-head').append(
                $('<span>').addClass('item-type').text(typeLabel(item.notificationType))
            );

            if (unread) $head.append($('<span>').addClass('new-dot').attr('aria-label', '새 알림'));

            $body.append(
                $head,
                $('<p>').addClass('notification-content').text(item.content || '알림 내용이 없습니다.'),
                $('<span>').addClass('notification-meta').text(formatDate(item.createdAt))
            );

            $button.append(
                $icon,
                $body,
                $('<span>').addClass('read-label').text(unread ? '읽음 처리' : '확인함')
            );

            $notificationList.append($button);
        });
    }

    function loadUnreadCount() {
        return request('/unread-count.dox', {}).done(function (response) {
            if (response.result === 'success') updateSummary(response.unreadCount);
        });
    }

    function loadNotificationList() {
        return request('/list.dox', { limit: 20 }).done(function (response) {
            if (response.result === 'success') {
                notifications = response.list || [];
                renderList();
            } else if (response.message) {
                renderState('!', '확인이 필요해요', response.message);
            }
        });
    }

    function refreshAll(showMessage) {
        $('#btnRefresh').prop('disabled', true);
        $.when(loadUnreadCount(), loadNotificationList()).always(function () {
            $('#btnRefresh').prop('disabled', false);
            if (showMessage) showToast('알림을 새로 불러왔어요.');
        });
    }

    $('.filter-btn').on('click', function () {
        currentFilter = $(this).data('filter');
        $('.filter-btn').removeClass('active').attr('aria-selected', 'false');
        $(this).addClass('active').attr('aria-selected', 'true');
        renderList();
    });

    $('#btnBack').on('click', function () {
        if (window.history.length > 1) {
            window.history.back();
        } else {
            window.location.href = '${pageContext.request.contextPath}/';
        }
    });

    $('#btnRefresh').on('click', function () { refreshAll(true); });

    $('#celebrationPrev').on('click', function () {
        celebrationIndex = (celebrationIndex - 1 + weddingNews.length) % weddingNews.length;
        renderCelebration();
    });

    $('#celebrationNext').on('click', function () {
        celebrationIndex = (celebrationIndex + 1) % weddingNews.length;
        renderCelebration();
    });

    $('#demoNotificationBtn').on('click', function () {
        const $wrap = $('#demoNotificationWrap').toggleClass('open');
        $(this).attr('aria-expanded', $wrap.hasClass('open'));
    });

    $('#demoReadAll').on('click', function () {
        $('#btnReadAll').trigger('click');
    });

    $('#demoDropdownList').on('click', '.demo-dropdown-item', function () {
        const notificationNo = $(this).data('notification-no');
        const item = notifications.find(function (value) {
            return String(value.notificationNo) === String(notificationNo);
        });

        if (!item || item.isRead !== 'N') return;

        request('/read.dox', { notificationNo: notificationNo }).done(function (response) {
            if (response.result === 'success') {
                item.isRead = 'Y';
                renderList();
                loadUnreadCount();
                showToast('알림을 읽음 처리했어요.');
            }
        });
    });

    $notificationList.on('click', '.notification-item', function () {
        const notificationNo = $(this).data('notification-no');
        const item = notifications.find(function (value) {
            return String(value.notificationNo) === String(notificationNo);
        });

        if (!item || item.isRead !== 'N') return;

        request('/read.dox', { notificationNo: notificationNo }).done(function (response) {
            if (response.result === 'success') {
                item.isRead = 'Y';
                renderList();
                loadUnreadCount();
                showToast('알림을 읽음 처리했어요.');
            }
        });
    });

    $('#btnReadAll').on('click', function () {
        const $button = $(this).prop('disabled', true);
        request('/read-all.dox', {}).done(function (response) {
            if (response.result === 'success') {
                notifications.forEach(function (item) { item.isRead = 'Y'; });
                updateSummary(0);
                renderList();
                showToast('모든 알림을 확인했어요.');
            }
        }).always(function () {
            if (notifications.some(function (item) { return item.isRead === 'N'; })) {
                $button.prop('disabled', false);
            }
        });
    });

    renderCelebration();
    setupSideVideo();
    refreshAll(false);
});
</script>
</body>
</html>
