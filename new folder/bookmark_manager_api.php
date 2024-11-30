<?php
session_start();

// CSRF 토큰 생성 (세션에 저장)
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32)); // 안전한 랜덤 값 생성
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookmark Manager API</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        #message {
            margin-top: 10px;
            padding: 10px;
            border-radius: 5px;
            display: none;
        }
        #message.success {
            background-color: #d4edda;
            color: #155724;
        }
        #message.error {
            background-color: #f8d7da;
            color: #721c24;
        }
        #bookmark-list {
            margin-top: 20px;
        }
        .bookmark-item {
            padding: 5px;
            border-bottom: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <h1>Bookmark Manager API</h1>

    <!-- 북마크 저장 폼 -->
    <form id="bookmark-form">
        <input type="text" name="title" id="title" placeholder="Bookmark Title" required>
        <input type="url" name="url" id="url" placeholder="Bookmark URL" required>
        <input type="hidden" name="csrf_token" id="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
        <button type="submit">Save Bookmark</button>
    </form>

    <div id="message"></div>

    <!-- 북마크 목록 -->
    <h2>Your Bookmarks</h2>
    <div id="bookmark-list"></div>

    <script>
        $(document).ready(function () {
            // 북마크 목록 로드
            loadBookmarks();

            // 북마크 저장
            $("#bookmark-form").on("submit", function (e) {
                e.preventDefault();

                const title = $("#title").val().trim();
                const url = $("#url").val().trim();
                const csrfToken = $("#csrf_token").val();

                if (!title || !url) {
                    showMessage("Both title and URL are required.", "error");
                    return;
                }

                if (!isValidURL(url)) {
                    showMessage("Please enter a valid URL.", "error");
                    return;
                }

                $.ajax({
                    url: "save_bookmark.php",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ title, url, csrf_token: csrfToken }),
                    success: function (response) {
                        if (response.error) {
                            showMessage(response.error, "error");
                        } else {
                            showMessage("Bookmark saved successfully!", "success");
                            loadBookmarks();
                            $("#bookmark-form")[0].reset();
                        }
                    },
                    error: function () {
                        showMessage("Failed to save bookmark.", "error");
                    }
                });
            });

            // 북마크 불러오기
            function loadBookmarks() {
                $.ajax({
                    url: "get_bookmarks.php",
                    type: "GET",
                    success: function (response) {
                        if (response.error) {
                            $("#bookmark-list").html(`<p>${response.error}</p>`);
                        } else if (response.bookmarks && response.bookmarks.length > 0) {
                            let html = "";
                            response.bookmarks.forEach(bookmark => {
                                html += `<div class="bookmark-item">
                                    <a href="${escapeHTML(bookmark.url)}" target="_blank">${escapeHTML(bookmark.title)}</a>
                                </div>`;
                            });
                            $("#bookmark-list").html(html);
                        } else {
                            $("#bookmark-list").html("<p>No bookmarks found.</p>");
                        }
                    },
                    error: function () {
                        $("#bookmark-list").html("<p>Failed to load bookmarks.</p>");
                    }
                });
            }

            // 유효한 URL 확인
            function isValidURL(url) {
                const pattern = /^(https?:\/\/[^\s$.?#].[^\s]*)$/i;
                return pattern.test(url);
            }

            // 메시지 표시
            function showMessage(message, type) {
                $("#message")
                    .text(message)
                    .removeClass()
                    .addClass(type)
                    .fadeIn()
                    .delay(3000)
                    .fadeOut();
            }

            // HTML 인코딩
            function escapeHTML(str) {
                return str.replace(/[&<>"']/g, function (tag) {
                    const chars = {
                        "&": "&amp;",
                        "<": "&lt;",
                        ">": "&gt;",
                        '"': "&quot;",
                        "'": "&#39;"
                    };
                    return chars[tag] || tag;
                });
            }
        });
    </script>
</body>
</html>
