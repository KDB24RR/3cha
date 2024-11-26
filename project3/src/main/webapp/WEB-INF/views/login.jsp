<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f0f0;
        }
        .login-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
        }
        .login-container input {
            margin: 10px 0;
            padding: 10px;
            width: calc(100% - 22px);
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .login-container button {
            padding: 10px;
            width: 100%;
            background: #98EECC;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        #responseMessage, #tokenDisplay {
            margin-top: 15px;
            color: #333;
        }
        .checkbox-container {
            display: flex;
            justify-content: center; /* 중앙 정렬 */
            gap: 20px;
            width: 100%;
            margin-bottom: 10px;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 5px; /* 체크박스와 텍스트 사이 간격 */
            white-space: nowrap; /* 줄바꿈 방지 */
        }
        .social-buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 15px;
        }
        .social-buttons img {
            cursor: pointer;
            width: 80px;
            height: auto;
        }
        .login-links {
            margin-top: 10px;
            display: flex;
            justify-content: space-around;
            color: #333;
            text-decoration: none;
        }
        .login-links a {
            color: #333;
            text-decoration: none;
        }
        .login-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Eco-Wave Login</h1>
        <form id="loginForm" onsubmit="return login(event)">
            <input type="text" id="username" placeholder="아이디" required><br>
            <input type="password" id="password" placeholder="비밀번호" required><br>
            
            <div class="checkbox-container">
                <div class="checkbox-item">
                    <input type="checkbox" id="keepLogin">
                    <label for="keepLogin">로그인 유지</label>
                </div>
            </div>
            
            <button type="submit">로그인</button>

        </form>
        <p id="responseMessage"></p>
        <p id="tokenDisplay"></p>

        <!-- 회원가입 링크 -->
        <a href="/signup" class="signup-link">Eco-Wave 회원가입</a>
    </div>

<script>
    (function() {
        // 세션 및 로컬 스토리지의 액세스 토큰 삭제
		sessionStorage.clear();
		localStorage.clear();
        // 리프레시 토큰 쿠키 삭제
        document.cookie = 'refreshToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 UTC;';
    })();
</script>

<script>

document.addEventListener("DOMContentLoaded", function() {
    const savedUsername = localStorage.getItem("savedUsername");
    const autoLogin = localStorage.getItem("autoLogin");

    if (savedUsername) {
        document.getElementById("username").value = savedUsername;
    }

    if (autoLogin && savedUsername) {
        login(); // 자동 로그인 시도 (비밀번호 저장 대신 세션 토큰 기반으로 변경 고려)
    }
});

// JWT 토큰에서 페이로드를 파싱하는 함수
function parseJwt(token) {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
        atob(base64)
            .split('')
            .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
            .join('')
    );
    return JSON.parse(jsonPayload);
}

// 로그인 요청 함수
function login(event) {
    if (event) event.preventDefault();

    // 메시지 초기화
    document.getElementById("responseMessage").innerText = "";

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;
    const keepLogin = document.getElementById("keepLogin").checked;
    const payload = { username, password };

    // 첫 번째 /login 요청
    fetch("https://localhost:8030/jwt/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" , "X-Keep-Logged-In": keepLogin ? "true" : "false"},
        body: JSON.stringify(payload),
        credentials: "include"  // 쿠키 포함 요청
    })
    .then(response => {
        if (response.status === 200) {
            // 중복 세션이 없는 경우, 로그인 성공 처리
            return response.json().then(data => handleLoginSuccess(data, keepLogin));
        } else if (response.status === 409) {
            // 중복 세션이 있는 경우, 사용자에게 알림
            return response.json().then(data => {
                const userConfirmed = confirm(data.errorMessage);
                
                if (userConfirmed) {
                    sessionStorage.setItem("oneTimeToken", data.oneTimeToken);
                    // 세션 만료를 위한 /expire 요청 실행 후 재로그인 시도
                    return expireSessionAndRetryLogin(username, payload, keepLogin);
                } else {
                    throw new Error("다중 세션은 허용되지 않습니다");
                }
            });
        } else if (response.status === 401) {
            document.getElementById("responseMessage").innerText = "아이디 또는 비밀번호가 유효하지 않습니다";
            throw new Error("Unauthorized");
        } else {
            throw new Error("로그인 중 오류가 발생했습니다.");
        }
    })
    .catch(error => {
        if (error.message !== "Unauthorized") {
            console.error("Error:", error);
        }
    });
}

// /expire 요청을 통해 세션을 만료하고 재로그인 시도
function expireSessionAndRetryLogin(username, payload, keepLogin) {
    const storedToken = sessionStorage.getItem("oneTimeToken");

    return fetch("https://localhost:8030/jwt/expire", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ 
            username: username,
            oneTimeToken: storedToken
        }),
    })
    .then(expireResponse => {
        if (expireResponse.ok) {
            // 세션 만료 성공 후 재로그인 시도
            return fetch("https://localhost:8030/jwt/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" , "X-Keep-Logged-In": keepLogin ? "true" : "false" },
                body: JSON.stringify(payload),
                credentials: "include"
            })
            .then(loginResponse => {
                if (loginResponse.status === 200) {
                    return loginResponse.json().then(data => handleLoginSuccess(data, keepLogin));
                } else {
                    throw new Error("재로그인 중 오류가 발생했습니다.");
                }
            });
        } else {
            throw new Error("세션 만료 요청이 실패했습니다.");
        }
    })
    .catch(error => {
        console.error("Error during session expire and retry login:", error);
    });
}

// 로그인 성공 시 토큰 처리 및 리다이렉트 공통 함수
function handleLoginSuccess(data, keepLogin) {
    console.log("Final token data:", data);
    if (data.token) {
    	
        if (keepLogin) {
            localStorage.setItem("accessToken", data.token);
        } else {
            sessionStorage.setItem("accessToken", data.token);
        }

        // 토큰에서 페이로드 정보를 파싱하여 세션 스토리지에 저장
        const payload = parseJwt(data.token);
        sessionStorage.setItem("username", payload.username); // 공통으로 저장

        // role 값에 따라 분기하여 다른 정보 저장
        if (payload.role === "customer") {
            sessionStorage.setItem("role", payload.role);
            sessionStorage.setItem("name", payload.name);
            sessionStorage.setItem("sex", payload.sex);
            sessionStorage.setItem("tel", payload.tel);
            sessionStorage.setItem("birth", payload.birth);
            sessionStorage.setItem("email", payload.email);
            sessionStorage.setItem("address", payload.address);
        } else if (payload.role === "company") {
            sessionStorage.setItem("role", payload.role);
            sessionStorage.setItem("name", payload.name);
            sessionStorage.setItem("brn", payload.brn);  // 사업자 등록 번호
            sessionStorage.setItem("tel", payload.tel);
            sessionStorage.setItem("email", payload.email);
            sessionStorage.setItem("address", payload.address);
        }


        
        // 성공 후 메인 페이지로 이동
        window.location.href = "/index";
    } else {
        document.getElementById("responseMessage").innerText = "아이디 또는 비밀번호가 유효하지 않습니다.";
    }
}




</script>
</body>
</html>