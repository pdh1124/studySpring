package kr.icia.domain;

import lombok.Data;

@Data
public class AuthVO {
	private String userid; //사용자 아이디
	private String auth; //권한.
	//즉, 사용자별 권한 등록
}
