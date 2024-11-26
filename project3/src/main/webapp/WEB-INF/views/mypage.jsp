<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style3.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/dateFormatter.js"></script>
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

    <div class="container">
        <div class="sidebar">
            <ul>
                <li class="active"><a href="#">주문 조회</a></li>
                <li><a href="#">크레딧 사용 현황</a></li>
                <li><a href="#">취소/교환/반품</a></li>
                <li><a href="#">1:1 문의</a></li>
                <li><a href="#">친환경 참여 활동</a></li>
                <li><a href="${pageContext.request.contextPath}/mypage_modify">회원 정보 수정</a></li>
            </ul>
        </div>
		<div class="main-content">
			<div class="user-info-box">
				<h3>회원 정보</h3>
				<p>아이디: <span id ="customerID"></span></p>
				<p>보유 크레딧: <span id="creditDisplay"></span></p>
			</div>

			<div class="order-history-box">
				<h3>주문 조회</h3>
				<p id="no-orders-message">주문 내역이 없습니다.</p> <!-- 기본 메시지 -->
				<div id="order-list">
					<div class="order-item" style="display: none;"> <!-- 초기에는 숨겨둠 -->
						<p>상품 ID : <span class="thing-id"></span></p>
						<p>수량 : <span class="num"></span></p>
						<p>가격 : <span class="price"></span></p>
						<p>구매 날짜 : <span class="date"></span></p>
						<hr>
					</div>
				</div>
			</div>
		</div>
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

	<script>
	    document.addEventListener("DOMContentLoaded", function() {
	        updateNavbar();
	        loadCustomerInfo();
	    });

	    function updateNavbar() {
	        const authButtons = document.querySelector('.auth-buttons');
	        const accessToken = localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken");
	        const savedUsername = localStorage.getItem("savedUsername") || sessionStorage.getItem("username");

	        if (savedUsername && accessToken) {
	            console.log("로그인 상태입니다.");
	            authButtons.innerHTML =
	                '<a href="${pageContext.request.contextPath}/shop_cart">' +
	                    '<button class="cart-btn">장바구니</button>' +
	                '</a>' +
	                '<a href="#" onclick="performLogout()">' +
	                    '<button class="logout-btn">' + savedUsername + '(로그아웃)</button>' +
	                '</a>';
	        } else {
	            console.log("비로그인 상태입니다.");
	            authButtons.innerHTML =
	                '<a href="#">' +
	                    '<button class="signup-btn">sign up</button>' +
	                '</a>' +
	                '<a href="#">' +
	                    '<button class="login-btn">log in</button>' +
	                '</a>';
	        }
	    }

	    function performLogout() {
	        fetch("https://localhost:8030/jwt/logout", {
	            method: "POST",
	            credentials: "include" // 쿠키 포함하여 요청
	        })
	        .then(response => {
	            if (response.status === 200) {
	                clearSessionAndCookie();
	                alert("로그아웃되었습니다.");
	                window.location.href = "${pageContext.request.contextPath}/index"; // 메인 페이지로 이동
	            } else {
	                alert("로그아웃에 실패했습니다.");
	            }
	        })
	        .catch(error => {
	            console.error("로그아웃 오류:", error);
	            alert("로그아웃 요청 중 오류가 발생했습니다.");
	        });
	    }

	    function clearSessionAndCookie() {
	        localStorage.clear(); // 액세스 토큰 삭제
	        sessionStorage.clear(); // 사용자 정보 삭제
	        document.cookie = "refreshToken=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 UTC; Secure; HttpOnly; SameSite=Lax";
	    }

	    function loadCustomerInfo() {
	        console.log('AJAX 요청 시작');

	        // 아이디와 크레딧 정보 불러오기
	        $.ajax({
	            url: 'https://localhost:8587/api/customer_info',
	            method: 'GET',
	            contentType: 'application/json',
	            data: { customer_id: username },
	            success: function(response) {
	                console.log('사용자 정보 응답:', response);
	                document.getElementById('customerID').textContent = response.id;
	                document.getElementById('creditDisplay').textContent = response.credit;
	            },
	            error: function(xhr, status, error) {
	                console.error('사용자 정보 불러오기 실패:', error);
	            }
	        });

	        // 주문 내역 불러오기
	        $.ajax({
	            url: 'https://localhost:8587/api/order_history',
	            method: 'GET',
	            contentType: 'application/json',
	            data: { customer_id: username },
	            success: function(response) {
	                console.log('주문 이력 응답:', response);

	                const noOrdersMessage = document.getElementById("no-orders-message");
	                const orderList = document.getElementById("order-list");
	                const template = document.querySelector(".order-item");

	                if (response.length === 0) {
	                    noOrdersMessage.style.display = "block";
	                } else {
	                    noOrdersMessage.style.display = "none";
	                    orderList.innerHTML = "";

	                    response.forEach(order => {
	                        const orderItem = template.cloneNode(true);
	                        orderItem.style.display = "block";
	                        orderItem.querySelector(".thing-id").textContent = order.thingId;
	                        orderItem.querySelector(".num").textContent = order.num;
	                        orderItem.querySelector(".price").textContent = order.price;
	                        orderItem.querySelector(".date").textContent = formatDate(order.date_);
	                        orderList.appendChild(orderItem);
	                    });
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error('주문 이력 불러오기 실패:', error);
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
</body>
</html>
