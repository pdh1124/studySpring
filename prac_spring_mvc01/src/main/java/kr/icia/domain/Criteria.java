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
	
	public Criteria() { //디폴트 값 (1페이지는 고정값)
		this(1, 10); //아래쪽 전달값 2개 생성자 호출
	}
	
	public Criteria(int pageNum, int amount) { //변화하는 값 (1페이지 이후의 값)
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
}
