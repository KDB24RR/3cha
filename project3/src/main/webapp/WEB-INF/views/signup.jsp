<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eco-Wave Sign up</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            overflow-y: auto;
        }
        .signup-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }
        h2 { margin-bottom: 20px; color: #333; }
        .form-control { margin-bottom: 15px; text-align: center; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #555; }
        input[type="text"], input[type="email"], input[type="password"], input[type="tel"], input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .signup-button, .check-button, .address-button {
            width: 100%;
            padding: 10px;
            background-color: #98EECC;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        .signup-button:hover, .check-button:hover, .address-button:hover {
            background-color: #7ED6B2;
        }
        .login-link { margin-top: 10px; display: block; color: #333; }
        .login-link:hover { text-decoration: underline; }
        #map { width: 100%; height: 400px; margin-top: 20px; display: none; }
        
        .gender-options {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
        }
        .form-control#map + .form-control {
            margin-top: 15px;
        }
    </style>
</head>
<body>

<div class="signup-container">
    <h1>Eco-Wave Sign up</h1>
    <form id="signupForm" method="post" action="/api/signup" onsubmit="submitSignupForm(event)">
        <input type="hidden" name="_csrf" value="${_csrf.token}" />

        <div class="form-control">
            <label for="userType">회원 유형</label>
            <select id="userType" name="userType" onchange="toggleUserFields()">
                <option value="personal">개인</option>
                <option value="corporate">기업</option>
            </select>
        </div>

        <div class="form-control">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" placeholder="띄어쓰기 없이 영어/숫자 6~20자" required pattern="^[A-Za-z0-9]{6,20}$" oninput="filterKorean(this)" title="띄어쓰기 없이 영어/숫자 6~20자">
            <button type="button" class="check-button" onclick="checkUsername()">아이디 중복 확인</button>
            <span id="usernameCheckResult" style="color: red;"></span>
        </div>

        <div class="form-control personal-only">
            <label for="name">이름</label>
            <input type="text" id="personalName" name="personalName">
        </div>
        
		<div class="form-control personal-only">
		    <label for="birthDate">생년월일 (선택)</label>
		    <input type="date" id="birthDate" name="birthDate">
		</div>
        
        <div class="form-control personal-only">
            <label for="gender">성별</label>
            <div class="gender-options">
                <input type="radio" id="male" name="gender" value="male" required>
                <label for="male">남성</label>
                <input type="radio" id="female" name="gender" value="female" required>
                <label for="female">여성</label>
            </div>
        </div>

        <div class="corporate-only form-control">
            <label for="companyName">회사명(상호)</label>
            <input type="text" id="companyName" name="companyName">
        </div>

		<div class="corporate-only form-control">
		    <label for="businessNumber">사업자 등록번호 (예: 000-00-00000)</label>
		    <input type="text" id="businessNumber" name="businessNumber" 
		           placeholder="000-00-00000" maxlength="13" 
		           onblur="this.value = formatBusinessNumber(this.value);">
		    <button type="button" class="check-button" onclick="verifyBusinessNumber()">인증하기</button>
		    <span id="businessCheckResult" style="color: red;"></span>
		</div>

        <div class="form-control">
            <label for="tel">전화번호</label>
            <input type="tel" id="tel" name="tel" placeholder="10-11자리 숫자" maxlength="20" oninput="formatPhoneNumber(this)">
            <button type="button" class="check-button" onclick="verifyPhone()">인증하기</button>
            <span id="phoneCheckResult" style="color: red;"></span>
        </div>

        <div class="form-control">
            <label for="address">주소</label>
            <input type="text" id="address" name="address" placeholder="주소를 입력" required>
        </div>

        <div class="form-control">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" placeholder="영문, 숫자, 특수문자 포함 8자 이상" required pattern="(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}" title="영문, 숫자, 특수문자 포함 8자 이상.">
        </div>

        <div class="form-control">
            <label for="confirm-password">비밀번호 확인</label>
            <input type="password" id="confirm-password" name="confirm-password" placeholder="위의 비밀번호를 다시 입력" required>
            <span id="passwordMatchMessage" style="color: red;"></span>
        </div>

        <div class="form-control">
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" oninput="filterKorean(this)">
            <button type="button" class="check-button" onclick="verifyEmail()">인증하기</button>
            <span id="emailCheckResult" style="color: red;"></span>
        </div>

        <div class="form-control" id="emailVerificationCodeField">
            <label for="emailVerificationCode">인증 코드 입력</label>
            <input type="text" id="code" name="emailVerificationCode" placeholder="인증 코드를 입력하세요">
            <button type="button" class="check-button" onclick="verifyEmailCode()">인증 코드 확인</button>
            <span id="emailCodeCheckResult" style="color: red;"></span>
        </div>
        
        <button type="submit" class="signup-button">Eco-Wave 회원가입</button>
    </form>
    <a href="/login" class="login-link">이미 계정이 있으신가요? 로그인하기</a>
</div>

<script>

// 아이디 중복 확인
function checkUsername() {
    const username = document.getElementById('username').value;
    const usernameCheckResult = document.getElementById("usernameCheckResult");

    // 아이디가 입력되지 않았을 경우
    if (!username) {
        usernameCheckResult.innerText = "아이디를 입력하세요.";
        usernameCheckResult.style.color = "red";
        return;
    }

    fetch(`https://localhost:8180/api/check-username?username=`+username)
        .then(response => {
            if (response.status === 409) {
                usernameCheckResult.innerText = "이미 사용 중인 아이디입니다.";
                usernameCheckResult.style.color = "red";
            } else {
                usernameCheckResult.innerText = "사용 가능한 아이디입니다.";
                usernameCheckResult.style.color = "green";
            }
        })
        .catch(error => console.error("아이디 중복 확인 오류:", error));
}
    
function submitSignupForm(event) {
    event.preventDefault();

    // 회원 유형 확인
    const userTypeElement = document.getElementById("userType");
    const userType = userTypeElement?.value || ""; // userType이 없으면 빈 문자열
    if (!userType) {
        alert("회원 유형을 선택하세요.");
        return;
    }

    // 공통 입력 값
	const verificationCode = document.getElementById("code").value;
    const usernameElement = document.getElementById("username");
    const username = usernameElement?.value.trim() || "";
    if (!username) {
        alert("아이디를 입력하세요.");
        return;
    }

    const passwordElement = document.getElementById("password");
    const password = passwordElement?.value.trim() || "";
    const confirmPasswordElement = document.getElementById("confirm-password");
    const confirmPassword = confirmPasswordElement?.value.trim() || "";
    if (password !== confirmPassword) {
        document.getElementById("passwordMatchMessage").innerText = "비밀번호가 일치하지 않습니다.";
        return;
    }

    const emailElement = document.getElementById("email");
    const email = emailElement?.value.trim() || "";
    if (!email) {
        alert("이메일을 입력하세요.");
        return;
    }

    const addressElement = document.getElementById("address");
    const address = addressElement?.value.trim() || "";
    if (!address) {
        alert("주소를 입력하세요.");
        return;
    }
    
    const phoneElement = document.getElementById("tel");
    const phone = phoneElement?.value.trim() || "";
    console.log("전화번호 입력값:", phone); // 디버깅용 로그

    if (!phone) {
        alert("전화번호를 입력하세요.");
        return;
    }

    const phonePattern = /^[0-9]{3}-[0-9]{3,4}-[0-9]{4}$/; // 예: 010-1234-5678
    if (!phonePattern.test(phone)) {
        alert("올바른 전화번호 형식이 아닙니다. 예: 010-1234-5678");
        return;
    }

    // 데이터 생성
    const requestData = { verificationCode, username, password, email, address, phone };

    if (userType === "personal") {
        // 개인 회원 추가 데이터
        const nameElement = document.getElementById("personalName");
        const name = nameElement?.value.trim() || "";


        const birthDateElement = document.getElementById("birthDate");
        const birthDate = birthDateElement?.value || "";

        const genderElement = document.querySelector('input[name="gender"]:checked');
        const gender = genderElement?.value || "";
        if (!gender) {
            alert("성별을 선택하세요.");
            return;
        }

        Object.assign(requestData, { name, birthDate, gender });

        // 개인 회원 API 호출
        console.log("이름 입력값:", name); // 디버깅용 로그
        sendRequest("https://localhost:8180/api/register/personal", requestData);
    } else if (userType === "corporate") {
        // 기업 회원 추가 데이터
        const companyNameElement = document.getElementById("companyName");
        const companyName = companyNameElement?.value.trim() || "";
        const businessNumberElement = document.getElementById("businessNumber");
        const businessNumber = businessNumberElement?.value.trim() || "";

        if (!companyName || !businessNumber) {
            alert("기업 회원 정보를 모두 입력하세요.");
            return;
        }

        Object.assign(requestData, { companyName, businessNumber });
        console.log("RequestData after adding companyName and businessNumber:", requestData);

        // 기업 회원 API 호출
        sendRequest("https://localhost:8180/api/register/corporate", requestData);
       
    }
}

function sendRequest(url, data) {
    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    })
        .then(response => {
            if (response.ok) {
                // 응답이 JSON 형식인지 확인
                return response.text().then(text => {
                    try {
                        return JSON.parse(text); // JSON 파싱 시도
                    } catch (e) {
                        return { message: text }; // JSON이 아니면 텍스트로 처리
                    }
                });
            } else {
                return response.text().then(text => {
                    try {
                        const json = JSON.parse(text);
                        alert("회원가입 실패: " + (json.error || "알 수 없는 오류"));
                    } catch (e) {
                        alert("회원가입 실패: " + text);
                    }
                });
            }
        })
        .then(data => {
            if (data.message) {
                alert(data.message); // 성공 메시지 출력
                window.location.href = "/login";
            }
        })
        .catch(error => console.error("네트워크 오류:", error));
}

    function toggleUserFields() {
        const userType = document.getElementById('userType').value;
        const personalFields = document.querySelectorAll('.personal-only');
        const corporateFields = document.querySelectorAll('.corporate-only');

        personalFields.forEach(field => {
            field.style.display = (userType === 'personal') ? 'block' : 'none';
            field.querySelectorAll('input').forEach(input => input.required = (userType === 'personal'));
        });

        corporateFields.forEach(field => {
            field.style.display = (userType === 'corporate') ? 'block' : 'none';
            field.querySelectorAll('input').forEach(input => input.required = (userType === 'corporate'));
        });
    }

    document.addEventListener('DOMContentLoaded', toggleUserFields);

    function checkPasswordMatch() {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirm-password").value;
        const message = document.getElementById("passwordMatchMessage");

        if (confirmPassword === password) {
            message.textContent = "비밀번호가 일치합니다.";
            message.style.color = "green";
        } else {
            message.textContent = "비밀번호가 일치하지 않습니다.";
            message.style.color = "red";
        }
    }

    function filterKorean(input) {
        input.value = input.value.replace(/[^A-Za-z0-9@._-]/g, '');
    }

    function validatePassword(input) {
        const pattern = /(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])(?!.*(.)\1\1)[A-Za-z\d!@#$%^&*]{8,}/;
        const message = document.getElementById("passwordMatchMessage");
        if (!pattern.test(input.value)) {
            message.textContent = "조건을 만족하는 비밀번호를 입력하세요.";
            message.style.color = "red";
        } else {
            message.textContent = "";
        }
    }

    function verifyPhone() {
        const phoneInput = document.getElementById("tel"); // <input> 요소 가져오기
        const phone = phoneInput.value.trim(); // 공백 제거
        const phoneCheckResult = document.getElementById("phoneCheckResult");
        
        // 전화번호가 입력되지 않았을 경우
        if (!phone) {
            phoneCheckResult.innerText = "전화번호를 입력하세요.";
            phoneCheckResult.style.color = "red";
            return;
        }

        fetch(`https://localhost:8180/api/check-customer-tel?tel=`+phone)
            .then(response => {
                if (response.status === 409) {
                    phoneCheckResult.innerText = "이미 사용 중인 전화번호입니다.";
                    phoneCheckResult.style.color = "red";
                } else {
                    phoneCheckResult.innerText = "사용 가능한 전화번호입니다.";
                    phoneCheckResult.style.color = "green";
                }
            })
            .catch(error => console.error("전화번호 인증 오류:", error));
    }

    function formatPhoneNumber(input) {
        let value = input.value.replace(/[^0-9]/g, '');
        if (value.length <= 3) {
            input.value = value;
        } else if (value.length <= 7) {
            input.value = value.replace(/(\d{3})(\d+)/, '$1-$2');
        } else {
            input.value = value.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
        }
    }

 // 이메일 인증
    function verifyEmail() {
        const email = document.getElementById("email").value;
        const emailCheckResult = document.getElementById("emailCheckResult");

        // 이메일이 입력되지 않았을 경우
        if (!email) {
            emailCheckResult.innerText = "올바른 메일 주소를 입력하세요.";
            emailCheckResult.style.color = "red";
            return;
        }

        fetch(`https://localhost:8180/api/send-email-verification?email=`+email, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email: email })
        })
        .then(response => {
            if (response.ok) {
                alert("인증 코드가 이메일로 전송되었습니다.");
                emailCheckResult.innerText = ""; // 전송 성공 시 메시지 제거
            } else {
                emailCheckResult.innerText = "이메일 인증 요청 중 오류가 발생했습니다.";
                emailCheckResult.style.color = "red";
            }
        })
        .catch(error => {
            console.error("이메일 인증 오류:", error);
            emailCheckResult.innerText = "오류 발생: " + error.message;
            emailCheckResult.style.color = "red";
        });
    }

    function verifyEmailCode() {
        const email = document.getElementById("email").value;
        const code = document.getElementById("code").value;

        fetch(`https://localhost:8180/api/verify-email-code?code=`+code, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, code }) // email과 code를 JSON으로 전달
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert(result.message); // 인증 성공 메시지
            } else {
                alert(result.message); // 인증 실패 메시지
            }
        })
        .catch(error => {
            console.error("인증 코드 검증 오류:", error);
            alert("인증 코드 검증 중 오류가 발생했습니다.");
        });
    }

    function formatBusinessNumber(bNo) {
        // 입력 값에서 숫자만 남기고 포맷팅
        return bNo.replace(/[^0-9]/g, '').replace(/(\d{3})(\d{2})(\d{5})/, '$1-$2-$3');
    }

    // 사업자 등록번호 포맷팅 이벤트 추가
    document.getElementById('businessNumber').addEventListener('blur', function () {
        this.value = formatBusinessNumber(this.value); // 입력 값 포맷팅
    });

    // 사업자 번호 인증 함수 (기존)
   async function verifyBusinessNumber() {
    const businessNumber = document.getElementById('businessNumber').value.replace(/-/g, ''); // 하이픈 제거

    try {
        const response = await fetch('https://localhost:8180/api/business-info', {
            method: 'POST', // 반드시 POST 사용
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ b_no: [businessNumber] }), // JSON 형식 데이터 전송
        });

        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }

        const data = await response.json();
        console.log('사업자 정보:', data);
    } catch (error) {
        console.error('사업자 번호 확인 실패:', error);
    }
}

</script>
</body>
</html>
