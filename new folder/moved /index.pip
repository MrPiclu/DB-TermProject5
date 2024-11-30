<?php
session_start(); // 세션 시작

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
            $.ajax({
                url: "save_bookmark.php",
                type: "POST",
                data: {
                    title: $("#title").val(),
                    url: $("#url").val(),
                    csrf_token: $("#csrf_token").val() // CSRF 토큰 추가
                },
                success: function (response) {
                    $("#message").text(response);
                    loadBookmarks(); // 북마크 목록 새로고침
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
                success: function (data) {
                    $("#bookmark-list").html(data);
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
