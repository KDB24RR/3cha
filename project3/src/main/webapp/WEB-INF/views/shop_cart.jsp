<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style2_cart.css">
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

    <!-- 장바구니 페이지 본문 -->
    
      <div class="me">
         <div class="me-content">
              <h1>장바구니</h1>
            <input type="checkbox" id="selectAll" checked>전체 선택</button>
            <button id="delete-select">선택삭제</button>      
            <hr>
         </div>
      </div>
      <div class="cart-container">
        <div class="cart-items" id="cart-items-container"></div> 
      <button id="buy">결제 하기</button>
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
            loadcart();
         document.getElementById("delete-select").addEventListener("click", deleteSelects);
         
         const selectAllCheckbox = document.getElementById("selectAll");
         
         selectAllCheckbox.addEventListener("change", function() {
            const itemCheckboxes = document.querySelectorAll(".item-checkbox");
                     itemCheckboxes.forEach(checkbox => {
                         checkbox.checked = selectAllCheckbox.checked;
                     });
                 });

               document.addEventListener("change", function(event) {
                       if (event.target.classList.contains("item-checkbox")) {
                           const itemCheckboxes = document.querySelectorAll(".item-checkbox");
                           selectAllCheckbox.checked = [...itemCheckboxes].every(cb => cb.checked);
                       }
                   });
         
        });

      //cart테이블 불러오기
function loadcart() {
    $.ajax({
        url: 'https://localhost:8588/api/products/cartlist',
        method: 'GET',
        contentType: 'application/json',
        data: { customer_id: username },
        success: function(products) {
            const cartItemsContainer = document.getElementById('cart-items-container');
            cartItemsContainer.innerHTML = '';
         // null 또는 빈 배열 처리
            if (!products || products.length === 0) {
                alert("장바구니에 물건이 없습니다.");
                return;
            }
            // 장바구니에 아이템 렌더링
            products.forEach((product) => {
                const productElement =
                    '<div class="cart-item" data-thing-id="' + product.thing_id + '">' +
                        '<input type="checkbox" class="item-checkbox" data-thing-id="' + product.thing_id + ' "checked>' +
                        '<div class="item-info">' +
                            '<img src="' + product.image_path + '" alt="product" class="item-image">' +
                            '<div class="item-details">' +
                                '<p class="item-name">' + product.name + '</p>' +
                                '<p class="item-price"> 가격 : ' + product.price + '원 </p>' +
                            '</div>' +
                            '<div class="item-quantity">' +
                                '<button class="decrease-btn">-</button>' +
                                '<span class="quantity">' + product.num + '</span>' +
                                '<button class="increase-btn">+</button>' +
                                '<button class="delete-btn">삭제</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>';

                cartItemsContainer.insertAdjacentHTML('beforeend', productElement);
                

                
            });
        },
        error: function(xhr) {
            alert("장바구니 정보를 가져오는 데 실패했습니다.");
        }
    });
}


      // 수량 감소 및 증가 버튼 이벤트
      $('#cart-items-container').on('click', '.decrease-btn', function() {         
          console.log("이제 더한다???")    
    	  updateCartQuantity.call(this, 1);
              
      });

      $('#cart-items-container').on('click', '.increase-btn', function() {         
              updateCartQuantity.call(this, 2);
      });

      $('#cart-items-container').on('click', '.delete-btn', function() {         
            deletecart.call(this);
      });
      

        // 수량 업데이트 함수
        function updateCartQuantity(btnid) {      
         const itemElement = $(this).closest('.cart-item');
         let currentQuantity = parseInt(itemElement.find('.quantity').text());
         let pricePerItem = parseInt(
        		    itemElement.find('.item-price').text().replace(/[^0-9]/g, ''),
        		    10
        		);
         const thing_id = itemElement.data('thing-id');
         
            $.ajax({
                url: 'https://localhost:8588/api/products/cartnum',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ customer_id: username, thing_id: thing_id, num: currentQuantity, price:pricePerItem, bid:btnid}),
                success: function(response) {
               loadcart();
                },
                error: function(xhr) {
                    alert("수량 업데이트에 실패했습니다.");
                }
            });
         
         
        }

      //cart삭제
      function deletecart() {      
    	  
         const itemElement = $(this).closest('.cart-item');
         const thing_id = itemElement.data('thing-id');
         console.log("들어오긴함");
         console.log(thing_id);
          $.ajax({
                 url: 'https://localhost:8588/api/products/deletecart',
                 method: 'POST',
                 contentType: 'application/json',
                 data: JSON.stringify({ customer_id: username, thing_id: thing_id}),
                 success: function(response) {
                  loadcart();
                 },
                 error: function(xhr) {
                      alert("상품을 삭제하지 못했습니다");
                      }
                  });
               
               
              }

            // 체크된 항목 삭제 함수
            const deleteSelects = () => {
                const selectedItems = document.querySelectorAll('.item-checkbox:checked');
                const thingId = Array.from(selectedItems).map(item => item.getAttribute('data-thing-id'));
                if (thingId.length === 0) {
                    alert("삭제할 항목을 선택하세요.");
                    return;
                }

                $.ajax({
                    url: 'https://localhost:8588/api/products/deletecarts',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ customer_id: username, thing_ids: thingId}),  // thingIds 배열을 JSON으로 전송
                    success: (response) => {
                        alert("선택한 항목이 삭제되었습니다.");
                        loadcart();
                    },
                    error: (xhr, status, error) => {
                        console.error("삭제 요청 실패:", error);
                        alert("삭제에 실패했습니다.");
                    }
                });
            };

            document.getElementById("buy").addEventListener("click", function() {
                const selectedItems = document.querySelectorAll('.item-checkbox:checked');
                const thingIds = Array.from(selectedItems).map(item => item.getAttribute('data-thing-id').trim());

                if (thingIds.length === 0) {
                    alert("구매할 항목을 선택하세요.");
                    return;
                }

                // 선택된 thing_id들을 URL 파라미터로 추가
                const url = 'shop_buy?thing_id='+thingIds.join(',')+'&from=product';
                window.location.href = url;
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
