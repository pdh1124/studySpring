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
				
				<input type="hidden" name="bno" value="${board.bno}" />
				
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
				
				<button type="submit" data-oper="modify" class="btn btn-success">Modify</button>
				<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
				<button type="submit" data-oper="list" class="btn btn-info">List</button>

			</form>
         </div>
         
      </div>
   </div>
</div>


<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function() {
		/*문서가 준비 됐다면, 아래 함수 수행.*/
		var formObj = $("form"); /*문서중 form 요소를 찾아서 변수에 할당*/
		
		$('button').on("click", function(e) {
			/*버튼이 클릭이 된다면 아래 함수 수행을 한다, e라는 이벤트 객체를 전달하면서*/
			e.preventDefault(); /*기본 이벤트 동작 막기.*/
			var operation = $(this).date("oper");
			/*버튼에서 oper 속성을 읽어서 변수에 할당*/
			console.log(operation);
			/*브라우저 로그로 oper값 출력.*/
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
				/*form에 액션 속성을 변경.*/
			} else if (operation === 'list') {
				self.location = "/board/list";
				return;
			}
			formObj.submit();
			/*위의 조건이 아니라면 수정 처리*/
		});
	});
</script>