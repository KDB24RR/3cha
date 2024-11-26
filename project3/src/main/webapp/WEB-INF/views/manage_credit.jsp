<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매 관리</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style0_credit.css">
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
    
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/manage">관리자 홈</a>
        <a href="${pageContext.request.contextPath}/manage_credit" class="active">구매 관리</a>
        <a href="${pageContext.request.contextPath}/company">상품 등록</a>
        <a href="${pageContext.request.contextPath}/manage_certification">활동 인증 관리</a>
        <a href="#">회원 관리</a>
    </div>
    
    
    <div class="title">
    

    <h1>구매내역</h1>
    <br>
    </div>
    
   
    <!-- 검색 필터 -->
    <div class="search-filter">
        <input type="date" id="startDate">
        <span>to </span>
        <input type="date" id="endDate">
        <input type="text" id="userId" placeholder="아이디">
        <button class="search-btn" onclick="searchTransactions()">검색</button>
    </div>

    <!-- 크레딧 거래내역 테이블 -->
    <table class="credit-table">
        <thead>
            <tr>
                <th>아이디</th>
                <th>구매 내역</th>
                <th>사용 크레딧</th>
                <th>취소</th>
            </tr>
        </thead>
        <tbody id="transactionTableBody">
            <!-- 거래 내역이 동적으로 추가될 부분 -->
        </tbody>
    </table>

    <!-- 페이지네이션 버튼 -->
    <div class="pagination" id="pagination"></div>

	<div class="title2">
    <hr>
    <h1>취소내역</h1>
    <br>
    </div>
    <!-- 검색 필터 -->
    <div class="search-filter1">
        <input type="date" id="startDate2">
        <span>to </span>
        <input type="date" id="endDate2">
        <input type="text" id="userId2" placeholder="아이디">
        <button class="search-btn" onclick="searchCancelTransactions()">검색</button>
    </div>

    <!-- 취소내역 테이블 -->
    <table class="cancel-table">
        <thead>
            <tr class="table-header">
                <th>아이디</th>
                <th>구매 내역</th>
                <th>사용 크레딧</th>
                <th>취소</th>
                
                
                
                
                
            </tr>
        </thead>
        <tbody id="cancelTableBody">
            <!-- 취소 내역이 동적으로 추가될 부분 -->
        </tbody>
    </table>

	<div id="confirmModal" class="modal">
	    <div class="modal-content">
	        <p>진짜 취소 하겠습니까?</p> 
	        <button id="cancelBtn">취소</button>
			<button id="confirmBtn">확인</button>



	    </div>
	</div>
	
    <!-- 페이지네이션 버튼 -->
    <div class="pagination" id="cancelPagination"></div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
<script>
    document.getElementById("confirmBtn").addEventListener("click", function () {
        // 두 개의 함수를 호출
        loadAllTransactions();
        loadAllCancelTransactions();
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
    
    <script>
		
		const confirmModal = document.getElementById('confirmModal');
		        let currentCustomerId, currentUsedCredits, currentTransactionDate;
				
		function showModal(customerId, usedCredits, transactionDate, isCancel) {
				currentCustomerId = customerId;
				currentUsedCredits = usedCredits;
				currentTransactionDate = transactionDate;
				confirmModal.style.display = 'block';
				
		}
				
		
        document.addEventListener("DOMContentLoaded", function() {
            const today = new Date();
            const formattedToday = today.toISOString().split('T')[0];
            document.getElementById('endDate').value = formattedToday;
            document.getElementById('endDate2').value = formattedToday;

            today.setMonth(today.getMonth() - 1);
            const formattedOneMonthAgo = today.toISOString().split('T')[0];
            document.getElementById('startDate').value = formattedOneMonthAgo;
            document.getElementById('startDate2').value = formattedOneMonthAgo;
        });

        const itemsPerPage = 5;
        let currentPage = 1;
        let cancelPage = 1;
        let transactionsData = [];
        let cancelTransactionsData = [];

        $(document).ready(function() {
            loadAllTransactions();
            loadAllCancelTransactions();
        });

        function loadAllTransactions() {
            $.ajax({
                url: "https://localhost:8587/api/transactions",
                method: "GET",
                success: function(data) {
					console.log("결제내역 전체 불러옴");
                    transactionsData = Array.isArray(data) ? data : [data];
					console.log(transactionsData);
                    renderPagination();
                    renderTransactions();
                },
                error: function(xhr, status, error) {
                    console.error("거래 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }

        function loadAllCancelTransactions() {
			console.log("전체 불러올수 있냐")
            $.ajax({
                url: "https://localhost:8587/api/cancel_transactiondate",
                method: "GET",
                success: function(data) {
					console.log("취소내역 전체 불러옴");
                    cancelTransactionsData = Array.isArray(data) ? data : [data];
					console.log(cancelTransactionsData);
                    renderCancelPagination();
                    renderCancelTransactions();
                },
                error: function(xhr, status, error) {
                    console.error("취소 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }

        function searchTransactions() {
            const startDate = $('#startDate').val();
            let endDate = $('#endDate').val();
            if (endDate) {
                let endDateObj = new Date(endDate);
                endDateObj.setDate(endDateObj.getDate() + 1);
                endDate = endDateObj.toISOString().split('T')[0];
            }
            const userId = $('#userId').val();

            $.ajax({
                url: "https://localhost:8587/api/transactions_search",
                method: "GET",
                data: { startDate, endDate, userId },
                success: function(data) {
                    transactionsData = Array.isArray(data) ? data : [data];
                    currentPage = 1;
                    renderPagination();
                    renderTransactions();
                },
                error: function(xhr, status, error) {
                    console.error("거래 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }

        function searchCancelTransactions() {
            const startDate = $('#startDate2').val();
            let endDate = $('#endDate2').val();
            if (endDate) {
                let endDateObj = new Date(endDate);
                endDateObj.setDate(endDateObj.getDate() + 1);
                endDate = endDateObj.toISOString().split('T')[0];
            }
            const userId = $('#userId2').val();

            $.ajax({
                url: "https://localhost:8587/api/cancel_transactions_search",
                method: "GET",
                data: { startDate, endDate, userId },
                success: function(data) {
                    cancelTransactionsData = Array.isArray(data) ? data : [data];
                    cancelPage = 1;
                    renderCancelPagination();
                    renderCancelTransactions();
                },
                error: function(xhr, status, error) {
                    console.error("취소 내역을 불러오는 중 오류 발생:", error);
                }
            });
        }

        function renderPagination() {
            const totalPages = Math.ceil(transactionsData.length / itemsPerPage);
            const pagination = $("#pagination");
            pagination.empty();
            for (let i = 1; i <= totalPages; i++) {
                const pageButton = $("<button>").text(i);
                if (i === currentPage) pageButton.addClass("active");
                pageButton.on("click", function() {
                    currentPage = i;
                    renderTransactions();
                    renderPagination();
                });
                pagination.append(pageButton);
            }
        }

        function renderCancelPagination() {
            const totalPages = Math.ceil(cancelTransactionsData.length / itemsPerPage);
            const cancelPagination = $("#cancelPagination");
            cancelPagination.empty();
            for (let i = 1; i <= totalPages; i++) {
                const pageButton = $("<button>").text(i);
                if (i === cancelPage) pageButton.addClass("active");
                pageButton.on("click", function() {
                    cancelPage = i;
                    renderCancelTransactions();
                    
                    renderCancelPagination();
                });
                cancelPagination.append(pageButton);
            }
        }

        function renderTransactions() {
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const transactionTableBody = $("#transactionTableBody");
            transactionTableBody.empty();
            transactionsData.slice(startIndex, endIndex).forEach(transaction => {
                const row = '<tr>' +
				        '<td>' + transaction.customerId + '</td>' +
				        '<td>' + transaction.transactionDate + '</td>' +
				        '<td>' + transaction.usedCredits + 'c</td>' +
				        '<td><button class="cancel-btn" onclick="cancel(\'' + transaction.customerId + '\', \'' + transaction.usedCredits + '\', \'' + transaction.transactionDate + '\')">취소</button></td>' +
				    '</tr>';
                transactionTableBody.append(row);
            });
        }
		
	   function cancel(a,b,c){
		     confirmModal.style.display = 'block'
			 
			 document.getElementById('confirmBtn').onclick = function() {
			      confirmModal.style.display = 'none';
			      cancelTransaction(a, b, c);
			 };

			             // 취소 버튼 클릭 이벤트
			 document.getElementById('cancelBtn').onclick = function() {
			       confirmModal.style.display = 'none';
			 };			 
	   }

       function renderCancelTransactions() {
            const startIndex = (cancelPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const cancelTableBody = $("#cancelTableBody");
            cancelTableBody.empty();
            cancelTransactionsData.slice(startIndex, endIndex).forEach(transaction => {
                const row = 
					'<tr>' +
				        '<td>' + transaction.customerId + '</td>' +
				        '<td>' + transaction.transactionDate + '</td>' +
				        '<td>' + transaction.usedCredits + 'c</td>' +
				        '<td><button class="cancel-btn" onclick="cancelcancel(\'' + transaction.customerId + '\', \'' + transaction.usedCredits + '\', \'' + transaction.transactionDate + '\')">취소</button></td>' +
				    '</tr>'				;
                cancelTableBody.append(row);
            });
        }
		
		function cancelcancel(a,b,c){
				     confirmModal.style.display = 'block'
					 
					 document.getElementById('confirmBtn').onclick = function() {
					      confirmModal.style.display = 'none';
					      Transactioncancel(a, b, c);
					 };

					             // 취소 버튼 클릭 이벤트
					 document.getElementById('cancelBtn').onclick = function() {
					       confirmModal.style.display = 'none';
					 };			 
			   }

        function cancelTransaction(customerId, usedCredits, transactionDate) {
            let isoDate = new Date(transactionDate).toISOString();
			console.log("취소 하러 왔다")
            $.ajax({
                url: "https://localhost:8587/api/cancel_transaction",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify({ customerId, usedCredits, transactionDate: isoDate }),
                success: function(response) {
                    if (response.success) {
                        alert("거래가 취소되었습니다.");
						loadAllCancelTransactions()
                        loadAllTransactions();
                    } else {
                        alert("거래 취소에 실패했습니다: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("거래 취소 중 오류 발생:", error);
                }
            });
        }
		
		function Transactioncancel(customerId, usedCredits, transactionDate) {
		            let isoDate = new Date(transactionDate).toISOString();
					console.log("취소 하러 왔다222")
		            $.ajax({
		                url: "https://localhost:8587/api/Transactioncancel",
		                method: "POST",
		                contentType: "application/json",
		                data: JSON.stringify({ customerId, usedCredits, transactionDate: isoDate }),
		                success: function(response) {
		                    if (response.success) {
		                        alert("거래가 취소되었습니다.");
		                        loadAllTransactions();
								loadAllCancelTransactions();
		                    } else {
		                        alert("거래 취소에 실패했습니다: " + response.message);
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error("거래 취소 중 오류 발생:", error);
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
