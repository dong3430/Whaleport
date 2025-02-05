<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/quill/dist/quill.snow.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/quill/dist/quill.js"></script>

<style>
.hidden {
    display: none;
}
#editor {
    height: 300px; /* 에디터 높이 설정 */
}
</style>


<div class="body-wrapper">
    <div class="container-fluid">
    
    
	<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
            <div class="card-body px-4 py-3">
              <div class="row align-items-center">
                <div class="col-9">
                  <h4 class="fw-semibold mb-8">공지사항 수정</h4>
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a class="text-muted text-decoration-none" href="/common/home">DashBoard</a>
                      </li>
                      <li class="breadcrumb-item" aria-current="page">Notice</li>
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
            <div class="border-bottom title-part-padding">
                <h4 class="card-title mb-0">공지사항 수정</h4>
            </div>
            <div class="card-body">
                <form action="/info/notice/update" class="mt-0" method="post" id="noticeForm" enctype="multipart/form-data">
                 <div class="mb-3 form-group">
                  <label class="form-label">
                  </label>
                  <input type="hidden" name="noNo" value="${noticeVO.noNo }" />
                  <div class="controls">
                    <select name="noCategory" id="noCategory"  class="form-select form-control">
                      <option value="">분류를선택해주세요</option>
                      <option value="PY" <c:if test="${noticeVO.noCategory eq 'PY' }">selected</c:if> >팝업용</option>
                      <option value="PN" <c:if test="${noticeVO.noCategory eq 'PN' }">selected</c:if> >게시용</option>
                    </select>
                  </div>
                </div>
                    <input type="text" class="form-control" id="noTitle" name="noTitle" value="${noticeVO.noTitle }">
                    <div id="editor"></div>
                    <input class="hidden" id="noContent" name="noContent" >
                    <br/>
                    <input class="form-control" type="file" id="noFile" name="noFile" multiple="multiple"    >
                    
						<div class="card-footer bg-white">
							<c:if test="${not empty noticeVO.noticeFileList }">
								<ul class="mailbox-attachments d-flex align-items-stretch clearfix">
									<c:forEach items="${noticeVO.noticeFileList }" var="noticeFile" >
										<li>
											<span class="mailbox-attachment-icon">
												<i class="far fa-file-pdf"></i>
											</span>
				
											<div class="mailbox-attachment-info">
												<a href="#" class="mailbox-attachment-name">
													<i class="fas fa-paperclip"></i>${noticeFile.fileRealname }
												</a> 
												<span class="mailbox-attachment-size clearfix mt-1">
													<span>${noticeFile.fileFancysize }</span>
													<span class="btn btn-default btn-sm float-right attachmentFileDel" id="span_${noticeFile.fileNo }" >
														<i class="fas fa-times"></i>
													</span>
												</span>
											</div>
										</li>
									</c:forEach>
								</ul>
							</c:if>
						</div>
                    <sec:csrfInput/>
                </form>
                <br/>
                <div class="d-flex justify-content-end">
                    <a href="/info/notice/list" class="btn btn-outline-primary me-3">이전</a>
                    <button type="button" class="btn btn-primary" onclick="submitForm()">저장</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quill 에디터 초기화 -->
<script>
let quill; // Quill 인스턴스를 전역 변수로 선언

document.addEventListener('DOMContentLoaded', function() {
    // Quill 인스턴스 생성
    quill = new Quill('#editor', {
        placeholder: '내용을 입력하세요.', // 플레이스홀더 설정
        theme: 'snow' // 또는 'bubble'
    });
    
    // Quill 에디터에 기존 내용 설정
    quill.root.innerHTML = "${noticeVO.noContent}"; // 기존 내용을 에디터에 삽입


    // 폼 제출 함수 정의
    window.submitForm = function() {
        // Quill 에디터의 내용을 hidden input에 저장 
        var content = quill.root.innerText; // HTML 포함한 내용 가져오기
        document.getElementById('noContent').value = content;

        // 폼 제출
        document.getElementById('noticeForm').submit();
    }
});

$(function(){
	var attachmentFileDel = $(".attachmentFileDel");	// 파일 1개당 'X' 버튼 element
	
	// 'x' 버튼 클릭 이벤트
	attachmentFileDel.on("click", function(){
		var id = $(this).prop("id");
		var idx = id.indexOf("_");	// span_fileNo에서 "_"의 현재 idx 위치를 가져온다.
		var noticeFileNo = id.substring(idx+1);
		var ptrn = "<input type='hidden' name='delNoticeNo' value='%v' />";
		$("#noticeForm").append(ptrn.replace("%v", noticeFileNo));
		$(this).parents("li:first").hide();
	});
	

});

</script>
