<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl core 쓸때 태그에 c 로 표시. -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl fmt 쓸때 위와 같음. fmt : formatter 형식 맞춰서 표시 -->
<%@ include file="../includes/header.jsp"%>



<!-- DataTales Example -->
<div class="card shadow mb-4">
   <div class="card-body">
      <div class="table-responsive">
         <div class="panel-heading">Board Write</div>
         <div class="panel-body">
         	<form role="form" action="/board/modify" method="post">
				
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> 
				<input type="hidden" name="bno" value="${board.bno}" />
				<input type="hidden" name="pageNum" value="${cri.pageNum }" />
				<input type="hidden" name="amount" value="${cri.amount }" />
				<input type="hidden" name="type" value="${cri.type }">
        		<input type="hidden" name="keyword" value="${cri.keyword }">
				
	            <div class="form-group">
	            	<label>Title</label>
	         		<input class="form-control" name="title" value='<c:out value="${board.title}"/>'>
	         	</div>
	         	
	         	<div class="form-group">
	            	<label>Text area</label>
	         		<textarea row="3" class="form-control" name="content"><c:out value="${board.content}"/></textarea>
	         	</div>
	         	
	         	<div class="form-group">
	            	<label>Writer</label>
	         		<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
	         	</div>
	         	
				<sec:authentication property="principal" var="pinfo" />
				<sec:authorize access="isAuthenticated()">
					<!-- 인증된 사용자만 허가 -->
					<c:if test="${pinfo.username eq board.writer}">
						<button type="submit" data-oper="modify" class="btn btn-success">Modify</button>
						<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
					</c:if>
				</sec:authorize>
				<button type="submit" data-oper="list" class="btn btn-info">List</button>

			</form>
         </div>
         
      </div>
   </div>
</div>


<!-- 첨부파일 표시 -->
<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panal-heading">첨부파일</div>
			<div class="panal-body">
				<div class="form-group uploadDiv">
					파일 첨부 : <input type="file" name="uploadFile" multiple>
					<!-- http://tcpschool.com/html-tag-attrs/input-multiple -->
				</div>
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 첨부파일 끝 -->


<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function() {
		/*문서가 준비 됐다면, 아래 함수 수행.*/
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		/*ajax 처리시 csrf 값을 함께 전송하기 위한 준비
		스프링 시큐리티는 데이터 post 전송시 csrf 값을 꼭 확인 하므로*/
		
		$(document).ajaxSend(function(e,xhr,options) {
			xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
		});
		
		var formObj = $("form"); /*문서중 form 요소를 찾아서 변수에 할당*/
		
		$('button').on("click", function(e) {
			/*버튼이 클릭이 된다면 아래 함수 수행을 한다, e라는 이벤트 객체를 전달하면서*/
			e.preventDefault(); /*기본 이벤트 동작 막기.*/
			var operation = $(this).data("oper");
			/*버튼에서 oper 속성을 읽어서 변수에 할당*/
			console.log(operation);
			/*브라우저 로그로 oper값 출력.*/
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
				/*form에 액션 속성을 변경.*/
			} else if (operation === 'list') {
				//self.location = "/board/list";
				//return;
				
				formObj.attr("action", "/board/list").attr("method", "get");
				// form action="/board/list"
				// method = "get"
				var pageNumTag = $("input[name='pageNum']");
				var amountTag = $("input[name='amount']");
				var keywordTag = $("input[name='keyword']");
				var typeTag = $("input[name='type']");
				
				formObj.empty(); //폼의 내용들 비우기 - 목록으로 가는데 굳이 글번호,제목,내용 등을 가져갈 필요가 없기 때문에
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);				
			}
			
			//수정버튼을 눌렀을 때, 첨부파일의 정보를 히든 값으로 함께 전송하는 처리.
			else if (operation === 'modify') {
				var str="";
				$(".uploadResult ul li").each(function(i,obj) {
					var jobj=$(obj);
					console.dir(jobj);
					console.log("-------------");
					console.log(jobj.data("filename"));
					
					str +="<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
					str +="<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
					str +="<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
					str +="<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
				});
				formObj.append(str);
			}
			formObj.submit(); //기본이 수정 처리.
			/*위의 조건이 아니라면 수정 처리*/
		});
		
		//첨부파일 목록 표시(get.jsp에서도 동일하게 사용에서 [x]를 추가)
		(function(){
			var bno='<c:out value="${board.bno}"/>';
			//화면상에 공유된 bno 값 가져와 사용 준비.
			$.getJSON("/board/getAttachList",{bno:bno}, function(arr) {
				console.log(arr);
				
				var str="";
				$(arr).each(function(i,attach){
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
					
					str+="<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str+="<div>";
					str+="<img src='/resources/img/attach.png' width='20'>";
					str+="<span> " + attach.fileName + "</span>&nbsp;&nbsp;";
					str+="<b data-file='" + fileCallPath + "' data-type='file'>[x]</b>";
					str+="</div>";
					str+="</li>";
				});
				$(".uploadResult ul").html(str);
			});
		})();
			
		
		//첨부파일 목록에서 삭제 처리
		$(".uploadResult").on("click","b",function(e){
			console.log("delete file");
			
			var targetFile=$(this).data("file");
			var type=$(this).data("type");
			var targetLi=$(this).closest("li");
			
			$.ajax({
				url : '/deleteFile',
				data : {
					fileName : targetFile,
					type : type
				},
				dataType : 'text',
				type : 'POST',
				success : function(result){
					alert(result);
					targetLi.remove();
				}			
			})
		});
		
		//첨부파일 등록 (register.jsp에서도 사용)
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		//정규표현식. 일부 파일의 업로드 제한.
		//https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/%EC%A0%95%EA%B7%9C%EC%8B%9D
		//https://regexper.com/
		//(.*?)\.(exe|sh|zip|alz)를 입력해보면 어떻게 동작하는지 알려준다.
		
		var maxSize = 5242880; // 5MB
		
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) { //파일 크기가 최대용량보다 넘을경우
				alert("파일 크기 초과");
				return false; //실패
			}
			if(regex.test(fileName)){ //파일 형식의 제한에 들어갈때
				alert("해당 종류의 파일은 업로드 불가.");
				return false; //실패
			}
			return true; //모든 조건이 아니라면 성공
		}
		
		$("input[type='file']").change(function(e) {
			var formData = new FormData();
			var inputFile=$("input[name='uploadFile']");
			var files = inputFile[0].files; //등록한 첨부파일의 정보를 배열형태로 전달.
			
			for(var i=0;i<files.length;i++) {
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile",files[i]);
				// 결과적으로 첨부파일의 정보를 확인하여 크기와 종류가 맞다면,
				// formData 에 첨부파일 정보를 추가.
			}
			
			$.ajax({
				url : '/uploadAjaxAction',
				processData:false, //processData가 false로 되어 있으면 키와 값의 쌍으로 설정하지 않는다.
				contentType:false,
				data:formData,
				type:'POST',
				dataType:'json',
				success:function(result) {
					console.log(result);
					showUploadReuslt(result);
				}	
			});
		});
		
		//글쓰기 폼에 첨부파일을 등록 할 경우 목록에 꾸리기(register.jsp에서도 동일하게 사용)
		function showUploadReuslt(uploadResultArr) {
			if (!uploadResultArr || uploadResultArr.ength == 0) {
				//json 처리 경과가 없다면 함수 종료.
				return;
			}
			
			var uploadUL = $('.uploadResult ul');
			var str = "";
			
			// each 구문은 전달된 배열의 길이 만큼,
			// each 이후의 함수를 반복 처리.
			// https://api.jquery.com/jQuery.each/#jQuery-each-array-callback
			$(uploadResultArr).each(function(i, obj) {
				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_"+ obj.fileName);
				// encodeURIComponent : 
				// uri 로 전달되는 특수문자의 치환
				// & ?
				// 파일의 직접적인 경로를 알 수 있음
				
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				//전달 되는 값들 중에서 역슬러시를 찾아서 슬러시로 변경.
				
				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
				str += "<div>";
				str += "<img src='/resources/img/attach.png' width='20' height='20'>";
				str += "<span>" + obj.fileName + "</span> ";
				str += "<b data-file='" + fileCallPath + "' data-type='file'>[x]</b>";
				str += "</div>";
				str += "</li>";
			});
			uploadUL.append(str);
		}
	});
</script>