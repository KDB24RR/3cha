<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage mode</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style0.css">
    <link href="https://fonts.googleapis.com/css2?family=Schoolbell&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
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
        <a href="${pageContext.request.contextPath}/manage" class="active">관리자 홈</a>
        <a href="${pageContext.request.contextPath}/manage_credit">구매 관리</a>
        <a href="${pageContext.request.contextPath}/company">상품 등록</a>
        <a href="${pageContext.request.contextPath}/manage_certification">활동 인증 관리</a>
        <a href="#">회원 관리</a>
    </div>


    <!-- 차트들이 포함된 직사각형 틀 -->
    <div class="chart-box">
    <!-- 차트들을 가로로 나란히 배치 -->
    <div class="chart-row">
        <div id="chart-container1" class="chart-container"></div>
        <div id="chart-container3" class="chart-container"></div>
        <div id="chart-container4" class="chart-container"></div>
    </div>
    <!-- 월별 가입자 차트 (가장 아래 위치) -->
    <div id="chart-container2" class="chart-container"></div>
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

    
    <!-- 월별 가입자 차트 (가장 아래 위치) -->
    

    <!-- JavaScript for Chart -->
    <script>
    $(document).ready(function () {
    	$('.sidebar a').each(function () {
            if (this.href === window.location.href) {
                $(this).addClass('active');
            }
        });

        $('.sidebar a').click(function () {
            $('.sidebar a').removeClass('active');
            $(this).addClass('active');
        });

    	
        // 클릭 횟수가 가장 많은 상품 Top 4 데이터를 가져오기 위한 AJAX 호출
        $.ajax({
            url: 'https://localhost:8777/api/topClickCountItems',
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                console.log("Received data:", data);

                // 데이터 포인트에 thingId를 포함시킵니다.
                const dataPoints = data.map(item => ({
                    name: item.name,
                    y: item.clickCount,
                    thingId: item.thingId // thingId 정보를 추가합니다.
                }));

                Highcharts.chart('chart-container1', {
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: '클릭 횟수 TOP'
                    },
                    xAxis: {
                        categories: data.map(item => item.name),
                        title: {
                            text: '상품 이름'
                        }
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: '클릭 횟수'
                        }
                    },
                    series: [{
                        name: '클릭 횟수',
                        data: dataPoints.map((point, index) => ({
                            y: point.y,
                            color: index === 0 ? '#79E0EE' : index === 1 ? '#98EECC' : '#D0F5BE', // 각 막대의 색상을 다르게 지정 (예: 파랑, 빨강, 초록)
                            thingId: point.thingId,
                            name: point.name
                        }))
                    }],
                    plotOptions: {
                        series: {
                            cursor: 'pointer',
                            point: {
                                events: {
                                    click: function () {
                                        // thingId를 직접 사용하여 demographics 데이터를 가져옵니다.
                                        getDemographicsData(this.options.thingId);
                                    }
                                }
                            }
                        }
                    }
                });
            },
            error: function (xhr, status, error) {
                console.error('차트 데이터를 가져오는 중 오류가 발생했습니다: ' + error);
            }
        });

        // 성비와 나이대 데이터를 가져오는 함수
        function getDemographicsData(thingId) {
            console.log('Demographics request URL:', 'https://localhost:8777/api/getProductDemographics?thingId=' + encodeURIComponent(thingId));
            $.ajax({
                url: 'https://localhost:8777/api/getProductDemographics?thingId=' + encodeURIComponent(thingId),
                method: 'GET',
                dataType: 'json',
                success: function (data) {
                    console.log("Received demographics data:", data);

                    const genderData = [
                        { name: '남성', y: data.MAN_COUNT },
                        { name: '여성', y: data.WOMAN_COUNT }
                    ];

                    const ageData = [
                        { name: '10대', y: data.TEENAGER_COUNT},
                        { name: '20-40대', y: data.MIDDLEAGED_COUNT},
                        { name: '기타', y: data.ELSEAGE_COUNT}
                    ];

                    // 성비 원형 차트 생성
                    Highcharts.chart('chart-container3', {
                        chart: {
                            type: 'pie'
                        },
                        title: {
                            text: '클릭 성비'
                        },
                        plotOptions: {
                            pie: {
                                size: '60%',  // 파이 차트 크기를 전체 차트의 60%로 설정
                                innerSize: '20%',  // 도넛형으로 변경하고 내부 크기 설정
                                dataLabels: {
                                    enabled: true,
                                    format: '{point.percentage:.1f} %', // 데이터 레이블 형식
                                    style: {
                                        color: '#000000',  // 텍스트 색상
                                        fontSize: '12px'
                                    }
                                }
                            }
                        },
                        series: [{
                            name: '성비',
                            colorByPoint: true,
                            data: [
                                { name: '남성', y: data.MAN_COUNT, color: '#3498db' },  // 남성 색상 지정 (예: 파란색)
                                { name: '여성', y: data.WOMAN_COUNT, color: '#e74c3c' } // 여성 색상 지정 (예: 빨간색)
                            ]
                        }]
                    });

                    // 나이대 원형 차트 생성
                    Highcharts.chart('chart-container4', {
                        chart: {
                            type: 'pie'
                        },
                        title: {
                            text: '클릭 나이대'
                        },
                        series: [{
                            name: '나이대',
                            colorByPoint: true,
                            data: [
                            	 { name: '10대', y: data.TEENAGER_COUNT, color: '#79E0EE' },  // 10대 색상 지정 (예: 청록색)
                                 { name: '20-30대', y: data.MIDDLEAGED_COUNT, color: '#98EECC' }, // 20-40대 색상 지정 (예: 보라색)
                                 { name: '기타', y: data.ELSEAGE_COUNT, color: '#D0F5BE' } 
                            	
                            ]
                        
                        }]
                    });
                },
                error: function (xhr, status, error) {
                    console.error('성비 및 나이대 데이터를 가져오는 중 오류가 발생했습니다: ' + error);
                }
            });
        }

        // 월별 가입자 수 데이터를 가져오기 위한 AJAX 호출 (가장 아래에 위치)
        $.ajax({
            url: 'https://localhost:8777/api/monthlySignupCount',
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                console.log("Received monthly signup data:", data);

                // 데이터 가공: 대문자로 된 키 이름을 그대로 사용합니다.
                const months = data.map(item => item.SIGNUP_MONTH);
                const signupCounts = data.map(item => item.SIGNUP_COUNT);

                console.log("Months:", months);
                console.log("Signup Counts:", signupCounts);

                Highcharts.chart('chart-container2', {
                    chart: {
                        type: 'line'
                    },
                    title: {
                        text: '월별 가입자 수'
                    },
                    xAxis: {
                        categories: months,
                        title: {
                            text: '월'
                        }
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: '가입자 수'
                        }
                    },
                    series: [{
                        name: '가입자 수',
                        data: signupCounts
                    }]
                });
            },
            error: function (xhr, status, error) {
                console.error('월별 가입자 수 데이터를 가져오는 중 오류가 발생했습니다: ' + error);
            }
        });
    });
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
