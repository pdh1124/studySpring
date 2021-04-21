/**
 * 
 */console.log("Reply module.....55");

//ajax처리
var replyService = (function() { //자바스크립트는 함수를 변수에 할당 가능.
	function add(reply, callback, error) {
	// reply : 댓글 객체,
	// callback : 댓글 등록후 수행할 메소드 . 비동기
	// 주문과 동시에 처리할 내용도 전달. 페이지 이동없이 새로운 내용 갱신.
	console.log("add reply......");
	
		$.ajax({
			type: 'post',
			url: '/replies/new',
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if (callback) {
					callback(result)
				}
				// result와 status 차이는? 없음
				// xhr 이 다 가지고 있음. status 와 responseText
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}	
		});
	}
	
	return {
		add: add// 변수명,호출명 예) replyService.add
	};
})(); // 즉시 실행 함수 : 명시하는 것과 동시에 메모리에 등록
// 자바 스크립트는 함수도 변수에 할당 가능함.
// 자바 람다식도 함수를 변수에 할당