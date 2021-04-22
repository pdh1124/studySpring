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

<!-- 댓글 목록 시작 -->
<br/>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				<button id="addReplyBtn" class="btn btn-primary btn-xs float-right">new reply</button>
			</div>
			<br />
			<div class="panel-body">
				<ul class="chat">
					<li>good</li>
				</ul>
			</div>
			<div clas="panel-footer"></div>
		</div>
	</div>
</div>
<!-- 댓글 목록 끝 -->

<!-- 댓글 입력 모달 시작 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">댓글 창</h4>
			</div>
			
			<div class="modal-body">
				<div class="form-group">
					<label>댓글</label> 
					<input class="form-control" name="reply" value="새 댓글">
				</div>
				<div class="form-group">
					<label>작성자</label> 
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label>댓글 작성일</label> 
					<input class="form-control" name="replyDate" value="">
				</div>
			</div>
			
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btnwarning">수정</button>
				<button id="modalRemoveBtn" type="button" class="btn btndanger">삭제</button>
				<button id="modalRegisterBtn" type="button" class="btn btnprimary">등록</button>
				<button id="modalCloseBtn" type="button" class="btn btndefault">닫기</button>
			</div>
			
		</div>
	</div>
</div>
<!-- 댓글 입력 모달 끝 -->

<%@ include file="../includes/footer.jsp"%>

<script type="text/javascript" src="/resources/js/reply.js"></script>
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
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		
		/*replyService.add({
			reply : "js test",
			replyer : "tester",
			bno : bnoValue
		}, function(result) {
			alert("result: " + result);
		}); */
		//게시글을 읽을때 자동으로 댓글 1개 등록.
		
		var modal = $("#myModal");
		// 댓글 용 모달.
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		// 댓글 작성일 항목.
		var modalRegisterBtn = $("#modalRegisterBtn");
		// 모달에서 표시되는 댓글쓰기 버튼
		var modalInputReply = modal.find("input[name='reply']");
		// 댓글 내용
		var modalInputReplyer = modal.find("input[name='replyer']");
		// 댓글 작성자.
		
		$("#addReplyBtn").on("click", function(e) {
			// 댓글 쓰기 버튼을 클릭하다면,
			modal.find("input").val("");
			// 모달의 모든 입력창을 ""(빈값)으로 초기화
			modalInputReplyDate.closest("div").hide();
			// closest : 선택 요소와 가장 가까운 요소를 지정.
			// 즉, modalInputReplyDate 요소의 가장 가까운 div를 찾아서 숨김
			// 결론은 날짜창을 숨긴다는 뜻
			modal.find("button[id != 'modalCloseBtn']").hide();
			// 모달창에 버튼이 총 4개인데, 닫기 버튼을 제외하고 나머지는 숨겨라
			modalRegisterBtn.show(); //등록 버튼을 보여라.
			$("#myModal").modal("show"); //모달 표시
		});
		
		//닫기버튼을 눌렀을때 모달창이 닫히는 명령
		$("#modalCloseBtn").on("click", function(e) {
			modal.modal("hide");
			//모달 닫기 라는 버튼을 클릭한다면 모달창을 숨김
		});
		
		//등록버튼을 눌렀을때 등록되는 명령
		modalRegisterBtn.on("click", function(e) {
			//댓글 등록 버튼을 눌렀다면,
			var reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			}; //ajax로 전달할 reply 객체 선언 및 할당. reply 변수에 reply 객체를 생성해주기
			replyService.add(reply, function(result) {
				alert(result);
				//ajax 처리후 결과 리턴
				modal.find("input").val("");
				//모달창 초기화
				modal.modal("hide");//모달창 숨기기
			});
		});
		
		replyService.getList({
			bno : bnoValue,
			page : 1
		}, function(list) {
			for (var i = 0, len = list.length || 0; i < len; i++) {
				console.log(list[i]);
			}
		});

	});
	
</script>
