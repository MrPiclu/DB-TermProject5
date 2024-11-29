<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookmark System</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>Bookmark Manager</h1>

    <!-- 북마크 저장 폼 -->
    <form id="bookmark-form">
        <input type="text" name="title" id="title" placeholder="Bookmark Title" required>
        <input type="url" name="url" id="url" placeholder="Bookmark URL" required>
        <input type="hidden" name="csrf_token" id="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>"> <!-- CSRF 토큰 추가 -->
        <button type="submit">Save Bookmark</button>
    </form>

    <div id="message"></div>

    <!-- 북마크 목록 -->
    <h2>Your Bookmarks</h2>
    <div id="bookmark-list"></div>

    <script>
        // 북마크 저장
        $("#bookmark-form").on("submit", function (e) {
            e.preventDefault();

            // 데이터 수집
            const title = $("#title").val();
            const url = $("#url").val();
            const csrfToken = $("#csrf_token").val();

            // AJAX 요청
            $.ajax({
                url: "save_bookmark.php",
                type: "POST",
                contentType: "application/json", // JSON 요청
                data: JSON.stringify({ title, url, csrf_token: csrfToken }),
                success: function (response) {
                    const data = JSON.parse(response);
                    if (data.error) {
                        $("#message").text(data.error);
                    } else {
                        $("#message").text("Bookmark saved successfully.");
                        loadBookmarks();
                    }
                },
                error: function () {
                    $("#message").text("Failed to save bookmark.");
                }
            });
        });

        // 북마크 불러오기
        function loadBookmarks() {
            $.ajax({
                url: "get_bookmarks.php",
                type: "GET",
                contentType: "application/json", // JSON 요청
                success: function (response) {
                    const data = JSON.parse(response);
                    if (data.error) {
                        $("#bookmark-list").html(`<p>${data.error}</p>`);
                    } else if (data.bookmarks && data.bookmarks.length > 0) {
                        let html = "";
                        data.bookmarks.forEach(bookmark => {
                            html += `<p><a href="${bookmark.url}" target="_blank">${bookmark.title}</a></p>`;
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

        // 페이지 로드 시 북마크 목록 가져오기
        $(document).ready(function () {
            loadBookmarks();
        });
    </script>
</body>
</html>
