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
		            <img src="${pageContext.request.contextPath}/grim/logo.png" alt="logo">
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
		            <button class="login-btn">log in</button>
					</a>
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
		               <p>아이디: <span id ="customerID""></span></p>
		               <p>보유 크레딧: <span id="creditDisplay"></span></p>
		           </div>

		           <div class="order-history-box">
					    <h3>주문 조회</h3>
					    <p id="no-orders-message">주문 내역이 없습니다.</p> <!-- 기본 메시지 -->
					    <div id="order-list">
					        <!-- 여기에 템플릿을 미리 작성 -->
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
		  <!-- <script>
		      document.addEventListener("DOMContentLoaded", function() {
		          loadCredits();
		      });
		      
		      function loadCredits(){
		          console.log('AJAX 요청 시작');  // 요청이 시작되었는지 확인
		      
		          // 첫 번째 AJAX 요청: 크레딧 정보를 불러오는 요청
		          $.ajax({
		              url: 'https://localhost:8587/api/shop_buy',
		              method: 'GET',
		              contentType: 'application/json',
		              success: function(response){
		                  console.log('크레딧 정보 응답:', response);  // 응답 출력
		                  const creditDisplays = document.getElementById('creditDisplay');
		                  creditDisplays.textContent = response;  // 응답 데이터를 HTML에 바인딩
		              },
		              error: function(xhr, status, error) {
		                  console.error('크레딧 정보 불러오기 실패:', error);  // 에러 출력
		              }
		          });
		          
		          // 두 번째 AJAX 요청: 사용자 ID를 불러오는 요청
		          $.ajax({
		              url: 'https://localhost:8587/api/mypg',
		              method: 'GET',
		              contentType: 'application/json',
		              success: function(response){
		                  console.log('사용자 ID 응답:', response);  // 응답 출력
		                  const customerIDElement = document.getElementById('customerID');
		                  customerIDElement.textContent = response;  // 응답 데이터를 HTML에 바인딩 (response.id)
		              },
		              error: function(xhr, status, error) {
		                  console.error('사용자 ID 불러오기 실패:', error);  // 에러 출력
		              }
		          });
		      }
		   </script>-->
		   
		   <script>
		      document.addEventListener("DOMContentLoaded", function() {
		          loadCustomerInfo();
		      });

		      function loadCustomerInfo() {
		          console.log('AJAX 요청 시작'); // 요청이 시작되었는지 확인

		          // AJAX 요청: 아이디와 크레딧 정보를 불러오는 요청
		          $.ajax({
		              url: 'https://localhost:8587/api/customer_info',
		              method: 'GET',
		              contentType: 'application/json',
		              success: function(response) {
		                  console.log('사용자 정보 응답:', response); // 응답 출력
		                  
		                  // 아이디와 크레딧 정보 HTML 요소에 바인딩
		                  document.getElementById('customerID').textContent = response.id; // SawonVO의 id
		                  document.getElementById('creditDisplay').textContent = response.credit; // SawonVO의 credit
		              },
		              error: function(xhr, status, error) {
		                  console.error('사용자 정보 불러오기 실패:', error); // 에러 출력
		              }
		          });
		          
		          
		       // 주문 이력 요청 직전 로그 출력
		          console.log("주문 이력 요청 URL:", 'https://localhost:8587/api/order_history?customerId=C001'); // 여기 추가
		          
		          // 주문 이력 AJAX 요청
		          $.ajax({
		              url: 'https://localhost:8587/api/order_history',
		              method: 'GET',
		              data: { customerId: username },
		              contentType: 'application/json',
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
		                          orderItem.style.display = "block"; // 항목 표시
		                          orderItem.querySelector(".thing-id").textContent = order.thingId;
		                          orderItem.querySelector(".num").textContent = order.num;
		                          orderItem.querySelector(".price").textContent = order.price;
		                          orderItem.querySelector(".date").textContent = formatDate(order.date_);

		                          orderList.appendChild(orderItem); // 주문 목록에 항목 추가
		                      });
		                  }
		              },
		              error: function(xhr, status, error) {
		                  console.error('주문 이력 불러오기 실패:', error);
		              }
		          });
		               
		      }
		   </script>
		   
	<!-- nav bar 변경 -->
     <script>
	    document.addEventListener("DOMContentLoaded", function() {
	        const authButtons = document.querySelector('.auth-buttons');
	        const accessToken = localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken");
	        const savedUsername = localStorage.getItem("savedUsername") || sessionStorage.getItem("username");
	        console.log("저장된 사용자 이름:", savedUsername);
	        if (savedUsername) {
	        	console.log("로그인 상태입니다.");
	            // 로그인 상태일 경우: sign up 및 log in 버튼 숨기고 장바구니와 사용자 아이디 표시
	            authButtons.innerHTML =
	                '<a href="${pageContext.request.contextPath}/shop_cart">' +
	                    '<button class="cart-btn">장바구니</button>' +
	                '</a>' +
	                '<a href="${pageContext.request.contextPath}/mypage">' +
	                '<button class="cart-btn">' + savedUsername + '님</button>' +
	            	'</a>';               
	        }else {
	            // 비로그인 상태일 경우 아무것도 하지 않음 (기본 상태 유지)
	            console.log("비로그인 상태입니다.");
	        }
	    });
	</script>
    

    </div>
    
    
    
</body>
</html>
