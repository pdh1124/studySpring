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
         <div class="panel-heading">Board reding</div>
         <div class="panel-body">
         
         	<div class="form-group">
         		게시물 번호<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
         	</div>
            
            <div class="form-group">
            	<label>Title</label>
         		<input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
         	</div>
         	
         	<div class="form-group">
            	<label>Text area</label>
         		<textarea row="3" class="form-control" name="content" readonly="readonly"><c:out value="${board.content}"/></textarea>
         	</div>
         	
         	<div class="form-group">
            	<label>Writer</label>
         		<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
         	</div>
			
			<button data-oper="modify" class="btn btn-warning">수정</button>
			<button data-oper="list" class="btn btn-info">목록</button>
			
			<!-- 게시물의 번호를 전달하기 위해 폼의 hidden으로 전달 -->
			<form id="operForm" action="/board/modify" method="get">
				<input type="hidden" id="bno" name="bno" value="${board.bno }" />
				<input type="hidden" name="pageNum" value="${cri.pageNum }" />
				<input type="hidden" name="amount" value="${cri.amount }" /> 
				<input type="hidden" name="type" value="${cri.type }">
        		<input type="hidden" name="keyword" value="${cri.keyword }">
			</form>
			
         </div>
         
      </div>
   </div>
</div>


<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function() {
		/*문서가 준비가 됐다면, 아래 함수 수행. */
		var operForm = $("#operForm"); /*문서중 form 요소를 찾아서 변수에 할당*/
		$('button[data-oper="modify"]').on("click", function(e) {
			//버튼을 클릭했다면? (버튼 속성에 [data-oper="modify"]속성이 있다면 실행)
			//버튼이 클릭된다면 아래 함수 수행, e라는 이벤트 객체를 전달하면서
			operForm.attr("action","/board/modify").submit();
			//즉, get 방식으로 bno 전달하면서 modify 로 이동.
		});
		
		$('button[data-oper="list"]').on("click", function(e) {
			//버튼을 클릭했다면? (버튼 속성에 [data-oper="list"]속성이 있다면 실행)
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();
		});
	
	});
	
</script>
<script type="text/javascript" src="/resources/js/reply.js"></script>