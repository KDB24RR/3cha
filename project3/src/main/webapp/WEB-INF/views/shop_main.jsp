<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eco Wave</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style2_main.css">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <!-- 상단 네비게이션 -->
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

   <!-- 메인 배너 영역 -->
<section class="swiper-container main-banner">
    <div class="swiper-wrapper">
        <!-- 첫 번째 배너 슬라이드 -->
        <div class="swiper-slide swiper-slide-1">
            <div class="banner-text">
                <h1>제로 웨이스트</h1>
                <p class="first-line">"Join the zero waste movement with our eco-friendly products</p>
                <p class="second-line">for a sustainable future."</p>
                <a href="#" class="btn">View Detail</a>
            </div>
        </div>
        <!-- 두 번째 배너 슬라이드 -->
        <div class="swiper-slide swiper-slide-2">
            <div class="banner-text">
            </div>
        </div>
        <!-- 세 번째 배너 슬라이드 -->
        <div class="swiper-slide swiper-slide-3">
            <div class="banner-text">
                <p class="first-line">"Embrace sustainability for a brighter tomorrow."</p>
                <p class="second-line">Make eco-friendly choices every day.</p>
                <a href="#" class="btn">Learn More</a>
            </div>
        </div>
    </div>

    <!-- Swiper 네비게이션 버튼 -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>

    <!-- Swiper 페이지네이션 -->
    <div class="swiper-pagination"></div>
</section>


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


 <!-- Swiper JS -->
    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

    <!-- Swiper 초기화 스크립트 -->
    <script>
        var swiper = new Swiper('.swiper-container', {
            loop: true, /* 무한 루프 */
            autoplay: {
                delay: 3000, /*3초마다 슬라이드 */
                disableOnInteraction: false,
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
        });
    </script>

    <!-- 제품 목록 -->
    <section class="best-product">
        <h2>BEST PRODUCT</h2>
        
		 
		<div class="product-grid">	
		
	<script>

		document.addEventListener("DOMContentLoaded", function() {
		    loadProducts();
		});

		function loadProducts() {
		    $.ajax({
		        url: 'https://localhost:8588/api/products/list',
		        method: 'GET',
		        contentType: 'application/json',
		        success: function(products) {
		            const productGrid = document.querySelector('.product-grid');
		             
		            productGrid.innerHTML = '';  // 기존 내용을 초기화
					console.log(products);

		            products.forEach(product => { 
						const productElement = 
						    '<div class="product">' +
								'<a href="shop_detail?thing_id=' + product.thing_id + '">'+
									'<img src="' + product.image_path + '" alt="이미지" />' +
						        '<h3>' + product.name + '</h3>' +
								'</a>'+
						        '<h4>' + product.price + "원"+'</h4>' +
						    '</div>';
		                productGrid.insertAdjacentHTML('beforeend', productElement); // HTML을 .product-grid 안에 추가
		            });
		        },
		        error: function(xhr) {
		            alert("물건 품목을 가지고 올 수 없습니다: " + xhr.responseText);
		        }
		    });
		}
	</script>
	
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

      
    
	

        </div>
    </section>
    
    <!-- nav bar 변경 -->
    
    
    
    
</body>
</html>
