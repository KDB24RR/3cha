<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Campaign</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style4_main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
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
               <a href="#">참여방법</a>
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
          <div class ="top">
		</div>
        <div class="banner">
    <!-- 배경 이미지가 배너로 들어감 -->
    <div class="banner-content">
        <h2 class="section-title">참 여 방 법</h2>
        <div class="steps-container">
            <div class="step">
                <div class="circle">
                    <img src="https://res.cloudinary.com/dhuybxduy/image/upload/v1731823109/free-icon-touch-4424004_mb20ny.png" alt="step 1">
                </div>
                <p class="step-title">step 1</p>
                <span class="step-description">참여를 원하는 캠페인 선택</span>
            </div>
            <div class="step">
                <div class="circle">
                    <img src="https://res.cloudinary.com/dhuybxduy/image/upload/v1731822756/smartphone_18313985_qsdmo9.png" alt="step 2">
                </div>
                <p class="step-title">step 2</p>
                <span class="step-description">해당 캠페인 공식 웹사이트에서<br>활동 목적 및 내용을 확인</span>
            </div>
            <div class="step">
                <div class="circle">
                    <img src="https://res.cloudinary.com/dhuybxduy/image/upload/v1731822923/compliant_4813649_uzxj51.png" alt="step 3">
                </div>
                <p class="step-title">step 3</p>
                <span class="step-description">신청서 작성 후<br>친환경 캠페인에 참여</span>
            </div>
        </div>
    </div>
</div>
			
			<!-- 캠페인 활동 제목 추가 -->
			<section class="campaign-activity">
			    <h2 class="campaign-title">캠페인 활동</h2>
			</section>

            <!-- 캠페인 활동 포스터 섹션 -->
            <section class="campaign-poster">
            <div class = "poster-grid">
                       <script>
         
                     document.addEventListener("DOMContentLoaded", function() {
                         loadPosters();
                     });
               
                     function loadPosters() {
                         $.ajax({
                             url: 'https://localhost:8388/api/posters/list',
                             method: 'GET',
                             contentType: 'application/json',
                             success: function(posters) {
                                 const posterGrid = document.querySelector('.poster-grid');
                                  
                                 posterGrid.innerHTML = '';  // 기존 내용을 초기화
                                 
                                 posters.forEach(poster => {
                                     if (!poster || !poster.cimage) {
                                         console.warn("잘못된 데이터:", poster); // 잘못된 데이터를 콘솔에 경고 출력
                                         return; // cimage가 없는 경우 건너뜁니다
                                     }
               

                                 const posterElement = 
                                     '<div class="poster">' +
                                       '<a href="campaign_detail?cimageid=' + poster.cimage + '">'+
                                          '<img src="' + poster.cimage + '" alt="이미지" />' +                                        
                                       '</a>'+
                                     '</div>';
                                     posterGrid.insertAdjacentHTML('beforeend', posterElement); // HTML을 .poster-grid 안에 추가
                                 });
                             },
                             error: function(xhr) {                             
                                 alert("포스터를 가지고 올 수 없습니다: " + xhr.responseText);
                             }
                         });
                     }

                  </script>                                                   
                 </div>
            </section>
        </main>
    </div>
    
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
       // 세션 스토리지에서 값 가져오기
    const username = sessionStorage.getItem("username");
    const role = sessionStorage.getItem("role");
    const name = sessionStorage.getItem("name");
    const sex = sessionStorage.getItem("sex");
    const tel = sessionStorage.getItem("tel");
    const birth = sessionStorage.getItem("birth");
    const email = sessionStorage.getItem("email");
    const address = sessionStorage.getItem("address");
    const brn = sessionStorage.getItem("brn");
</script>
    
        <!-- nav bar 변경 -->
     <script>
       document.addEventListener("DOMContentLoaded", function() {
           const authButtons = document.querySelector('.auth-buttons');
           const accessToken = localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken");
           const savedUsername = localStorage.getItem("savedUsername") || sessionStorage.getItem("username");
           const role = sessionStorage.getItem("role");
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

           // role이 company인 경우 navbar 수정
           if (role === "company") {
               const navLinks = document.querySelector('.nav-links');
               navLinks.innerHTML =
                   '<a href="${pageContext.request.contextPath}/campaign_main">참여활동</a>' +
                   '<a href="#">회사소개</a>' +
                   '<a href="${pageContext.request.contextPath}/shop_main">eco 쇼핑</a>' +
                   '<a href="${pageContext.request.contextPath}/campaign_main">참여방법</a>' +
                   '<a href="${pageContext.request.contextPath}/company_main">상품등록</a>';
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
    

    <script src="script.js"></script>
          
          

</body>
</html>