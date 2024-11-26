<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style4_detail.css">
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
               <a href="${pageContext.request.contextPath}/campaign_main">참여방법</a>
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
              
              <div class="form-container">
                     <h2>캠페인 참여 인증</h2>
                     <!-- 상품 등록 폼 -->
                     <form id="productForm">
                         <div>
                             <label for="name">이름</label>
                             <input type="text" id="name" name="name" required>
                         </div>
                         <div>
                             <label for="phone">전화번호</label>
                             <input type="text" id="phone" name="phone" required>
                         </div>
                         <div>
                             <label for="email">이메일 주소</label>
                             <input type="text" id="email" name="email" required>
                         </div>
                         
                         <div>
							<label>인증 사진 첨부</label>
							<td> <input type="file" name="uploadFile"> </td>
						</div>
						
						<button type="button" id="verifyButton">참여 인증</button>
                        
                        
                     </form>
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
                    // 페이지 로드 시 고객 정보 로드
                    $(document).ready(function() {
                        loadCustomers();
                    });

                    function loadCustomers() {
                         // 고객 정보 가져오기
                         $.ajax({
                             url: 'https://localhost:8888/api/customers/list', 
                             type: 'GET',
                             data: { name: username },
                             contentType: 'application/json',
                             success: function(customer) {
                                 document.getElementById('name').value  = customer.name;
                                 document.getElementById('phone').value = customer.tel;
                                 document.getElementById('email').value = customer.email;
                             }, 
                             error: function(xhr, status, error) {
                                 alert("고객 정보를 가져오는 데 실패했습니다: " + error); 
                             }
                         });
                    }
					
					
					$(document).ready(function() {
					    $('#verifyButton').on('click', function() {
					        console.log("AJAX 요청 시작"); // 요청 시작 확인
					        
					        const formData = new FormData();
					        formData.append('customer_id', username); 
					        
					        const fileInput = $('input[name="uploadFile"]')[0];
					        if (fileInput.files.length > 0) {
					            formData.append('uploadFile', fileInput.files[0]);
					            console.log("파일 추가됨"); // 파일 추가 확인
					        } else {
					            alert('이미지를 선택해 주세요.');
					            return;
					        }

					        $.ajax({
					            url: 'https://localhost:8388/api/campaign/accept',
					            method: 'POST',
					            processData: false,
					            contentType: false,
					            data: formData,
					            success: function(response) {
					                console.log("AJAX 요청 성공:", response); // 응답 성공 로그
					                if (response.success) {
					                    alert('캠페인 참여가 성공적으로 등록되었습니다: ' + response.message);
					                    window.location.href = '/campaign_main';
					                } else {
					                    alert('캠페인 참여 등록에 실패했습니다: ' + response.message);
					                }
					            },
					            error: function(xhr) {
					                console.error("AJAX 요청 실패:", xhr.responseText); // 오류 로그
					                alert('오류 발생: ' + xhr.responseText);
					            }
					        });
					    });
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
