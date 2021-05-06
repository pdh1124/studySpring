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
			
			<sec:authentication property="principal" var="pinfo" />
			<!-- 프린서펄 정보를 pinfo라는 이름으로 jsp에서 이용. -->
			<sec:authorize access="isAuthenticated()">
				<!-- 인증된 사용자만 허가 -->
				<c:if test="${pinfo.username eq board.writer }">
					<!-- 인증되었으면서 작성자가 본인 일때 수정 버튼 표시 -->
					<button data-oper="modify" class="btn btn-warning">수정</button>
				</c:if>
			</sec:authorize>			
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

<!-- 첨부파일 시작 -->
<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panal-heading">첨부파일</div>
			<div class="panal-body">
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 첨부파일 끝 -->


<!-- 댓글 목록 시작 -->
<br/>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs float-right">new reply</button>
				</sec:authorize>
			</div>
			<br />
			<div class="panel-body">
				<ul class="chat">
					<li>good</li>
				</ul>
			</div>
			<div class="panel-footer"></div>
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
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		/*ajax 처리시 csrf 값을 함께 전송하기 위한 준비
		스프링 시큐리티는 데이터 post 전송시 csrf 값을 꼭 확인 하므로*/
		
		$(document).ajaxSend(function(e,xhr,options) {
			xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
		});
		
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
		
		
		var replyer = null;
		<sec:authorize access="isAuthenticated()">
			replyer='${pinfo.username}';
		</sec:authorize>
		/*댓글의 작성자를 초기화. 로그인한 사용자의 이름으로 댓글 작성자를 붙혀넣겠다.*/
		
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
		var modalModBtn = $("#modalModBtn");
		// 수정 버튼
		var modalRemoveBtn = $("#modalRemoveBtn");
		// 삭제 버튼
		
		$("#addReplyBtn").on("click", function(e) {
			// 댓글 쓰기 버튼을 클릭하다면,
			modal.find("input").val("");
			// 모달의 모든 입력창을 ""(빈값)으로 초기화
			
			modal.find("input[name='replyer']").val(replyer);
			modal.find("input[name='replyer']").attr("readonly","readonly");
			//댓글 작성자를 로그인한 사용자로 지정하고 readonly(읽기전용) 수정하지 못하도록 한다.
			
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
			
			var reply_con=modalInputReply.val();console.log("reply_con:"+reply_con);
            if(reply_con=="") {
            	return;
            };
			
			replyService.add(reply, function(result) {
				alert(result);
				//ajax 처리후 결과 리턴
				modal.find("input").val("");
				//모달창 초기화
				modal.modal("hide");//모달창 숨기기
				showList(-1); //댓글 등록 후 댓글 목록 갱신을 위해서 목록 함수를 호출.
			});
		});
		
		//댓글의 모달창에서 수정을 눌렀을때 동작하는 부분
		modalModBtn.on("click", function(e) {
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {
				rno : modal.data("rno"),
				reply : modalInputReply.val(),
				replyer : originalReplyer
			};//자바스크립트 객체 생성.
			
			if(!replyer) {
				alert("로그인 후 수정 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정 가능");
				modal.modal("hide");
				return
			}
			
			replyService.update(reply, function(result) {
				alert(result);
				modal.modal("hide");
				showList(-1);
			});
		});
		
		//댓글 삭제기능
		modalRemoveBtn.on("click", function(e) {
			var rno = modal.data("rno");
			var originalReplyer = modalInputReplyer.val();
			
			if(!replyer) {
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제 가능");
				modal.modal("hide");
				return
			}
			
			replyService.remove(rno, originalReplyer, function(result) {
				alert(result);
				modal.modal("hide");
				showList(-1); //아직 페이징 처리를 하지 않아서 -1로 임시로 구분함. 나중에 페이징 처리를 하게되면 페이지가 들어갈 예정
			});
		});
		
		
		/*replyService.getList({
			bno : bnoValue,
			page : 1
		}, function(list) {
			for (var i = 0, len = list.length || 0; i < len; i++) {
				console.log(list[i]);
			}
		});*/
		
		//댓글을 클릭하면 수정하는 기능
		$(".chat").on("click", "li", function(e) {
			//클래스 chat 을 클릭하는데, 하위 요소가 li라면,
			var rno = $(this).data("rno");
			//댓글에 포함된 값들 중에서 rno를 추출하여 변수 할당.
			console.log(rno);
			replyService.get(rno,function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
				//readonly : 읽기 전용
				//댓글 목록의 값들을 모달창에 할당
				
				modal.data("rno",reply.rno); //표시되는 모달창에 rno라는 이름으로 data-rno를 저장
				modal.find("button[id !='modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				//버튼 보이기 설정.
				
				$("#myModal").modal("show");
			});	
		});
			
		//상세페이지에 댓글 구현
		var replyUL = $(".chat");
		// reply Unorderd List
		
		function showList(page) {
			replyService.getList({
				bno : bnoValue,
				page : page || 1
			}, 
			function(replyCnt, list) {
				
				console.log("replyCnt : " + replyCnt);
				
				if(page == -1) {
					//페이지 번호가 음수 값 이라면,
					//댓글 목록 갱신하기 위한 임의의 숫자가 -1
					//가장 최근에 등록한 댓글을 표시
					pageNum = Math.ceil(replyCnt/10.0);
					// 댓글의 마지막 페이지 구하기.
					console.log("page : " + pageNum);
					showList(pageNum);
					//댓글 목록 새로고침(갱신)
					return;
				}
				
				var str = "";
				if(list == null || list.length == 0) {
					replyUL.html("");
					return;
				}
				for(var i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class'left clearfix' data-rno='" + list[i].rno + "'>";
					str += "<div>"
					str += "<div class='header'>";
					str += "<strong class='primary-font'>" + list[i].replyer + "</strong>";
					str += "<small class='float-sm-right'>" + replyService.displayTime(list[i].replyDate) + "</small>";
					str += "</div>"
					str += "<p>" + list[i].reply + "</p>";
					str += "</div>"
					str += "</li>"
				}
				replyUL.html(str);
				showReplyPage(replyCnt);
			});
		}
		showList(1);//아직 페이징 처리를 하지 않아서 -1로 임시로 구분함. 나중에 페이징 처리를 하게되면 페이지가 들어갈 예정
		
		/*댓글 페이징 시작*/
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt) {
			var endNum = Math.ceil(pageNum/10.0) * 10;
			//pageNum : 1이라고 가정한다면,
			//Math.ceil(1/10.0) 처리하고 *10, 즉 endNum : 10
			var startNum = endNum - 9; // -가 나올수도 있다.
			var prev = startNum != 1; // false = (1 != 1)
			var next = false;
	
			//예를 들어, replyCnt : 384, endNum : 39 
			if(endNum * 10 >= replyCnt) { // 100 >= 384니까 실행 안함
				endNum = Math.ceil(replyCnt / 10.0);
			}
			if(endNum * 10 < replyCnt) {
				next = true;
			}
			var str = "<ul class='pagination justify-content-center'>"
			if(prev) { //이전으로 가는 버튼
				str += "<li class='page-item'>";
				str += "<a class='page-link' href='" + (startNum - 1) + "'>이전</a>";
				str += "</li>";
			}
			for(var i = startNum; i <= endNum; i++) { //페이징 1,2,3,4...
				var active = pageNum == i ? "active" : "";
				str += "<li class='page-item " + active + "'>"; //현재 페이지를 파란색 표시
				str += "<a class='page-link' href='" + i + "'>" + i + "</a>";
				str += "</li>";
			}
			if(next) { //다음으로 가는 버튼
				str += "<li class='page-item'>";
				str += "<a class='page-link' href='" + (endNum + 1) + "'>다음</a>"
				str += "</li>";
			}
			str += "</ul>";
			console.log(str);
			replyPageFooter.html(str);
		}
		/*댓글 페이징 끝*/
		
		//페이징을 누를 때 페이지 이동
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault(); //이벤트를 초기화를 하고
			var targetPageNum = $(this).attr("href"); //href에 있는 i값을 가져와서
			pageNum = targetPageNum; //pageNum에 i값을 넣는다.
			showList(pageNum);
		});
		
		//첨부파일 목록 표시
		(function() {
			var bno = '<c:out value="${board.bno}"/>';
			//화면상에 공유된 bno값을 가져와 사용 준비.
			$.getJSON("/board/getAttachList",{bno:bno}, function(arr) {
				console.log(arr);
				
				var str="";	
				$(arr).each(function(i,attach){
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str += "<div>";
					str += "<img src='/resources/img/attach.png' width='20px'>";
					str += "<span>&nbsp;" + attach.fileName + "</span><br />";
					str += "</div>";
					str += "</li>";
				});
				$(".uploadResult ul").html(str);
			});
		})(); //즉시 실행 함수
		
		//첨부파일 클릭시 다운로드 처리 스크립트.
		$(".uploadResult").on("click", "li", function(e) {
			console.log("download file");
			var liObj =$(this);
			var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
			// c:\upload\2021\04\29\uuid_fileName.ext 로 됨
			//console.log("/download?fileName="+path);
			self.location="/download?fileName="+path;
		});
	});
	
</script>
