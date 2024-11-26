<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style5_main.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <!-- 헤더 영역 -->
    <header>
        <div class="navbar">
           <div class="logo">
            <a href="${pageContext.request.contextPath}/index">
               <img src="https://res.cloudinary.com/dhuybxduy/image/upload/v1730854684/logo_odbfxc.png" alt="logo" id="logo-image">
            </a>
           </div>
           <div class="nav-links">
               <a href="${pageContext.request.contextPath}/campaign_main">참여활동</a>
               <a href="#">회사소개</a>
               <a href="${pageContext.request.contextPath}/shop_main">eco 쇼핑</a>
               <a href="${pageContext.request.contextPath}/campaign_main">참여방법</a>
               <a href="${pageContext.request.contextPath}/company_main">상품등록</a>
           </div>
           <div class="auth-buttons">
            <a href="#">
               <button class="signup-btn">sign up</button>
            </a>
            <a href="#">
               <button class="login-btn" onclick="location.href='https://localhost:8443/login'">log in</button>
            </a>
           </div>
       </div>
       <div id="logoutModal" class="modal">
    	<div class="modal-content">
        <p>로그아웃 하시겠습니까?</p>
        <button id="cancelLogout" class="modal-btn">취소</button>
        <button id="confirmLogout" class="modal-btn">확인</button>
    	</div>
		</div>
		
    </header>
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/company" class="active">상품 등록</a>

    </div>
    
      <div class="form-container">
       <h2>상품 등록</h2>
       <!-- 상품 등록 폼 -->
       <form id="productForm">
           <div>
               <label for="company_id">회사 ID</label>
               <input type="text" id="company_id" name="company_id" required>
           </div>
           <div>
               <label for="name">상품명</label>
               <input type="text" id="name" name="name" required>
           </div>
           <div>
               <label for="price">가격 (원)</label>
               <input type="number" id="price" name="price" required>
           </div>
           <div>
               <label for="num">입고 수량</label>
               <input type="number" id="num" name="num" required>
           </div>
           <div>
               <label for="explain">상품 설명</label>
               <textarea id="explain" name="explain" rows="4" required></textarea>
           </div>
           <div>
                 <labe >상품 이미지</label>
                <td> <input type="file" name="uploadFile"> </td>
           </div>
           <button type="button" id="registerButton">상품 등록</button>
       </form>
   </div>

   <script>
       $(document).ready(function() {
    	   $('.sidebar a').each(function () {
	            if (this.href === window.location.href) {
	                $(this).addClass('active');
	            }
	        });

	        $('.sidebar a').click(function () {
	            $('.sidebar a').removeClass('active');
	            $(this).addClass('active');
	        });
	        
           $('#registerButton').on('click', function() {
              
              console.log("AJAX 요청 시작"); // 요청 시작 확인용 콘솔 출력
              
               // 폼 데이터 수집
               const formData = new FormData();
               formData.append('company_id', $('#company_id').val());
               formData.append('name', $('#name').val());
               formData.append('price', $('#price').val());
               formData.append('num', $('#num').val());
               formData.append('explain', $('#explain').val());
            // 파일 입력 필드에서 파일 가져오기
               const fileInput = $('input[name="uploadFile"]')[0];
               if (fileInput.files.length > 0) {
                   formData.append('uploadFile', fileInput.files[0]); // 파일 추가
               } else {
                   alert('이미지를 선택해 주세요.');
                   return;
               }

               // Ajax 요청을 통해 서버로 데이터 전송
               $.ajax({
                   url: 'https://localhost:8588/api/things/register',  // 상품 등록 API URL
                   method: 'POST',
                   processData: false,
                   contentType: false,
                   data: formData,
                   success: function(response) {
                      
                      console.log(response);  // 응답 데이터 확인용 콘솔 출력
                      
                       if (response.success) {
                           alert('상품 등록 완료: ' + response.message);
                       } else {
                           alert('상품 등록 실패: ' + response.message);
                       }
                   },
                   error: function(xhr) {
                       alert('오류 발생: ' + xhr.responseText);
                   }
               });
           });
       });
   </script>
   
   
    
  
  <script>
    // JWT 파싱 함수
    function parseJwt(token) {
        try {
            const base64Url = token.split('.')[1]; // JWT의 Payload 부분 추출
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/'); // Base64 URL -> Base64 변환
            const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            return JSON.parse(jsonPayload); // JSON 형태로 변환
        } catch (e) {
            console.error("Invalid JWT token", e);
            return null;
        }
    }

    
    if (!accessToken) {
        // 리프레시 토큰 삭제
        document.cookie = 'refreshToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 UTC; Secure; HttpOnly;';
    }
    
    // 로컬 스토리지에서 액세스 토큰 가져오기
	const accessToken = localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken");
    
    
    if (accessToken) {
        console.log("Access token found. Parsing and storing in session storage.");

        // JWT 파싱
        const payload = parseJwt(accessToken);

        if (payload) {
            // 세션 스토리지에 사용자 정보 저장
            sessionStorage.setItem("username", payload.username);

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
                sessionStorage.setItem("brn", payload.brn); // 사업자 등록 번호
                sessionStorage.setItem("tel", payload.tel);
                sessionStorage.setItem("email", payload.email);
                sessionStorage.setItem("address", payload.address);
            }

            console.log("Session storage updated successfully.");
        } else {
            console.error("Failed to parse JWT payload.");
        }
    } else {
        console.log("No access token found in local storage.");
    }
    const username = sessionStorage.getItem("username");
    const role = sessionStorage.getItem("role");
    
</script>


 <script>
       document.addEventListener("DOMContentLoaded", function() {
           const authButtons = document.querySelector('.auth-buttons');
           const accessToken = localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken");
           const savedUsername = localStorage.getItem("savedUsername") || sessionStorage.getItem("username");
           console.log("저장된 사용자 이름:", savedUsername);

           if (savedUsername) {
               console.log("로그인 상태입니다.");
               authButtons.innerHTML =
                   '<a href="${pageContext.request.contextPath}/shop_cart">' +
                       '<button class="cart-btn">장바구니</button>' +
                   '</a>' +
                   '<a href="${pageContext.request.contextPath}/mypage">' +
                       '<button class="cart-btn">' + savedUsername + '님</button>' +
                   '</a>' +
                   '<button id="logoutButton" class="cart-btn">log out</button>';

               // 로그아웃 버튼 클릭 시 모달 열기
               document.getElementById("logoutButton").addEventListener("click", function() {
                   document.getElementById("logoutModal").style.display = "flex";
               });
           }

           // 모달 창에서 '취소' 버튼 클릭 시 모달 닫기
           document.getElementById("cancelLogout").addEventListener("click", function() {
               document.getElementById("logoutModal").style.display = "none";
           });

           // 모달 창에서 '확인' 버튼 클릭 시 로그아웃 요청
           document.getElementById("confirmLogout").addEventListener("click", function() {
               performLogout();
           });
       });

       // 로그아웃 요청 함수
       function performLogout() {
           fetch("https://localhost:8030/jwt/logout", {
               method: "POST",
               credentials: "include"  // 쿠키 포함하여 요청
           })
           .then(response => {
               if (response.status === 200) {
                   // 로그아웃 성공 시 세션 스토리지와 쿠키 정리
                   clearSessionAndCookie();
                   alert("로그아웃되었습니다.");
                   window.location.href = "/login";  // 로그아웃 후 로그인 페이지로 이동
               } else {
                   alert("로그아웃에 실패했습니다.");
               }
           })
           .catch(error => {
               console.error("로그아웃 오류:", error);
               alert("로그아웃 요청 중 오류가 발생했습니다.");
           });
       }

       // 세션 스토리지와 쿠키 정리 함수
       function clearSessionAndCookie() {
           // 세션 스토리지 비우기
           sessionStorage.clear();

           // 리프레시 토큰 쿠키 삭제
           document.cookie = "refreshToken=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 UTC; Secure; HttpOnly; SameSite=Lax";
       }
   </script>
   </body>
   </html>
   