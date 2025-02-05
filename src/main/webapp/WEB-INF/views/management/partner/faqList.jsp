<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/quill/dist/quill.snow.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/quill/dist/quill.js"></script>

<style>
.table th {
   text-align: center;
}

.table td {
   text-align: center;
}

.hoverEffect {
    cursor: pointer; /* 커서가 포인터로 변경됩니다. */
}
</style>


<%!
    // 숫자를 영어 단어로 변환하는 메서드 (1-50)
    public String numberToWords(int num) {
        String[] belowTwenty = {"", "one", "two", "three", "four", "five", "six", "seven", "eight",
                                "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
                                "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"};
        String[] tens = {"", "", "twenty", "thirty", "forty", "fifty"};

        if (num <= 0 || num > 50) {
            return "";
        } else if (num < 20) {
            return belowTwenty[num];
        } else {
            int tenPlace = num / 10;
            int unitPlace = num % 10;
            return tens[tenPlace] + (unitPlace != 0 ? belowTwenty[unitPlace] : "");
        }
    }
%>

<%
    // numberWords 배열 생성 (1부터 50까지)
    String[] numberWords = new String[50];
    for (int i = 0; i < 50; i++) {
        numberWords[i] = numberToWords(i + 1);
    }

    // 배열을 페이지 컨텍스트에 설정
    pageContext.setAttribute("numberWords", numberWords);
%>

<!-- 등록/수정 모달 -->
<div class="modal fade" id="editFaqModal" tabindex="-1" aria-labelledby="editFaqLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header d-flex align-items-center">
        <div id="editFaqLabel" style="display: none">
	        <h4 class="modal-title">FAQ 수정</h4>
        </div>
        <div id="addFaqLabel" style="display: none">
	        <h4 class="modal-title">FAQ 등록</h4>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
	    <input type="hidden" id="editFaqNo" name="faqNo">
	    <div class="mb-3">
	      <label for="editFaqCategory" class="form-label">카테고리</label>
	      <select class="form-select" id="editFaqCategory" name="faqCategory">
            <option value="계약 및 협력">계약 및 협력</option>
            <option value="정책 및 규정">정책 및 규정</option>
            <option value="지불 및 정산">지불 및 정산</option>
            <option value="커뮤니케이션">커뮤니케이션</option>
          </select>
	    </div>
	    <div class="mb-3">
	        <label for="editFaqTitle" class="form-label">제목</label>
	        <input type="text" class="form-control" id="editFaqTitle" name="faqTitle" value="" required>
	    </div>
	    <div class="mb-3">
	        <label for="editFaqAnswer" class="form-label">답변</label>
	        <textarea class="form-control" id="editFaqAnswer" name="faqAns" rows="3" required></textarea>
	    </div>
	    <div align="right">
		    <button type="button" class="btn btn-primary" id="faqAdd" style="display: none">등록</button>
		    <button type="button" class="btn btn-primary" id="faqUpdate" style="display: none">수정</button>
	    </div>
      </div>
    </div>
  </div>
</div>
<!-- 등록/수정 모달 끝 -->

<div class="body-wrapper">
   <div class="container-fluid">
      <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
         <div class="card-body px-4 py-3">
           <div class="row align-items-center" style="margin-top:20px;">
             <div class="col-9">
               <h4 class="fw-semibold mb-8">QnA / FAQ</h4>
               <nav aria-label="breadcrumb">
                 <ol class="breadcrumb">
                   <li class="breadcrumb-item">
                     <a class="text-muted text-decoration-none" href="../main/index.html">DashBoard</a>
                   </li>
                   <li class="breadcrumb-item" aria-current="page">QnA / FAQ</li>
                 </ol>
               </nav>
             </div>
             <div class="col-3">
               <div class="text-center mb-n4">
                 <img src="${pageContext.request.contextPath }/resources/assets/images/logos/symbol-01.png" alt="modernize-img" class="img-fluid" style="width: 120px; height: auto;">
               </div>
             </div>
           </div>
         </div>
      </div>
      
		<div class="card">
		    <div class="card-body text-center">
		        <span class="hoverEffect" id="ptQna" style="margin-right: 15px;">QnA</span>
		        <span class="serviceCenterBar " style="margin-right: 15px;"> | </span>
		        <span class="hoverEffect" style="color: black; text-decoration: underline; font-weight: bold; text-underline-offset: 5px;" id="ptFaq">FAQ</span>
		    </div>
		</div>

      
        <div class="card w-100 position-relative overflow-hidden">
            <div class="card-body p-4">
				<!-- FAQ 영역 시작 -->
			    <div class="row justify-content-center" id="UNfaqArea">
			      <div class="text-center mb-7"></div>
			      <div class="col-lg-10">
			        <div class="accordion accordion-flush mb-5 card position-relative overflow-hidden" id="accordionFlushExample">
			          <c:choose>
			            <c:when test="${empty faqList}">등록된 FAQ 내역이 존재하지 않습니다.</c:when>
			            <c:otherwise>
			              <c:forEach items="${faqList}" var="faq" varStatus="status">
			                <c:set var="numWord" value="${numberWords[status.index]}"/>
			                <div class="accordion-item">
			                  <h2 class="accordion-header" id="flush-heading${numWord}">
			                    <button class="accordion-button collapsed fs-4 fw-semibold shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse${numWord}" aria-expanded="false" aria-controls="flush-collapse${numWord}">
			                      [${faq.faqCategory}] ${faq.faqTitle}
			                    </button>
			                  </h2>
			                  <div id="flush-collapse${numWord}" class="accordion-collapse collapse" aria-labelledby="flush-heading${numWord}" data-bs-parent="#accordionFlushExample">
			                    <div class="accordion-body fw-normal">
			                      ${faq.faqAns}
			                      <div align="right">
			                        <button class="btn btn-primary editFaq" data-no="${faq.faqNo}" data-category="${faq.faqCategory}" data-title="${faq.faqTitle}" data-answer="${faq.faqAns}">수정</button>
			                      	<button type="button" class="btn btn-danger deleteFaq" data-no="${faq.faqNo}">삭제</button>
			                      </div>
			                    </div>
			                  </div>
			                </div>
			              </c:forEach>
			            </c:otherwise>
			          </c:choose>
			        </div>
			        <div align="right">
				        <button class="btn btn-primary" id="faqAddModal">FAQ 작성</button>
			        </div>
			      </div>
			    </div>
			    <!-- FAQ 영역 끝 -->
            </div>
        </div>
   </div>
</div>



<script type="text/javascript">
$(function(){
	var qna = $("#ptQna");
	var faq = $("#ptFaq");
	
	
	qna.on("click", function(){
		location.href="/management/partner/qna/qnaList"
	});
	
	faq.on("click", function(){
		location.href="/management/partner/faq/faqList";
	});
});


///////////////////////////////////////////////////////////

$(function(){
	var faqNo;
	var faqTitle;
	var faqAnswer;
	var faqCategory;
	
	// 등록 버튼
	$('#faqAddModal').on('click', function(){
		
		// 모달 창 / 등록버튼 띄우기
		$('#editFaqLabel').hide();
		$('#faqUpdate').hide();
		$('#addFaqLabel').show();
		$('#faqAdd').show();
	    $('#editFaqModal').modal('show');
	});
	
	// 모달창 닫으면 기존 입력값 삭제
	$(document).on('hidden.bs.modal', '#editFaqModal', function () {
		$(this).find('input[type="text"], textarea').val('');
	});
	
	$('.editFaq').on('click', function() {
	    faqNo = $(this).data('no');
	    faqTitle = $(this).data('title');
	    faqAnswer = $(this).data('answer');
	    faqCategory = $(this).data('category');

	    // 모달 창에 데이터 삽입
	    $('#editFaqNo').val(faqNo);
	    $('#editFaqTitle').val(faqTitle);
	    $('#editFaqAnswer').val(faqAnswer);
	    $('#editFaqCategory').val(faqCategory);
	
	    // 모달 창 / 수정버튼 띄우기
	    $('#addFaqLabel').hide();
	    $('#editFaqLabel').show();
	    $('#faqUpdate').show();
	    $('#faqAdd').hide();
	    $('#editFaqModal').modal('show');
	});
	
	$(document).on('click', '.deleteFaq', function(e){

		var faqNo = $(this).data('no');  // 클릭된 버튼에서 faqNo 가져오기
        
        var formDataDel = {
            faqNo : faqNo
        };
		
		Swal.fire({
 		   title: '삭제 처리',
 		   text: '삭제를 진행하시겠습니까?',
 		   icon: 'warning',
 		   
 		   showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
 		   confirmButtonText: '확인', // 확인 버튼 텍스트 변경
 		   cancelButtonText: '취소', // 취소 버튼 텍스트 변경
 		   customClass: {
                cancelButton: 'btn btn-outline-primary', // 취소 버튼에 Bootstrap 클래스 추가
                confirmButton: 'btn btn-primary me-2' // 확인 버튼에 Bootstrap 기본 클래스 추가 (선택 사항)
            },
            buttonsStyling: false // SweetAlert2의 기본 버튼 스타일 비활성화
 		   
		}).then(result => {
		   // 만약 Promise리턴을 받으면,
		   if (result.isConfirmed) { // 만약 모달창에서 confirm 버튼을 눌렀다면
		   
			   $.ajax({
				    url: '/management/partner/faq/faqDelete',
				    method: 'GET',
				    data: {
				    	faqNo : faqNo
				    },
		            success: function(res) {
		            	if(res === "SUCCESS"){
		            		Swal.fire(
				                    '삭제 완료',
				                    '삭제가 완료되었습니다!',
				                    'success'
				                ).then(() => {
				                	location.reload();
				                });
		            	} else {
		            		Swal.fire(
			                        '오류',
			                        '삭제 처리에 실패했습니다.',
			                        'error'
			                );
		            	}
		            	
		            },
		            error: function(xhr, status, error) {
		            	Swal.fire(
		                        '오류',
		                        '삭제 처리에 실패했습니다.',
		                        'error'
		                );
		            }
		        });
		   }
		});
	});
	 
	 
	// 등록 버튼 이벤트
	$('#faqAdd').on('click', function(e){
		e.preventDefault();
		
	    var formData = {
	    		faqTitle : $('#editFaqTitle').val(),
	    		faqAns : $('#editFaqAnswer').val(),
	    		faqCategory : $('#editFaqCategory').val()
	    }
	
	    // AJAX 요청으로 등록 처리
	    $.ajax({
	        url: '/management/partner/faq/faqRegister',
	        method: 'POST',
	        data: JSON.stringify(formData),
	        contentType : 'application/json; charset=utf-8', 
	        success: function(response) {
	        	// 성공적으로 등록되었을 때
                Swal.fire(
                    '등록 완료',
                    '등록이 완료되었습니다!',
                    'success'
                ).then(() => {
                	location.reload();
                });
	        },
	        error: function(xhr, status, error) {
	        	Swal.fire(
                        '오류',
                        '등록 처리에 실패했습니다.',
                        'error'
                );
	        }
	    });
	});
	
	// 수정 버튼 이벤트
	$('#faqUpdate').on('click', function(e){
		e.preventDefault();
		
	    var formData = {
	    		faqNo : faqNo,
	    		faqTitle : $('#editFaqTitle').val(),
	    		faqAns : $('#editFaqAnswer').val(),
	    		faqCategory : $('#editFaqCategory').val()
	    }
	
	    // AJAX 요청으로 수정 처리
	    $.ajax({
	        url: '/management/partner/faq/faqUpdate',
	        method: 'POST',
	        data: JSON.stringify(formData),
	        contentType : 'application/json; charset=utf-8',  // 서버로 보낼 데이터 타입
	        success: function(response) {
	        	// 성공적으로 수정되었을 때
                Swal.fire(
                    '수정 완료',
                    '수정이 완료되었습니다!',
                    'success'
                ).then(() => {
                	location.reload();
                });
	        },
	        error: function(xhr, status, error) {
	        	Swal.fire(
                        '오류',
                        '수정 처리에 실패했습니다.',
                        'error'
                );
	        }
	    });
	});
});
</script>

