<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style3_modify.css">
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




<div id="logoutModal" class="modal1">
    	<div class="modal-content1">
        <p>로그아웃 하시겠습니까?</p>
        <button id="cancelLogout" class="modal-btn1">취소</button>
        <button id="confirmLogout" class="modal-btn1">확인</button>
    	</div>
		</div>


    <div class="container">
        <div class="sidebar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/mypage">주문 조회</a></li>
                <li><a href="#">크레딧 사용 현황</a></li>
                <li><a href="#">취소/교환/반품</a></li>
                <li><a href="#">1:1 문의</a></li>
                <li><a href="#">친환경 참여 활동</a></li>
                <li class="active"><a href="#">회원 정보 수정</a></li>
            </ul>
        </div>

        <div class="main-content">
        
           <!-- 프로필 섹션 -->
           <div class="profile-title-section">
             <table class="profile-title-table">
                 <tr>
                     <td class="profile-title-cell">프로필</td>
                 </tr>
             </table>
         </div>
           
           
            <div class="profile-section">
                <table class="profile-table">
                    <tr>
                        <td rowspan="2" class="profile-image-cell">
                            <img src="https://ipfs.io/ipfs/QmaQ2t3bJJKXYq8uuCy4LpyQnw2DPiX2oaDn2ZxgtdcacA" alt="Profile Image" class="profile-image">
                        </td>
                        <td class="profile-email" id="profileEmail"></td>
                    </tr>
                    <tr>
                        <td class="profile-name" id="profileName"></td>
                    </tr>
                </table>
            </div>
        
       <div class="main-section">
            <h2>회원 정보 수정</h2>
            
                <table class="info-edit-table">
               <input type="hidden" id="customer_id" value="">
                    <tr>
                        <td>이름</td>
                        <td>
                            <input type="text" id="name" class="input-name" placeholder="변경할 이름">
                            <button type="submit" class="btn1"">변경</button>
                        </td>
                    </tr>
                    <tr>
                        <td>이메일</td>
                        <td>
                            <input type="email" id="email" class="input-email" placeholder="변경할 이메일 주소">
                            <button type="submit" class="btn2">변경</button>
                        </td>
                    </tr>
                    <tr>
                        <td>휴대폰 번호</td>
                        <td>
                            <input type="text" id="phone" class="input-phone" placeholder="변경할 휴대폰 번호 (010-xxxx-xxxx)">
                            <button type="submit" class="btn3">변경</button>
                        </td>
                    </tr>
                    <tr>
                        <td>비밀번호 변경</td>
                        <td>
                            <input type="password" id="current_password" class="current_password" placeholder="현재 비밀번호"><br>
                            <input type="password" id="new_password" class="new_password" placeholder="새 비밀번호"><br>
                            <input type="password" id="confirm_password" class="confirm_password" placeholder="새 비밀번호 확인"><br>
                            <button class="btn4" type="submit">변경</button>
                        </td>
                    </tr>
                </table>
        </div>
    </div>
   <div id="passwordModal" class="modal">
           <div class="modal-content">
                <div class="modal-left">
            <img src="https://ipfs.io/ipfs/QmdygQJCXNnx5c5zMzVkegneDq9AU1KSxTAF4ybmsUFfeV" alt="Image" class="modal-image" id="modalImage">
        </div>
        <div class="modal-right">
            <h3>비밀번호 확인</h3>
            <input type="password" id="modal_password" placeholder="비밀번호를 입력하세요">
            <button id="password_confirm_btn" class="small-btn">확인</button>
        </div>
    </div>
</div>
       
       
   <div class="customer-grid">
       <script>
       
       const modal = document.getElementById('passwordModal');
       
       document.addEventListener("DOMContentLoaded", function() {
          console.log("DOMContentLoaded event fired");
          // 페이지 로드 시 모달 열기
           
          if (modal){
             modal.style.display = 'block';    
             console.log("모달 오픈 성공")
          }else {
             console.log("모달 요소 찾지 모함")
          }
           

           // 비밀번호 확인 버튼 클릭 이벤트
          document.getElementById('password_confirm_btn').addEventListener('click', checkPassword);
       });
       
       function checkPassword() {
               const inputPassword = document.getElementById('modal_password').value;

               if (!inputPassword) {
                   alert("비밀번호를 입력하세요.");
                   return;
               }
               console.log("하이하이요");

               // 서버로 비밀번호 확인 요청
             // 서버로 비밀번호 확인 요청
               $.ajax({
                   url: 'https://localhost:8888/api/customers/verifyPassword', 
                   type: 'POST',
                   contentType: 'application/json',
                   
                   headers: {
                       'username': username // 헤더에 username 추가
                   },
                   
                   data: JSON.stringify({modal_password : inputPassword }),
                   success: function(response) {
                       if (response.valid) {                          
                           const imageElement = document.getElementById("modalImage");
                           imageElement.src = "https://ipfs.io/ipfs/QmYJuEurvbdsba43VbxDjbVAa3q2zTPwJeWYMU6L86SwW5"; // 새로운 이미지 경로                        
                           setTimeout(function() {
 
                               modal.style.display = 'none';
                               console.log("넘어 갑니다");
                               loadCustomers();
                           }, 500); // 1000ms = 1초
                       } else {
                           alert("비밀번호가 올바르지 않습니다");
                       }
                   },
                   error: function(xhr, status, error) {
                       if (xhr.status === 401) {
                            const errorResponse = JSON.parse(xhr.responseText);
                            alert(errorResponse.message); 
                        } else {
                            alert("유효하지 않은 요청입니다: " + error);
                        }
                        
                    }
               });
           }
       


   function loadCustomers() {
	   console.log("냠하");
	   console.log(username);
       // 고객 정보 가져오기
       $.ajax({
       url: 'https://localhost:8888/api/customers/list', 
       type: 'GET',
       data: { customer_id: username},
       contentType: 'application/json',
       success: function(customer) {
           document.getElementById('name').value  = customer.name;
           document.getElementById('email').value = customer.email;
           document.getElementById('phone').value = customer.tel;  
           document.getElementById('profileName').textContent  = customer.name;
           document.getElementById('profileEmail').textContent  = customer.email;
       }, 
       error: function(xhr, status, error) {
           alert("고객 정보를 가져오는 데 실패했습니다: " + error); 
       }
   });
   }

   document.querySelector('.btn1').addEventListener('click', function() {
       const newName = document.getElementById('name').value;
       const customerId = $('#customer_id').val(); 

    
       if (!newName) {
           alert("이름을 입력하세요.");
           return;
       }

       // 서버로 이름 변경 요청
       $.ajax({
           url: 'https://localhost:8888/api/customers/updateInfo', 
           type: 'PUT',
           contentType: 'application/json',
           data: JSON.stringify({customer_id: username, name: newName}),
           success: function(response) {
               alert("이름이 성공적으로 변경되었습니다.");
           },
           error: function(xhr, status, error) {
               alert("이름 변경에 실패했습니다: " + error); 
           }
       });
   });
   

   //이메일 변경 버튼 클릭 이벤트 update-email
   document.querySelector('.btn2').addEventListener('click', function() {
       const newEmail = document.getElementById('email').value;
       const customerId = $('#customer_id').val(); 
    
       if (!newEmail) {
           alert("이메일을 입력하세요.");
           return;
       }

       // 서버로 이메일 변경 요청
       $.ajax({
           url: 'https://localhost:8888/api/customers/updateInfo', 
           type: 'PUT',
           contentType: 'application/json',
           data: JSON.stringify({customer_id: username, email : newEmail}),
           success: function(response) {
               alert("이메일 정보가 성공적으로 변경되었습니다.");
           },
           error: function(xhr, status, error) {
               alert("이메일 정보 변경에 실패했습니다: " + error); 
           }
       });
   });


   //전화번호 변경 버튼 클릭 이벤트
   document.querySelector('.btn3').addEventListener('click', function() {
      const newPhone = document.getElementById('phone').value;
       const customerId = $('#customer_id').val(); 
    
       if (!newPhone) {
           alert("전화번호를 입력하세요.");
           return;
       }

       // 서버로 전화번호 변경 요청
       $.ajax({
           url: 'https://localhost:8888/api/customers/updateInfo', 
           type: 'PUT',
           contentType: 'application/json',
           data: JSON.stringify({customer_id: username, tel : newPhone}),
           success: function(response) {
               alert("전화번호 정보가 성공적으로 변경되었습니다.");
           },
           error: function(xhr, status, error) {
               alert("전화번호 정보 변경에 실패했습니다: " + error); 
           }
       });
   });


   document.querySelector('.btn4').addEventListener('click', function() {
	      const currentPassword = document.getElementById('current_password').value;
	      const newPassword = document.getElementById('new_password').value;
	      const confirmPassword = document.getElementById('confirm_password').value;
	      const customerId = username
	      
	      if(!currentPassword || !newPassword || !confirmPassword) {
	         alert("모든 필드를 입력하세요");
	         return;
	      }
	      
	      if (newPassword !== confirmPassword){
	         alert("새로운 비밀번호가 일치하지 않습니다");
	         return;
	      }
	      
	      $.ajax({
	    	    url: 'https://localhost:8888/api/customers/updatePassword',
	    	    type: 'PUT',
	    	    contentType: 'application/json',
	    	    data: JSON.stringify({
	    	        customer_id: username,
	    	        current_password: currentPassword,
	    	        new_password: newPassword
	    	    }),
	    	    success: function(response) {
	    	        alert("비밀번호가 성공적으로 변경되었습니다");
	    	    },
	    	    error: function(xhr, status, error) {
	    	        alert("현재 비밀번호가 올바르지 않습니다");  
	    	    }
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
    
   
   
    </div>
    
</body>
</html>
