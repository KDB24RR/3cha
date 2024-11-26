<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>제품 상세 페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style2_detail.css"> <!-- 스타일시트 링크 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
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
       <div id="logoutModal" class="modal2">
    	<div class="modal2-content">
        <p>로그아웃 하시겠습니까?</p>
        <button id="cancelLogout" class="modal2-btn">취소</button>
        <button id="confirmLogout" class="modal2-btn">확인</button>
    	</div>
		</div>
	
    <!-- 상품 상세 정보 영역 -->
	<div class="container">
		<img id="product-image" alt="상품 이미지" width="400" height="400">

    <div class="product-info">
        <h1 id="product-name">제품 이름</h1>     
        <p class="price" id="product-price"></p>
		<hr class="line">
        <p class="info" id="product-info">상품 설명</p>

        <!-- 수량 선택 -->
        <div class="quantity-count">
            <label for="quantity" id="count">수량</label>
            <input type="number" id="quantity" name="quantity" min="1" value="1">
        </div>

        <div class="total-price">
            <p>총 상품금액: <span id="total">원</span></p>
        </div>

        <div class="button-group">
            <button class="btn-cart">장바구니</button>
            <button class="btn-buy" id="buyButton" onclick="location.href='${pageContext.request.contextPath}/shop_buy?thing_id=${thing_id}'">구매하기</button>

        </div>

    </div>
	</div>

    <div class="footer">
        <button class="footer-view">상세정보</button>
        <button class="footer-re">Review</button>
        <button class="footer-qna">QnA</button> 
        <hr class="line">
    </div>
	
	<!-- 모달 창 HTML -->
	<div class="modal" style="display: none;">
		<div class="modal_popup">
			<h3>장바구니에 담겼습니다</h3>
			<div class="button-group">
				<button type="button" class="gocart" onclick="location.href='shop_cart'">장바구니로 가기</button>
				<button type="button" class="close_btn">쇼핑 계속하기</button>
			</div>
		</div>
	</div>	
	
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
    
    	let thing_id;
        // 페이지가 로드되면 상품 정보를 불러옵니다.
        document.addEventListener("DOMContentLoaded", function() {
        	thing_id = getParameterByName("thing_id");
            loadProductDetail();
            increaseClickCountAndStats();
        });

        // URL에서 imageid 파라미터를 추출하는 함수
        function getParameterByName(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }
		
		
		
		document.getElementById("buyButton").addEventListener("click", function() {
			const quantity = document.getElementById("quantity").value;
		    if (thing_id) {
		        window.location.href = '/shop_buy?thing_id='+thing_id+'&quantity=' + quantity;;
		    } else {
		        alert("상품 정보가 없습니다.");
		    }
		});

        // 상품 상세 정보를 불러오는 함수
        function loadProductDetail() {
            const thing_id = getParameterByName("thing_id");
			
            // imageid가 없으면 경고를 띄우고 종료
            if (!thing_id) {
                alert("상품 정보가 없습니다.");
                return;
            }

            // 상품 정보를 서버에서 불러옴
            $.ajax({
                url: 'https://localhost:8588/api/products/detail?thing_id=' + thing_id,
                method: 'GET',
                contentType: 'application/json',
                success: function(product) {
                    // 상품 정보를 화면에 표시
                    document.getElementById('product-image').src = product.image_path;
                    document.getElementById('product-name').textContent = product.name;
                    document.getElementById('product-price').textContent = '가격: ' + product.price + '원';
                    document.getElementById('product-info').textContent = product.explain;
                    document.getElementById('total').textContent = product.price + '원';

                    // 수량에 따른 총 금액 계산
                    const quantityInput = document.getElementById('quantity');
                    const totalPrice = document.getElementById('total');
                    const pricePerItem = parseFloat(product.price); // 개당 가격

                    quantityInput.addEventListener('input', function() {
                        const quantity = parseInt(this.value);
                        totalPrice.textContent = (quantity * pricePerItem).toLocaleString() + '원';
                    });
                },
                error: function(xhr) {
                    alert("상품 정보를 불러올 수 없습니다: " + xhr.responseText);
                }
            });
        }
        
        
        function increaseClickCountAndStats() {
           console.log("클릭함");
			console.log(username);
			console.log(thing_id);
			
            $.ajax({
                url: 'https://localhost:8777/api/increaseClickCountAndStats',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({thing_id: thing_id, customerId: username }),
                success: function(response) {
                    console.log("클릭 및 통계가 업데이트되었습니다.");
                },
                error: function(xhr) {
                    console.error("클릭 및 통계 업데이트 실패: " + xhr.responseText);
                }
            });
        }

		// 모달 열기
		document.querySelector(".btn-cart").addEventListener("click", function() {
			
			const productId = getParameterByName("thing_id"); // 상품 ID 가져오기
			const priceText = document.getElementById('total').textContent;
			const price = parseInt(priceText.replace(/[^0-9]/g, ''));			
			const count = document.getElementById('quantity').value;
			const name = document.getElementById('product-name').textContent; // 상품 이름 가져오기
			const image_path = document.getElementById("product-image").src;
			
			$.ajax({
				url: 'https://localhost:8588/api/products/cart',
				method: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({customer_id: username ,thing_id: productId, price:price, num:count, name:name, image_path: image_path}),
				success: function() {
					document.querySelector(".modal").style.display = "block";
				},
				error: function(xhr, status, error) {
					console.error("Error details:", xhr.status,xhr.statusText,xhr.responseText,error); // 에러 상세 로그
					alert("장바구니에 담는데 실패 했습니다"); // 에러 메시지
				}
			});
		});

		// 모달 닫기
		document.querySelector(".close_btn").addEventListener("click", function() {
			document.querySelector(".modal").style.display = "none";
		});
		
		

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
