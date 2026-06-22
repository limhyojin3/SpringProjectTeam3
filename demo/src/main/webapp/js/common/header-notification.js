(function () {
    'use strict';

    function initHeaderNotification() {
        var root = document.getElementById('mvHeaderNoti');
        if (!root || root.dataset.initialized === 'true') return;

        root.dataset.initialized = 'true';

        var apiBase = root.dataset.apiBase || '';
        var contextPath = root.dataset.contextPath || '';
        var sessionRole = root.dataset.sessionRole || '';
        var button = root.querySelector('.mv-noti-btn');
        var badge = root.querySelector('.mv-noti-badge');
        var list = root.querySelector('.mv-noti-list');
        var readAllButton = root.querySelector('.mv-noti-read-all');
        var notifications = [];
        var refreshTimer;

        function request(path, data) {
            var body = new URLSearchParams();
            Object.keys(data || {}).forEach(function (key) {
                body.append(key, data[key]);
            });

            return fetch(apiBase + path, {
                method: 'POST',
                credentials: 'same-origin',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: body.toString()
            }).then(function (response) {
                if (!response.ok) throw new Error('HTTP ' + response.status);
                return response.json();
            });
        }

        function formatDate(value) {
            if (!value) return '';
            var date = new Date(String(value).replace(' ', 'T'));
            if (Number.isNaN(date.getTime())) return value;

            var diff = Date.now() - date.getTime();
            var minute = 60 * 1000;
            var hour = 60 * minute;
            var day = 24 * hour;

            if (diff < minute) return '방금 전';
            if (diff < hour) return Math.floor(diff / minute) + '분 전';
            if (diff < day) return Math.floor(diff / hour) + '시간 전';
            if (diff < 7 * day) return Math.floor(diff / day) + '일 전';
            return value;
        }

        function targetUrl(item) {
            var number = encodeURIComponent(item.targetNo || '');
            var type = String(item.targetType || '').toUpperCase();

            if (type === 'REVIEW' && number) return contextPath + '/api/review/detail.do?reviewNo=' + number;
            if ((type === 'COMMUNITY' || type === 'POST') && number) return contextPath + '/api/community/detail.do?postNo=' + number;
            if (type === 'INQUIRY') return contextPath + (sessionRole === 'ADMIN' ? '/adminInquiry.do' : '/userMyPage-cs.do');
            if (type === 'REPORT') return contextPath + (sessionRole === 'ADMIN' ? '/adminReport.do' : '/userMyPage-cs.do');
            return '';
        }

        function updateBadge(count) {
            count = Number(count) || 0;
            badge.textContent = count > 99 ? '99+' : String(count);
            badge.hidden = count === 0;
            readAllButton.disabled = count === 0;
        }

        function emptyMessage(message) {
            list.replaceChildren();
            var empty = document.createElement('div');
            empty.className = 'mv-noti-empty';
            empty.textContent = message;
            list.appendChild(empty);
        }

        function renderList() {
            list.replaceChildren();

            if (!notifications.length) {
                emptyMessage('새로운 알림이 없습니다.');
                return;
            }

            notifications.forEach(function (item) {
                var itemButton = document.createElement('button');
                itemButton.type = 'button';
                itemButton.className = 'mv-noti-item' + (item.isRead === 'N' ? ' unread' : '');
                itemButton.dataset.notificationNo = item.notificationNo;

                var content = document.createElement('div');
                content.className = 'mv-noti-content';
                content.textContent = item.content || '알림 내용이 없습니다.';

                var date = document.createElement('div');
                date.className = 'mv-noti-date';
                date.textContent = formatDate(item.createdAt);

                itemButton.append(content, date);
                itemButton.addEventListener('click', function () { openNotification(item); });
                list.appendChild(itemButton);
            });
        }

        function refresh() {
            return Promise.all([
                request('/list.dox', { limit: 5 }),
                request('/unread-count.dox', {})
            ]).then(function (responses) {
                var listResponse = responses[0];
                var countResponse = responses[1];

                if (listResponse.result === 'success') {
                    notifications = listResponse.list || [];
                    renderList();
                } else {
                    emptyMessage(listResponse.message || '알림을 불러오지 못했습니다.');
                }

                if (countResponse.result === 'success') updateBadge(countResponse.unreadCount);
            }).catch(function () {
                emptyMessage('알림을 불러오지 못했습니다.');
            });
        }

        function openNotification(item) {
            var destination = targetUrl(item);
            var readPromise = item.isRead === 'N'
                ? request('/read.dox', { notificationNo: item.notificationNo })
                : Promise.resolve({ result: 'success' });

            readPromise.finally(function () {
                if (destination) {
                    window.location.href = destination;
                } else {
                    refresh();
                }
            });
        }

        button.addEventListener('click', function () {
            window.location.href = contextPath + '/api/notification/list.do';
        });

        readAllButton.addEventListener('click', function () {
            readAllButton.disabled = true;
            request('/read-all.dox', {}).then(function (response) {
                if (response.result === 'success') {
                    notifications.forEach(function (item) { item.isRead = 'Y'; });
                    updateBadge(0);
                    renderList();
                    document.dispatchEvent(new CustomEvent('mv:notification-changed'));
                }
            }).catch(function () {
                readAllButton.disabled = false;
            });
        });

        document.addEventListener('click', function (event) {
            if (!root.contains(event.target)) {
                root.classList.remove('is-open');
                button.setAttribute('aria-expanded', 'false');
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                root.classList.remove('is-open');
                button.setAttribute('aria-expanded', 'false');
                button.focus();
            }
        });

        document.addEventListener('mv:notification-changed', refresh);
        refresh();
        refreshTimer = window.setInterval(function () {
            if (document.visibilityState === 'visible') refresh();
        }, 30000);

        window.addEventListener('pagehide', function () {
            window.clearInterval(refreshTimer);
        }, { once: true });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initHeaderNotification);
    } else {
        initHeaderNotification();
    }
})();
