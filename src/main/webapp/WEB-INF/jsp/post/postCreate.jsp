<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="d-flex justify-content-center">
	<div class="w-50">
		<h1>글쓰기</h1>
		
		<input type="text" id="subject" class="form-control" placeholder="제목을 입력하세요.">
		<textarea class="form-control" id="content" rows="15" placeholder="내용을 입력하세요."></textarea>
		<div class="d-flex justify-content-end">
			<input type="file" id="file" accept=".jpg,.jpeg,.png,.gif">
		</div>
		
		<div class="d-flex justify-content-between mt-3">
			<button type="button" id="postListBtn" class="btn btn-dark">목록</button>
			
			<div>
				<button type="button" id="clearBtn" class="btn btn-secondary">모두 지우기</button>
				<button type="button" id="postCreateBtn" class="btn btn-info">저장</button>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		// 목록버튼 클릭
		$('#postListBtn').on('click', function() {
			location.href = "/post/post_list_view";	
		});
		
		// 모두지우기 버튼클릭
		$('#clearBtn').on('click', function() {
			$('#subject').val("");
			$('#content').val("");
		});
		
		// 저장
		$("#postCreateBtn").on('click', function() {
			let subject = $('#subject').val().trim();
			let content = $('#content').val();
			
			if (subject.length < 1) {
				alert("제목을 입력하세요.");
				return;
			}
			
			console.log(content);
			
			let file = $('#file').val();			//C:\fakepath\%C6%C4.jpg
			// alert(file);
			// 파일이 로드 된 경우에만 확장자 체크
			if (file != "") {
				// alert(file.split(".").pop().toLowerCase());
				let ext = file.split(".").pop().toLowerCase();
				
				if ($.inArray(ext, ['jpg', 'jpeg', 'png', 'gif']) == -1) {
					alert("이미지 파일만 업로드 할 수 있습니다.");
					$('#file').val("");	// 파일을 비운다
					return;
				}
			}
			
			// submit - ajax
			
			// 이미지를 업로드 할때는 form 태그가 있어야 한다 (자바스크립트에서 만듦)
			// append로 넣는 값은 form태그의 name으로 넣는것과 같다(request parameter)
			let formData = new FormData();
			formData.append("subject", subject);
			formData.append("content", content);
			formData.append("file", $('#file')[0].files[0]);
			
			// ajax 통신으로 formData에 있는 데이터 전송
			$.ajax({
				type:"post"
				, url:"/post/create"
				, data:formData		// 폼객체를 통째로
				
				, enctype:"multipart/form-data" // 파일 업로드를 위한 필수 설정
				, processData:false  // 파일 업로드를 위한 필수 설정
				, contentType:false  // 파일 업로드를 위한 필수 설정
				
				, success:function(data) {
					if (data.code == 1) {
						// 성공
						alert("메모가 저장되었습니다.");
						location.href = "/post/post_list_view";
					} else {
						// 실패
						alert(data.errorMessage);
					}
				}
				, error:function(e) {
					alert("ajax error!!!");
				}
			});
		});
		
	});
</script>