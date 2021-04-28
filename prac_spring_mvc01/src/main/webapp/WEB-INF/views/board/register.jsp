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
         <div class="panel-heading">Board Register</div>
         <div class="panel-body">
            <form role="form" action="/board/register" 
            method="post">
            
               <div class="form-group">
                  <label>Title</label> 
                  <input class="form-control" name='title'>
               </div>

               <div class="form-group">
                  <label>Text area</label>
                  <textarea class="form-control" rows="3" 
                  name='content'></textarea>
               </div>
               
               <div class="form-group">
                  <label>Writer</label> 
                  <input class="form-control" name="writer">
               </div>
               
               <button type="submit" class="btn btn-default">
               Submit Button</button>
               <button type="reset" class="btn btn-default">
               Reset Button</button>
            
            </form>
         </div>
         
      </div>
   </div>
</div>

<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading"></div>
			<div class="panel-body">
				<!-- 파일을 입력(첨부)하는 부분 -->
				<div clss="form-group uploadDiv">
					파일 첨부 : <input type="file" name="uploadFile" multiple>
				</div>
				<!-- 파일 첨부한 것을 보여주는 부분 -->
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>


<script>
$(document).ready(function(e) {
	var formObj=$("form[role='form']");
	
	$("button[type='submit']").on("click",function(e) {	
		e.preventDefault();
		console.log("submit clicked");
	});
	
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
			}	
		});
	});
});
</script>

<%@ include file="../includes/footer.jsp"%>