<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="d-flex justify-content-center">
	<div class="container">
		<input type="text" id="subject" class="form-control"
			placeholder="제목을 입력하세요." value="${post.subject}">
		<textarea class="form-control" id="content" rows="15"
			placeholder="내용을 입력하세요.">${post.content}</textarea>
			
		<%-- 이미지가 있을때만 이미지 영역 추가 --%>
		<c:if test="${not empty post.imagePath}">
		<div class="mt-3">
			<img alt="업로드 이미지" src="${post.imagePath}" width="300">
		</div>
		</c:if>
		<div class="d-flex justify-content-end">
			<input type="file" id="file" accept=".jpg,.jpeg,.png,.gif">
		</div>
		
		<div class="d-flex justify-content-between mt-3">
			<button type="button" id="postDeleteBtn" class="btn btn-dark" data-post-id="${post.id}">삭제</button>
			
			<div>
				<a href="/post/post_list_view" class="btn btn-secondary">목록으로</a>
				<button type="button" id="postUpdateBtn" class="btn btn-info" data-post-id="${post.id}">수정</button>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		$('#postDeleteBtn').on('click', function() {
			let postId = $(this).data('post-id');
			
			$.ajax({
				type:"delete"
				, url:"/post/delete"
				, data:{"postId":postId}
			
				, success:function(data) {
					if (data.result == "성공") {
						alert("삭제 되었습니다.");
						location.href = "/post/post_list_view";
					} else {
						alert(data.errorMessage);
					}
				}
				, error:function(e) {
					alert("ajax error" + e);
				}
			});
		});
		
		$('#postUpdateBtn').on('click', function() {
			let subject = $('#subject').val().trim();
			if (subject == '') {
				alert("제목을 입력하세요");
				return;
			}
			
			let content = $('#content').val();
			console.log(content);
			
			let file = $("#file").val();
			console.log(file);
			
			// 파일이 업로드 된 경우 확장자 체크
			if (file != '') {
				let ext = file.split(".").pop().toLowerCase();
				
				if ($.inArray(ext, ['jpg', 'jpeg', 'png', 'gif']) == -1) {
					alert("이미지 파일만 업로드 할 수 있습니다.");
					$('#file').val("");	// 파일을 비운다
					return;
				}
			}
			
			let postId = $(this).data('post-id');
			// 폼태그를 자바스크립트에서 만든다.
			let formData = new FormData();
			formData.append("postId", postId);
			formData.append("subject", subject);
			formData.append("content", content);
			formData.append("file", $('#file')[0].files[0]);
			
			$.ajax({
				// request
				type:"put"
				, url:"/post/update"
				, data:formData
				
				, enctype:"multipart/form-data"	//파일 업로드를 위한 필수 설정
				, processData:false				//파일 업로드를 위한 필수 설정
				, contentType:false				//파일 업로드를 위한 필수 설정
				
				// response
				, success:function(data) {
					if (data.code == 1) {
						alert("메모가 수정되었습니다.");
						location.reload();
					} else {
						alert(data.errorMassage);
					}
				}
			
				, error:function(e) {
					alert("ajax error" + e);
				}
			});
			
		});
		
	});
</script>