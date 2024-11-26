<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>활동 인증 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style0_certification.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Schoolbell&display=swap" rel="stylesheet">
</head>

<body>
    <div class="navbar">
           <div class="logo">
            <a href="${pageContext.request.contextPath}/index">
               <img src="https://res.cloudinary.com/dhuybxduy/image/upload/v1730854684/logo_odbfxc.png" alt="logo" id="logo-image">
            </a>
           </div>
           <div class="nav-links">
               <a href="${pageContext.request.contextPath}/manage" >관리자 홈</a>
               <a href="${pageContext.request.contextPath}/manage_credit">구매 관리</a>
               <a href="${pageContext.request.contextPath}/company" class="active">상품 등록</a>
               <a href="${pageContext.request.contextPath}/manage_certification">활동 인증 관리</a>
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

    <div class="content">
        <h2>활동 인증 관리</h2>
        <table class="certification-table">
            <thead>
                <tr>
                    <th>인증 이미지</th>
                    <th>고객 ID</th>
                    <th>인증 날짜</th>
                    <th>작업</th>
                </tr>
            </thead>
            <tbody>
                <!-- 동적으로 생성될 행은 여기에 추가됩니다. -->
            </tbody>
        </table>
    </div>

    <div id="confirmationModal" class="modal" style="display: none;">
        <div class="modal-content">
            <h3>승인 완료</h3>
            <p>크레딧이 100만큼 추가되었습니다.</p>
            <button id="confirmButton">확인</button>
        </div>
    </div>
    
       <div class="sidebar">
        <a href="${pageContext.request.contextPath}/manage" >관리자 홈</a>
        <a href="${pageContext.request.contextPath}/manage_credit">구매 관리</a>
        <a href="${pageContext.request.contextPath}/company">상품 등록</a>
        <a href="${pageContext.request.contextPath}/manage_certification" class="active">활동 인증 관리</a>
        <a href="#">회원 관리</a>
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
	    let currentCertificationDate; // 현재 승인할 인증 날짜를 저장할 변수
	    let currentRow; // 현재 승인할 행을 저장할 변수

	    document.addEventListener('DOMContentLoaded', function() {
	        loadCampaignAccepts();

	        // 모달 확인 버튼 클릭 이벤트
	        document.getElementById("confirmButton").onclick = function() {
	            approveCertification(currentCertificationDate, currentRow); // 승인 처리
	            document.getElementById("confirmationModal").style.display = "none"; // 모달 닫기
	        };
	    });

	    function loadCampaignAccepts() {
	    	
	    	$('.sidebar a').each(function () {
	            if (this.href === window.location.href) {
	                $(this).addClass('active');
	            }
	        });

	        $('.sidebar a').click(function () {
	            $('.sidebar a').removeClass('active');
	            $(this).addClass('active');
	        });
	        
	        $.ajax({
	            url: 'https://localhost:8388/api/campaign/certification',
	            type: 'GET',
	            contentType: 'application/json',
	            success: function(data) {
	                console.log("AJAX 호출 성공:", data); // 성공 로그
	                const tbody = document.querySelector('.certification-table tbody');
	                tbody.innerHTML = ''; // 기존 데이터를 비움
	                
	                data.forEach(function(item) {
	                    // 클라이언트에서 날짜 변환
	                    const certificationDateUTC = new Date(item.certificationDate); // UTC
	                    const options = {
	                        timeZone: 'Asia/Seoul', 
	                        year: 'numeric', 
	                        month: '2-digit', 
	                        day: '2-digit', 
	                        hour: '2-digit', 
	                        minute: '2-digit', 
	                        second: '2-digit'
	                    };
	                    const seoulDateString = certificationDateUTC.toLocaleString('ko-KR', options); // 서울 시간대로 변환
	                    
	                    const row = document.createElement('tr');
	                    
	                    // 인증 이미지 셀
	                    const imgCell = document.createElement('td');
	                    const img = document.createElement('img');
	                    img.src = item.campaignImage; // 이미지 경로 설정
	                    img.alt = "인증 이미지";
	                    img.width = 300; // 너비 설정
	                    img.height = 500; // 높이 설정
	                    imgCell.appendChild(img);
	                    
	                    // 고객 ID 셀
	                    const customerIdCell = document.createElement('td');
	                    customerIdCell.textContent = item.customerId; // 고객 ID 설정
	                    
	                    // 인증 날짜 셀 (변환된 날짜로 수정)
	                    const certificationDateCell = document.createElement('td');
	                    certificationDateCell.textContent = seoulDateString; // 변환된 인증 날짜 설정
	                    
	                    // 작업 셀
	                    const actionCell = document.createElement('td');
	                    const approveButton = document.createElement('button'); // approveButton 생성
	                    approveButton.className = "approve-btn"; // 클래스 추가
	                    approveButton.textContent = "승인"; // 버튼 텍스트 설정

	                    approveButton.onclick = function() {
	                        currentCertificationDate = item.certificationDate; // 인증 날짜 저장
	                        currentRow = row; // 행 저장
	                        showConfirmationModal(); // 모달 표시
	                    };

	                    const rejectButton = document.createElement('button');
	                    rejectButton.className = "reject-btn";
	                    rejectButton.textContent = "반려";
	                    actionCell.appendChild(approveButton); // 작업 셀에 approveButton 추가
	                    actionCell.appendChild(rejectButton); // 작업 셀에 rejectButton 추가
	                    
	                    // 행에 셀 추가
	                    row.appendChild(imgCell);
	                    row.appendChild(customerIdCell);
	                    row.appendChild(certificationDateCell);
	                    row.appendChild(actionCell);
	                    
	                    // tbody에 새로운 행 추가
	                    tbody.appendChild(row);
	                });
	            },
	            error: function(xhr, status, error) {
	                console.error("AJAX 호출 실패:", error); // 실패 로그
	                alert("데이터를 가져오는 데 실패했습니다: " + error);
	            }
	        });
	    }

	    function showConfirmationModal() {
	        document.getElementById("confirmationModal").style.display = "block"; // 모달 표시
	    }

	    function approveCertification(certificationDate, row) {
	        const customerId = row.querySelector('td:nth-child(2)').textContent; // 고객 ID 추출

	        $.ajax({
	            url: 'https://localhost:8388/api/campaign/certification',
	            type: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify({
	                customerId: customerId,
	                certificationDate: certificationDate // 서버에 인증 날짜 전달
	            }),
	            success: function(response) {
	                console.log("인증 승인 성공:", response);
	                if (response.success) {
	                    alert(response.message); // 승인 성공 메시지 표시
	                    row.remove(); // 승인된 행을 테이블에서 제거
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error("인증 승인 실패:", error);
	                alert("인증 승인에 실패했습니다.");
	            }
	        });
	    }
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
