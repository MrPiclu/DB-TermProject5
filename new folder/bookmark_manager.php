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
            
            let title = $("#title").val().trim();  // 입력값에서 공백 제거
            let url = $("#url").val().trim();  // 입력값에서 공백 제거
            let csrf_token = $("#csrf_token").val();
            
            if (!title || !url) {
                $("#message").text("Both title and URL are required.");
                return;
            }

            // URL 형식 검증 (추가적인 검증)
            if (!isValidURL(url)) {
                $("#message").text("Please enter a valid URL.");
                return;
            }

            // AJAX 요청
            $.ajax({
                url: "save_bookmark.php",
                type: "POST",
                data: {
                    title: title,
                    url: url,
                    csrf_token: csrf_token // CSRF 토큰 포함
                },
                beforeSend: function() {
                    $("#message").text("Saving bookmark...");
                },
                success: function (response) {
                    $("#message").text(response.message);
                    if (response.success) {
                        loadBookmarks(); // 북마크 목록 새로고침
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    $("#message").text("Failed to save bookmark: " + errorThrown);
                }
            });
        });

        // URL 검증 함수
        function isValidURL(url) {
            const pattern = /^(https?:\/\/[^\s$.?#].[^\s]*)$/i;
            return pattern.test(url);
        }

        // 북마크 불러오기
        function loadBookmarks() {
            $.ajax({
                url: "get_bookmarks.php",
                type: "GET",
                beforeSend: function() {
                    $("#bookmark-list").html("<p>Loading bookmarks...</p>");
                },
                success: function (data) {
                    $("#bookmark-list").html(data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    $("#bookmark-list").html("<p>Failed to load bookmarks: " + errorThrown + "</p>");
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
