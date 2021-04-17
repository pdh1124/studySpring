package kr.icia.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	private int pageNum; //현재 페이지 번호.
	private int amount; //페이지당 게시물수
	private String type; //검색 타입. 내용+제목+작성자 ctw라는 검색타입이 넘어감
	private String keyword; //검색어. 예) 새로운
	
	public Criteria() { //디폴트 값 (1페이지는 고정값)
		this(1, 10); //아래쪽 전달값 2개 생성자 호출
	}
	
	public Criteria(int pageNum, int amount) { //변화하는 값 (1페이지 이후의 값)
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String[] getTypeArr() {
		//검색 타입 배열 가져오기
		return type == null ? new String[] {} : type.split("");
		// 삼항 연산자 : (조건)?(참):(거짓)
		// 검색타입이 널이라면 비어있는 문자열 배열을 만들고,
		// 그렇지 않다면, 검색타입을 한글자씩 잘라서 문자열 배열로 만듦.
	}
	
}
